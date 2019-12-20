package vexriscv.plugin

import vexriscv.{VexRiscv, _}
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer
case class MemoryProtectionUnitPort(bus : MemoryTranslatorBus, priority : Int)

class MemoryProtectionUnitPlugin(ioRange : UInt => Bool, romRange : UInt => Bool, ramRange : UInt => Bool, supervisorRange : UInt => Bool) extends Plugin[VexRiscv] with MemoryTranslator {
  val portsInfo = ArrayBuffer[MemoryProtectionUnitPort]()

  override def newTranslationPort(priority : Int,args : Any): MemoryTranslatorBus = {
//    val exceptionBus = pipeline.service(classOf[ExceptionService]).newExceptionPort(stage)
    val port = MemoryProtectionUnitPort(MemoryTranslatorBus(),priority)
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
      val ports = for ((port, portId) <- portsInfo.zipWithIndex) yield new Area {
        val privilegeService = pipeline.serviceElse(classOf[PrivilegeService], PrivilegeServiceDefault())

        port.bus.rsp.physicalAddress := port.bus.cmd.virtualAddress

        when(supervisorRange(port.bus.rsp.physicalAddress)) {
          port.bus.rsp.allowRead := privilegeService.isMachine() || privilegeService.isSupervisor()
          port.bus.rsp.allowWrite := privilegeService.isMachine() || privilegeService.isSupervisor()
          port.bus.rsp.allowExecute := False
        } otherwise {
          port.bus.rsp.allowRead := True
          // last term for debugging upload
          port.bus.rsp.allowWrite := !romRange(port.bus.rsp.physicalAddress) || privilegeService.isMachine()
          port.bus.rsp.allowExecute := romRange(port.bus.rsp.physicalAddress) 
        }
        port.bus.rsp.isIoAccess := ioRange(port.bus.rsp.physicalAddress)
        port.bus.rsp.exception := False
        port.bus.rsp.refilling := False
        port.bus.busy := False
      }
    }
  }
}
