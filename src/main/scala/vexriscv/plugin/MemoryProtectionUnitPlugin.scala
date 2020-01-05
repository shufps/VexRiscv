package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._
import vexriscv._
import vexriscv.Riscv._

import util.control.Breaks._
import scala.collection.mutable


import scala.collection.mutable.ArrayBuffer
case class PMPPluginPort(bus : MemoryTranslatorBus, priority : Int)

case class PMPPluginConfig (
                            ioRange             : UInt => Bool,
                            pmpcfg0Init         : BigInt = 0x00000000,
                            pmpcfg1Init         : BigInt = 0x00000000,
                            pmpcfg2Init         : BigInt = 0x00000000,
                            pmpcfg3Init         : BigInt = 0x00000000,
                            pmpaddr0Init        : BigInt = 0x00000000,
                            pmpaddr1Init        : BigInt = 0x00000000,
                            pmpaddr2Init        : BigInt = 0x00000000,
                            pmpaddr3Init        : BigInt = 0x00000000,
                            pmpaddr4Init        : BigInt = 0x00000000,
                            pmpaddr5Init        : BigInt = 0x00000000,
                            pmpaddr6Init        : BigInt = 0x00000000,
                            pmpaddr7Init        : BigInt = 0x00000000,
                            pmpaddr8Init        : BigInt = 0x00000000,
                            pmpaddr9Init        : BigInt = 0x00000000,
                            pmpaddr10Init       : BigInt = 0x00000000,
                            pmpaddr11Init       : BigInt = 0x00000000,
                            pmpaddr12Init       : BigInt = 0x00000000,
                            pmpaddr13Init       : BigInt = 0x00000000,
                            pmpaddr14Init       : BigInt = 0x00000000,
                            pmpaddr15Init       : BigInt = 0x00000000
) {

}



class PMPPlugin(val config: PMPPluginConfig) extends Plugin[VexRiscv] with MemoryTranslator {
  import config._
  val portsInfo = ArrayBuffer[PMPPluginPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
//    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
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
        val pmpcfgPacked = Array.fill(4)(Reg(UInt(32 bits)) init(U"x00000000"))
        val pmpaddr = Array.fill(16)(Reg(UInt(32 bits)) /*init(U"x00000000")*/)

        // unpack pmpcfgx CSR registers
        var pmpcfg = new Array[UInt](16)
        for (j <- 0 to 3) {
            for (i <- 0 to 3) {
                pmpcfg(j*4+i)  = pmpcfgPacked(j)(i*8+7 downto i*8)
            }
        }
        
        // shadow-registers - store in unpacked form
        val shadow_pmpaddr = Array.fill(16)(Reg(UInt(32 bits)) /*init(U"x00000000")*/)
        val shadow_pmpcfg = Array.fill(16)(Reg(UInt(8 bits)) init(U"x00"))

        for (i <- 0 to 15) {
            var locked = False
            
            // current entry locked?
            when (shadow_pmpcfg(i)(7) === True) {
                locked \= True
            }.otherwise{
                // Top PMP has no 'next' to check
                if (i == 15) {
                    locked \= False
                } else {
                    // In TOR mode, need to check the lock bit of the next pmp
                    // (if there is a next)
                    when (shadow_pmpcfg(i+1)(7) === True && shadow_pmpcfg(i+1)(4 downto 3) === U"01") {
                        locked \= True
                    }
                }
            }
            when (locked =/= True) {
                shadow_pmpcfg(i) := pmpcfg(i)
                shadow_pmpaddr(i) := pmpaddr(i)
            }
        }        
      // implement CSR read/write
      val csrService = pipeline.service(classOf[CsrInterface])

      // write CSRs
      for (i <- 0 to 15) {
        if (i < 4) {
            csrService.w(CSR.PMPCFG0 + i, pmpcfgPacked(i))
        }
        csrService.w(CSR.PMPADDR0 + i, pmpaddr(i))
      }

      // read CSRs and pack pmpcfgx-registers
      val tmp_pmpcfgPacked = Array.fill(4)(UInt(32 bits))
      for (j <- 0 to 3) {
        for (i <- 0 to 3) {
            tmp_pmpcfgPacked(j)(i*8+7 downto i*8) := shadow_pmpcfg(j*4+i)
        }
      }
    
      for (i <- 0 to 15) {
        if (i < 4) {
            csrService.r(CSR.PMPCFG0 + i, tmp_pmpcfgPacked(i))
        } 
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
        
        // inspired by https://github.com/qemu/qemu/blob/master/target/riscv/pmp.c
       
        for (i <- 0 to 15) {
            val pmp_r    = shadow_pmpcfg(i)(0)
            val pmp_w    = shadow_pmpcfg(i)(1)
            val pmp_x    = shadow_pmpcfg(i)(2)
            val pmp_a    = shadow_pmpcfg(i)(4 downto 3)
//          val pmp_     = shadow_pmpcfg(i)(6 downto 5)    // not used
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

            when (matched === False && (
                    (match_tor   === True && pmp_a === U"01") ||
                    (match_na4   === True && pmp_a === U"10") ||
                    (match_napot === True && pmp_a === U"11")
                 )) {
                 
                    when (privilegeService.isMachine() === False || pmp_l === True) {
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

        // no active rule -> allow all
        when (enabled === False) {
            port.bus.rsp.allowRead := True
            port.bus.rsp.allowWrite := True
            port.bus.rsp.allowExecute := True
        }.otherwise {
            when (matched === True) { // rule matched
                port.bus.rsp.allowRead := matched_r
                port.bus.rsp.allowWrite := matched_w
                port.bus.rsp.allowExecute := matched_x
            }.otherwise {
                when (privilegeService.isMachine() === True) { 
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
