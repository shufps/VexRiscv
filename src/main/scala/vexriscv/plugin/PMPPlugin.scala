/*
-- PMP Plugin
--
-- 2020 by Thomas Pototschnig <microengineer18@gmail.com>
-- discord: pmaxuw#8292
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWAR
--
-- With help of:
--      - https://github.com/qemu/qemu/blob/master/target/riscv/pmp.c
--      - https://content.riscv.org/wp-content/uploads/2017/05/riscv-privileged-v1.10.pdf
-- 
*/

package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._

import scala.collection.mutable.ArrayBuffer

case class PMPPluginPort(bus : MemoryTranslatorBus, priority : Int)

case class PMPPluginConfig (
                            pmpCfgRegisterCount : Int,
                            privExtension       : Boolean,
                            ioRange             : UInt => Bool
) {
    assert(pmpCfgRegisterCount >= 1 && pmpCfgRegisterCount <= 4)

    val pmpCount = pmpCfgRegisterCount * 4
}

class PMPPlugin(val config: PMPPluginConfig) extends Plugin[VexRiscv] with MemoryTranslator {
  import config._
  val portsInfo = ArrayBuffer[PMPPluginPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
    val port = PMPPluginPort(MemoryTranslatorBus(),priority)
    portsInfo += port
    port.bus
  }

