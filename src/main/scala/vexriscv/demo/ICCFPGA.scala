package vexriscv.demo


import vexriscv.plugin._
import vexriscv._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.com.jtag.Jtag
import spinal.lib.graphic.RgbConfig
import spinal.lib.io.TriStateArray
import spinal.lib.misc.HexTools
import spinal.lib.soc.pinsec.{PinsecTimerCtrl, PinsecTimerCtrlExternal}
import spinal.lib.system.debugger.{JtagAxi4SharedDebugger, JtagBridge, SystemDebugger, SystemDebuggerConfig}

import scala.collection.mutable.ArrayBuffer


case class ICCFPGAConfig(axiFrequency : HertzNumber,
                       onChipRamSize : BigInt,
                       cpuPlugins : ArrayBuffer[Plugin[VexRiscv]]
                      )

object ICCFPGAConfig{

  def default = {
    val config = ICCFPGAConfig(
      axiFrequency = 50 MHz,
      onChipRamSize  = 4 kB,
      cpuPlugins = ArrayBuffer(
        new PcManagerSimplePlugin(0x00000000l, false),
        //          new IBusSimplePlugin(
        //            interfaceKeepData = false,
        //            catchAccessFault = true
        //          ),
        new IBusCachedPlugin(
          resetVector = 0x00000000l,
          prediction = STATIC,
          compressedGen = true,
          injectorStage = true,
          config = InstructionCacheConfig(
            cacheSize = 4096,
            bytePerLine =32,
            wayCount = 1,
            addressWidth = 32,
            cpuDataWidth = 32,
            memDataWidth = 32,
            catchIllegalAccess = true,
            catchAccessFault = true,
            asyncTagMemory = false,
            twoCycleRam = true,
            twoCycleCache = true
          )
          //            askMemoryTranslation = true,
          //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
          //              portTlbSize = 4
          //            )
        ),
        //                    new DBusSimplePlugin(
        //                      catchAddressMisaligned = true,
        //                      catchAccessFault = true
        //                    ),
        new DBusCachedPlugin(
          config = new DataCacheConfig(
            cacheSize         = 4096,
            bytePerLine       = 32,
            wayCount          = 1,
            addressWidth      = 32,
            cpuDataWidth      = 32,
            memDataWidth      = 32,
            catchAccessError  = true,
            catchIllegal      = true,
            catchUnaligned    = true
//            memAsBlackBox     = true
          ),
          memoryTranslatorPortConfig = null
          //            memoryTranslatorPortConfig = MemoryTranslatorPortConfig(
          //              portTlbSize = 6
          //            )
        ),
/*        new StaticMemoryTranslatorPlugin(
          ioRange      = _(31 downto 28) === 0xF
        ),*/
        new PMPPlugin(
            config = PMPPluginConfig(
                ioRange             = _(31 downto 28) === 0xF,
                pmpCfgRegisterCount = 2
            )
        ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new FullBarrelShifterPlugin,
        new MulPlugin,
        new DivPlugin,
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new BranchPlugin(
          earlyBranch = false,
          catchAddressMisaligned = true
        ),
        new CsrPlugin(
          config = CsrPluginConfig(
            catchIllegalAccess = false,
            mvendorid      = null,
            marchid        = null,
            mimpid         = null,
            mhartid        = null,
            misaExtensionsInit = 66,
            misaAccess     = CsrAccess.NONE,
            mtvecAccess    = CsrAccess.NONE,
            mtvecInit      = 0x00000020l,
//            stvecInit      = 0x00000140l,
            mepcAccess     = CsrAccess.READ_WRITE,
            mscratchGen    = true,
            mcauseAccess   = CsrAccess.READ_ONLY,
            mbadaddrAccess = CsrAccess.READ_ONLY,
            mcycleAccess   = CsrAccess.NONE,
            minstretAccess = CsrAccess.NONE,
            ecallGen       = true,
            wfiGenAsWait   = false,
            ucycleAccess   = CsrAccess.NONE,
            userGen        = true
/*            supervisorGen  = true,
            stvecAccess         = CsrAccess.READ_WRITE,
            sepcAccess          = CsrAccess.READ_WRITE,
            scauseAccess        = CsrAccess.READ_WRITE,
            sbadaddrAccess      = CsrAccess.READ_WRITE,
            medelegAccess       = CsrAccess.WRITE_ONLY,
            midelegAccess       = CsrAccess.WRITE_ONLY*/
          )
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
    config
  }
}



class ICCFPGA(config: ICCFPGAConfig) extends Component{

  //Legacy constructor
  def this(axiFrequency: HertzNumber) {
    this(ICCFPGAConfig.default.copy(axiFrequency = axiFrequency))
  }

  import config._
  val debug = true
  val interruptCount = 4
    
  val axiIOConfig = Axi4Config (
    addressWidth = 32,
    dataWidth = 32,
    idWidth = 4
  )

  val io = new Bundle{
    //Clocks / reset
    val asyncReset = in Bool
    val axiClk     = in Bool

    //Main components IO
    val jtag       = slave(Jtag())

    val axiIO     = master(Axi4(axiIOConfig))

    //Peripherals IO
    val timerInterrupt = in Bool
/*    val timerExternal = in(PinsecTimerCtrlExternal()) */
    val coreInterrupt = in Bool
//    val coreInterruptS = in Bool
  }

  val resetCtrlClockDomain = ClockDomain(
    clock = io.axiClk,
    config = ClockDomainConfig(
      resetKind = BOOT
    )
  )

  val resetCtrl = new ClockingArea(resetCtrlClockDomain) {
    val systemResetUnbuffered  = False
//    val coreResetUnbuffered = False

    //Implement an counter to keep the reset axiResetOrder high 64 cycles
    // Also this counter will automaticly do a reset when the system boot.
    val systemResetCounter = Reg(UInt(6 bits)) init(0)
    when(systemResetCounter =/= U(systemResetCounter.range -> true)){
      systemResetCounter := systemResetCounter + 1
      systemResetUnbuffered := True
    }
    when(BufferCC(io.asyncReset)){
      systemResetCounter := 0
    }

    //Create all reset used later in the design
    val systemReset  = RegNext(systemResetUnbuffered)
    val axiReset     = RegNext(systemResetUnbuffered)
  }

  val axiClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = resetCtrl.axiReset,
    frequency = FixedFrequency(axiFrequency) //The frequency information is used by the SDRAM controller
  )

  val debugClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = resetCtrl.systemReset,
    frequency = FixedFrequency(axiFrequency)
  )


  val axi = new ClockingArea(axiClockDomain) {
    val ram = Axi4SharedOnChipRam(
      dataWidth = 32,
      byteCount = 128 kB,
      idWidth = 4
    )

    val svram = Axi4SharedOnChipRam(
      dataWidth = 32,
      byteCount = 4 kB,
      idWidth = 4
    )

    svram.ram.generateAsBlackBox()

    val rom = Axi4SharedOnChipRam(
      dataWidth = 32,
      byteCount = 128 kB,
      idWidth = 4
    )

    ram.ram.generateAsBlackBox()
    rom.ram.generateAsBlackBox()

    ram.ram.userLabel = "ram"
    rom.ram.userLabel = "rom"
    svram.ram.userLabel = "secure"
/*
    val apbBridge = Axi4SharedToApb3Bridge(
      addressWidth = 20,
      dataWidth    = 32,
      idWidth      = 4
    )

    val timerCtrl = PinsecTimerCtrl()
*/

    val core = new Area{
      val config = VexRiscvConfig(
        plugins = cpuPlugins += new DebugPlugin(debugClockDomain)
      )

      val cpu = new VexRiscv(config)
      var iBus : Axi4ReadOnly = null
      var dBus : Axi4Shared = null
      for(plugin <- config.plugins) plugin match{
        case plugin : IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin : IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
        case plugin : DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
        case plugin : DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared(true)
        case plugin : CsrPlugin        => {
          plugin.externalInterrupt := BufferCC(io.coreInterrupt)
//          plugin.externalInterruptS := BufferCC(io.coreInterruptS)
          plugin.timerInterrupt := BufferCC(io.timerInterrupt) /* timerCtrl.io.interrupt */
        }
        case plugin : DebugPlugin      => debugClockDomain{
          resetCtrl.axiReset setWhen(RegNext(plugin.io.resetOut))
          io.jtag <> plugin.io.bus.fromJtag()
        }
        case _ =>
      }
    }

    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      rom.io.axi           -> (0x00000000L,   128 kB),
      ram.io.axi           -> (0x80000000L,   128 kB),
      svram.io.axi         -> (0x84000000L,   4 kB), 
/*      apbBridge.io.axi     -> (0xF0000000L,   1 MB), */
      io.axiIO             -> (0xF1000000L,   64 MB)
    )

    axiCrossbar.addConnections(
      core.iBus       -> List(rom.io.axi),
      core.dBus       -> List(rom.io.axi, ram.io.axi, svram.io.axi, /*apbBridge.io.axi,*/ io.axiIO)
    )

/*
    axiCrossbar.addPipelining(apbBridge.io.axi)((crossbar,bridge) => {
      crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
      crossbar.writeData.halfPipe() >> bridge.writeData
      crossbar.writeRsp             << bridge.writeRsp
      crossbar.readRsp              << bridge.readRsp
    })
*/
    axiCrossbar.addPipelining(rom.io.axi)((crossbar,ctrl) => {
      crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
      crossbar.writeData            >/-> ctrl.writeData
      crossbar.writeRsp              <<  ctrl.writeRsp
      crossbar.readRsp               <<  ctrl.readRsp
    })

    axiCrossbar.addPipelining(ram.io.axi)((crossbar,ctrl) => {
      crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
      crossbar.writeData            >/-> ctrl.writeData
      crossbar.writeRsp              <<  ctrl.writeRsp
      crossbar.readRsp               <<  ctrl.readRsp
    })

    axiCrossbar.addPipelining(svram.io.axi)((crossbar,ctrl) => {
      crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
      crossbar.writeData            >/-> ctrl.writeData
      crossbar.writeRsp              <<  ctrl.writeRsp
      crossbar.readRsp               <<  ctrl.readRsp
    })

    axiCrossbar.addPipelining(core.dBus)((cpu,crossbar) => {
      cpu.sharedCmd             >>  crossbar.sharedCmd
      cpu.writeData             >>  crossbar.writeData
      cpu.writeRsp              <<  crossbar.writeRsp
      cpu.readRsp               <-< crossbar.readRsp //Data cache directly use read responses without buffering, so pipeline it for FMax
    })

    axiCrossbar.build()

/*
    val apbDecoder = Apb3Decoder(
      master = apbBridge.io.apb,
      slaves = List(
        timerCtrl.io.apb -> (0x20000, 4 kB)
      )
    )
*/    
  }
/*  
  io.timerExternal  <> axi.timerCtrl.io.external
*/
}

//DE1-SoC
object ICCFPGA{
  def main(args: Array[String]) {
    val config = SpinalConfig()
    config.generateVerilog({
//    config.generateVhdl({
      val toplevel = new ICCFPGA(ICCFPGAConfig.default)
      toplevel
    })
  }
}
/*
//DE1-SoC with memory init
object ICCFPGAWithMemoryInit{
  def main(args: Array[String]) {
    val config = SpinalConfig()
    config.generateVerilog({
      val toplevel = new ICCFPGA(ICCFPGAConfig.default)
      HexTools.initRam(toplevel.axi.ram.ram, "src/main/ressource/hex/muraxDemo.hex", 0x80000000l)
      toplevel
    })
  }
}


//DE0-Nano
object ICCFPGADe0Nano{
  def main(args: Array[String]) {
    val config = SpinalConfig()
    config.generateVerilog({
      val toplevel = new ICCFPGA(ICCFPGAConfig.default.copy())
      toplevel
    })
  }
}*/
