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
                            romRange            : UInt => Bool,
                            ramRange            : UInt => Bool,
                            supervisorRange     : UInt => Bool,
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
      // can this be done directly as arrays?
      val pmpcfg0 = Reg(UInt(32 bits)) init(pmpcfg0Init)
      val pmpcfg1 = Reg(UInt(32 bits)) init(pmpcfg1Init)
      val pmpcfg2 = Reg(UInt(32 bits)) init(pmpcfg2Init)
      val pmpcfg3 = Reg(UInt(32 bits)) init(pmpcfg3Init)

      val pmpaddr0 = Reg(UInt(32 bits)) init(pmpaddr0Init)
      val pmpaddr1 = Reg(UInt(32 bits)) init(pmpaddr1Init)
      val pmpaddr2 = Reg(UInt(32 bits)) init(pmpaddr2Init)
      val pmpaddr3 = Reg(UInt(32 bits)) init(pmpaddr3Init)
      val pmpaddr4 = Reg(UInt(32 bits)) init(pmpaddr4Init)
      val pmpaddr5 = Reg(UInt(32 bits)) init(pmpaddr5Init)
      val pmpaddr6 = Reg(UInt(32 bits)) init(pmpaddr6Init)
      val pmpaddr7 = Reg(UInt(32 bits)) init(pmpaddr7Init)
      val pmpaddr8 = Reg(UInt(32 bits)) init(pmpaddr8Init)
      val pmpaddr9 = Reg(UInt(32 bits)) init(pmpaddr9Init)
      val pmpaddr10 = Reg(UInt(32 bits)) init(pmpaddr10Init)
      val pmpaddr11 = Reg(UInt(32 bits)) init(pmpaddr11Init)
      val pmpaddr12 = Reg(UInt(32 bits)) init(pmpaddr12Init)
      val pmpaddr13 = Reg(UInt(32 bits)) init(pmpaddr13Init)
      val pmpaddr14 = Reg(UInt(32 bits)) init(pmpaddr14Init)
      val pmpaddr15 = Reg(UInt(32 bits)) init(pmpaddr15Init)

      val csrService = pipeline.service(classOf[CsrInterface])
      
      val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())
      if (privilegeService.isMachine() == True) {   // TODO how to do it right?
        csrService.rw(CSR.PMPCFG0, pmpcfg0)
        csrService.rw(CSR.PMPCFG1, pmpcfg1)
        csrService.rw(CSR.PMPCFG2, pmpcfg2)
        csrService.rw(CSR.PMPCFG3, pmpcfg3)
        csrService.rw(CSR.PMPADDR0, pmpaddr0)
        csrService.rw(CSR.PMPADDR1, pmpaddr1)
        csrService.rw(CSR.PMPADDR2, pmpaddr2)
        csrService.rw(CSR.PMPADDR3, pmpaddr3)
        csrService.rw(CSR.PMPADDR4, pmpaddr4)
        csrService.rw(CSR.PMPADDR5, pmpaddr5)
        csrService.rw(CSR.PMPADDR6, pmpaddr6)
        csrService.rw(CSR.PMPADDR7, pmpaddr7)
        csrService.rw(CSR.PMPADDR8, pmpaddr8)
        csrService.rw(CSR.PMPADDR9, pmpaddr9)
        csrService.rw(CSR.PMPADDR10, pmpaddr10)
        csrService.rw(CSR.PMPADDR11, pmpaddr11)
        csrService.rw(CSR.PMPADDR12, pmpaddr12)
        csrService.rw(CSR.PMPADDR13, pmpaddr13)
        csrService.rw(CSR.PMPADDR14, pmpaddr14)
        csrService.rw(CSR.PMPADDR15, pmpaddr15)
      }
        // save conveniently into array
        var pmpaddr = new Array[UInt](16)
        var pmpcfg = new Array[UInt](16)
        for (i <- 0 to 3) {
            pmpcfg(0+i)  = pmpcfg0(i*8+7 downto i*8)
            pmpcfg(4+i)  = pmpcfg1(i*8+7 downto i*8)
            pmpcfg(8+i)  = pmpcfg2(i*8+7 downto i*8)
            pmpcfg(12+i) = pmpcfg3(i*8+7 downto i*8)
        }
        
        pmpaddr(0) = pmpaddr0
        pmpaddr(1) = pmpaddr1
        pmpaddr(2) = pmpaddr2
        pmpaddr(3) = pmpaddr3
        pmpaddr(4) = pmpaddr4
        pmpaddr(5) = pmpaddr5
        pmpaddr(6) = pmpaddr6
        pmpaddr(7) = pmpaddr7
        pmpaddr(8) = pmpaddr8
        pmpaddr(9) = pmpaddr9
        pmpaddr(10) = pmpaddr10
        pmpaddr(11) = pmpaddr11
        pmpaddr(12) = pmpaddr12
        pmpaddr(13) = pmpaddr13
        pmpaddr(14) = pmpaddr14
        pmpaddr(15) = pmpaddr15
    
      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {
        val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())

        val physAddr = port.bus.cmd.virtualAddress
        
        // no MMU - phys == virt
        port.bus.rsp.physicalAddress := physAddr

        port.bus.rsp.allowRead := True
        port.bus.rsp.allowWrite := True
        port.bus.rsp.allowExecute := True

        breakable {
            for (i <- 0 to 15) {
                val pmp_r    = pmpcfg(i)(0)
                val pmp_w    = pmpcfg(i)(1)
                val pmp_x    = pmpcfg(i)(2)
                val pmp_a    = pmpcfg(i)(4 downto 3)
    //          val pmp_wiri = pmpcfg(i)(6 downto 5)    // not used because not 64bit 
                val pmp_l    = pmpcfg(i)(7)
                val pmp_addr = pmpaddr(i)
                
                var addrMatch = False
                
                if (pmp_a == U"00") {   // cfg disabled
                    // nop
                } else if (pmp_a == U"01") { // TOR (top of range) - not implemented
                    // nop
                } else if (pmp_a == U"10") { // NA4 (naturally aligned four-byte region)
                    if ((physAddr(31 downto 0) === pmp_addr(31 downto 0)) == True) {
                        addrMatch = True
                    }
                } else if (pmp_a == U"11") { // NAPOT (naturally aligned power-of-two-region >= 8 bytes)
                    // search for first '0'
                    var count = 0
                    val mask = pmp_addr ^ (pmp_addr+1)
                    if (((physAddr & mask) === (pmp_addr & mask)) == True) {
                        addrMatch = True
                    }
                }

                if (addrMatch == True) {
                    port.bus.rsp.allowRead := pmp_r
                    port.bus.rsp.allowWrite := pmp_w
                    port.bus.rsp.allowExecute := pmp_x
                    break   // break loop on match
                }
            }
        }
       
/*
        when(supervisorRange(port.bus.rsp.physicalAddress)) {
          port.bus.rsp.allowRead := privilegeService.isMachine() || privilegeService.isSupervisor()
          port.bus.rsp.allowWrite := privilegeService.isMachine() || privilegeService.isSupervisor()
          port.bus.rsp.allowExecute := False
        } otherwise {
          port.bus.rsp.allowRead := True
          // last term for debugging upload
          port.bus.rsp.allowWrite := !romRange(port.bus.rsp.physicalAddress) || privilegeService.isMachine()
          port.bus.rsp.allowExecute := romRange(port.bus.rsp.physicalAddress) 
        }*/
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False
      }
    }
  }
}