  override def setup(pipeline: VexRiscv): Unit = {
  }

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import pipeline.config._
    import Riscv._

    
    val core = pipeline plug new Area {
        // registers for CSRs
        val pmpcfgPacked = Array.fill(pmpCount/4)(Reg(UInt(32 bits)) init(U"x00000000"))
        val pmpaddr = Array.fill(pmpCount)(Reg(UInt(32 bits)))

        // unpack pmpcfgx CSR registers
        var pmpcfg = new Array[UInt](pmpCount)

        for (i <- 0 to pmpCount-1) {
            pmpcfg(i)  = pmpcfgPacked(i/4)((i%4)*8+7 downto (i%4)*8)
        }

        // shadow-registers - store in unpacked form
        val shadow_pmpaddr = Array.fill(pmpCount)(Reg(UInt(32 bits)))
        val shadow_pmpcfg = Array.fill(pmpCount)(Reg(UInt(8 bits)) init(U"x00"))

        for (i <- 0 to pmpCount-1) {
            var locked = False
            
            // current entry locked?
            when (shadow_pmpcfg(i)(7)) {
                locked \= True
            }.otherwise{
                // Top PMP has no 'next' to check
                if (i == pmpCount-1) {
                    locked \= False
                } else {
                    // In TOR mode, need to check the lock bit of the next pmp
                    // (if there is a next)
                    when (shadow_pmpcfg(i+1)(7) && shadow_pmpcfg(i+1)(4 downto 3) === U"01") {
                        locked \= True
                    }
                }
            }
            when (!locked) {
                shadow_pmpcfg(i) := pmpcfg(i)
                shadow_pmpaddr(i) := pmpaddr(i)
            }
        }        
      // implement CSR read/write
      val csrService = pipeline.service(classOf[CsrInterface])

      // write CSRs
      for (i <- 0 to pmpCount/4-1) {
          csrService.w(CSR.PMPCFG0 + i, pmpcfgPacked(i))
      }

      for (i <- 0 to pmpCount-1) {
          csrService.w(CSR.PMPADDR0 + i, pmpaddr(i))
      }

      // read CSRs and pack pmpcfgx-registers
      val tmp_pmpcfgPacked = Array.fill(pmpCount/4)(UInt(32 bits))
      for (i <- 0 to pmpCount-1) {
          tmp_pmpcfgPacked(i/4)((i%4)*8+7 downto (i%4)*8) := shadow_pmpcfg(i)
      }
    
      for (i <- 0 to pmpCount/4-1) {
          csrService.r(CSR.PMPCFG0 + i, tmp_pmpcfgPacked(i))
      } 

      for (i <- 0 to pmpCount-1) {
        csrService.r(CSR.PMPADDR0 + i, shadow_pmpaddr(i))
      }

      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {
        val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())

        // no MMU - phys == virt
        port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress
        
        // pmp needs physaddr to be shifted by 2
        val physAddr = U"00" @@ port.bus.cmd.virtualAddress(31 downto 2)
        
        var matched = False
        var matched_r = False
        var matched_w = False
        var matched_x = False
        var enabled = False
        
      
        for (i <- 0 to pmpCount-1) {
            val pmp_r    = shadow_pmpcfg(i)(0)
            val pmp_w    = shadow_pmpcfg(i)(1)
            val pmp_x    = shadow_pmpcfg(i)(2)
            val pmp_a    = shadow_pmpcfg(i)(4 downto 3)
//          val pmp_     = shadow_pmpcfg(i)(6 downto 5)    // not used
            val pmp_p    = shadow_pmpcfg(i)(6 downto 5)     // custom: match privilege level with bits
            val pmp_l    = shadow_pmpcfg(i)(7)
            val pmp_addr = shadow_pmpaddr(i)
            
            
            // at least one rule active
            when (pmp_a =/= U"00") {
                enabled \= True
            }
            
            val pmp_prev_addr = if (i == 0) U"x00000000" else shadow_pmpaddr(i-1)
            val mask = ~(pmp_addr ^ (pmp_addr+1))
            
            val match_tor = (physAddr >= pmp_prev_addr && physAddr < pmp_addr)
            val match_na4 = (physAddr === pmp_addr)
            val match_napot = (physAddr & mask) === (pmp_addr & mask)

            when (!matched && (
                    (match_tor   && pmp_a === U"01") ||
                    (match_na4   && pmp_a === U"10") ||
                    (match_napot && pmp_a === U"11")
            )) {
                // custom extension which uses unused bits for encoding minimum privilege level
                if (privExtension) {
                    when (
                            (privilegeService.isMachine()     &&  pmp_p === 3)  ||
//                          (privilegeService.isHypervisor()  &&  pmp_p === 2)  ||
                            (privilegeService.isSupervisor()  &&  pmp_p === 1)  ||
                            (privilegeService.isUser()        &&  pmp_p === 0) 
                    
                    ) {
                        matched_r \= pmp_r
                        matched_w \= pmp_w
                        matched_x \= pmp_x
                        matched \= True
                    }
                } else {
                    when (!privilegeService.isMachine() || pmp_l) {
                        // When the L bit is set, these permissions are enforced for all privilege modes
                        matched_r \= pmp_r
                        matched_w \= pmp_w
                        matched_x \= pmp_x
                    }.otherwise {
                        // If the L bit is clear and the privilege mode of the access is M, the access succeeds.
                        matched_r \= True
                        matched_w \= True
                        matched_x \= True
                    }                 
                    matched \= True
                }
            }
        }

        // no active rule -> allow all
        when (!enabled) {
            port.bus.rsp.allowRead := True
            port.bus.rsp.allowWrite := True
            port.bus.rsp.allowExecute := True
        }.otherwise {
            when (matched) { // rule matched
                port.bus.rsp.allowRead := matched_r
                port.bus.rsp.allowWrite := matched_w
                port.bus.rsp.allowExecute := matched_x
            }.otherwise {
                when (privilegeService.isMachine()) { 
                    // Privileged spec v1.10 states if no PMP entry matches an
                    // M-Mode access, the access succeeds 
                    port.bus.rsp.allowRead := True
                    port.bus.rsp.allowWrite := True
                    port.bus.rsp.allowExecute := True
                }.otherwise {
                    // Other modes are not allowed to succeed if they don't
                    // match a rule, but there are rules.  We've checked for
                    // no rule earlier in this function.
                    port.bus.rsp.allowRead := False
                    port.bus.rsp.allowWrite := False
                    port.bus.rsp.allowExecute := False
                }
            }
        }
        
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False
      }
    }
  }
}
