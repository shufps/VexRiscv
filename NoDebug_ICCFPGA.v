// Generator : SpinalHDL v1.3.7    git head : e0c0435e19603628a22ba5819ff2bcc670964d29
// Date      : 03/02/2020, 11:35:13
// Component : NoDebug_ICCFPGA


`define EnvCtrlEnum_defaultEncoding_type [1:0]
`define EnvCtrlEnum_defaultEncoding_NONE 2'b00
`define EnvCtrlEnum_defaultEncoding_XRET 2'b01
`define EnvCtrlEnum_defaultEncoding_ECALL 2'b10

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

module NoDebug_InstructionCache (
      input   io_flush,
      input   io_cpu_prefetch_isValid,
      output reg  io_cpu_prefetch_haltIt,
      input  [31:0] io_cpu_prefetch_pc,
      input   io_cpu_fetch_isValid,
      input   io_cpu_fetch_isStuck,
      input   io_cpu_fetch_isRemoved,
      input  [31:0] io_cpu_fetch_pc,
      output [31:0] io_cpu_fetch_data,
      output  io_cpu_fetch_mmuBus_cmd_isValid,
      output [31:0] io_cpu_fetch_mmuBus_cmd_virtualAddress,
      output  io_cpu_fetch_mmuBus_cmd_bypassTranslation,
      input  [31:0] io_cpu_fetch_mmuBus_rsp_physicalAddress,
      input   io_cpu_fetch_mmuBus_rsp_isIoAccess,
      input   io_cpu_fetch_mmuBus_rsp_allowRead,
      input   io_cpu_fetch_mmuBus_rsp_allowWrite,
      input   io_cpu_fetch_mmuBus_rsp_allowExecute,
      input   io_cpu_fetch_mmuBus_rsp_exception,
      input   io_cpu_fetch_mmuBus_rsp_refilling,
      output  io_cpu_fetch_mmuBus_end,
      input   io_cpu_fetch_mmuBus_busy,
      output [31:0] io_cpu_fetch_physicalAddress,
      output  io_cpu_fetch_haltIt,
      input   io_cpu_decode_isValid,
      input   io_cpu_decode_isStuck,
      input  [31:0] io_cpu_decode_pc,
      output [31:0] io_cpu_decode_physicalAddress,
      output [31:0] io_cpu_decode_data,
      output  io_cpu_decode_cacheMiss,
      output  io_cpu_decode_error,
      output  io_cpu_decode_mmuRefilling,
      output  io_cpu_decode_mmuException,
      input   io_cpu_decode_isUser,
      input   io_cpu_fill_valid,
      input  [31:0] io_cpu_fill_payload,
      output  io_mem_cmd_valid,
      input   io_mem_cmd_ready,
      output [31:0] io_mem_cmd_payload_address,
      output [2:0] io_mem_cmd_payload_size,
      input   io_mem_rsp_valid,
      input  [31:0] io_mem_rsp_payload_data,
      input   io_mem_rsp_payload_error,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg [21:0] _zz_11_;
  reg [31:0] _zz_12_;
  wire  _zz_13_;
  wire  _zz_14_;
  wire [0:0] _zz_15_;
  wire [0:0] _zz_16_;
  wire [21:0] _zz_17_;
  reg  _zz_1_;
  reg  _zz_2_;
  reg  lineLoader_fire;
  reg  lineLoader_valid;
  (* keep , syn_keep *) reg [31:0] lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg  lineLoader_hadError;
  reg  lineLoader_flushPending;
  reg [7:0] lineLoader_flushCounter;
  reg  _zz_3_;
  reg  lineLoader_cmdSent;
  reg  lineLoader_wayToAllocate_willIncrement;
  wire  lineLoader_wayToAllocate_willClear;
  wire  lineLoader_wayToAllocate_willOverflowIfInc;
  wire  lineLoader_wayToAllocate_willOverflow;
  (* keep , syn_keep *) reg [2:0] lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
  wire  lineLoader_write_tag_0_valid;
  wire [6:0] lineLoader_write_tag_0_payload_address;
  wire  lineLoader_write_tag_0_payload_data_valid;
  wire  lineLoader_write_tag_0_payload_data_error;
  wire [19:0] lineLoader_write_tag_0_payload_data_address;
  wire  lineLoader_write_data_0_valid;
  wire [9:0] lineLoader_write_data_0_payload_address;
  wire [31:0] lineLoader_write_data_0_payload_data;
  wire  _zz_4_;
  wire [6:0] _zz_5_;
  wire  _zz_6_;
  wire  fetchStage_read_waysValues_0_tag_valid;
  wire  fetchStage_read_waysValues_0_tag_error;
  wire [19:0] fetchStage_read_waysValues_0_tag_address;
  wire [21:0] _zz_7_;
  wire [9:0] _zz_8_;
  wire  _zz_9_;
  wire [31:0] fetchStage_read_waysValues_0_data;
  reg [31:0] decodeStage_mmuRsp_physicalAddress;
  reg  decodeStage_mmuRsp_isIoAccess;
  reg  decodeStage_mmuRsp_allowRead;
  reg  decodeStage_mmuRsp_allowWrite;
  reg  decodeStage_mmuRsp_allowExecute;
  reg  decodeStage_mmuRsp_exception;
  reg  decodeStage_mmuRsp_refilling;
  reg  decodeStage_hit_tags_0_valid;
  reg  decodeStage_hit_tags_0_error;
  reg [19:0] decodeStage_hit_tags_0_address;
  wire  decodeStage_hit_hits_0;
  wire  decodeStage_hit_valid;
  wire  decodeStage_hit_error;
  reg [31:0] _zz_10_;
  wire [31:0] decodeStage_hit_data;
  reg [21:0] ways_0_tags [0:127];
  reg [31:0] ways_0_datas [0:1023];
  assign _zz_13_ = (! lineLoader_flushCounter[7]);
  assign _zz_14_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_15_ = _zz_7_[0 : 0];
  assign _zz_16_ = _zz_7_[1 : 1];
  assign _zz_17_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge io_axiClk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_17_;
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_6_) begin
      _zz_11_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_9_) begin
      _zz_12_ <= ways_0_datas[_zz_8_];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2_ = 1'b1;
    end
  end

  assign io_cpu_fetch_haltIt = io_cpu_fetch_mmuBus_busy;
  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == (3'b111)))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_13_)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3_))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],(5'b00000)};
  assign io_mem_cmd_payload_size = (3'b101);
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign _zz_4_ = 1'b1;
  assign lineLoader_write_tag_0_valid = ((_zz_4_ && lineLoader_fire) || (! lineLoader_flushCounter[7]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[7] ? lineLoader_address[11 : 5] : lineLoader_flushCounter[6 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[7];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 12];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && _zz_4_);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[11 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_5_ = io_cpu_prefetch_pc[11 : 5];
  assign _zz_6_ = (! io_cpu_fetch_isStuck);
  assign _zz_7_ = _zz_11_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_15_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_16_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[21 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[11 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_12_;
  assign io_cpu_fetch_data = fetchStage_read_waysValues_0_data;
  assign io_cpu_fetch_mmuBus_cmd_isValid = io_cpu_fetch_isValid;
  assign io_cpu_fetch_mmuBus_cmd_virtualAddress = io_cpu_fetch_pc;
  assign io_cpu_fetch_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_fetch_mmuBus_end = ((! io_cpu_fetch_isStuck) || io_cpu_fetch_isRemoved);
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuBus_rsp_physicalAddress;
  assign decodeStage_hit_hits_0 = (decodeStage_hit_tags_0_valid && (decodeStage_hit_tags_0_address == decodeStage_mmuRsp_physicalAddress[31 : 12]));
  assign decodeStage_hit_valid = (decodeStage_hit_hits_0 != (1'b0));
  assign decodeStage_hit_error = decodeStage_hit_tags_0_error;
  assign decodeStage_hit_data = _zz_10_;
  assign io_cpu_decode_data = decodeStage_hit_data;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = decodeStage_hit_error;
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = ((! decodeStage_mmuRsp_refilling) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= (3'b000);
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_14_)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + (3'b001));
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_13_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + (8'b00000001));
    end
    _zz_3_ <= lineLoader_flushCounter[7];
    if(_zz_14_)begin
      lineLoader_flushCounter <= (8'b00000000);
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuBus_rsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuBus_rsp_isIoAccess;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuBus_rsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuBus_rsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuBus_rsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuBus_rsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuBus_rsp_refilling;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_tags_0_valid <= fetchStage_read_waysValues_0_tag_valid;
      decodeStage_hit_tags_0_error <= fetchStage_read_waysValues_0_tag_error;
      decodeStage_hit_tags_0_address <= fetchStage_read_waysValues_0_tag_address;
    end
    if((! io_cpu_decode_isStuck))begin
      _zz_10_ <= fetchStage_read_waysValues_0_data;
    end
  end

endmodule

module NoDebug_DataCache (
      input   io_cpu_execute_isValid,
      input  [31:0] io_cpu_execute_address,
      input   io_cpu_execute_args_wr,
      input  [31:0] io_cpu_execute_args_data,
      input  [1:0] io_cpu_execute_args_size,
      input   io_cpu_memory_isValid,
      input   io_cpu_memory_isStuck,
      input   io_cpu_memory_isRemoved,
      output  io_cpu_memory_isWrite,
      input  [31:0] io_cpu_memory_address,
      output  io_cpu_memory_mmuBus_cmd_isValid,
      output [31:0] io_cpu_memory_mmuBus_cmd_virtualAddress,
      output  io_cpu_memory_mmuBus_cmd_bypassTranslation,
      input  [31:0] io_cpu_memory_mmuBus_rsp_physicalAddress,
      input   io_cpu_memory_mmuBus_rsp_isIoAccess,
      input   io_cpu_memory_mmuBus_rsp_allowRead,
      input   io_cpu_memory_mmuBus_rsp_allowWrite,
      input   io_cpu_memory_mmuBus_rsp_allowExecute,
      input   io_cpu_memory_mmuBus_rsp_exception,
      input   io_cpu_memory_mmuBus_rsp_refilling,
      output  io_cpu_memory_mmuBus_end,
      input   io_cpu_memory_mmuBus_busy,
      input   io_cpu_writeBack_isValid,
      input   io_cpu_writeBack_isStuck,
      input   io_cpu_writeBack_isUser,
      output reg  io_cpu_writeBack_haltIt,
      output  io_cpu_writeBack_isWrite,
      output reg [31:0] io_cpu_writeBack_data,
      input  [31:0] io_cpu_writeBack_address,
      output  io_cpu_writeBack_mmuException,
      output  io_cpu_writeBack_unalignedAccess,
      output reg  io_cpu_writeBack_accessError,
      output reg  io_cpu_redo,
      input   io_cpu_flush_valid,
      output reg  io_cpu_flush_ready,
      output reg  io_mem_cmd_valid,
      input   io_mem_cmd_ready,
      output reg  io_mem_cmd_payload_wr,
      output reg [31:0] io_mem_cmd_payload_address,
      output [31:0] io_mem_cmd_payload_data,
      output [3:0] io_mem_cmd_payload_mask,
      output reg [2:0] io_mem_cmd_payload_length,
      output reg  io_mem_cmd_payload_last,
      input   io_mem_rsp_valid,
      input  [31:0] io_mem_rsp_payload_data,
      input   io_mem_rsp_payload_error,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg [21:0] _zz_10_;
  reg [31:0] _zz_11_;
  wire  _zz_12_;
  wire  _zz_13_;
  wire  _zz_14_;
  wire  _zz_15_;
  wire  _zz_16_;
  wire  _zz_17_;
  wire [0:0] _zz_18_;
  wire [0:0] _zz_19_;
  wire [0:0] _zz_20_;
  wire [2:0] _zz_21_;
  wire [1:0] _zz_22_;
  wire [21:0] _zz_23_;
  reg  _zz_1_;
  reg  _zz_2_;
  wire  haltCpu;
  reg  tagsReadCmd_valid;
  reg [6:0] tagsReadCmd_payload;
  reg  tagsWriteCmd_valid;
  reg [0:0] tagsWriteCmd_payload_way;
  reg [6:0] tagsWriteCmd_payload_address;
  reg  tagsWriteCmd_payload_data_valid;
  reg  tagsWriteCmd_payload_data_error;
  reg [19:0] tagsWriteCmd_payload_data_address;
  reg  tagsWriteLastCmd_valid;
  reg [0:0] tagsWriteLastCmd_payload_way;
  reg [6:0] tagsWriteLastCmd_payload_address;
  reg  tagsWriteLastCmd_payload_data_valid;
  reg  tagsWriteLastCmd_payload_data_error;
  reg [19:0] tagsWriteLastCmd_payload_data_address;
  reg  dataReadCmd_valid;
  reg [9:0] dataReadCmd_payload;
  reg  dataWriteCmd_valid;
  reg [0:0] dataWriteCmd_payload_way;
  reg [9:0] dataWriteCmd_payload_address;
  reg [31:0] dataWriteCmd_payload_data;
  reg [3:0] dataWriteCmd_payload_mask;
  wire  _zz_3_;
  wire  ways_0_tagsReadRsp_valid;
  wire  ways_0_tagsReadRsp_error;
  wire [19:0] ways_0_tagsReadRsp_address;
  wire [21:0] _zz_4_;
  wire  _zz_5_;
  wire [31:0] ways_0_dataReadRsp;
  reg [3:0] _zz_6_;
  wire [3:0] stage0_mask;
  wire [0:0] stage0_colisions;
  reg  stageA_request_wr;
  reg [31:0] stageA_request_data;
  reg [1:0] stageA_request_size;
  reg [3:0] stageA_mask;
  wire  stageA_wayHits_0;
  reg [0:0] stage0_colisions_regNextWhen;
  wire [0:0] _zz_7_;
  wire [0:0] stageA_colisions;
  reg  stageB_request_wr;
  reg [31:0] stageB_request_data;
  reg [1:0] stageB_request_size;
  reg  stageB_mmuRspFreeze;
  reg [31:0] stageB_mmuRsp_physicalAddress;
  reg  stageB_mmuRsp_isIoAccess;
  reg  stageB_mmuRsp_allowRead;
  reg  stageB_mmuRsp_allowWrite;
  reg  stageB_mmuRsp_allowExecute;
  reg  stageB_mmuRsp_exception;
  reg  stageB_mmuRsp_refilling;
  reg  stageB_tagsReadRsp_0_valid;
  reg  stageB_tagsReadRsp_0_error;
  reg [19:0] stageB_tagsReadRsp_0_address;
  reg [31:0] stageB_dataReadRsp_0;
  wire [0:0] _zz_8_;
  reg [0:0] stageB_waysHits;
  wire  stageB_waysHit;
  wire [31:0] stageB_dataMux;
  reg [3:0] stageB_mask;
  reg [0:0] stageB_colisions;
  reg  stageB_loaderValid;
  reg  stageB_flusher_valid;
  wire [31:0] stageB_requestDataBypass;
  wire  stageB_isAmo;
  reg  stageB_memCmdSent;
  wire [0:0] _zz_9_;
  reg  loader_valid;
  reg  loader_counter_willIncrement;
  wire  loader_counter_willClear;
  reg [2:0] loader_counter_valueNext;
  reg [2:0] loader_counter_value;
  wire  loader_counter_willOverflowIfInc;
  wire  loader_counter_willOverflow;
  reg [0:0] loader_waysAllocator;
  reg  loader_error;
  reg [21:0] ways_0_tags [0:127];
  reg [7:0] ways_0_data_symbol0 [0:1023];
  reg [7:0] ways_0_data_symbol1 [0:1023];
  reg [7:0] ways_0_data_symbol2 [0:1023];
  reg [7:0] ways_0_data_symbol3 [0:1023];
  reg [7:0] _zz_24_;
  reg [7:0] _zz_25_;
  reg [7:0] _zz_26_;
  reg [7:0] _zz_27_;
  assign _zz_12_ = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_13_ = (((stageB_mmuRsp_refilling || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_14_ = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmo)));
  assign _zz_15_ = (loader_valid && io_mem_rsp_valid);
  assign _zz_16_ = ((((io_cpu_flush_valid && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
  assign _zz_17_ = ((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze));
  assign _zz_18_ = _zz_4_[0 : 0];
  assign _zz_19_ = _zz_4_[1 : 1];
  assign _zz_20_ = loader_counter_willIncrement;
  assign _zz_21_ = {2'd0, _zz_20_};
  assign _zz_22_ = {loader_waysAllocator,loader_waysAllocator[0]};
  assign _zz_23_ = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge io_axiClk) begin
    if(_zz_3_) begin
      _zz_10_ <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_2_) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_23_;
    end
  end

  always @ (*) begin
    _zz_11_ = {_zz_27_, _zz_26_, _zz_25_, _zz_24_};
  end
  always @ (posedge io_axiClk) begin
    if(_zz_5_) begin
      _zz_24_ <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_25_ <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_26_ <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_27_ <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge io_axiClk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1_) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1_) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1_) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1_) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_2_ = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_3_ = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_4_ = _zz_10_;
  assign ways_0_tagsReadRsp_valid = _zz_18_[0];
  assign ways_0_tagsReadRsp_error = _zz_19_[0];
  assign ways_0_tagsReadRsp_address = _zz_4_[21 : 2];
  assign _zz_5_ = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRsp = _zz_11_;
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = (7'bxxxxxxx);
    if(_zz_12_)begin
      tagsReadCmd_payload = io_cpu_execute_address[11 : 5];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = (10'bxxxxxxxxxx);
    if(_zz_12_)begin
      dataReadCmd_payload = io_cpu_execute_address[11 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_valid = stageB_flusher_valid;
    end
    if(_zz_13_)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = (1'bx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_way = (1'b1);
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = (7'bxxxxxxx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_error = (loader_error || io_mem_rsp_payload_error);
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_address = (20'bxxxxxxxxxxxxxxxxxxxx);
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 12];
    end
  end

  always @ (*) begin
    dataWriteCmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((stageB_request_wr && stageB_waysHit))begin
            dataWriteCmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_15_)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = (1'bx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_way = stageB_waysHits;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = (10'bxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 2];
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[11 : 5],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_data = stageB_requestDataBypass;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = (4'bxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_mask = stageB_mask;
        end
      end
    end
    if(_zz_15_)begin
      dataWriteCmd_payload_mask = (4'b1111);
    end
  end

  always @ (*) begin
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_6_ = (4'b0001);
      end
      2'b01 : begin
        _zz_6_ = (4'b0011);
      end
      default : begin
        _zz_6_ = (4'b1111);
      end
    endcase
  end

  assign stage0_mask = (_zz_6_ <<< io_cpu_execute_address[1 : 0]);
  assign stage0_colisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_execute_address[11 : 2])) && ((stage0_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign io_cpu_memory_mmuBus_cmd_isValid = io_cpu_memory_isValid;
  assign io_cpu_memory_mmuBus_cmd_virtualAddress = io_cpu_memory_address;
  assign io_cpu_memory_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_memory_mmuBus_end = ((! io_cpu_memory_isStuck) || io_cpu_memory_isRemoved);
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_wayHits_0 = ((io_cpu_memory_mmuBus_rsp_physicalAddress[31 : 12] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid);
  assign _zz_7_[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_memory_address[11 : 2])) && ((stageA_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign stageA_colisions = (stage0_colisions_regNextWhen | _zz_7_);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign _zz_8_[0] = stageA_wayHits_0;
  assign stageB_waysHit = (stageB_waysHits != (1'b0));
  assign stageB_dataMux = stageB_dataReadRsp_0;
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          if(io_mem_cmd_ready)begin
            stageB_loaderValid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      stageB_loaderValid = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_haltIt = io_cpu_writeBack_isValid;
    if(stageB_flusher_valid)begin
      io_cpu_writeBack_haltIt = 1'b1;
    end
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        if((stageB_request_wr ? io_mem_cmd_ready : io_mem_rsp_valid))begin
          io_cpu_writeBack_haltIt = 1'b0;
        end
      end else begin
        if(_zz_14_)begin
          if(((! stageB_request_wr) || io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_flush_ready = 1'b0;
    if(_zz_16_)begin
      io_cpu_flush_ready = 1'b1;
    end
  end

  assign stageB_requestDataBypass = stageB_request_data;
  assign stageB_isAmo = 1'b0;
  always @ (*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((((! stageB_request_wr) || stageB_isAmo) && ((stageB_colisions & stageB_waysHits) != (1'b0))))begin
            io_cpu_redo = 1'b1;
          end
        end
      end
    end
    if((io_cpu_writeBack_isValid && stageB_mmuRsp_refilling))begin
      io_cpu_redo = 1'b1;
    end
    if(loader_valid)begin
      io_cpu_redo = 1'b1;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_accessError = 1'b0;
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_accessError = (io_mem_rsp_valid && io_mem_rsp_payload_error);
    end else begin
      io_cpu_writeBack_accessError = ((stageB_waysHits & _zz_9_) != (1'b0));
    end
  end

  assign io_cpu_writeBack_mmuException = (io_cpu_writeBack_isValid && ((stageB_mmuRsp_exception || ((! stageB_mmuRsp_allowWrite) && stageB_request_wr)) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo))));
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && (((stageB_request_size == (2'b10)) && (stageB_mmuRsp_physicalAddress[1 : 0] != (2'b00))) || ((stageB_request_size == (2'b01)) && (stageB_mmuRsp_physicalAddress[0 : 0] != (1'b0)))));
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @ (*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_valid = (! stageB_memCmdSent);
      end else begin
        if(_zz_14_)begin
          if(stageB_request_wr)begin
            io_mem_cmd_valid = 1'b1;
          end
        end else begin
          if((! stageB_memCmdSent))begin
            io_mem_cmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
        end else begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 5],(5'b00000)};
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_length = (3'bxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_length = (3'b000);
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_length = (3'b000);
        end else begin
          io_mem_cmd_payload_length = (3'b111);
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_last = 1'bx;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_last = 1'b1;
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_last = 1'b1;
        end else begin
          io_mem_cmd_payload_last = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          io_mem_cmd_payload_wr = 1'b0;
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  always @ (*) begin
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_data = io_mem_rsp_payload_data;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
  end

  assign _zz_9_[0] = stageB_tagsReadRsp_0_error;
  always @ (*) begin
    loader_counter_willIncrement = 1'b0;
    if(_zz_15_)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == (3'b111));
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_21_);
    if(loader_counter_willClear)begin
      loader_counter_valueNext = (3'b000);
    end
  end

  always @ (posedge io_axiClk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if((! io_cpu_memory_isStuck))begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_data <= io_cpu_execute_args_data;
      stageA_request_size <= io_cpu_execute_args_size;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_mask <= stage0_mask;
    end
    if((! io_cpu_memory_isStuck))begin
      stage0_colisions_regNextWhen <= stage0_colisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_data <= stageA_request_data;
      stageB_request_size <= stageA_request_size;
    end
    if(_zz_17_)begin
      stageB_mmuRsp_isIoAccess <= io_cpu_memory_mmuBus_rsp_isIoAccess;
      stageB_mmuRsp_allowRead <= io_cpu_memory_mmuBus_rsp_allowRead;
      stageB_mmuRsp_allowWrite <= io_cpu_memory_mmuBus_rsp_allowWrite;
      stageB_mmuRsp_allowExecute <= io_cpu_memory_mmuBus_rsp_allowExecute;
      stageB_mmuRsp_exception <= io_cpu_memory_mmuBus_rsp_exception;
      stageB_mmuRsp_refilling <= io_cpu_memory_mmuBus_rsp_refilling;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_waysHits <= _zz_8_;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_mask <= stageA_mask;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_colisions <= stageA_colisions;
    end
    if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
      $display("ERROR writeBack stuck by another plugin is not allowed");
    end
  end

  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      stageB_flusher_valid <= 1'b1;
      stageB_mmuRsp_physicalAddress <= (32'b00000000000000000000000000000000);
      stageB_memCmdSent <= 1'b0;
      loader_valid <= 1'b0;
      loader_counter_value <= (3'b000);
      loader_waysAllocator <= (1'b1);
      loader_error <= 1'b0;
    end else begin
      if(_zz_17_)begin
        stageB_mmuRsp_physicalAddress <= io_cpu_memory_mmuBus_rsp_physicalAddress;
      end
      if(stageB_flusher_valid)begin
        if((stageB_mmuRsp_physicalAddress[11 : 5] != (7'b1111111)))begin
          stageB_mmuRsp_physicalAddress[11 : 5] <= (stageB_mmuRsp_physicalAddress[11 : 5] + (7'b0000001));
        end else begin
          stageB_flusher_valid <= 1'b0;
        end
      end
      if(_zz_16_)begin
        stageB_mmuRsp_physicalAddress[11 : 5] <= (7'b0000000);
        stageB_flusher_valid <= 1'b1;
      end
      if(io_mem_cmd_ready)begin
        stageB_memCmdSent <= 1'b1;
      end
      if((! io_cpu_writeBack_isStuck))begin
        stageB_memCmdSent <= 1'b0;
      end
      if(stageB_loaderValid)begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(_zz_15_)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_counter_willOverflow)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_22_[0:0];
      end
    end
  end

endmodule

module NoDebug_Axi4ReadOnlyErrorSlave (
      input   io_axi_ar_valid,
      output  io_axi_ar_ready,
      input  [31:0] io_axi_ar_payload_addr,
      input  [7:0] io_axi_ar_payload_len,
      input  [1:0] io_axi_ar_payload_burst,
      input  [3:0] io_axi_ar_payload_cache,
      input  [2:0] io_axi_ar_payload_prot,
      output  io_axi_r_valid,
      input   io_axi_r_ready,
      output [31:0] io_axi_r_payload_data,
      output [1:0] io_axi_r_payload_resp,
      output  io_axi_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_1_;
  reg  sendRsp;
  reg [7:0] remaining;
  wire  remainingZero;
  assign _zz_1_ = (io_axi_ar_valid && io_axi_ar_ready);
  assign remainingZero = (remaining == (8'b00000000));
  assign io_axi_ar_ready = (! sendRsp);
  assign io_axi_r_valid = sendRsp;
  assign io_axi_r_payload_resp = (2'b11);
  assign io_axi_r_payload_last = remainingZero;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      sendRsp <= 1'b0;
    end else begin
      if(_zz_1_)begin
        sendRsp <= 1'b1;
      end
      if(sendRsp)begin
        if(io_axi_r_ready)begin
          if(remainingZero)begin
            sendRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_1_)begin
      remaining <= io_axi_ar_payload_len;
    end
    if(sendRsp)begin
      if(io_axi_r_ready)begin
        remaining <= (remaining - (8'b00000001));
      end
    end
  end

endmodule

module NoDebug_Axi4SharedErrorSlave (
      input   io_axi_arw_valid,
      output  io_axi_arw_ready,
      input  [31:0] io_axi_arw_payload_addr,
      input  [7:0] io_axi_arw_payload_len,
      input  [2:0] io_axi_arw_payload_size,
      input  [3:0] io_axi_arw_payload_cache,
      input  [2:0] io_axi_arw_payload_prot,
      input   io_axi_arw_payload_write,
      input   io_axi_w_valid,
      output  io_axi_w_ready,
      input  [31:0] io_axi_w_payload_data,
      input  [3:0] io_axi_w_payload_strb,
      input   io_axi_w_payload_last,
      output  io_axi_b_valid,
      input   io_axi_b_ready,
      output [1:0] io_axi_b_payload_resp,
      output  io_axi_r_valid,
      input   io_axi_r_ready,
      output [31:0] io_axi_r_payload_data,
      output [1:0] io_axi_r_payload_resp,
      output  io_axi_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_1_;
  reg  consumeData;
  reg  sendReadRsp;
  reg  sendWriteRsp;
  reg [7:0] remaining;
  wire  remainingZero;
  assign _zz_1_ = (io_axi_arw_valid && io_axi_arw_ready);
  assign remainingZero = (remaining == (8'b00000000));
  assign io_axi_arw_ready = (! ((consumeData || sendWriteRsp) || sendReadRsp));
  assign io_axi_w_ready = consumeData;
  assign io_axi_b_valid = sendWriteRsp;
  assign io_axi_b_payload_resp = (2'b11);
  assign io_axi_r_valid = sendReadRsp;
  assign io_axi_r_payload_resp = (2'b11);
  assign io_axi_r_payload_last = remainingZero;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      consumeData <= 1'b0;
      sendReadRsp <= 1'b0;
      sendWriteRsp <= 1'b0;
    end else begin
      if(_zz_1_)begin
        consumeData <= io_axi_arw_payload_write;
        sendReadRsp <= (! io_axi_arw_payload_write);
      end
      if(((io_axi_w_valid && io_axi_w_ready) && io_axi_w_payload_last))begin
        consumeData <= 1'b0;
        sendWriteRsp <= 1'b1;
      end
      if((io_axi_b_valid && io_axi_b_ready))begin
        sendWriteRsp <= 1'b0;
      end
      if(sendReadRsp)begin
        if(io_axi_r_ready)begin
          if(remainingZero)begin
            sendReadRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_1_)begin
      remaining <= io_axi_arw_payload_len;
    end
    if(sendReadRsp)begin
      if(io_axi_r_ready)begin
        remaining <= (remaining - (8'b00000001));
      end
    end
  end

endmodule

module NoDebug_StreamArbiter (
      input   io_inputs_0_valid,
      output  io_inputs_0_ready,
      input  [16:0] io_inputs_0_payload_addr,
      input  [3:0] io_inputs_0_payload_id,
      input  [7:0] io_inputs_0_payload_len,
      input  [2:0] io_inputs_0_payload_size,
      input  [1:0] io_inputs_0_payload_burst,
      input   io_inputs_0_payload_write,
      output  io_output_valid,
      input   io_output_ready,
      output [16:0] io_output_payload_addr,
      output [3:0] io_output_payload_id,
      output [7:0] io_output_payload_len,
      output [2:0] io_output_payload_size,
      output [1:0] io_output_payload_burst,
      output  io_output_payload_write,
      output [0:0] io_chosenOH,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire [1:0] _zz_4_;
  wire [0:0] _zz_5_;
  wire [1:0] _zz_6_;
  wire [0:0] _zz_7_;
  wire [0:0] _zz_8_;
  reg  locked;
  wire  maskProposal_0;
  reg  maskLocked_0;
  wire  maskRouted_0;
  wire [0:0] _zz_1_;
  wire [1:0] _zz_2_;
  wire [1:0] _zz_3_;
  assign _zz_4_ = (_zz_2_ - _zz_6_);
  assign _zz_5_ = maskLocked_0;
  assign _zz_6_ = {1'd0, _zz_5_};
  assign _zz_7_ = _zz_8_[0 : 0];
  assign _zz_8_ = (_zz_3_[1 : 1] | _zz_3_[0 : 0]);
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign _zz_1_ = io_inputs_0_valid;
  assign _zz_2_ = {_zz_1_,_zz_1_};
  assign _zz_3_ = (_zz_2_ & (~ _zz_4_));
  assign maskProposal_0 = _zz_7_[0];
  assign io_output_valid = (io_inputs_0_valid && maskRouted_0);
  assign io_output_payload_addr = io_inputs_0_payload_addr;
  assign io_output_payload_id = io_inputs_0_payload_id;
  assign io_output_payload_len = io_inputs_0_payload_len;
  assign io_output_payload_size = io_inputs_0_payload_size;
  assign io_output_payload_burst = io_inputs_0_payload_burst;
  assign io_output_payload_write = io_inputs_0_payload_write;
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_chosenOH = maskRouted_0;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end

endmodule

module NoDebug_StreamFork (
      input   io_input_valid,
      output reg  io_input_ready,
      input  [16:0] io_input_payload_addr,
      input  [3:0] io_input_payload_id,
      input  [7:0] io_input_payload_len,
      input  [2:0] io_input_payload_size,
      input  [1:0] io_input_payload_burst,
      input   io_input_payload_write,
      output  io_outputs_0_valid,
      input   io_outputs_0_ready,
      output [16:0] io_outputs_0_payload_addr,
      output [3:0] io_outputs_0_payload_id,
      output [7:0] io_outputs_0_payload_len,
      output [2:0] io_outputs_0_payload_size,
      output [1:0] io_outputs_0_payload_burst,
      output  io_outputs_0_payload_write,
      output  io_outputs_1_valid,
      input   io_outputs_1_ready,
      output [16:0] io_outputs_1_payload_addr,
      output [3:0] io_outputs_1_payload_id,
      output [7:0] io_outputs_1_payload_len,
      output [2:0] io_outputs_1_payload_size,
      output [1:0] io_outputs_1_payload_burst,
      output  io_outputs_1_payload_write,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  linkEnable_0;
  reg  linkEnable_1;
  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && linkEnable_0))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && linkEnable_1))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && linkEnable_0);
  assign io_outputs_0_payload_addr = io_input_payload_addr;
  assign io_outputs_0_payload_id = io_input_payload_id;
  assign io_outputs_0_payload_len = io_input_payload_len;
  assign io_outputs_0_payload_size = io_input_payload_size;
  assign io_outputs_0_payload_burst = io_input_payload_burst;
  assign io_outputs_0_payload_write = io_input_payload_write;
  assign io_outputs_1_valid = (io_input_valid && linkEnable_1);
  assign io_outputs_1_payload_addr = io_input_payload_addr;
  assign io_outputs_1_payload_id = io_input_payload_id;
  assign io_outputs_1_payload_len = io_input_payload_len;
  assign io_outputs_1_payload_size = io_input_payload_size;
  assign io_outputs_1_payload_burst = io_input_payload_burst;
  assign io_outputs_1_payload_write = io_input_payload_write;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      linkEnable_0 <= 1'b1;
      linkEnable_1 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        linkEnable_0 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        linkEnable_1 <= 1'b0;
      end
      if(io_input_ready)begin
        linkEnable_0 <= 1'b1;
        linkEnable_1 <= 1'b1;
      end
    end
  end

endmodule

module NoDebug_StreamFifoLowLatency (
      input   io_push_valid,
      output  io_push_ready,
      output reg  io_pop_valid,
      input   io_pop_ready,
      input   io_flush,
      output [2:0] io_occupancy,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire [0:0] _zz_1_;
  wire [1:0] _zz_2_;
  wire [0:0] _zz_3_;
  wire [1:0] _zz_4_;
  reg  pushPtr_willIncrement;
  reg  pushPtr_willClear;
  reg [1:0] pushPtr_valueNext;
  reg [1:0] pushPtr_value;
  wire  pushPtr_willOverflowIfInc;
  wire  pushPtr_willOverflow;
  reg  popPtr_willIncrement;
  reg  popPtr_willClear;
  reg [1:0] popPtr_valueNext;
  reg [1:0] popPtr_value;
  wire  popPtr_willOverflowIfInc;
  wire  popPtr_willOverflow;
  wire  ptrMatch;
  reg  risingOccupancy;
  wire  empty;
  wire  full;
  wire  pushing;
  wire  popping;
  wire [1:0] ptrDif;
  assign _zz_1_ = pushPtr_willIncrement;
  assign _zz_2_ = {1'd0, _zz_1_};
  assign _zz_3_ = popPtr_willIncrement;
  assign _zz_4_ = {1'd0, _zz_3_};
  always @ (*) begin
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = (pushPtr_value == (2'b11));
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @ (*) begin
    pushPtr_valueNext = (pushPtr_value + _zz_2_);
    if(pushPtr_willClear)begin
      pushPtr_valueNext = (2'b00);
    end
  end

  always @ (*) begin
    popPtr_willIncrement = 1'b0;
    if(popping)begin
      popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      popPtr_willClear = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = (popPtr_value == (2'b11));
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  always @ (*) begin
    popPtr_valueNext = (popPtr_value + _zz_4_);
    if(popPtr_willClear)begin
      popPtr_valueNext = (2'b00);
    end
  end

  assign ptrMatch = (pushPtr_value == popPtr_value);
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  always @ (*) begin
    if((! empty))begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  assign ptrDif = (pushPtr_value - popPtr_value);
  assign io_occupancy = {(risingOccupancy && ptrMatch),ptrDif};
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      pushPtr_value <= (2'b00);
      popPtr_value <= (2'b00);
      risingOccupancy <= 1'b0;
    end else begin
      pushPtr_value <= pushPtr_valueNext;
      popPtr_value <= popPtr_valueNext;
      if((pushing != popping))begin
        risingOccupancy <= pushing;
      end
      if(io_flush)begin
        risingOccupancy <= 1'b0;
      end
    end
  end

endmodule

module NoDebug_StreamArbiter_1_ (
      input   io_inputs_0_valid,
      output  io_inputs_0_ready,
      input  [11:0] io_inputs_0_payload_addr,
      input  [3:0] io_inputs_0_payload_id,
      input  [7:0] io_inputs_0_payload_len,
      input  [2:0] io_inputs_0_payload_size,
      input  [1:0] io_inputs_0_payload_burst,
      input   io_inputs_0_payload_write,
      output  io_output_valid,
      input   io_output_ready,
      output [11:0] io_output_payload_addr,
      output [3:0] io_output_payload_id,
      output [7:0] io_output_payload_len,
      output [2:0] io_output_payload_size,
      output [1:0] io_output_payload_burst,
      output  io_output_payload_write,
      output [0:0] io_chosenOH,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire [1:0] _zz_4_;
  wire [0:0] _zz_5_;
  wire [1:0] _zz_6_;
  wire [0:0] _zz_7_;
  wire [0:0] _zz_8_;
  reg  locked;
  wire  maskProposal_0;
  reg  maskLocked_0;
  wire  maskRouted_0;
  wire [0:0] _zz_1_;
  wire [1:0] _zz_2_;
  wire [1:0] _zz_3_;
  assign _zz_4_ = (_zz_2_ - _zz_6_);
  assign _zz_5_ = maskLocked_0;
  assign _zz_6_ = {1'd0, _zz_5_};
  assign _zz_7_ = _zz_8_[0 : 0];
  assign _zz_8_ = (_zz_3_[1 : 1] | _zz_3_[0 : 0]);
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign _zz_1_ = io_inputs_0_valid;
  assign _zz_2_ = {_zz_1_,_zz_1_};
  assign _zz_3_ = (_zz_2_ & (~ _zz_4_));
  assign maskProposal_0 = _zz_7_[0];
  assign io_output_valid = (io_inputs_0_valid && maskRouted_0);
  assign io_output_payload_addr = io_inputs_0_payload_addr;
  assign io_output_payload_id = io_inputs_0_payload_id;
  assign io_output_payload_len = io_inputs_0_payload_len;
  assign io_output_payload_size = io_inputs_0_payload_size;
  assign io_output_payload_burst = io_inputs_0_payload_burst;
  assign io_output_payload_write = io_inputs_0_payload_write;
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_chosenOH = maskRouted_0;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end

endmodule

module NoDebug_StreamFork_1_ (
      input   io_input_valid,
      output reg  io_input_ready,
      input  [11:0] io_input_payload_addr,
      input  [3:0] io_input_payload_id,
      input  [7:0] io_input_payload_len,
      input  [2:0] io_input_payload_size,
      input  [1:0] io_input_payload_burst,
      input   io_input_payload_write,
      output  io_outputs_0_valid,
      input   io_outputs_0_ready,
      output [11:0] io_outputs_0_payload_addr,
      output [3:0] io_outputs_0_payload_id,
      output [7:0] io_outputs_0_payload_len,
      output [2:0] io_outputs_0_payload_size,
      output [1:0] io_outputs_0_payload_burst,
      output  io_outputs_0_payload_write,
      output  io_outputs_1_valid,
      input   io_outputs_1_ready,
      output [11:0] io_outputs_1_payload_addr,
      output [3:0] io_outputs_1_payload_id,
      output [7:0] io_outputs_1_payload_len,
      output [2:0] io_outputs_1_payload_size,
      output [1:0] io_outputs_1_payload_burst,
      output  io_outputs_1_payload_write,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  linkEnable_0;
  reg  linkEnable_1;
  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && linkEnable_0))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && linkEnable_1))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && linkEnable_0);
  assign io_outputs_0_payload_addr = io_input_payload_addr;
  assign io_outputs_0_payload_id = io_input_payload_id;
  assign io_outputs_0_payload_len = io_input_payload_len;
  assign io_outputs_0_payload_size = io_input_payload_size;
  assign io_outputs_0_payload_burst = io_input_payload_burst;
  assign io_outputs_0_payload_write = io_input_payload_write;
  assign io_outputs_1_valid = (io_input_valid && linkEnable_1);
  assign io_outputs_1_payload_addr = io_input_payload_addr;
  assign io_outputs_1_payload_id = io_input_payload_id;
  assign io_outputs_1_payload_len = io_input_payload_len;
  assign io_outputs_1_payload_size = io_input_payload_size;
  assign io_outputs_1_payload_burst = io_input_payload_burst;
  assign io_outputs_1_payload_write = io_input_payload_write;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      linkEnable_0 <= 1'b1;
      linkEnable_1 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        linkEnable_0 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        linkEnable_1 <= 1'b0;
      end
      if(io_input_ready)begin
        linkEnable_0 <= 1'b1;
        linkEnable_1 <= 1'b1;
      end
    end
  end

endmodule


//NoDebug_StreamFifoLowLatency_1_ remplaced by NoDebug_StreamFifoLowLatency

module NoDebug_StreamArbiter_2_ (
      input   io_inputs_0_valid,
      output  io_inputs_0_ready,
      input  [16:0] io_inputs_0_payload_addr,
      input  [2:0] io_inputs_0_payload_id,
      input  [7:0] io_inputs_0_payload_len,
      input  [2:0] io_inputs_0_payload_size,
      input  [1:0] io_inputs_0_payload_burst,
      input   io_inputs_0_payload_write,
      input   io_inputs_1_valid,
      output  io_inputs_1_ready,
      input  [16:0] io_inputs_1_payload_addr,
      input  [2:0] io_inputs_1_payload_id,
      input  [7:0] io_inputs_1_payload_len,
      input  [2:0] io_inputs_1_payload_size,
      input  [1:0] io_inputs_1_payload_burst,
      input   io_inputs_1_payload_write,
      output  io_output_valid,
      input   io_output_ready,
      output [16:0] io_output_payload_addr,
      output [2:0] io_output_payload_id,
      output [7:0] io_output_payload_len,
      output [2:0] io_output_payload_size,
      output [1:0] io_output_payload_burst,
      output  io_output_payload_write,
      output [0:0] io_chosen,
      output [1:0] io_chosenOH,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire [3:0] _zz_6_;
  wire [1:0] _zz_7_;
  wire [3:0] _zz_8_;
  wire [0:0] _zz_9_;
  wire [0:0] _zz_10_;
  reg  locked;
  wire  maskProposal_0;
  wire  maskProposal_1;
  reg  maskLocked_0;
  reg  maskLocked_1;
  wire  maskRouted_0;
  wire  maskRouted_1;
  wire [1:0] _zz_1_;
  wire [3:0] _zz_2_;
  wire [3:0] _zz_3_;
  wire [1:0] _zz_4_;
  wire  _zz_5_;
  assign _zz_6_ = (_zz_2_ - _zz_8_);
  assign _zz_7_ = {maskLocked_0,maskLocked_1};
  assign _zz_8_ = {2'd0, _zz_7_};
  assign _zz_9_ = _zz_4_[0 : 0];
  assign _zz_10_ = _zz_4_[1 : 1];
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_1_ = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_2_ = {_zz_1_,_zz_1_};
  assign _zz_3_ = (_zz_2_ & (~ _zz_6_));
  assign _zz_4_ = (_zz_3_[3 : 2] | _zz_3_[1 : 0]);
  assign maskProposal_0 = _zz_9_[0];
  assign maskProposal_1 = _zz_10_[0];
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_id = (maskRouted_0 ? io_inputs_0_payload_id : io_inputs_1_payload_id);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_burst = (maskRouted_0 ? io_inputs_0_payload_burst : io_inputs_1_payload_burst);
  assign io_output_payload_write = (maskRouted_0 ? io_inputs_0_payload_write : io_inputs_1_payload_write);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_5_ = io_chosenOH[1];
  assign io_chosen = _zz_5_;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end

endmodule

module NoDebug_StreamFork_2_ (
      input   io_input_valid,
      output reg  io_input_ready,
      input  [16:0] io_input_payload_addr,
      input  [2:0] io_input_payload_id,
      input  [7:0] io_input_payload_len,
      input  [2:0] io_input_payload_size,
      input  [1:0] io_input_payload_burst,
      input   io_input_payload_write,
      output  io_outputs_0_valid,
      input   io_outputs_0_ready,
      output [16:0] io_outputs_0_payload_addr,
      output [2:0] io_outputs_0_payload_id,
      output [7:0] io_outputs_0_payload_len,
      output [2:0] io_outputs_0_payload_size,
      output [1:0] io_outputs_0_payload_burst,
      output  io_outputs_0_payload_write,
      output  io_outputs_1_valid,
      input   io_outputs_1_ready,
      output [16:0] io_outputs_1_payload_addr,
      output [2:0] io_outputs_1_payload_id,
      output [7:0] io_outputs_1_payload_len,
      output [2:0] io_outputs_1_payload_size,
      output [1:0] io_outputs_1_payload_burst,
      output  io_outputs_1_payload_write,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  linkEnable_0;
  reg  linkEnable_1;
  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && linkEnable_0))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && linkEnable_1))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && linkEnable_0);
  assign io_outputs_0_payload_addr = io_input_payload_addr;
  assign io_outputs_0_payload_id = io_input_payload_id;
  assign io_outputs_0_payload_len = io_input_payload_len;
  assign io_outputs_0_payload_size = io_input_payload_size;
  assign io_outputs_0_payload_burst = io_input_payload_burst;
  assign io_outputs_0_payload_write = io_input_payload_write;
  assign io_outputs_1_valid = (io_input_valid && linkEnable_1);
  assign io_outputs_1_payload_addr = io_input_payload_addr;
  assign io_outputs_1_payload_id = io_input_payload_id;
  assign io_outputs_1_payload_len = io_input_payload_len;
  assign io_outputs_1_payload_size = io_input_payload_size;
  assign io_outputs_1_payload_burst = io_input_payload_burst;
  assign io_outputs_1_payload_write = io_input_payload_write;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      linkEnable_0 <= 1'b1;
      linkEnable_1 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        linkEnable_0 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        linkEnable_1 <= 1'b0;
      end
      if(io_input_ready)begin
        linkEnable_0 <= 1'b1;
        linkEnable_1 <= 1'b1;
      end
    end
  end

endmodule


//NoDebug_StreamFifoLowLatency_2_ remplaced by NoDebug_StreamFifoLowLatency

module NoDebug_StreamArbiter_3_ (
      input   io_inputs_0_valid,
      output  io_inputs_0_ready,
      input  [31:0] io_inputs_0_payload_addr,
      input  [3:0] io_inputs_0_payload_id,
      input  [3:0] io_inputs_0_payload_region,
      input  [7:0] io_inputs_0_payload_len,
      input  [2:0] io_inputs_0_payload_size,
      input  [1:0] io_inputs_0_payload_burst,
      input  [0:0] io_inputs_0_payload_lock,
      input  [3:0] io_inputs_0_payload_cache,
      input  [3:0] io_inputs_0_payload_qos,
      input  [2:0] io_inputs_0_payload_prot,
      output  io_output_valid,
      input   io_output_ready,
      output [31:0] io_output_payload_addr,
      output [3:0] io_output_payload_id,
      output [3:0] io_output_payload_region,
      output [7:0] io_output_payload_len,
      output [2:0] io_output_payload_size,
      output [1:0] io_output_payload_burst,
      output [0:0] io_output_payload_lock,
      output [3:0] io_output_payload_cache,
      output [3:0] io_output_payload_qos,
      output [2:0] io_output_payload_prot,
      output [0:0] io_chosenOH,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire [1:0] _zz_4_;
  wire [0:0] _zz_5_;
  wire [1:0] _zz_6_;
  wire [0:0] _zz_7_;
  wire [0:0] _zz_8_;
  reg  locked;
  wire  maskProposal_0;
  reg  maskLocked_0;
  wire  maskRouted_0;
  wire [0:0] _zz_1_;
  wire [1:0] _zz_2_;
  wire [1:0] _zz_3_;
  assign _zz_4_ = (_zz_2_ - _zz_6_);
  assign _zz_5_ = maskLocked_0;
  assign _zz_6_ = {1'd0, _zz_5_};
  assign _zz_7_ = _zz_8_[0 : 0];
  assign _zz_8_ = (_zz_3_[1 : 1] | _zz_3_[0 : 0]);
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign _zz_1_ = io_inputs_0_valid;
  assign _zz_2_ = {_zz_1_,_zz_1_};
  assign _zz_3_ = (_zz_2_ & (~ _zz_4_));
  assign maskProposal_0 = _zz_7_[0];
  assign io_output_valid = (io_inputs_0_valid && maskRouted_0);
  assign io_output_payload_addr = io_inputs_0_payload_addr;
  assign io_output_payload_id = io_inputs_0_payload_id;
  assign io_output_payload_region = io_inputs_0_payload_region;
  assign io_output_payload_len = io_inputs_0_payload_len;
  assign io_output_payload_size = io_inputs_0_payload_size;
  assign io_output_payload_burst = io_inputs_0_payload_burst;
  assign io_output_payload_lock = io_inputs_0_payload_lock;
  assign io_output_payload_cache = io_inputs_0_payload_cache;
  assign io_output_payload_qos = io_inputs_0_payload_qos;
  assign io_output_payload_prot = io_inputs_0_payload_prot;
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_chosenOH = maskRouted_0;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b1;
    end else begin
      if(io_output_valid)begin
        maskLocked_0 <= maskRouted_0;
      end
      if(io_output_valid)begin
        locked <= 1'b1;
      end
      if((io_output_valid && io_output_ready))begin
        locked <= 1'b0;
      end
    end
  end

endmodule


//NoDebug_StreamArbiter_4_ remplaced by NoDebug_StreamArbiter_3_

module NoDebug_StreamFork_3_ (
      input   io_input_valid,
      output reg  io_input_ready,
      input  [31:0] io_input_payload_addr,
      input  [3:0] io_input_payload_id,
      input  [3:0] io_input_payload_region,
      input  [7:0] io_input_payload_len,
      input  [2:0] io_input_payload_size,
      input  [1:0] io_input_payload_burst,
      input  [0:0] io_input_payload_lock,
      input  [3:0] io_input_payload_cache,
      input  [3:0] io_input_payload_qos,
      input  [2:0] io_input_payload_prot,
      output  io_outputs_0_valid,
      input   io_outputs_0_ready,
      output [31:0] io_outputs_0_payload_addr,
      output [3:0] io_outputs_0_payload_id,
      output [3:0] io_outputs_0_payload_region,
      output [7:0] io_outputs_0_payload_len,
      output [2:0] io_outputs_0_payload_size,
      output [1:0] io_outputs_0_payload_burst,
      output [0:0] io_outputs_0_payload_lock,
      output [3:0] io_outputs_0_payload_cache,
      output [3:0] io_outputs_0_payload_qos,
      output [2:0] io_outputs_0_payload_prot,
      output  io_outputs_1_valid,
      input   io_outputs_1_ready,
      output [31:0] io_outputs_1_payload_addr,
      output [3:0] io_outputs_1_payload_id,
      output [3:0] io_outputs_1_payload_region,
      output [7:0] io_outputs_1_payload_len,
      output [2:0] io_outputs_1_payload_size,
      output [1:0] io_outputs_1_payload_burst,
      output [0:0] io_outputs_1_payload_lock,
      output [3:0] io_outputs_1_payload_cache,
      output [3:0] io_outputs_1_payload_qos,
      output [2:0] io_outputs_1_payload_prot,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  linkEnable_0;
  reg  linkEnable_1;
  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && linkEnable_0))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && linkEnable_1))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && linkEnable_0);
  assign io_outputs_0_payload_addr = io_input_payload_addr;
  assign io_outputs_0_payload_id = io_input_payload_id;
  assign io_outputs_0_payload_region = io_input_payload_region;
  assign io_outputs_0_payload_len = io_input_payload_len;
  assign io_outputs_0_payload_size = io_input_payload_size;
  assign io_outputs_0_payload_burst = io_input_payload_burst;
  assign io_outputs_0_payload_lock = io_input_payload_lock;
  assign io_outputs_0_payload_cache = io_input_payload_cache;
  assign io_outputs_0_payload_qos = io_input_payload_qos;
  assign io_outputs_0_payload_prot = io_input_payload_prot;
  assign io_outputs_1_valid = (io_input_valid && linkEnable_1);
  assign io_outputs_1_payload_addr = io_input_payload_addr;
  assign io_outputs_1_payload_id = io_input_payload_id;
  assign io_outputs_1_payload_region = io_input_payload_region;
  assign io_outputs_1_payload_len = io_input_payload_len;
  assign io_outputs_1_payload_size = io_input_payload_size;
  assign io_outputs_1_payload_burst = io_input_payload_burst;
  assign io_outputs_1_payload_lock = io_input_payload_lock;
  assign io_outputs_1_payload_cache = io_input_payload_cache;
  assign io_outputs_1_payload_qos = io_input_payload_qos;
  assign io_outputs_1_payload_prot = io_input_payload_prot;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      linkEnable_0 <= 1'b1;
      linkEnable_1 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        linkEnable_0 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        linkEnable_1 <= 1'b0;
      end
      if(io_input_ready)begin
        linkEnable_0 <= 1'b1;
        linkEnable_1 <= 1'b1;
      end
    end
  end

endmodule


//NoDebug_StreamFifoLowLatency_3_ remplaced by NoDebug_StreamFifoLowLatency

module NoDebug_BufferCC (
      input   io_dataIn,
      output  io_dataOut,
      input   io_axiClk);
  reg  buffers_0;
  reg  buffers_1;
  assign io_dataOut = buffers_1;
  always @ (posedge io_axiClk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end

endmodule

module NoDebug_Axi4SharedOnChipRam (
      input   io_axi_arw_valid,
      output reg  io_axi_arw_ready,
      input  [16:0] io_axi_arw_payload_addr,
      input  [3:0] io_axi_arw_payload_id,
      input  [7:0] io_axi_arw_payload_len,
      input  [2:0] io_axi_arw_payload_size,
      input  [1:0] io_axi_arw_payload_burst,
      input   io_axi_arw_payload_write,
      input   io_axi_w_valid,
      output  io_axi_w_ready,
      input  [31:0] io_axi_w_payload_data,
      input  [3:0] io_axi_w_payload_strb,
      input   io_axi_w_payload_last,
      output  io_axi_b_valid,
      input   io_axi_b_ready,
      output [3:0] io_axi_b_payload_id,
      output [1:0] io_axi_b_payload_resp,
      output  io_axi_r_valid,
      input   io_axi_r_ready,
      output [31:0] io_axi_r_payload_data,
      output [3:0] io_axi_r_payload_id,
      output [1:0] io_axi_r_payload_resp,
      output  io_axi_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_3_;
  wire [14:0] _zz_4_;
  reg [11:0] _zz_5_;
  wire [31:0] ram_rdData;
  wire  _zz_6_;
  wire [1:0] _zz_7_;
  wire [11:0] _zz_8_;
  wire [11:0] _zz_9_;
  wire [11:0] _zz_10_;
  wire [2:0] _zz_11_;
  wire [2:0] _zz_12_;
  reg  arw_valid;
  wire  arw_ready;
  reg  arw_payload_last;
  reg [16:0] arw_payload_fragment_addr;
  reg [3:0] arw_payload_fragment_id;
  reg [2:0] arw_payload_fragment_size;
  reg [1:0] arw_payload_fragment_burst;
  reg  arw_payload_fragment_write;
  wire  unburstify_doResult;
  reg  unburstify_buffer_valid;
  reg [7:0] unburstify_buffer_len;
  reg [7:0] unburstify_buffer_beat;
  reg [16:0] unburstify_buffer_transaction_addr;
  reg [3:0] unburstify_buffer_transaction_id;
  reg [2:0] unburstify_buffer_transaction_size;
  reg [1:0] unburstify_buffer_transaction_burst;
  reg  unburstify_buffer_transaction_write;
  wire  unburstify_buffer_last;
  wire [1:0] Axi4Incr_validSize;
  reg [16:0] unburstify_buffer_address;
  wire [4:0] Axi4Incr_highCat;
  wire [2:0] Axi4Incr_sizeValue;
  wire [11:0] Axi4Incr_alignMask;
  wire [11:0] Axi4Incr_base;
  wire [11:0] Axi4Incr_baseIncr;
  reg [1:0] _zz_1_;
  wire [2:0] Axi4Incr_wrapCase;
  wire  _zz_2_;
  wire  stage0_valid;
  wire  stage0_ready;
  wire  stage0_payload_last;
  wire [16:0] stage0_payload_fragment_addr;
  wire [3:0] stage0_payload_fragment_id;
  wire [2:0] stage0_payload_fragment_size;
  wire [1:0] stage0_payload_fragment_burst;
  wire  stage0_payload_fragment_write;
  wire  stage1_valid;
  wire  stage1_ready;
  wire  stage1_payload_last;
  wire [16:0] stage1_payload_fragment_addr;
  wire [3:0] stage1_payload_fragment_id;
  wire [2:0] stage1_payload_fragment_size;
  wire [1:0] stage1_payload_fragment_burst;
  wire  stage1_payload_fragment_write;
  reg  stage0_m2sPipe_rValid;
  reg  stage0_m2sPipe_rData_last;
  reg [16:0] stage0_m2sPipe_rData_fragment_addr;
  reg [3:0] stage0_m2sPipe_rData_fragment_id;
  reg [2:0] stage0_m2sPipe_rData_fragment_size;
  reg [1:0] stage0_m2sPipe_rData_fragment_burst;
  reg  stage0_m2sPipe_rData_fragment_write;
  assign _zz_6_ = (io_axi_arw_payload_len == (8'b00000000));
  assign _zz_7_ = {((2'b01) < Axi4Incr_validSize),((2'b00) < Axi4Incr_validSize)};
  assign _zz_8_ = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_9_ = _zz_8_;
  assign _zz_10_ = {9'd0, Axi4Incr_sizeValue};
  assign _zz_11_ = {1'd0, Axi4Incr_validSize};
  assign _zz_12_ = {1'd0, _zz_1_};
  NoDebug_Ram_1wrs #( 
    .wordCount(32768),
    .wordWidth(32),
    .readUnderWrite("dontCare"),
    .technology("auto"),
    .maskWidth(4),
    .maskEnable(1'b1),
    .userLabel("ram") 
  ) ram ( 
    .clk(io_axiClk),
    .en(_zz_3_),
    .wr(stage0_payload_fragment_write),
    .addr(_zz_4_),
    .mask(io_axi_w_payload_strb),
    .wrData(io_axi_w_payload_data),
    .rdData(ram_rdData) 
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : begin
        _zz_5_ = {Axi4Incr_base[11 : 1],Axi4Incr_baseIncr[0 : 0]};
      end
      3'b001 : begin
        _zz_5_ = {Axi4Incr_base[11 : 2],Axi4Incr_baseIncr[1 : 0]};
      end
      3'b010 : begin
        _zz_5_ = {Axi4Incr_base[11 : 3],Axi4Incr_baseIncr[2 : 0]};
      end
      3'b011 : begin
        _zz_5_ = {Axi4Incr_base[11 : 4],Axi4Incr_baseIncr[3 : 0]};
      end
      3'b100 : begin
        _zz_5_ = {Axi4Incr_base[11 : 5],Axi4Incr_baseIncr[4 : 0]};
      end
      default : begin
        _zz_5_ = {Axi4Incr_base[11 : 6],Axi4Incr_baseIncr[5 : 0]};
      end
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == (8'b00000001));
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[16 : 12];
  assign Axi4Incr_sizeValue = {((2'b10) == Axi4Incr_validSize),{((2'b01) == Axi4Incr_validSize),((2'b00) == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_7_};
  assign Axi4Incr_base = (_zz_9_ & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_10_);
  always @ (*) begin
    if((((unburstify_buffer_len & (8'b00001000)) == (8'b00001000)))) begin
        _zz_1_ = (2'b11);
    end else if((((unburstify_buffer_len & (8'b00000100)) == (8'b00000100)))) begin
        _zz_1_ = (2'b10);
    end else if((((unburstify_buffer_len & (8'b00000010)) == (8'b00000010)))) begin
        _zz_1_ = (2'b01);
    end else begin
        _zz_1_ = (2'b00);
    end
  end

  assign Axi4Incr_wrapCase = (_zz_11_ + _zz_12_);
  always @ (*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        unburstify_buffer_address = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        unburstify_buffer_address = {Axi4Incr_highCat,_zz_5_};
      end
      default : begin
        unburstify_buffer_address = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @ (*) begin
    io_axi_arw_ready = 1'b0;
    if(! unburstify_buffer_valid) begin
      io_axi_arw_ready = arw_ready;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_valid = 1'b1;
    end else begin
      arw_valid = io_axi_arw_valid;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_last = unburstify_buffer_last;
    end else begin
      if(_zz_6_)begin
        arw_payload_last = 1'b1;
      end else begin
        arw_payload_last = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      arw_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      arw_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      arw_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      arw_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_addr = unburstify_buffer_address;
    end else begin
      arw_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign _zz_2_ = (! (arw_payload_fragment_write && (! io_axi_w_valid)));
  assign stage0_valid = (arw_valid && _zz_2_);
  assign arw_ready = (stage0_ready && _zz_2_);
  assign stage0_payload_last = arw_payload_last;
  assign stage0_payload_fragment_addr = arw_payload_fragment_addr;
  assign stage0_payload_fragment_id = arw_payload_fragment_id;
  assign stage0_payload_fragment_size = arw_payload_fragment_size;
  assign stage0_payload_fragment_burst = arw_payload_fragment_burst;
  assign stage0_payload_fragment_write = arw_payload_fragment_write;
  assign io_axi_r_payload_data = ram_rdData;
  assign io_axi_w_ready = ((arw_valid && arw_payload_fragment_write) && stage0_ready);
  assign stage0_ready = ((1'b1 && (! stage1_valid)) || stage1_ready);
  assign stage1_valid = stage0_m2sPipe_rValid;
  assign stage1_payload_last = stage0_m2sPipe_rData_last;
  assign stage1_payload_fragment_addr = stage0_m2sPipe_rData_fragment_addr;
  assign stage1_payload_fragment_id = stage0_m2sPipe_rData_fragment_id;
  assign stage1_payload_fragment_size = stage0_m2sPipe_rData_fragment_size;
  assign stage1_payload_fragment_burst = stage0_m2sPipe_rData_fragment_burst;
  assign stage1_payload_fragment_write = stage0_m2sPipe_rData_fragment_write;
  assign stage1_ready = ((io_axi_r_ready && (! stage1_payload_fragment_write)) || ((io_axi_b_ready || (! stage1_payload_last)) && stage1_payload_fragment_write));
  assign io_axi_r_valid = (stage1_valid && (! stage1_payload_fragment_write));
  assign io_axi_r_payload_id = stage1_payload_fragment_id;
  assign io_axi_r_payload_last = stage1_payload_last;
  assign io_axi_r_payload_resp = (2'b00);
  assign io_axi_b_valid = ((stage1_valid && stage1_payload_fragment_write) && stage1_payload_last);
  assign io_axi_b_payload_resp = (2'b00);
  assign io_axi_b_payload_id = stage1_payload_fragment_id;
  assign _zz_4_ = stage0_payload_fragment_addr[16 : 2];
  assign _zz_3_ = ((stage0_valid && stage0_ready) && 1'b1);
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      unburstify_buffer_valid <= 1'b0;
      stage0_m2sPipe_rValid <= 1'b0;
    end else begin
      if(arw_ready)begin
        if(unburstify_buffer_last)begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(! unburstify_buffer_valid) begin
        if(! _zz_6_) begin
          if(arw_ready)begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(stage0_ready)begin
        stage0_m2sPipe_rValid <= stage0_valid;
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(arw_ready)begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - (8'b00000001));
      unburstify_buffer_transaction_addr[11 : 0] <= unburstify_buffer_address[11 : 0];
    end
    if(! unburstify_buffer_valid) begin
      if(! _zz_6_) begin
        if(arw_ready)begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(stage0_ready)begin
      stage0_m2sPipe_rData_last <= stage0_payload_last;
      stage0_m2sPipe_rData_fragment_addr <= stage0_payload_fragment_addr;
      stage0_m2sPipe_rData_fragment_id <= stage0_payload_fragment_id;
      stage0_m2sPipe_rData_fragment_size <= stage0_payload_fragment_size;
      stage0_m2sPipe_rData_fragment_burst <= stage0_payload_fragment_burst;
      stage0_m2sPipe_rData_fragment_write <= stage0_payload_fragment_write;
    end
  end

endmodule

module NoDebug_Axi4SharedOnChipRam_1_ (
      input   io_axi_arw_valid,
      output reg  io_axi_arw_ready,
      input  [11:0] io_axi_arw_payload_addr,
      input  [3:0] io_axi_arw_payload_id,
      input  [7:0] io_axi_arw_payload_len,
      input  [2:0] io_axi_arw_payload_size,
      input  [1:0] io_axi_arw_payload_burst,
      input   io_axi_arw_payload_write,
      input   io_axi_w_valid,
      output  io_axi_w_ready,
      input  [31:0] io_axi_w_payload_data,
      input  [3:0] io_axi_w_payload_strb,
      input   io_axi_w_payload_last,
      output  io_axi_b_valid,
      input   io_axi_b_ready,
      output [3:0] io_axi_b_payload_id,
      output [1:0] io_axi_b_payload_resp,
      output  io_axi_r_valid,
      input   io_axi_r_ready,
      output [31:0] io_axi_r_payload_data,
      output [3:0] io_axi_r_payload_id,
      output [1:0] io_axi_r_payload_resp,
      output  io_axi_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_3_;
  wire [9:0] _zz_4_;
  reg [11:0] _zz_5_;
  wire [31:0] ram_rdData;
  wire  _zz_6_;
  wire [1:0] _zz_7_;
  wire [11:0] _zz_8_;
  wire [11:0] _zz_9_;
  wire [11:0] _zz_10_;
  wire [2:0] _zz_11_;
  wire [2:0] _zz_12_;
  reg  arw_valid;
  wire  arw_ready;
  reg  arw_payload_last;
  reg [11:0] arw_payload_fragment_addr;
  reg [3:0] arw_payload_fragment_id;
  reg [2:0] arw_payload_fragment_size;
  reg [1:0] arw_payload_fragment_burst;
  reg  arw_payload_fragment_write;
  wire  unburstify_doResult;
  reg  unburstify_buffer_valid;
  reg [7:0] unburstify_buffer_len;
  reg [7:0] unburstify_buffer_beat;
  reg [11:0] unburstify_buffer_transaction_addr;
  reg [3:0] unburstify_buffer_transaction_id;
  reg [2:0] unburstify_buffer_transaction_size;
  reg [1:0] unburstify_buffer_transaction_burst;
  reg  unburstify_buffer_transaction_write;
  wire  unburstify_buffer_last;
  wire [1:0] Axi4Incr_validSize;
  reg [11:0] unburstify_buffer_address;
  wire [2:0] Axi4Incr_sizeValue;
  wire [11:0] Axi4Incr_alignMask;
  wire [11:0] Axi4Incr_base;
  wire [11:0] Axi4Incr_baseIncr;
  reg [1:0] _zz_1_;
  wire [2:0] Axi4Incr_wrapCase;
  wire  _zz_2_;
  wire  stage0_valid;
  wire  stage0_ready;
  wire  stage0_payload_last;
  wire [11:0] stage0_payload_fragment_addr;
  wire [3:0] stage0_payload_fragment_id;
  wire [2:0] stage0_payload_fragment_size;
  wire [1:0] stage0_payload_fragment_burst;
  wire  stage0_payload_fragment_write;
  wire  stage1_valid;
  wire  stage1_ready;
  wire  stage1_payload_last;
  wire [11:0] stage1_payload_fragment_addr;
  wire [3:0] stage1_payload_fragment_id;
  wire [2:0] stage1_payload_fragment_size;
  wire [1:0] stage1_payload_fragment_burst;
  wire  stage1_payload_fragment_write;
  reg  stage0_m2sPipe_rValid;
  reg  stage0_m2sPipe_rData_last;
  reg [11:0] stage0_m2sPipe_rData_fragment_addr;
  reg [3:0] stage0_m2sPipe_rData_fragment_id;
  reg [2:0] stage0_m2sPipe_rData_fragment_size;
  reg [1:0] stage0_m2sPipe_rData_fragment_burst;
  reg  stage0_m2sPipe_rData_fragment_write;
  assign _zz_6_ = (io_axi_arw_payload_len == (8'b00000000));
  assign _zz_7_ = {((2'b01) < Axi4Incr_validSize),((2'b00) < Axi4Incr_validSize)};
  assign _zz_8_ = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_9_ = _zz_8_;
  assign _zz_10_ = {9'd0, Axi4Incr_sizeValue};
  assign _zz_11_ = {1'd0, Axi4Incr_validSize};
  assign _zz_12_ = {1'd0, _zz_1_};
  NoDebug_Ram_1wrs #( 
    .wordCount(1024),
    .wordWidth(32),
    .readUnderWrite("dontCare"),
    .technology("auto"),
    .maskWidth(4),
    .maskEnable(1'b1),
    .userLabel("secure") 
  ) ram ( 
    .clk(io_axiClk),
    .en(_zz_3_),
    .wr(stage0_payload_fragment_write),
    .addr(_zz_4_),
    .mask(io_axi_w_payload_strb),
    .wrData(io_axi_w_payload_data),
    .rdData(ram_rdData) 
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : begin
        _zz_5_ = {Axi4Incr_base[11 : 1],Axi4Incr_baseIncr[0 : 0]};
      end
      3'b001 : begin
        _zz_5_ = {Axi4Incr_base[11 : 2],Axi4Incr_baseIncr[1 : 0]};
      end
      3'b010 : begin
        _zz_5_ = {Axi4Incr_base[11 : 3],Axi4Incr_baseIncr[2 : 0]};
      end
      3'b011 : begin
        _zz_5_ = {Axi4Incr_base[11 : 4],Axi4Incr_baseIncr[3 : 0]};
      end
      3'b100 : begin
        _zz_5_ = {Axi4Incr_base[11 : 5],Axi4Incr_baseIncr[4 : 0]};
      end
      default : begin
        _zz_5_ = {Axi4Incr_base[11 : 6],Axi4Incr_baseIncr[5 : 0]};
      end
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == (8'b00000001));
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_sizeValue = {((2'b10) == Axi4Incr_validSize),{((2'b01) == Axi4Incr_validSize),((2'b00) == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_7_};
  assign Axi4Incr_base = (_zz_9_ & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_10_);
  always @ (*) begin
    if((((unburstify_buffer_len & (8'b00001000)) == (8'b00001000)))) begin
        _zz_1_ = (2'b11);
    end else if((((unburstify_buffer_len & (8'b00000100)) == (8'b00000100)))) begin
        _zz_1_ = (2'b10);
    end else if((((unburstify_buffer_len & (8'b00000010)) == (8'b00000010)))) begin
        _zz_1_ = (2'b01);
    end else begin
        _zz_1_ = (2'b00);
    end
  end

  assign Axi4Incr_wrapCase = (_zz_11_ + _zz_12_);
  always @ (*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        unburstify_buffer_address = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        unburstify_buffer_address = _zz_5_;
      end
      default : begin
        unburstify_buffer_address = Axi4Incr_baseIncr;
      end
    endcase
  end

  always @ (*) begin
    io_axi_arw_ready = 1'b0;
    if(! unburstify_buffer_valid) begin
      io_axi_arw_ready = arw_ready;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_valid = 1'b1;
    end else begin
      arw_valid = io_axi_arw_valid;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_last = unburstify_buffer_last;
    end else begin
      if(_zz_6_)begin
        arw_payload_last = 1'b1;
      end else begin
        arw_payload_last = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      arw_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      arw_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      arw_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      arw_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_addr = unburstify_buffer_address;
    end else begin
      arw_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign _zz_2_ = (! (arw_payload_fragment_write && (! io_axi_w_valid)));
  assign stage0_valid = (arw_valid && _zz_2_);
  assign arw_ready = (stage0_ready && _zz_2_);
  assign stage0_payload_last = arw_payload_last;
  assign stage0_payload_fragment_addr = arw_payload_fragment_addr;
  assign stage0_payload_fragment_id = arw_payload_fragment_id;
  assign stage0_payload_fragment_size = arw_payload_fragment_size;
  assign stage0_payload_fragment_burst = arw_payload_fragment_burst;
  assign stage0_payload_fragment_write = arw_payload_fragment_write;
  assign io_axi_r_payload_data = ram_rdData;
  assign io_axi_w_ready = ((arw_valid && arw_payload_fragment_write) && stage0_ready);
  assign stage0_ready = ((1'b1 && (! stage1_valid)) || stage1_ready);
  assign stage1_valid = stage0_m2sPipe_rValid;
  assign stage1_payload_last = stage0_m2sPipe_rData_last;
  assign stage1_payload_fragment_addr = stage0_m2sPipe_rData_fragment_addr;
  assign stage1_payload_fragment_id = stage0_m2sPipe_rData_fragment_id;
  assign stage1_payload_fragment_size = stage0_m2sPipe_rData_fragment_size;
  assign stage1_payload_fragment_burst = stage0_m2sPipe_rData_fragment_burst;
  assign stage1_payload_fragment_write = stage0_m2sPipe_rData_fragment_write;
  assign stage1_ready = ((io_axi_r_ready && (! stage1_payload_fragment_write)) || ((io_axi_b_ready || (! stage1_payload_last)) && stage1_payload_fragment_write));
  assign io_axi_r_valid = (stage1_valid && (! stage1_payload_fragment_write));
  assign io_axi_r_payload_id = stage1_payload_fragment_id;
  assign io_axi_r_payload_last = stage1_payload_last;
  assign io_axi_r_payload_resp = (2'b00);
  assign io_axi_b_valid = ((stage1_valid && stage1_payload_fragment_write) && stage1_payload_last);
  assign io_axi_b_payload_resp = (2'b00);
  assign io_axi_b_payload_id = stage1_payload_fragment_id;
  assign _zz_4_ = stage0_payload_fragment_addr[11 : 2];
  assign _zz_3_ = ((stage0_valid && stage0_ready) && 1'b1);
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      unburstify_buffer_valid <= 1'b0;
      stage0_m2sPipe_rValid <= 1'b0;
    end else begin
      if(arw_ready)begin
        if(unburstify_buffer_last)begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(! unburstify_buffer_valid) begin
        if(! _zz_6_) begin
          if(arw_ready)begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(stage0_ready)begin
        stage0_m2sPipe_rValid <= stage0_valid;
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(arw_ready)begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - (8'b00000001));
      unburstify_buffer_transaction_addr[11 : 0] <= unburstify_buffer_address[11 : 0];
    end
    if(! unburstify_buffer_valid) begin
      if(! _zz_6_) begin
        if(arw_ready)begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(stage0_ready)begin
      stage0_m2sPipe_rData_last <= stage0_payload_last;
      stage0_m2sPipe_rData_fragment_addr <= stage0_payload_fragment_addr;
      stage0_m2sPipe_rData_fragment_id <= stage0_payload_fragment_id;
      stage0_m2sPipe_rData_fragment_size <= stage0_payload_fragment_size;
      stage0_m2sPipe_rData_fragment_burst <= stage0_payload_fragment_burst;
      stage0_m2sPipe_rData_fragment_write <= stage0_payload_fragment_write;
    end
  end

endmodule

module NoDebug_Axi4SharedOnChipRam_2_ (
      input   io_axi_arw_valid,
      output reg  io_axi_arw_ready,
      input  [16:0] io_axi_arw_payload_addr,
      input  [3:0] io_axi_arw_payload_id,
      input  [7:0] io_axi_arw_payload_len,
      input  [2:0] io_axi_arw_payload_size,
      input  [1:0] io_axi_arw_payload_burst,
      input   io_axi_arw_payload_write,
      input   io_axi_w_valid,
      output  io_axi_w_ready,
      input  [31:0] io_axi_w_payload_data,
      input  [3:0] io_axi_w_payload_strb,
      input   io_axi_w_payload_last,
      output  io_axi_b_valid,
      input   io_axi_b_ready,
      output [3:0] io_axi_b_payload_id,
      output [1:0] io_axi_b_payload_resp,
      output  io_axi_r_valid,
      input   io_axi_r_ready,
      output [31:0] io_axi_r_payload_data,
      output [3:0] io_axi_r_payload_id,
      output [1:0] io_axi_r_payload_resp,
      output  io_axi_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_3_;
  wire [14:0] _zz_4_;
  reg [11:0] _zz_5_;
  wire [31:0] ram_rdData;
  wire  _zz_6_;
  wire [1:0] _zz_7_;
  wire [11:0] _zz_8_;
  wire [11:0] _zz_9_;
  wire [11:0] _zz_10_;
  wire [2:0] _zz_11_;
  wire [2:0] _zz_12_;
  reg  arw_valid;
  wire  arw_ready;
  reg  arw_payload_last;
  reg [16:0] arw_payload_fragment_addr;
  reg [3:0] arw_payload_fragment_id;
  reg [2:0] arw_payload_fragment_size;
  reg [1:0] arw_payload_fragment_burst;
  reg  arw_payload_fragment_write;
  wire  unburstify_doResult;
  reg  unburstify_buffer_valid;
  reg [7:0] unburstify_buffer_len;
  reg [7:0] unburstify_buffer_beat;
  reg [16:0] unburstify_buffer_transaction_addr;
  reg [3:0] unburstify_buffer_transaction_id;
  reg [2:0] unburstify_buffer_transaction_size;
  reg [1:0] unburstify_buffer_transaction_burst;
  reg  unburstify_buffer_transaction_write;
  wire  unburstify_buffer_last;
  wire [1:0] Axi4Incr_validSize;
  reg [16:0] unburstify_buffer_address;
  wire [4:0] Axi4Incr_highCat;
  wire [2:0] Axi4Incr_sizeValue;
  wire [11:0] Axi4Incr_alignMask;
  wire [11:0] Axi4Incr_base;
  wire [11:0] Axi4Incr_baseIncr;
  reg [1:0] _zz_1_;
  wire [2:0] Axi4Incr_wrapCase;
  wire  _zz_2_;
  wire  stage0_valid;
  wire  stage0_ready;
  wire  stage0_payload_last;
  wire [16:0] stage0_payload_fragment_addr;
  wire [3:0] stage0_payload_fragment_id;
  wire [2:0] stage0_payload_fragment_size;
  wire [1:0] stage0_payload_fragment_burst;
  wire  stage0_payload_fragment_write;
  wire  stage1_valid;
  wire  stage1_ready;
  wire  stage1_payload_last;
  wire [16:0] stage1_payload_fragment_addr;
  wire [3:0] stage1_payload_fragment_id;
  wire [2:0] stage1_payload_fragment_size;
  wire [1:0] stage1_payload_fragment_burst;
  wire  stage1_payload_fragment_write;
  reg  stage0_m2sPipe_rValid;
  reg  stage0_m2sPipe_rData_last;
  reg [16:0] stage0_m2sPipe_rData_fragment_addr;
  reg [3:0] stage0_m2sPipe_rData_fragment_id;
  reg [2:0] stage0_m2sPipe_rData_fragment_size;
  reg [1:0] stage0_m2sPipe_rData_fragment_burst;
  reg  stage0_m2sPipe_rData_fragment_write;
  assign _zz_6_ = (io_axi_arw_payload_len == (8'b00000000));
  assign _zz_7_ = {((2'b01) < Axi4Incr_validSize),((2'b00) < Axi4Incr_validSize)};
  assign _zz_8_ = unburstify_buffer_transaction_addr[11 : 0];
  assign _zz_9_ = _zz_8_;
  assign _zz_10_ = {9'd0, Axi4Incr_sizeValue};
  assign _zz_11_ = {1'd0, Axi4Incr_validSize};
  assign _zz_12_ = {1'd0, _zz_1_};
  NoDebug_Ram_1wrs #( 
    .wordCount(32768),
    .wordWidth(32),
    .readUnderWrite("dontCare"),
    .technology("auto"),
    .maskWidth(4),
    .maskEnable(1'b1),
    .userLabel("rom") 
  ) ram ( 
    .clk(io_axiClk),
    .en(_zz_3_),
    .wr(stage0_payload_fragment_write),
    .addr(_zz_4_),
    .mask(io_axi_w_payload_strb),
    .wrData(io_axi_w_payload_data),
    .rdData(ram_rdData) 
  );
  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : begin
        _zz_5_ = {Axi4Incr_base[11 : 1],Axi4Incr_baseIncr[0 : 0]};
      end
      3'b001 : begin
        _zz_5_ = {Axi4Incr_base[11 : 2],Axi4Incr_baseIncr[1 : 0]};
      end
      3'b010 : begin
        _zz_5_ = {Axi4Incr_base[11 : 3],Axi4Incr_baseIncr[2 : 0]};
      end
      3'b011 : begin
        _zz_5_ = {Axi4Incr_base[11 : 4],Axi4Incr_baseIncr[3 : 0]};
      end
      3'b100 : begin
        _zz_5_ = {Axi4Incr_base[11 : 5],Axi4Incr_baseIncr[4 : 0]};
      end
      default : begin
        _zz_5_ = {Axi4Incr_base[11 : 6],Axi4Incr_baseIncr[5 : 0]};
      end
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == (8'b00000001));
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_highCat = unburstify_buffer_transaction_addr[16 : 12];
  assign Axi4Incr_sizeValue = {((2'b10) == Axi4Incr_validSize),{((2'b01) == Axi4Incr_validSize),((2'b00) == Axi4Incr_validSize)}};
  assign Axi4Incr_alignMask = {10'd0, _zz_7_};
  assign Axi4Incr_base = (_zz_9_ & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_10_);
  always @ (*) begin
    if((((unburstify_buffer_len & (8'b00001000)) == (8'b00001000)))) begin
        _zz_1_ = (2'b11);
    end else if((((unburstify_buffer_len & (8'b00000100)) == (8'b00000100)))) begin
        _zz_1_ = (2'b10);
    end else if((((unburstify_buffer_len & (8'b00000010)) == (8'b00000010)))) begin
        _zz_1_ = (2'b01);
    end else begin
        _zz_1_ = (2'b00);
    end
  end

  assign Axi4Incr_wrapCase = (_zz_11_ + _zz_12_);
  always @ (*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        unburstify_buffer_address = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        unburstify_buffer_address = {Axi4Incr_highCat,_zz_5_};
      end
      default : begin
        unburstify_buffer_address = {Axi4Incr_highCat,Axi4Incr_baseIncr};
      end
    endcase
  end

  always @ (*) begin
    io_axi_arw_ready = 1'b0;
    if(! unburstify_buffer_valid) begin
      io_axi_arw_ready = arw_ready;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_valid = 1'b1;
    end else begin
      arw_valid = io_axi_arw_valid;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_last = unburstify_buffer_last;
    end else begin
      if(_zz_6_)begin
        arw_payload_last = 1'b1;
      end else begin
        arw_payload_last = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      arw_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      arw_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      arw_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      arw_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @ (*) begin
    if(unburstify_buffer_valid)begin
      arw_payload_fragment_addr = unburstify_buffer_address;
    end else begin
      arw_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign _zz_2_ = (! (arw_payload_fragment_write && (! io_axi_w_valid)));
  assign stage0_valid = (arw_valid && _zz_2_);
  assign arw_ready = (stage0_ready && _zz_2_);
  assign stage0_payload_last = arw_payload_last;
  assign stage0_payload_fragment_addr = arw_payload_fragment_addr;
  assign stage0_payload_fragment_id = arw_payload_fragment_id;
  assign stage0_payload_fragment_size = arw_payload_fragment_size;
  assign stage0_payload_fragment_burst = arw_payload_fragment_burst;
  assign stage0_payload_fragment_write = arw_payload_fragment_write;
  assign io_axi_r_payload_data = ram_rdData;
  assign io_axi_w_ready = ((arw_valid && arw_payload_fragment_write) && stage0_ready);
  assign stage0_ready = ((1'b1 && (! stage1_valid)) || stage1_ready);
  assign stage1_valid = stage0_m2sPipe_rValid;
  assign stage1_payload_last = stage0_m2sPipe_rData_last;
  assign stage1_payload_fragment_addr = stage0_m2sPipe_rData_fragment_addr;
  assign stage1_payload_fragment_id = stage0_m2sPipe_rData_fragment_id;
  assign stage1_payload_fragment_size = stage0_m2sPipe_rData_fragment_size;
  assign stage1_payload_fragment_burst = stage0_m2sPipe_rData_fragment_burst;
  assign stage1_payload_fragment_write = stage0_m2sPipe_rData_fragment_write;
  assign stage1_ready = ((io_axi_r_ready && (! stage1_payload_fragment_write)) || ((io_axi_b_ready || (! stage1_payload_last)) && stage1_payload_fragment_write));
  assign io_axi_r_valid = (stage1_valid && (! stage1_payload_fragment_write));
  assign io_axi_r_payload_id = stage1_payload_fragment_id;
  assign io_axi_r_payload_last = stage1_payload_last;
  assign io_axi_r_payload_resp = (2'b00);
  assign io_axi_b_valid = ((stage1_valid && stage1_payload_fragment_write) && stage1_payload_last);
  assign io_axi_b_payload_resp = (2'b00);
  assign io_axi_b_payload_id = stage1_payload_fragment_id;
  assign _zz_4_ = stage0_payload_fragment_addr[16 : 2];
  assign _zz_3_ = ((stage0_valid && stage0_ready) && 1'b1);
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      unburstify_buffer_valid <= 1'b0;
      stage0_m2sPipe_rValid <= 1'b0;
    end else begin
      if(arw_ready)begin
        if(unburstify_buffer_last)begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(! unburstify_buffer_valid) begin
        if(! _zz_6_) begin
          if(arw_ready)begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(stage0_ready)begin
        stage0_m2sPipe_rValid <= stage0_valid;
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(arw_ready)begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - (8'b00000001));
      unburstify_buffer_transaction_addr[11 : 0] <= unburstify_buffer_address[11 : 0];
    end
    if(! unburstify_buffer_valid) begin
      if(! _zz_6_) begin
        if(arw_ready)begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(stage0_ready)begin
      stage0_m2sPipe_rData_last <= stage0_payload_last;
      stage0_m2sPipe_rData_fragment_addr <= stage0_payload_fragment_addr;
      stage0_m2sPipe_rData_fragment_id <= stage0_payload_fragment_id;
      stage0_m2sPipe_rData_fragment_size <= stage0_payload_fragment_size;
      stage0_m2sPipe_rData_fragment_burst <= stage0_payload_fragment_burst;
      stage0_m2sPipe_rData_fragment_write <= stage0_payload_fragment_write;
    end
  end

endmodule

module NoDebug_VexRiscv (
      input   timerInterrupt,
      input   externalInterrupt,
      input   softwareInterrupt,
      output  iBus_cmd_valid,
      input   iBus_cmd_ready,
      output reg [31:0] iBus_cmd_payload_address,
      output [2:0] iBus_cmd_payload_size,
      input   iBus_rsp_valid,
      input  [31:0] iBus_rsp_payload_data,
      input   iBus_rsp_payload_error,
      output  dBus_cmd_valid,
      input   dBus_cmd_ready,
      output  dBus_cmd_payload_wr,
      output [31:0] dBus_cmd_payload_address,
      output [31:0] dBus_cmd_payload_data,
      output [3:0] dBus_cmd_payload_mask,
      output [2:0] dBus_cmd_payload_length,
      output  dBus_cmd_payload_last,
      input   dBus_rsp_valid,
      input  [31:0] dBus_rsp_payload_data,
      input   dBus_rsp_payload_error,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_225_;
  wire  _zz_226_;
  wire  _zz_227_;
  wire  _zz_228_;
  wire  _zz_229_;
  wire  _zz_230_;
  wire  _zz_231_;
  reg  _zz_232_;
  wire  _zz_233_;
  wire [31:0] _zz_234_;
  wire  _zz_235_;
  wire [31:0] _zz_236_;
  reg  _zz_237_;
  wire  _zz_238_;
  wire  _zz_239_;
  wire [31:0] _zz_240_;
  wire  _zz_241_;
  reg [31:0] _zz_242_;
  reg [31:0] _zz_243_;
  reg [31:0] _zz_244_;
  wire  IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_haltIt;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  wire  IBusCachedPlugin_cache_io_cpu_decode_error;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_data;
  wire  IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire  IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire [31:0] IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire [2:0] IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire  dataCache_io_cpu_memory_isWrite;
  wire  dataCache_io_cpu_memory_mmuBus_cmd_isValid;
  wire [31:0] dataCache_io_cpu_memory_mmuBus_cmd_virtualAddress;
  wire  dataCache_io_cpu_memory_mmuBus_cmd_bypassTranslation;
  wire  dataCache_io_cpu_memory_mmuBus_end;
  wire  dataCache_io_cpu_writeBack_haltIt;
  wire [31:0] dataCache_io_cpu_writeBack_data;
  wire  dataCache_io_cpu_writeBack_mmuException;
  wire  dataCache_io_cpu_writeBack_unalignedAccess;
  wire  dataCache_io_cpu_writeBack_accessError;
  wire  dataCache_io_cpu_writeBack_isWrite;
  wire  dataCache_io_cpu_flush_ready;
  wire  dataCache_io_cpu_redo;
  wire  dataCache_io_mem_cmd_valid;
  wire  dataCache_io_mem_cmd_payload_wr;
  wire [31:0] dataCache_io_mem_cmd_payload_address;
  wire [31:0] dataCache_io_mem_cmd_payload_data;
  wire [3:0] dataCache_io_mem_cmd_payload_mask;
  wire [2:0] dataCache_io_mem_cmd_payload_length;
  wire  dataCache_io_mem_cmd_payload_last;
  wire  _zz_245_;
  wire  _zz_246_;
  wire  _zz_247_;
  wire  _zz_248_;
  wire  _zz_249_;
  wire  _zz_250_;
  wire  _zz_251_;
  wire  _zz_252_;
  wire  _zz_253_;
  wire  _zz_254_;
  wire  _zz_255_;
  wire  _zz_256_;
  wire  _zz_257_;
  wire  _zz_258_;
  wire  _zz_259_;
  wire  _zz_260_;
  wire  _zz_261_;
  wire  _zz_262_;
  wire  _zz_263_;
  wire  _zz_264_;
  wire  _zz_265_;
  wire  _zz_266_;
  wire  _zz_267_;
  wire  _zz_268_;
  wire  _zz_269_;
  wire  _zz_270_;
  wire  _zz_271_;
  wire  _zz_272_;
  wire  _zz_273_;
  wire  _zz_274_;
  wire  _zz_275_;
  wire  _zz_276_;
  wire  _zz_277_;
  wire  _zz_278_;
  wire  _zz_279_;
  wire  _zz_280_;
  wire  _zz_281_;
  wire  _zz_282_;
  wire  _zz_283_;
  wire  _zz_284_;
  wire  _zz_285_;
  wire  _zz_286_;
  wire  _zz_287_;
  wire  _zz_288_;
  wire  _zz_289_;
  wire  _zz_290_;
  wire  _zz_291_;
  wire  _zz_292_;
  wire  _zz_293_;
  wire  _zz_294_;
  wire  _zz_295_;
  wire  _zz_296_;
  wire  _zz_297_;
  wire [1:0] _zz_298_;
  wire  _zz_299_;
  wire  _zz_300_;
  wire  _zz_301_;
  wire  _zz_302_;
  wire  _zz_303_;
  wire  _zz_304_;
  wire  _zz_305_;
  wire  _zz_306_;
  wire [1:0] _zz_307_;
  wire  _zz_308_;
  wire  _zz_309_;
  wire  _zz_310_;
  wire  _zz_311_;
  wire  _zz_312_;
  wire  _zz_313_;
  wire  _zz_314_;
  wire  _zz_315_;
  wire  _zz_316_;
  wire  _zz_317_;
  wire  _zz_318_;
  wire  _zz_319_;
  wire  _zz_320_;
  wire  _zz_321_;
  wire  _zz_322_;
  wire  _zz_323_;
  wire  _zz_324_;
  wire  _zz_325_;
  wire  _zz_326_;
  wire  _zz_327_;
  wire [4:0] _zz_328_;
  wire [1:0] _zz_329_;
  wire [1:0] _zz_330_;
  wire [1:0] _zz_331_;
  wire [1:0] _zz_332_;
  wire  _zz_333_;
  wire [0:0] _zz_334_;
  wire [0:0] _zz_335_;
  wire [0:0] _zz_336_;
  wire [0:0] _zz_337_;
  wire [32:0] _zz_338_;
  wire [31:0] _zz_339_;
  wire [32:0] _zz_340_;
  wire [51:0] _zz_341_;
  wire [51:0] _zz_342_;
  wire [51:0] _zz_343_;
  wire [32:0] _zz_344_;
  wire [51:0] _zz_345_;
  wire [49:0] _zz_346_;
  wire [51:0] _zz_347_;
  wire [49:0] _zz_348_;
  wire [51:0] _zz_349_;
  wire [0:0] _zz_350_;
  wire [0:0] _zz_351_;
  wire [0:0] _zz_352_;
  wire [0:0] _zz_353_;
  wire [0:0] _zz_354_;
  wire [0:0] _zz_355_;
  wire [2:0] _zz_356_;
  wire [31:0] _zz_357_;
  wire [0:0] _zz_358_;
  wire [0:0] _zz_359_;
  wire [0:0] _zz_360_;
  wire [0:0] _zz_361_;
  wire [0:0] _zz_362_;
  wire [0:0] _zz_363_;
  wire [0:0] _zz_364_;
  wire [4:0] _zz_365_;
  wire [2:0] _zz_366_;
  wire [31:0] _zz_367_;
  wire [2:0] _zz_368_;
  wire [31:0] _zz_369_;
  wire [31:0] _zz_370_;
  wire [11:0] _zz_371_;
  wire [11:0] _zz_372_;
  wire [11:0] _zz_373_;
  wire [31:0] _zz_374_;
  wire [19:0] _zz_375_;
  wire [11:0] _zz_376_;
  wire [2:0] _zz_377_;
  wire [2:0] _zz_378_;
  wire [31:0] _zz_379_;
  wire [31:0] _zz_380_;
  wire [31:0] _zz_381_;
  wire [31:0] _zz_382_;
  wire [31:0] _zz_383_;
  wire [31:0] _zz_384_;
  wire [31:0] _zz_385_;
  wire [31:0] _zz_386_;
  wire [31:0] _zz_387_;
  wire [31:0] _zz_388_;
  wire [31:0] _zz_389_;
  wire [31:0] _zz_390_;
  wire [31:0] _zz_391_;
  wire [31:0] _zz_392_;
  wire [31:0] _zz_393_;
  wire [31:0] _zz_394_;
  wire [0:0] _zz_395_;
  wire [2:0] _zz_396_;
  wire [4:0] _zz_397_;
  wire [11:0] _zz_398_;
  wire [11:0] _zz_399_;
  wire [31:0] _zz_400_;
  wire [31:0] _zz_401_;
  wire [31:0] _zz_402_;
  wire [31:0] _zz_403_;
  wire [31:0] _zz_404_;
  wire [31:0] _zz_405_;
  wire [31:0] _zz_406_;
  wire [65:0] _zz_407_;
  wire [65:0] _zz_408_;
  wire [31:0] _zz_409_;
  wire [31:0] _zz_410_;
  wire [0:0] _zz_411_;
  wire [5:0] _zz_412_;
  wire [32:0] _zz_413_;
  wire [32:0] _zz_414_;
  wire [31:0] _zz_415_;
  wire [31:0] _zz_416_;
  wire [32:0] _zz_417_;
  wire [32:0] _zz_418_;
  wire [32:0] _zz_419_;
  wire [0:0] _zz_420_;
  wire [32:0] _zz_421_;
  wire [0:0] _zz_422_;
  wire [32:0] _zz_423_;
  wire [0:0] _zz_424_;
  wire [31:0] _zz_425_;
  wire [11:0] _zz_426_;
  wire [19:0] _zz_427_;
  wire [11:0] _zz_428_;
  wire [2:0] _zz_429_;
  wire [1:0] _zz_430_;
  wire [1:0] _zz_431_;
  wire [0:0] _zz_432_;
  wire [0:0] _zz_433_;
  wire [0:0] _zz_434_;
  wire [0:0] _zz_435_;
  wire [0:0] _zz_436_;
  wire [0:0] _zz_437_;
  wire  _zz_438_;
  wire  _zz_439_;
  wire [2:0] _zz_440_;
  wire [31:0] _zz_441_;
  wire [31:0] _zz_442_;
  wire [31:0] _zz_443_;
  wire  _zz_444_;
  wire [0:0] _zz_445_;
  wire [12:0] _zz_446_;
  wire [31:0] _zz_447_;
  wire [31:0] _zz_448_;
  wire [31:0] _zz_449_;
  wire  _zz_450_;
  wire [0:0] _zz_451_;
  wire [6:0] _zz_452_;
  wire [31:0] _zz_453_;
  wire [31:0] _zz_454_;
  wire [31:0] _zz_455_;
  wire  _zz_456_;
  wire [0:0] _zz_457_;
  wire [0:0] _zz_458_;
  wire  _zz_459_;
  wire  _zz_460_;
  wire [6:0] _zz_461_;
  wire [4:0] _zz_462_;
  wire  _zz_463_;
  wire [4:0] _zz_464_;
  wire [0:0] _zz_465_;
  wire [7:0] _zz_466_;
  wire  _zz_467_;
  wire [0:0] _zz_468_;
  wire [0:0] _zz_469_;
  wire [31:0] _zz_470_;
  wire  _zz_471_;
  wire [0:0] _zz_472_;
  wire [0:0] _zz_473_;
  wire [1:0] _zz_474_;
  wire [1:0] _zz_475_;
  wire  _zz_476_;
  wire [0:0] _zz_477_;
  wire [25:0] _zz_478_;
  wire [31:0] _zz_479_;
  wire [31:0] _zz_480_;
  wire [31:0] _zz_481_;
  wire [31:0] _zz_482_;
  wire [31:0] _zz_483_;
  wire  _zz_484_;
  wire  _zz_485_;
  wire [0:0] _zz_486_;
  wire [0:0] _zz_487_;
  wire  _zz_488_;
  wire [0:0] _zz_489_;
  wire [22:0] _zz_490_;
  wire  _zz_491_;
  wire [0:0] _zz_492_;
  wire [0:0] _zz_493_;
  wire [1:0] _zz_494_;
  wire [1:0] _zz_495_;
  wire  _zz_496_;
  wire [0:0] _zz_497_;
  wire [18:0] _zz_498_;
  wire [31:0] _zz_499_;
  wire [31:0] _zz_500_;
  wire [31:0] _zz_501_;
  wire [31:0] _zz_502_;
  wire [31:0] _zz_503_;
  wire  _zz_504_;
  wire [0:0] _zz_505_;
  wire [0:0] _zz_506_;
  wire [4:0] _zz_507_;
  wire [4:0] _zz_508_;
  wire  _zz_509_;
  wire [0:0] _zz_510_;
  wire [15:0] _zz_511_;
  wire [31:0] _zz_512_;
  wire [31:0] _zz_513_;
  wire  _zz_514_;
  wire [0:0] _zz_515_;
  wire [1:0] _zz_516_;
  wire [31:0] _zz_517_;
  wire [31:0] _zz_518_;
  wire  _zz_519_;
  wire [2:0] _zz_520_;
  wire [2:0] _zz_521_;
  wire  _zz_522_;
  wire [0:0] _zz_523_;
  wire [12:0] _zz_524_;
  wire [31:0] _zz_525_;
  wire [31:0] _zz_526_;
  wire [31:0] _zz_527_;
  wire [31:0] _zz_528_;
  wire [31:0] _zz_529_;
  wire [31:0] _zz_530_;
  wire [31:0] _zz_531_;
  wire  _zz_532_;
  wire  _zz_533_;
  wire [0:0] _zz_534_;
  wire [3:0] _zz_535_;
  wire  _zz_536_;
  wire [4:0] _zz_537_;
  wire [4:0] _zz_538_;
  wire  _zz_539_;
  wire [0:0] _zz_540_;
  wire [9:0] _zz_541_;
  wire [31:0] _zz_542_;
  wire [31:0] _zz_543_;
  wire [31:0] _zz_544_;
  wire [31:0] _zz_545_;
  wire  _zz_546_;
  wire [0:0] _zz_547_;
  wire [1:0] _zz_548_;
  wire [31:0] _zz_549_;
  wire  _zz_550_;
  wire [0:0] _zz_551_;
  wire [2:0] _zz_552_;
  wire [0:0] _zz_553_;
  wire [0:0] _zz_554_;
  wire [0:0] _zz_555_;
  wire [0:0] _zz_556_;
  wire  _zz_557_;
  wire [0:0] _zz_558_;
  wire [7:0] _zz_559_;
  wire [31:0] _zz_560_;
  wire [31:0] _zz_561_;
  wire [31:0] _zz_562_;
  wire  _zz_563_;
  wire  _zz_564_;
  wire [31:0] _zz_565_;
  wire  _zz_566_;
  wire [0:0] _zz_567_;
  wire [0:0] _zz_568_;
  wire [31:0] _zz_569_;
  wire [31:0] _zz_570_;
  wire [31:0] _zz_571_;
  wire [31:0] _zz_572_;
  wire [31:0] _zz_573_;
  wire [31:0] _zz_574_;
  wire [0:0] _zz_575_;
  wire [1:0] _zz_576_;
  wire [3:0] _zz_577_;
  wire [3:0] _zz_578_;
  wire  _zz_579_;
  wire [0:0] _zz_580_;
  wire [5:0] _zz_581_;
  wire [31:0] _zz_582_;
  wire [31:0] _zz_583_;
  wire [31:0] _zz_584_;
  wire [31:0] _zz_585_;
  wire [31:0] _zz_586_;
  wire [31:0] _zz_587_;
  wire [31:0] _zz_588_;
  wire [31:0] _zz_589_;
  wire [31:0] _zz_590_;
  wire  _zz_591_;
  wire  _zz_592_;
  wire  _zz_593_;
  wire [0:0] _zz_594_;
  wire [1:0] _zz_595_;
  wire [0:0] _zz_596_;
  wire [0:0] _zz_597_;
  wire [0:0] _zz_598_;
  wire [0:0] _zz_599_;
  wire  _zz_600_;
  wire [0:0] _zz_601_;
  wire [3:0] _zz_602_;
  wire [31:0] _zz_603_;
  wire [31:0] _zz_604_;
  wire [31:0] _zz_605_;
  wire [31:0] _zz_606_;
  wire [31:0] _zz_607_;
  wire  _zz_608_;
  wire  _zz_609_;
  wire [31:0] _zz_610_;
  wire [31:0] _zz_611_;
  wire [31:0] _zz_612_;
  wire [31:0] _zz_613_;
  wire [31:0] _zz_614_;
  wire [31:0] _zz_615_;
  wire  _zz_616_;
  wire [0:0] _zz_617_;
  wire [0:0] _zz_618_;
  wire  _zz_619_;
  wire [0:0] _zz_620_;
  wire [1:0] _zz_621_;
  wire [31:0] _zz_622_;
  wire [31:0] _zz_623_;
  wire [31:0] _zz_624_;
  wire  _zz_625_;
  wire [0:0] _zz_626_;
  wire [0:0] _zz_627_;
  wire [0:0] _zz_628_;
  wire [0:0] _zz_629_;
  wire  _zz_630_;
  wire  _zz_631_;
  wire  _zz_632_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_1_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_2_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_3_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_4_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_5_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_6_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_7_;
  wire  decode_SRC_LESS_UNSIGNED;
  wire  memory_MEMORY_WR;
  wire  decode_MEMORY_WR;
  wire  memory_IS_MUL;
  wire  execute_IS_MUL;
  wire  decode_IS_MUL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_8_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_9_;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_10_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_11_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_12_;
  wire  decode_IS_DIV;
  wire [31:0] execute_SHIFT_RIGHT;
  wire  decode_CSR_WRITE_OPCODE;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_13_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_14_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_15_;
  wire [31:0] memory_PC;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_16_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_17_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_18_;
  wire [51:0] memory_MUL_LOW;
  wire  execute_BRANCH_DO;
  wire  decode_IS_CSR;
  wire  decode_IS_RS2_SIGNED;
  wire  decode_MEMORY_MANAGMENT;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire  decode_CSR_READ_OPCODE;
  wire  decode_SRC2_FORCE_ZERO;
  wire  decode_PREDICTION_HAD_BRANCHED2;
  wire [33:0] execute_MUL_HL;
  wire [33:0] execute_MUL_LH;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_19_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_20_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_21_;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_22_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_23_;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_24_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_25_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_26_;
  wire [31:0] execute_MUL_LL;
  wire [33:0] memory_MUL_HH;
  wire [33:0] execute_MUL_HH;
  wire  decode_IS_RS1_SIGNED;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire [31:0] execute_BRANCH_CALC;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_27_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_28_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_29_;
  wire [31:0] memory_BRANCH_CALC;
  wire  memory_BRANCH_DO;
  wire [31:0] execute_PC;
  wire  execute_BRANCH_COND_RESULT;
  wire  execute_PREDICTION_HAD_BRANCHED2;
  wire `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_30_;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  reg [31:0] _zz_31_;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  wire  memory_REGFILE_WRITE_VALID;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  reg [31:0] decode_RS2;
  reg [31:0] decode_RS1;
  wire  execute_IS_RS1_SIGNED;
  wire  execute_IS_DIV;
  wire  execute_IS_RS2_SIGNED;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_IS_DIV;
  wire  writeBack_IS_MUL;
  wire [33:0] writeBack_MUL_HH;
  wire [51:0] writeBack_MUL_LOW;
  wire [33:0] memory_MUL_HL;
  wire [33:0] memory_MUL_LH;
  wire [31:0] memory_MUL_LL;
  wire [31:0] execute_RS1;
  wire [31:0] memory_SHIFT_RIGHT;
  reg [31:0] _zz_32_;
  wire `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_33_;
  wire `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_34_;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC2_FORCE_ZERO;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_35_;
  wire `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_36_;
  wire  execute_IS_RVC;
  wire `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_37_;
  wire  decode_SRC_USE_SUB_LESS;
  wire  decode_SRC_ADD_ZERO;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_38_;
  wire [31:0] execute_SRC2;
  wire [31:0] execute_SRC1;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_39_;
  wire [31:0] _zz_40_;
  wire  _zz_41_;
  reg  _zz_42_;
  wire [31:0] decode_INSTRUCTION_ANTICIPATED;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_43_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_44_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_45_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_46_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_47_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_48_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_49_;
  reg  PMPPlugin_ports_1_matched;
  reg  PMPPlugin_ports_1_matched_x;
  reg  PMPPlugin_ports_1_matched_w;
  reg  PMPPlugin_ports_1_matched_r;
  reg  PMPPlugin_ports_1_enabled;
  reg  PMPPlugin_ports_1_matched_6;
  reg  PMPPlugin_ports_1_matched_x_6;
  reg  PMPPlugin_ports_1_matched_w_6;
  reg  PMPPlugin_ports_1_matched_r_6;
  reg  PMPPlugin_ports_1_enabled_6;
  reg  PMPPlugin_ports_1_matched_5;
  reg  PMPPlugin_ports_1_matched_x_5;
  reg  PMPPlugin_ports_1_matched_w_5;
  reg  PMPPlugin_ports_1_matched_r_5;
  reg  PMPPlugin_ports_1_enabled_5;
  reg  PMPPlugin_ports_1_matched_4;
  reg  PMPPlugin_ports_1_matched_x_4;
  reg  PMPPlugin_ports_1_matched_w_4;
  reg  PMPPlugin_ports_1_matched_r_4;
  reg  PMPPlugin_ports_1_enabled_4;
  reg  PMPPlugin_ports_1_matched_3;
  reg  PMPPlugin_ports_1_matched_x_3;
  reg  PMPPlugin_ports_1_matched_w_3;
  reg  PMPPlugin_ports_1_matched_r_3;
  reg  PMPPlugin_ports_1_enabled_3;
  reg  PMPPlugin_ports_1_matched_2;
  reg  PMPPlugin_ports_1_matched_x_2;
  reg  PMPPlugin_ports_1_matched_w_2;
  reg  PMPPlugin_ports_1_matched_r_2;
  reg  PMPPlugin_ports_1_enabled_2;
  reg  PMPPlugin_ports_1_matched_1;
  reg  PMPPlugin_ports_1_matched_x_1;
  reg  PMPPlugin_ports_1_matched_w_1;
  reg  PMPPlugin_ports_1_matched_r_1;
  reg  PMPPlugin_ports_1_enabled_1;
  reg  PMPPlugin_ports_1_matched_0;
  reg  PMPPlugin_ports_1_matched_x_0;
  reg  PMPPlugin_ports_1_matched_w_0;
  reg  PMPPlugin_ports_1_matched_r_0;
  reg  PMPPlugin_ports_1_enabled_0;
  reg  PMPPlugin_ports_0_matched;
  reg  PMPPlugin_ports_0_matched_x;
  reg  PMPPlugin_ports_0_matched_w;
  reg  PMPPlugin_ports_0_matched_r;
  reg  PMPPlugin_ports_0_enabled;
  reg  PMPPlugin_ports_0_matched_6;
  reg  PMPPlugin_ports_0_matched_x_6;
  reg  PMPPlugin_ports_0_matched_w_6;
  reg  PMPPlugin_ports_0_matched_r_6;
  reg  PMPPlugin_ports_0_enabled_6;
  reg  PMPPlugin_ports_0_matched_5;
  reg  PMPPlugin_ports_0_matched_x_5;
  reg  PMPPlugin_ports_0_matched_w_5;
  reg  PMPPlugin_ports_0_matched_r_5;
  reg  PMPPlugin_ports_0_enabled_5;
  reg  PMPPlugin_ports_0_matched_4;
  reg  PMPPlugin_ports_0_matched_x_4;
  reg  PMPPlugin_ports_0_matched_w_4;
  reg  PMPPlugin_ports_0_matched_r_4;
  reg  PMPPlugin_ports_0_enabled_4;
  reg  PMPPlugin_ports_0_matched_3;
  reg  PMPPlugin_ports_0_matched_x_3;
  reg  PMPPlugin_ports_0_matched_w_3;
  reg  PMPPlugin_ports_0_matched_r_3;
  reg  PMPPlugin_ports_0_enabled_3;
  reg  PMPPlugin_ports_0_matched_2;
  reg  PMPPlugin_ports_0_matched_x_2;
  reg  PMPPlugin_ports_0_matched_w_2;
  reg  PMPPlugin_ports_0_matched_r_2;
  reg  PMPPlugin_ports_0_enabled_2;
  reg  PMPPlugin_ports_0_matched_1;
  reg  PMPPlugin_ports_0_matched_x_1;
  reg  PMPPlugin_ports_0_matched_w_1;
  reg  PMPPlugin_ports_0_matched_r_1;
  reg  PMPPlugin_ports_0_enabled_1;
  reg  PMPPlugin_ports_0_matched_0;
  reg  PMPPlugin_ports_0_matched_x_0;
  reg  PMPPlugin_ports_0_matched_w_0;
  reg  PMPPlugin_ports_0_matched_r_0;
  reg  PMPPlugin_ports_0_enabled_0;
  reg  _zz_50_;
  reg  _zz_50__0;
  reg  _zz_51_;
  reg  _zz_51__0;
  reg  _zz_52_;
  reg  _zz_52__0;
  reg  _zz_53_;
  reg  _zz_53__0;
  reg  _zz_54_;
  reg  _zz_54__0;
  reg  _zz_55_;
  reg  _zz_55__0;
  reg  _zz_56_;
  reg  _zz_56__0;
  reg  _zz_57_;
  reg  _zz_57__0;
  reg [31:0] _zz_58_;
  wire [1:0] writeBack_MEMORY_ADDRESS_LOW;
  wire  writeBack_MEMORY_WR;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire  writeBack_MEMORY_ENABLE;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_MEMORY_ENABLE;
  wire  execute_MEMORY_MANAGMENT;
  wire [31:0] execute_RS2;
  wire  execute_MEMORY_WR;
  wire [31:0] execute_SRC_ADD;
  wire  execute_MEMORY_ENABLE;
  wire [31:0] execute_INSTRUCTION;
  wire  decode_MEMORY_ENABLE;
  wire  decode_FLUSH_ALL;
  reg  IBusCachedPlugin_rsp_issueDetected;
  reg  IBusCachedPlugin_rsp_issueDetected_2;
  reg  IBusCachedPlugin_rsp_issueDetected_1;
  reg  IBusCachedPlugin_rsp_issueDetected_0;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_59_;
  reg [31:0] _zz_60_;
  reg [31:0] _zz_61_;
  wire [31:0] decode_PC;
  wire [31:0] decode_INSTRUCTION;
  wire  decode_IS_RVC;
  wire [31:0] writeBack_PC;
  wire [31:0] writeBack_INSTRUCTION;
  reg  decode_arbitration_haltItself;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushIt;
  reg  decode_arbitration_flushNext;
  wire  decode_arbitration_isValid;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  wire  execute_arbitration_flushIt;
  reg  execute_arbitration_flushNext;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  wire  memory_arbitration_flushIt;
  reg  memory_arbitration_flushNext;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  reg  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  reg  writeBack_arbitration_flushIt;
  reg  writeBack_arbitration_flushNext;
  reg  writeBack_arbitration_isValid;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring;
  wire [31:0] lastStageInstruction /* verilator public */ ;
  wire [31:0] lastStagePc /* verilator public */ ;
  wire  lastStageIsValid /* verilator public */ ;
  wire  lastStageIsFiring /* verilator public */ ;
  reg  IBusCachedPlugin_fetcherHalt;
  reg  IBusCachedPlugin_fetcherflushIt;
  reg  IBusCachedPlugin_incomingInstruction;
  wire  IBusCachedPlugin_predictionJumpInterface_valid;
  (* keep , syn_keep *) wire [31:0] IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  wire  IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire  IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire  IBusCachedPlugin_pcValids_0;
  wire  IBusCachedPlugin_pcValids_1;
  wire  IBusCachedPlugin_pcValids_2;
  wire  IBusCachedPlugin_pcValids_3;
  wire  IBusCachedPlugin_redoBranch_valid;
  wire [31:0] IBusCachedPlugin_redoBranch_payload;
  reg  IBusCachedPlugin_decodeExceptionPort_valid;
  reg [3:0] IBusCachedPlugin_decodeExceptionPort_payload_code;
  wire [31:0] IBusCachedPlugin_decodeExceptionPort_payload_badAddr;
  wire  IBusCachedPlugin_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire [31:0] IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire  IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg  IBusCachedPlugin_mmuBus_rsp_allowRead;
  reg  IBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg  IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire  IBusCachedPlugin_mmuBus_rsp_exception;
  wire  IBusCachedPlugin_mmuBus_rsp_refilling;
  wire  IBusCachedPlugin_mmuBus_end;
  wire  IBusCachedPlugin_mmuBus_busy;
  wire  DBusCachedPlugin_mmuBus_cmd_isValid;
  wire [31:0] DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire  DBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  wire [31:0] DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire  DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg  DBusCachedPlugin_mmuBus_rsp_allowRead;
  reg  DBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg  DBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire  DBusCachedPlugin_mmuBus_rsp_exception;
  wire  DBusCachedPlugin_mmuBus_rsp_refilling;
  wire  DBusCachedPlugin_mmuBus_end;
  wire  DBusCachedPlugin_mmuBus_busy;
  reg  DBusCachedPlugin_redoBranch_valid;
  wire [31:0] DBusCachedPlugin_redoBranch_payload;
  reg  DBusCachedPlugin_exceptionBus_valid;
  reg [3:0] DBusCachedPlugin_exceptionBus_payload_code;
  wire [31:0] DBusCachedPlugin_exceptionBus_payload_badAddr;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_payload_code;
  wire [31:0] decodeExceptionPort_payload_badAddr;
  wire  BranchPlugin_jumpInterface_valid;
  wire [31:0] BranchPlugin_jumpInterface_payload;
  wire  CsrPlugin_thirdPartyWake;
  reg  CsrPlugin_jumpInterface_valid;
  reg [31:0] CsrPlugin_jumpInterface_payload;
  wire  CsrPlugin_exceptionPendings_0;
  wire  CsrPlugin_exceptionPendings_1;
  wire  CsrPlugin_exceptionPendings_2;
  wire  CsrPlugin_exceptionPendings_3;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  wire  CsrPlugin_forceMachineWire;
  reg  CsrPlugin_selfException_valid;
  reg [3:0] CsrPlugin_selfException_payload_code;
  wire [31:0] CsrPlugin_selfException_payload_badAddr;
  wire  CsrPlugin_allowInterrupts;
  wire  CsrPlugin_allowException;
  wire  IBusCachedPlugin_jump_pcLoad_valid;
  wire [31:0] IBusCachedPlugin_jump_pcLoad_payload;
  wire [4:0] _zz_62_;
  wire [4:0] _zz_63_;
  wire  _zz_64_;
  wire  _zz_65_;
  wire  _zz_66_;
  wire  _zz_67_;
  wire  IBusCachedPlugin_fetchPc_output_valid;
  wire  IBusCachedPlugin_fetchPc_output_ready;
  wire [31:0] IBusCachedPlugin_fetchPc_output_payload;
  reg [31:0] IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusCachedPlugin_fetchPc_corrected;
  reg  IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg  IBusCachedPlugin_fetchPc_booted;
  reg  IBusCachedPlugin_fetchPc_inc;
  reg [31:0] IBusCachedPlugin_fetchPc_pc;
  reg [31:0] IBusCachedPlugin_decodePc_pcReg /* verilator public */ ;
  wire [31:0] IBusCachedPlugin_decodePc_pcPlus;
  wire  IBusCachedPlugin_decodePc_injectedDecode;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_0_inputSample;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_1_inputSample;
  wire  IBusCachedPlugin_iBusRsp_stages_2_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_2_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_2_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_2_inputSample;
  wire  _zz_68_;
  wire  _zz_69_;
  wire  _zz_70_;
  wire  _zz_71_;
  wire  _zz_72_;
  reg  _zz_73_;
  wire  _zz_74_;
  reg  _zz_75_;
  reg [31:0] _zz_76_;
  reg  IBusCachedPlugin_iBusRsp_readyForError;
  wire  IBusCachedPlugin_iBusRsp_output_valid;
  wire  IBusCachedPlugin_iBusRsp_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_output_payload_pc;
  wire  IBusCachedPlugin_iBusRsp_output_payload_rsp_error;
  wire [31:0] IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  wire  IBusCachedPlugin_iBusRsp_output_payload_isRvc;
  wire  IBusCachedPlugin_decompressor_output_valid;
  wire  IBusCachedPlugin_decompressor_output_ready;
  wire [31:0] IBusCachedPlugin_decompressor_output_payload_pc;
  wire  IBusCachedPlugin_decompressor_output_payload_rsp_error;
  wire [31:0] IBusCachedPlugin_decompressor_output_payload_rsp_inst;
  wire  IBusCachedPlugin_decompressor_output_payload_isRvc;
  reg  IBusCachedPlugin_decompressor_bufferValid;
  reg [15:0] IBusCachedPlugin_decompressor_bufferData;
  wire [31:0] IBusCachedPlugin_decompressor_raw;
  wire  IBusCachedPlugin_decompressor_isRvc;
  wire [15:0] _zz_77_;
  reg [31:0] IBusCachedPlugin_decompressor_decompressed;
  wire [4:0] _zz_78_;
  wire [4:0] _zz_79_;
  wire [11:0] _zz_80_;
  wire  _zz_81_;
  reg [11:0] _zz_82_;
  wire  _zz_83_;
  reg [9:0] _zz_84_;
  wire [20:0] _zz_85_;
  wire  _zz_86_;
  reg [14:0] _zz_87_;
  wire  _zz_88_;
  reg [2:0] _zz_89_;
  wire  _zz_90_;
  reg [9:0] _zz_91_;
  wire [20:0] _zz_92_;
  wire  _zz_93_;
  reg [4:0] _zz_94_;
  wire [12:0] _zz_95_;
  wire [4:0] _zz_96_;
  wire [4:0] _zz_97_;
  wire [4:0] _zz_98_;
  wire  _zz_99_;
  reg [2:0] _zz_100_;
  reg [2:0] _zz_101_;
  wire  _zz_102_;
  reg [6:0] _zz_103_;
  reg  IBusCachedPlugin_decompressor_bufferFill;
  wire  IBusCachedPlugin_injector_decodeInput_valid;
  wire  IBusCachedPlugin_injector_decodeInput_ready;
  wire [31:0] IBusCachedPlugin_injector_decodeInput_payload_pc;
  wire  IBusCachedPlugin_injector_decodeInput_payload_rsp_error;
  wire [31:0] IBusCachedPlugin_injector_decodeInput_payload_rsp_inst;
  wire  IBusCachedPlugin_injector_decodeInput_payload_isRvc;
  reg  _zz_104_;
  reg [31:0] _zz_105_;
  reg  _zz_106_;
  reg [31:0] _zz_107_;
  reg  _zz_108_;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg  IBusCachedPlugin_injector_decodeRemoved;
  reg [31:0] IBusCachedPlugin_injector_formal_rawInDecode;
  wire  _zz_109_;
  reg [18:0] _zz_110_;
  wire  _zz_111_;
  reg [10:0] _zz_112_;
  wire  _zz_113_;
  reg [18:0] _zz_114_;
  wire [31:0] _zz_115_;
  reg [31:0] IBusCachedPlugin_rspCounter;
  wire  IBusCachedPlugin_s0_tightlyCoupledHit;
  reg  IBusCachedPlugin_s1_tightlyCoupledHit;
  reg  IBusCachedPlugin_s2_tightlyCoupledHit;
  wire  IBusCachedPlugin_rsp_iBusRspOutputHalt;
  reg  IBusCachedPlugin_rsp_redoFetch;
  wire [31:0] _zz_116_;
  reg [31:0] DBusCachedPlugin_rspCounter;
  wire [1:0] execute_DBusCachedPlugin_size;
  reg [31:0] _zz_117_;
  reg [31:0] writeBack_DBusCachedPlugin_rspShifted;
  wire  _zz_118_;
  reg [31:0] _zz_119_;
  wire  _zz_120_;
  reg [31:0] _zz_121_;
  reg [31:0] writeBack_DBusCachedPlugin_rspFormated;
  reg [31:0] PMPPlugin_pmpcfgPacked_0;
  reg [31:0] PMPPlugin_pmpcfgPacked_1;
  reg [31:0] PMPPlugin_pmpaddr_0;
  reg [31:0] PMPPlugin_pmpaddr_1;
  reg [31:0] PMPPlugin_pmpaddr_2;
  reg [31:0] PMPPlugin_pmpaddr_3;
  reg [31:0] PMPPlugin_pmpaddr_4;
  reg [31:0] PMPPlugin_pmpaddr_5;
  reg [31:0] PMPPlugin_pmpaddr_6;
  reg [31:0] PMPPlugin_pmpaddr_7;
  wire [7:0] PMPPlugin_pmpcfg_0;
  wire [7:0] PMPPlugin_pmpcfg_1;
  wire [7:0] PMPPlugin_pmpcfg_2;
  wire [7:0] PMPPlugin_pmpcfg_3;
  wire [7:0] PMPPlugin_pmpcfg_4;
  wire [7:0] PMPPlugin_pmpcfg_5;
  wire [7:0] PMPPlugin_pmpcfg_6;
  wire [7:0] PMPPlugin_pmpcfg_7;
  reg [31:0] PMPPlugin_shadow_pmpaddr_0;
  reg [31:0] PMPPlugin_shadow_pmpaddr_1;
  reg [31:0] PMPPlugin_shadow_pmpaddr_2;
  reg [31:0] PMPPlugin_shadow_pmpaddr_3;
  reg [31:0] PMPPlugin_shadow_pmpaddr_4;
  reg [31:0] PMPPlugin_shadow_pmpaddr_5;
  reg [31:0] PMPPlugin_shadow_pmpaddr_6;
  reg [31:0] PMPPlugin_shadow_pmpaddr_7;
  reg [7:0] PMPPlugin_shadow_pmpcfg_0;
  reg [7:0] PMPPlugin_shadow_pmpcfg_1;
  reg [7:0] PMPPlugin_shadow_pmpcfg_2;
  reg [7:0] PMPPlugin_shadow_pmpcfg_3;
  reg [7:0] PMPPlugin_shadow_pmpcfg_4;
  reg [7:0] PMPPlugin_shadow_pmpcfg_5;
  reg [7:0] PMPPlugin_shadow_pmpcfg_6;
  reg [7:0] PMPPlugin_shadow_pmpcfg_7;
  reg [31:0] PMPPlugin_tmp_pmpcfgPacked_0;
  reg [31:0] PMPPlugin_tmp_pmpcfgPacked_1;
  wire [31:0] PMPPlugin_ports_0_physAddr;
  wire [1:0] _zz_122_;
  wire [1:0] _zz_123_;
  wire [31:0] _zz_124_;
  wire [1:0] _zz_125_;
  wire [1:0] _zz_126_;
  wire [31:0] _zz_127_;
  wire [1:0] _zz_128_;
  wire [1:0] _zz_129_;
  wire [31:0] _zz_130_;
  wire [1:0] _zz_131_;
  wire [1:0] _zz_132_;
  wire [31:0] _zz_133_;
  wire [1:0] _zz_134_;
  wire [1:0] _zz_135_;
  wire [31:0] _zz_136_;
  wire [1:0] _zz_137_;
  wire [1:0] _zz_138_;
  wire [31:0] _zz_139_;
  wire [1:0] _zz_140_;
  wire [1:0] _zz_141_;
  wire [31:0] _zz_142_;
  wire [1:0] _zz_143_;
  wire [1:0] _zz_144_;
  wire [31:0] _zz_145_;
  wire [31:0] PMPPlugin_ports_1_physAddr;
  wire [1:0] _zz_146_;
  wire [1:0] _zz_147_;
  wire [31:0] _zz_148_;
  wire [1:0] _zz_149_;
  wire [1:0] _zz_150_;
  wire [31:0] _zz_151_;
  wire [1:0] _zz_152_;
  wire [1:0] _zz_153_;
  wire [31:0] _zz_154_;
  wire [1:0] _zz_155_;
  wire [1:0] _zz_156_;
  wire [31:0] _zz_157_;
  wire [1:0] _zz_158_;
  wire [1:0] _zz_159_;
  wire [31:0] _zz_160_;
  wire [1:0] _zz_161_;
  wire [1:0] _zz_162_;
  wire [31:0] _zz_163_;
  wire [1:0] _zz_164_;
  wire [1:0] _zz_165_;
  wire [31:0] _zz_166_;
  wire [1:0] _zz_167_;
  wire [1:0] _zz_168_;
  wire [31:0] _zz_169_;
  wire [31:0] _zz_170_;
  wire  _zz_171_;
  wire  _zz_172_;
  wire  _zz_173_;
  wire  _zz_174_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_175_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_176_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_177_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_178_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_179_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_180_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_181_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  lastStageRegFileWrite_valid /* verilator public */ ;
  wire [4:0] lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire [31:0] lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg  _zz_182_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_183_;
  reg [31:0] _zz_184_;
  wire  _zz_185_;
  reg [19:0] _zz_186_;
  wire  _zz_187_;
  reg [19:0] _zz_188_;
  reg [31:0] _zz_189_;
  reg [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrelShifterPlugin_amplitude;
  reg [31:0] _zz_190_;
  wire [31:0] execute_FullBarrelShifterPlugin_reversed;
  reg [31:0] _zz_191_;
  reg  execute_MulPlugin_aSigned;
  reg  execute_MulPlugin_bSigned;
  wire [31:0] execute_MulPlugin_a;
  wire [31:0] execute_MulPlugin_b;
  wire [15:0] execute_MulPlugin_aULow;
  wire [15:0] execute_MulPlugin_bULow;
  wire [16:0] execute_MulPlugin_aSLow;
  wire [16:0] execute_MulPlugin_bSLow;
  wire [16:0] execute_MulPlugin_aHigh;
  wire [16:0] execute_MulPlugin_bHigh;
  wire [65:0] writeBack_MulPlugin_result;
  reg [32:0] memory_DivPlugin_rs1;
  reg [31:0] memory_DivPlugin_rs2;
  reg [64:0] memory_DivPlugin_accumulator;
  reg  memory_DivPlugin_div_needRevert;
  reg  memory_DivPlugin_div_counter_willIncrement;
  reg  memory_DivPlugin_div_counter_willClear;
  reg [5:0] memory_DivPlugin_div_counter_valueNext;
  reg [5:0] memory_DivPlugin_div_counter_value;
  wire  memory_DivPlugin_div_counter_willOverflowIfInc;
  wire  memory_DivPlugin_div_counter_willOverflow;
  reg  memory_DivPlugin_div_done;
  reg [31:0] memory_DivPlugin_div_result;
  wire [31:0] _zz_192_;
  wire [32:0] _zz_193_;
  wire [32:0] _zz_194_;
  wire [31:0] _zz_195_;
  wire  _zz_196_;
  wire  _zz_197_;
  reg [32:0] _zz_198_;
  reg  _zz_199_;
  reg  _zz_200_;
  reg  _zz_201_;
  reg [4:0] _zz_202_;
  reg [31:0] _zz_203_;
  wire  _zz_204_;
  wire  _zz_205_;
  wire  _zz_206_;
  wire  _zz_207_;
  wire  _zz_208_;
  wire  _zz_209_;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_210_;
  reg  _zz_211_;
  reg  _zz_212_;
  wire  execute_BranchPlugin_missAlignedTarget;
  reg [31:0] execute_BranchPlugin_branch_src1;
  reg [31:0] execute_BranchPlugin_branch_src2;
  wire  _zz_213_;
  reg [19:0] _zz_214_;
  wire  _zz_215_;
  reg [10:0] _zz_216_;
  wire  _zz_217_;
  reg [18:0] _zz_218_;
  wire [31:0] execute_BranchPlugin_branchAdder;
  reg [1:0] _zz_219_;
  wire [1:0] CsrPlugin_misa_base;
  wire [25:0] CsrPlugin_misa_extensions;
  wire [1:0] CsrPlugin_mtvec_mode;
  wire [29:0] CsrPlugin_mtvec_base;
  reg [31:0] CsrPlugin_mepc;
  reg  CsrPlugin_mstatus_MIE;
  reg  CsrPlugin_mstatus_MPIE;
  reg [1:0] CsrPlugin_mstatus_MPP;
  reg  CsrPlugin_mip_MEIP;
  reg  CsrPlugin_mip_MTIP;
  reg  CsrPlugin_mip_MSIP;
  reg  CsrPlugin_mie_MEIE;
  reg  CsrPlugin_mie_MTIE;
  reg  CsrPlugin_mie_MSIE;
  reg [31:0] CsrPlugin_mscratch;
  reg  CsrPlugin_mcause_interrupt;
  reg [3:0] CsrPlugin_mcause_exceptionCode;
  reg [31:0] CsrPlugin_mtval;
  reg [63:0] CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg [63:0] CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire  _zz_220_;
  wire  _zz_221_;
  wire  _zz_222_;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg [3:0] CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg [31:0] CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire [1:0] _zz_223_;
  wire  _zz_224_;
  reg  CsrPlugin_interrupt_valid;
  reg [3:0] CsrPlugin_interrupt_code /* verilator public */ ;
  reg [1:0] CsrPlugin_interrupt_targetPrivilege;
  wire  CsrPlugin_exception;
  wire  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  reg [1:0] CsrPlugin_targetPrivilege;
  reg [3:0] CsrPlugin_trapCause;
  reg [1:0] CsrPlugin_xtvec_mode;
  reg [29:0] CsrPlugin_xtvec_base;
  wire  execute_CsrPlugin_inWfi /* verilator public */ ;
  reg  execute_CsrPlugin_wfiWake;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  wire [31:0] execute_CsrPlugin_readToWriteData;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  reg [31:0] execute_to_memory_BRANCH_CALC;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_IS_RS1_SIGNED;
  reg [33:0] execute_to_memory_MUL_HH;
  reg [33:0] memory_to_writeBack_MUL_HH;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg [31:0] execute_to_memory_MUL_LL;
  reg `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg [31:0] decode_to_execute_RS1;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg [1:0] memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg [33:0] execute_to_memory_MUL_LH;
  reg [33:0] execute_to_memory_MUL_HL;
  reg  decode_to_execute_IS_RVC;
  reg  decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg  decode_to_execute_SRC2_FORCE_ZERO;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg  decode_to_execute_MEMORY_MANAGMENT;
  reg  decode_to_execute_IS_RS2_SIGNED;
  reg  decode_to_execute_IS_CSR;
  reg  execute_to_memory_BRANCH_DO;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg  memory_to_writeBack_MEMORY_ENABLE;
  reg [51:0] memory_to_writeBack_MUL_LOW;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg [31:0] decode_to_execute_RS2;
  reg [31:0] execute_to_memory_SHIFT_RIGHT;
  reg  decode_to_execute_IS_DIV;
  reg  execute_to_memory_IS_DIV;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg  decode_to_execute_IS_MUL;
  reg  execute_to_memory_IS_MUL;
  reg  memory_to_writeBack_IS_MUL;
  reg  decode_to_execute_MEMORY_WR;
  reg  execute_to_memory_MEMORY_WR;
  reg  memory_to_writeBack_MEMORY_WR;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  `ifndef SYNTHESIS
  reg [39:0] _zz_1__string;
  reg [39:0] _zz_2__string;
  reg [39:0] _zz_3__string;
  reg [39:0] _zz_4__string;
  reg [39:0] decode_ENV_CTRL_string;
  reg [39:0] _zz_5__string;
  reg [39:0] _zz_6__string;
  reg [39:0] _zz_7__string;
  reg [71:0] _zz_8__string;
  reg [71:0] _zz_9__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_10__string;
  reg [71:0] _zz_11__string;
  reg [71:0] _zz_12__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_13__string;
  reg [23:0] _zz_14__string;
  reg [23:0] _zz_15__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_16__string;
  reg [63:0] _zz_17__string;
  reg [63:0] _zz_18__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_19__string;
  reg [39:0] _zz_20__string;
  reg [39:0] _zz_21__string;
  reg [31:0] _zz_22__string;
  reg [31:0] _zz_23__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_24__string;
  reg [95:0] _zz_25__string;
  reg [95:0] _zz_26__string;
  reg [39:0] memory_ENV_CTRL_string;
  reg [39:0] _zz_27__string;
  reg [39:0] execute_ENV_CTRL_string;
  reg [39:0] _zz_28__string;
  reg [39:0] writeBack_ENV_CTRL_string;
  reg [39:0] _zz_29__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_30__string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_33__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_34__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_36__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_37__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_38__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_39__string;
  reg [95:0] _zz_43__string;
  reg [31:0] _zz_44__string;
  reg [23:0] _zz_45__string;
  reg [71:0] _zz_46__string;
  reg [39:0] _zz_47__string;
  reg [39:0] _zz_48__string;
  reg [63:0] _zz_49__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_59__string;
  reg [63:0] _zz_175__string;
  reg [39:0] _zz_176__string;
  reg [39:0] _zz_177__string;
  reg [71:0] _zz_178__string;
  reg [23:0] _zz_179__string;
  reg [31:0] _zz_180__string;
  reg [95:0] _zz_181__string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [39:0] decode_to_execute_ENV_CTRL_string;
  reg [39:0] execute_to_memory_ENV_CTRL_string;
  reg [39:0] memory_to_writeBack_ENV_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign _zz_245_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_246_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_247_ = 1'b1;
  assign _zz_248_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_249_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_250_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_251_ = ((! PMPPlugin_ports_1_matched_6) && (((((PMPPlugin_shadow_pmpaddr_6 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_7)) && (_zz_167_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_7) && (_zz_167_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_169_) == (PMPPlugin_shadow_pmpaddr_7 & _zz_169_)) && (_zz_167_ == (2'b11)))));
  assign _zz_252_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_168_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_168_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_168_ == (2'b00))));
  assign _zz_253_ = ((! PMPPlugin_ports_1_matched_5) && (((((PMPPlugin_shadow_pmpaddr_5 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_6)) && (_zz_164_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_6) && (_zz_164_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_166_) == (PMPPlugin_shadow_pmpaddr_6 & _zz_166_)) && (_zz_164_ == (2'b11)))));
  assign _zz_254_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_165_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_165_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_165_ == (2'b00))));
  assign _zz_255_ = ((! PMPPlugin_ports_1_matched_4) && (((((PMPPlugin_shadow_pmpaddr_4 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_5)) && (_zz_161_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_5) && (_zz_161_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_163_) == (PMPPlugin_shadow_pmpaddr_5 & _zz_163_)) && (_zz_161_ == (2'b11)))));
  assign _zz_256_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_162_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_162_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_162_ == (2'b00))));
  assign _zz_257_ = ((! PMPPlugin_ports_1_matched_3) && (((((PMPPlugin_shadow_pmpaddr_3 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_4)) && (_zz_158_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_4) && (_zz_158_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_160_) == (PMPPlugin_shadow_pmpaddr_4 & _zz_160_)) && (_zz_158_ == (2'b11)))));
  assign _zz_258_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_159_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_159_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_159_ == (2'b00))));
  assign _zz_259_ = ((! PMPPlugin_ports_1_matched_2) && (((((PMPPlugin_shadow_pmpaddr_2 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_3)) && (_zz_155_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_3) && (_zz_155_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_157_) == (PMPPlugin_shadow_pmpaddr_3 & _zz_157_)) && (_zz_155_ == (2'b11)))));
  assign _zz_260_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_156_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_156_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_156_ == (2'b00))));
  assign _zz_261_ = ((! PMPPlugin_ports_1_matched_1) && (((((PMPPlugin_shadow_pmpaddr_1 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_2)) && (_zz_152_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_2) && (_zz_152_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_154_) == (PMPPlugin_shadow_pmpaddr_2 & _zz_154_)) && (_zz_152_ == (2'b11)))));
  assign _zz_262_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_153_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_153_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_153_ == (2'b00))));
  assign _zz_263_ = ((! PMPPlugin_ports_1_matched_0) && (((((PMPPlugin_shadow_pmpaddr_0 <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_1)) && (_zz_149_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_1) && (_zz_149_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_151_) == (PMPPlugin_shadow_pmpaddr_1 & _zz_151_)) && (_zz_149_ == (2'b11)))));
  assign _zz_264_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_150_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_150_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_150_ == (2'b00))));
  assign _zz_265_ = ((! 1'b0) && ((((((32'b00000000000000000000000000000000) <= PMPPlugin_ports_1_physAddr) && (PMPPlugin_ports_1_physAddr < PMPPlugin_shadow_pmpaddr_0)) && (_zz_146_ == (2'b01))) || ((PMPPlugin_ports_1_physAddr == PMPPlugin_shadow_pmpaddr_0) && (_zz_146_ == (2'b10)))) || (((PMPPlugin_ports_1_physAddr & _zz_148_) == (PMPPlugin_shadow_pmpaddr_0 & _zz_148_)) && (_zz_146_ == (2'b11)))));
  assign _zz_266_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_147_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_147_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_147_ == (2'b00))));
  assign _zz_267_ = ((! PMPPlugin_ports_0_matched_6) && (((((PMPPlugin_shadow_pmpaddr_6 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_7)) && (_zz_143_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_7) && (_zz_143_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_145_) == (PMPPlugin_shadow_pmpaddr_7 & _zz_145_)) && (_zz_143_ == (2'b11)))));
  assign _zz_268_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_144_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_144_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_144_ == (2'b00))));
  assign _zz_269_ = ((! PMPPlugin_ports_0_matched_5) && (((((PMPPlugin_shadow_pmpaddr_5 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_6)) && (_zz_140_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_6) && (_zz_140_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_142_) == (PMPPlugin_shadow_pmpaddr_6 & _zz_142_)) && (_zz_140_ == (2'b11)))));
  assign _zz_270_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_141_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_141_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_141_ == (2'b00))));
  assign _zz_271_ = ((! PMPPlugin_ports_0_matched_4) && (((((PMPPlugin_shadow_pmpaddr_4 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_5)) && (_zz_137_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_5) && (_zz_137_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_139_) == (PMPPlugin_shadow_pmpaddr_5 & _zz_139_)) && (_zz_137_ == (2'b11)))));
  assign _zz_272_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_138_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_138_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_138_ == (2'b00))));
  assign _zz_273_ = ((! PMPPlugin_ports_0_matched_3) && (((((PMPPlugin_shadow_pmpaddr_3 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_4)) && (_zz_134_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_4) && (_zz_134_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_136_) == (PMPPlugin_shadow_pmpaddr_4 & _zz_136_)) && (_zz_134_ == (2'b11)))));
  assign _zz_274_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_135_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_135_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_135_ == (2'b00))));
  assign _zz_275_ = ((! PMPPlugin_ports_0_matched_2) && (((((PMPPlugin_shadow_pmpaddr_2 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_3)) && (_zz_131_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_3) && (_zz_131_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_133_) == (PMPPlugin_shadow_pmpaddr_3 & _zz_133_)) && (_zz_131_ == (2'b11)))));
  assign _zz_276_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_132_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_132_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_132_ == (2'b00))));
  assign _zz_277_ = ((! PMPPlugin_ports_0_matched_1) && (((((PMPPlugin_shadow_pmpaddr_1 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_2)) && (_zz_128_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_2) && (_zz_128_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_130_) == (PMPPlugin_shadow_pmpaddr_2 & _zz_130_)) && (_zz_128_ == (2'b11)))));
  assign _zz_278_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_129_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_129_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_129_ == (2'b00))));
  assign _zz_279_ = ((! PMPPlugin_ports_0_matched_0) && (((((PMPPlugin_shadow_pmpaddr_0 <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_1)) && (_zz_125_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_1) && (_zz_125_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_127_) == (PMPPlugin_shadow_pmpaddr_1 & _zz_127_)) && (_zz_125_ == (2'b11)))));
  assign _zz_280_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_126_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_126_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_126_ == (2'b00))));
  assign _zz_281_ = ((! 1'b0) && ((((((32'b00000000000000000000000000000000) <= PMPPlugin_ports_0_physAddr) && (PMPPlugin_ports_0_physAddr < PMPPlugin_shadow_pmpaddr_0)) && (_zz_122_ == (2'b01))) || ((PMPPlugin_ports_0_physAddr == PMPPlugin_shadow_pmpaddr_0) && (_zz_122_ == (2'b10)))) || (((PMPPlugin_ports_0_physAddr & _zz_124_) == (PMPPlugin_shadow_pmpaddr_0 & _zz_124_)) && (_zz_122_ == (2'b11)))));
  assign _zz_282_ = ((((CsrPlugin_privilege == (2'b11)) && (_zz_123_ == (2'b11))) || ((CsrPlugin_privilege == (2'b01)) && (_zz_123_ == (2'b01)))) || ((CsrPlugin_privilege == (2'b00)) && (_zz_123_ == (2'b00))));
  assign _zz_283_ = PMPPlugin_shadow_pmpcfg_6[7];
  assign _zz_284_ = PMPPlugin_shadow_pmpcfg_5[7];
  assign _zz_285_ = PMPPlugin_shadow_pmpcfg_4[7];
  assign _zz_286_ = PMPPlugin_shadow_pmpcfg_3[7];
  assign _zz_287_ = PMPPlugin_shadow_pmpcfg_2[7];
  assign _zz_288_ = PMPPlugin_shadow_pmpcfg_1[7];
  assign _zz_289_ = PMPPlugin_shadow_pmpcfg_0[7];
  assign _zz_290_ = ((_zz_229_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! IBusCachedPlugin_rsp_issueDetected_2));
  assign _zz_291_ = ((_zz_229_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! IBusCachedPlugin_rsp_issueDetected_1));
  assign _zz_292_ = ((_zz_229_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! IBusCachedPlugin_rsp_issueDetected_0));
  assign _zz_293_ = ((_zz_229_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! 1'b0));
  assign _zz_294_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_295_ = (! memory_DivPlugin_div_done);
  assign _zz_296_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_297_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_298_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_299_ = (IBusCachedPlugin_iBusRsp_output_valid && IBusCachedPlugin_iBusRsp_output_ready);
  assign _zz_300_ = ((! (((! IBusCachedPlugin_decompressor_isRvc) && (! IBusCachedPlugin_iBusRsp_output_payload_pc[1])) && (! IBusCachedPlugin_decompressor_bufferValid))) && (! ((IBusCachedPlugin_decompressor_isRvc && IBusCachedPlugin_iBusRsp_output_payload_pc[1]) && IBusCachedPlugin_decompressor_output_ready)));
  assign _zz_301_ = (! IBusCachedPlugin_iBusRsp_readyForError);
  assign _zz_302_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_303_ = (! PMPPlugin_ports_0_enabled);
  assign _zz_304_ = (CsrPlugin_privilege == (2'b11));
  assign _zz_305_ = (! PMPPlugin_ports_1_enabled);
  assign _zz_306_ = (CsrPlugin_privilege == (2'b11));
  assign _zz_307_ = execute_INSTRUCTION[13 : 12];
  assign _zz_308_ = (! memory_arbitration_isStuck);
  assign _zz_309_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_310_ = (1'b0 || (! 1'b1));
  assign _zz_311_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_312_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_313_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_314_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_315_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_316_ = (! _zz_57_);
  assign _zz_317_ = (! _zz_56_);
  assign _zz_318_ = (! _zz_55_);
  assign _zz_319_ = (! _zz_54_);
  assign _zz_320_ = (! _zz_53_);
  assign _zz_321_ = (! _zz_52_);
  assign _zz_322_ = (! _zz_51_);
  assign _zz_323_ = (! _zz_50_);
  assign _zz_324_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_325_ = ((_zz_220_ && 1'b1) && (! 1'b0));
  assign _zz_326_ = ((_zz_221_ && 1'b1) && (! 1'b0));
  assign _zz_327_ = ((_zz_222_ && 1'b1) && (! 1'b0));
  assign _zz_328_ = {_zz_77_[1 : 0],_zz_77_[15 : 13]};
  assign _zz_329_ = _zz_77_[6 : 5];
  assign _zz_330_ = _zz_77_[11 : 10];
  assign _zz_331_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_332_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_333_ = execute_INSTRUCTION[13];
  assign _zz_334_ = _zz_170_[28 : 28];
  assign _zz_335_ = _zz_170_[17 : 17];
  assign _zz_336_ = _zz_170_[10 : 10];
  assign _zz_337_ = _zz_170_[13 : 13];
  assign _zz_338_ = ($signed(_zz_340_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_339_ = _zz_338_[31 : 0];
  assign _zz_340_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_341_ = ($signed(_zz_342_) + $signed(_zz_347_));
  assign _zz_342_ = ($signed(_zz_343_) + $signed(_zz_345_));
  assign _zz_343_ = (52'b0000000000000000000000000000000000000000000000000000);
  assign _zz_344_ = {1'b0,memory_MUL_LL};
  assign _zz_345_ = {{19{_zz_344_[32]}}, _zz_344_};
  assign _zz_346_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_347_ = {{2{_zz_346_[49]}}, _zz_346_};
  assign _zz_348_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_349_ = {{2{_zz_348_[49]}}, _zz_348_};
  assign _zz_350_ = _zz_170_[7 : 7];
  assign _zz_351_ = _zz_170_[19 : 19];
  assign _zz_352_ = _zz_170_[25 : 25];
  assign _zz_353_ = _zz_170_[12 : 12];
  assign _zz_354_ = _zz_170_[18 : 18];
  assign _zz_355_ = _zz_170_[24 : 24];
  assign _zz_356_ = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_357_ = {29'd0, _zz_356_};
  assign _zz_358_ = _zz_170_[11 : 11];
  assign _zz_359_ = _zz_170_[8 : 8];
  assign _zz_360_ = _zz_170_[15 : 15];
  assign _zz_361_ = _zz_170_[16 : 16];
  assign _zz_362_ = _zz_170_[14 : 14];
  assign _zz_363_ = _zz_170_[2 : 2];
  assign _zz_364_ = _zz_170_[31 : 31];
  assign _zz_365_ = (_zz_62_ - (5'b00001));
  assign _zz_366_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_367_ = {29'd0, _zz_366_};
  assign _zz_368_ = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_369_ = {29'd0, _zz_368_};
  assign _zz_370_ = {{_zz_87_,_zz_77_[6 : 2]},(12'b000000000000)};
  assign _zz_371_ = {{{(4'b0000),_zz_77_[8 : 7]},_zz_77_[12 : 9]},(2'b00)};
  assign _zz_372_ = {{{(4'b0000),_zz_77_[8 : 7]},_zz_77_[12 : 9]},(2'b00)};
  assign _zz_373_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_374_ = {{_zz_110_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_375_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_376_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_377_ = (writeBack_MEMORY_WR ? (3'b111) : (3'b101));
  assign _zz_378_ = (writeBack_MEMORY_WR ? (3'b110) : (3'b100));
  assign _zz_379_ = (PMPPlugin_shadow_pmpaddr_0 + (32'b00000000000000000000000000000001));
  assign _zz_380_ = (PMPPlugin_shadow_pmpaddr_1 + (32'b00000000000000000000000000000001));
  assign _zz_381_ = (PMPPlugin_shadow_pmpaddr_2 + (32'b00000000000000000000000000000001));
  assign _zz_382_ = (PMPPlugin_shadow_pmpaddr_3 + (32'b00000000000000000000000000000001));
  assign _zz_383_ = (PMPPlugin_shadow_pmpaddr_4 + (32'b00000000000000000000000000000001));
  assign _zz_384_ = (PMPPlugin_shadow_pmpaddr_5 + (32'b00000000000000000000000000000001));
  assign _zz_385_ = (PMPPlugin_shadow_pmpaddr_6 + (32'b00000000000000000000000000000001));
  assign _zz_386_ = (PMPPlugin_shadow_pmpaddr_7 + (32'b00000000000000000000000000000001));
  assign _zz_387_ = (PMPPlugin_shadow_pmpaddr_0 + (32'b00000000000000000000000000000001));
  assign _zz_388_ = (PMPPlugin_shadow_pmpaddr_1 + (32'b00000000000000000000000000000001));
  assign _zz_389_ = (PMPPlugin_shadow_pmpaddr_2 + (32'b00000000000000000000000000000001));
  assign _zz_390_ = (PMPPlugin_shadow_pmpaddr_3 + (32'b00000000000000000000000000000001));
  assign _zz_391_ = (PMPPlugin_shadow_pmpaddr_4 + (32'b00000000000000000000000000000001));
  assign _zz_392_ = (PMPPlugin_shadow_pmpaddr_5 + (32'b00000000000000000000000000000001));
  assign _zz_393_ = (PMPPlugin_shadow_pmpaddr_6 + (32'b00000000000000000000000000000001));
  assign _zz_394_ = (PMPPlugin_shadow_pmpaddr_7 + (32'b00000000000000000000000000000001));
  assign _zz_395_ = execute_SRC_LESS;
  assign _zz_396_ = (execute_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_397_ = execute_INSTRUCTION[19 : 15];
  assign _zz_398_ = execute_INSTRUCTION[31 : 20];
  assign _zz_399_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_400_ = ($signed(_zz_401_) + $signed(_zz_404_));
  assign _zz_401_ = ($signed(_zz_402_) + $signed(_zz_403_));
  assign _zz_402_ = execute_SRC1;
  assign _zz_403_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_404_ = (execute_SRC_USE_SUB_LESS ? _zz_405_ : _zz_406_);
  assign _zz_405_ = (32'b00000000000000000000000000000001);
  assign _zz_406_ = (32'b00000000000000000000000000000000);
  assign _zz_407_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_408_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_409_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_410_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_411_ = memory_DivPlugin_div_counter_willIncrement;
  assign _zz_412_ = {5'd0, _zz_411_};
  assign _zz_413_ = {1'd0, memory_DivPlugin_rs2};
  assign _zz_414_ = {_zz_192_,(! _zz_194_[32])};
  assign _zz_415_ = _zz_194_[31:0];
  assign _zz_416_ = _zz_193_[31:0];
  assign _zz_417_ = _zz_418_;
  assign _zz_418_ = _zz_419_;
  assign _zz_419_ = ({1'b0,(memory_DivPlugin_div_needRevert ? (~ _zz_195_) : _zz_195_)} + _zz_421_);
  assign _zz_420_ = memory_DivPlugin_div_needRevert;
  assign _zz_421_ = {32'd0, _zz_420_};
  assign _zz_422_ = _zz_197_;
  assign _zz_423_ = {32'd0, _zz_422_};
  assign _zz_424_ = _zz_196_;
  assign _zz_425_ = {31'd0, _zz_424_};
  assign _zz_426_ = execute_INSTRUCTION[31 : 20];
  assign _zz_427_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_428_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_429_ = (execute_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_430_ = (_zz_223_ & (~ _zz_431_));
  assign _zz_431_ = (_zz_223_ - (2'b01));
  assign _zz_432_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_433_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_434_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_435_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_436_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_437_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_438_ = 1'b1;
  assign _zz_439_ = 1'b1;
  assign _zz_440_ = {_zz_65_,{_zz_67_,_zz_66_}};
  assign _zz_441_ = (32'b00000000000000000001000001111111);
  assign _zz_442_ = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_443_ = (32'b00000000000000000010000001110011);
  assign _zz_444_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001111111)) == (32'b00000000000000000100000001100011));
  assign _zz_445_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000010000000010011));
  assign _zz_446_ = {((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011)),{((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_447_) == (32'b00000000000000000000000000000011)),{(_zz_448_ == _zz_449_),{_zz_450_,{_zz_451_,_zz_452_}}}}}};
  assign _zz_447_ = (32'b00000000000000000101000001011111);
  assign _zz_448_ = (decode_INSTRUCTION & (32'b00000000000000000111000001111011));
  assign _zz_449_ = (32'b00000000000000000000000001100011);
  assign _zz_450_ = ((decode_INSTRUCTION & (32'b00000000000000000110000001111111)) == (32'b00000000000000000000000000001111));
  assign _zz_451_ = ((decode_INSTRUCTION & (32'b11111100000000000000000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_452_ = {((decode_INSTRUCTION & (32'b00000001111100000111000001111111)) == (32'b00000000000000000101000000001111)),{((decode_INSTRUCTION & (32'b10111100000000000111000001111111)) == (32'b00000000000000000101000000010011)),{((decode_INSTRUCTION & _zz_453_) == (32'b00000000000000000001000000010011)),{(_zz_454_ == _zz_455_),{_zz_456_,{_zz_457_,_zz_458_}}}}}};
  assign _zz_453_ = (32'b11111100000000000011000001111111);
  assign _zz_454_ = (decode_INSTRUCTION & (32'b10111110000000000111000001111111));
  assign _zz_455_ = (32'b00000000000000000101000000110011);
  assign _zz_456_ = ((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000000000000110011));
  assign _zz_457_ = ((decode_INSTRUCTION & (32'b11011111111111111111111111111111)) == (32'b00010000001000000000000001110011));
  assign _zz_458_ = ((decode_INSTRUCTION & (32'b11111111111111111111111111111111)) == (32'b00000000000000000000000001110011));
  assign _zz_459_ = (_zz_77_[11 : 10] == (2'b01));
  assign _zz_460_ = ((_zz_77_[11 : 10] == (2'b11)) && (_zz_77_[6 : 5] == (2'b00)));
  assign _zz_461_ = (7'b0000000);
  assign _zz_462_ = _zz_77_[6 : 2];
  assign _zz_463_ = _zz_77_[12];
  assign _zz_464_ = _zz_77_[11 : 7];
  assign _zz_465_ = decode_INSTRUCTION[31];
  assign _zz_466_ = decode_INSTRUCTION[19 : 12];
  assign _zz_467_ = decode_INSTRUCTION[20];
  assign _zz_468_ = decode_INSTRUCTION[31];
  assign _zz_469_ = decode_INSTRUCTION[7];
  assign _zz_470_ = (32'b00000000000000000101000001001000);
  assign _zz_471_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000010100)) == (32'b00000000000000000000000000000100));
  assign _zz_472_ = ((decode_INSTRUCTION & _zz_479_) == (32'b00000000000000000000000000000100));
  assign _zz_473_ = _zz_174_;
  assign _zz_474_ = {(_zz_480_ == _zz_481_),(_zz_482_ == _zz_483_)};
  assign _zz_475_ = (2'b00);
  assign _zz_476_ = ({_zz_172_,_zz_484_} != (2'b00));
  assign _zz_477_ = (_zz_485_ != (1'b0));
  assign _zz_478_ = {(_zz_486_ != _zz_487_),{_zz_488_,{_zz_489_,_zz_490_}}};
  assign _zz_479_ = (32'b00000000000000000000000001000100);
  assign _zz_480_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_481_ = (32'b00000000000000000010000000000000);
  assign _zz_482_ = (decode_INSTRUCTION & (32'b00000000000000000101000000000000));
  assign _zz_483_ = (32'b00000000000000000001000000000000);
  assign _zz_484_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000011100)) == (32'b00000000000000000000000000000100));
  assign _zz_485_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000001000000));
  assign _zz_486_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001001000)) == (32'b00000000000000000100000000001000));
  assign _zz_487_ = (1'b0);
  assign _zz_488_ = (_zz_173_ != (1'b0));
  assign _zz_489_ = ({_zz_171_,_zz_491_} != (2'b00));
  assign _zz_490_ = {({_zz_492_,_zz_493_} != (2'b00)),{(_zz_494_ != _zz_495_),{_zz_496_,{_zz_497_,_zz_498_}}}};
  assign _zz_491_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001110000)) == (32'b00000000000000000000000000100000));
  assign _zz_492_ = _zz_171_;
  assign _zz_493_ = ((decode_INSTRUCTION & _zz_499_) == (32'b00000000000000000000000000000000));
  assign _zz_494_ = {(_zz_500_ == _zz_501_),(_zz_502_ == _zz_503_)};
  assign _zz_495_ = (2'b00);
  assign _zz_496_ = ({_zz_504_,{_zz_505_,_zz_506_}} != (3'b000));
  assign _zz_497_ = (_zz_173_ != (1'b0));
  assign _zz_498_ = {(_zz_507_ != _zz_508_),{_zz_509_,{_zz_510_,_zz_511_}}};
  assign _zz_499_ = (32'b00000000000000000000000000100000);
  assign _zz_500_ = (decode_INSTRUCTION & (32'b00000000000000000111000000110100));
  assign _zz_501_ = (32'b00000000000000000101000000010000);
  assign _zz_502_ = (decode_INSTRUCTION & (32'b00000010000000000111000001100100));
  assign _zz_503_ = (32'b00000000000000000101000000100000);
  assign _zz_504_ = ((decode_INSTRUCTION & (32'b01000000000000000011000001010100)) == (32'b01000000000000000001000000010000));
  assign _zz_505_ = ((decode_INSTRUCTION & _zz_512_) == (32'b00000000000000000001000000010000));
  assign _zz_506_ = ((decode_INSTRUCTION & _zz_513_) == (32'b00000000000000000001000000010000));
  assign _zz_507_ = {_zz_171_,{_zz_514_,{_zz_515_,_zz_516_}}};
  assign _zz_508_ = (5'b00000);
  assign _zz_509_ = ((_zz_517_ == _zz_518_) != (1'b0));
  assign _zz_510_ = (_zz_519_ != (1'b0));
  assign _zz_511_ = {(_zz_520_ != _zz_521_),{_zz_522_,{_zz_523_,_zz_524_}}};
  assign _zz_512_ = (32'b00000000000000000111000000110100);
  assign _zz_513_ = (32'b00000010000000000111000001010100);
  assign _zz_514_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000110000)) == (32'b00000000000000000010000000010000));
  assign _zz_515_ = ((decode_INSTRUCTION & _zz_525_) == (32'b00000000000000000000000000010000));
  assign _zz_516_ = {(_zz_526_ == _zz_527_),(_zz_528_ == _zz_529_)};
  assign _zz_517_ = (decode_INSTRUCTION & (32'b00000000000000000000000000100000));
  assign _zz_518_ = (32'b00000000000000000000000000100000);
  assign _zz_519_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100100));
  assign _zz_520_ = {(_zz_530_ == _zz_531_),{_zz_532_,_zz_533_}};
  assign _zz_521_ = (3'b000);
  assign _zz_522_ = ({_zz_172_,{_zz_534_,_zz_535_}} != (6'b000000));
  assign _zz_523_ = (_zz_536_ != (1'b0));
  assign _zz_524_ = {(_zz_537_ != _zz_538_),{_zz_539_,{_zz_540_,_zz_541_}}};
  assign _zz_525_ = (32'b00000000000000000001000000110000);
  assign _zz_526_ = (decode_INSTRUCTION & (32'b00000010000000000010000001100000));
  assign _zz_527_ = (32'b00000000000000000010000000100000);
  assign _zz_528_ = (decode_INSTRUCTION & (32'b00000010000000000011000000100000));
  assign _zz_529_ = (32'b00000000000000000000000000100000);
  assign _zz_530_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000100));
  assign _zz_531_ = (32'b00000000000000000000000001000000);
  assign _zz_532_ = ((decode_INSTRUCTION & _zz_542_) == (32'b00000000000000000010000000010000));
  assign _zz_533_ = ((decode_INSTRUCTION & _zz_543_) == (32'b01000000000000000000000000110000));
  assign _zz_534_ = (_zz_544_ == _zz_545_);
  assign _zz_535_ = {_zz_546_,{_zz_547_,_zz_548_}};
  assign _zz_536_ = ((decode_INSTRUCTION & _zz_549_) == (32'b00000010000000000100000000100000));
  assign _zz_537_ = {_zz_550_,{_zz_551_,_zz_552_}};
  assign _zz_538_ = (5'b00000);
  assign _zz_539_ = ({_zz_553_,_zz_554_} != (2'b00));
  assign _zz_540_ = (_zz_555_ != _zz_556_);
  assign _zz_541_ = {_zz_557_,{_zz_558_,_zz_559_}};
  assign _zz_542_ = (32'b00000000000000000010000000010100);
  assign _zz_543_ = (32'b01000000000000000000000000110100);
  assign _zz_544_ = (decode_INSTRUCTION & (32'b00000000000000000001000000010000));
  assign _zz_545_ = (32'b00000000000000000001000000010000);
  assign _zz_546_ = ((decode_INSTRUCTION & _zz_560_) == (32'b00000000000000000010000000010000));
  assign _zz_547_ = (_zz_561_ == _zz_562_);
  assign _zz_548_ = {_zz_563_,_zz_564_};
  assign _zz_549_ = (32'b00000010000000000100000001100100);
  assign _zz_550_ = ((decode_INSTRUCTION & _zz_565_) == (32'b00000000000000000000000001000000));
  assign _zz_551_ = _zz_171_;
  assign _zz_552_ = {_zz_566_,{_zz_567_,_zz_568_}};
  assign _zz_553_ = (_zz_569_ == _zz_570_);
  assign _zz_554_ = (_zz_571_ == _zz_572_);
  assign _zz_555_ = (_zz_573_ == _zz_574_);
  assign _zz_556_ = (1'b0);
  assign _zz_557_ = ({_zz_575_,_zz_576_} != (3'b000));
  assign _zz_558_ = (_zz_577_ != _zz_578_);
  assign _zz_559_ = {_zz_579_,{_zz_580_,_zz_581_}};
  assign _zz_560_ = (32'b00000000000000000010000000010000);
  assign _zz_561_ = (decode_INSTRUCTION & (32'b00000000000000000000000001010000));
  assign _zz_562_ = (32'b00000000000000000000000000010000);
  assign _zz_563_ = ((decode_INSTRUCTION & _zz_582_) == (32'b00000000000000000000000000000100));
  assign _zz_564_ = ((decode_INSTRUCTION & _zz_583_) == (32'b00000000000000000000000000000000));
  assign _zz_565_ = (32'b00000000000000000000000001000000);
  assign _zz_566_ = ((decode_INSTRUCTION & _zz_584_) == (32'b00000000000000000100000000100000));
  assign _zz_567_ = (_zz_585_ == _zz_586_);
  assign _zz_568_ = (_zz_587_ == _zz_588_);
  assign _zz_569_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110100));
  assign _zz_570_ = (32'b00000000000000000000000000100000);
  assign _zz_571_ = (decode_INSTRUCTION & (32'b00000000000000000000000001100100));
  assign _zz_572_ = (32'b00000000000000000000000000100000);
  assign _zz_573_ = (decode_INSTRUCTION & (32'b00000010000000000100000001110100));
  assign _zz_574_ = (32'b00000010000000000000000000110000);
  assign _zz_575_ = (_zz_589_ == _zz_590_);
  assign _zz_576_ = {_zz_591_,_zz_592_};
  assign _zz_577_ = {_zz_593_,{_zz_594_,_zz_595_}};
  assign _zz_578_ = (4'b0000);
  assign _zz_579_ = ({_zz_596_,_zz_597_} != (2'b00));
  assign _zz_580_ = (_zz_598_ != _zz_599_);
  assign _zz_581_ = {_zz_600_,{_zz_601_,_zz_602_}};
  assign _zz_582_ = (32'b00000000000000000000000000001100);
  assign _zz_583_ = (32'b00000000000000000000000000101000);
  assign _zz_584_ = (32'b00000000000000000100000000100000);
  assign _zz_585_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110000));
  assign _zz_586_ = (32'b00000000000000000000000000010000);
  assign _zz_587_ = (decode_INSTRUCTION & (32'b00000010000000000000000000100000));
  assign _zz_588_ = (32'b00000000000000000000000000100000);
  assign _zz_589_ = (decode_INSTRUCTION & (32'b00000000000000000000000001010000));
  assign _zz_590_ = (32'b00000000000000000000000001000000);
  assign _zz_591_ = ((decode_INSTRUCTION & _zz_603_) == (32'b00000000000000000000000001000000));
  assign _zz_592_ = ((decode_INSTRUCTION & _zz_604_) == (32'b00000000000000000000000000000000));
  assign _zz_593_ = ((decode_INSTRUCTION & _zz_605_) == (32'b00000000000000000000000000000000));
  assign _zz_594_ = (_zz_606_ == _zz_607_);
  assign _zz_595_ = {_zz_608_,_zz_609_};
  assign _zz_596_ = (_zz_610_ == _zz_611_);
  assign _zz_597_ = (_zz_612_ == _zz_613_);
  assign _zz_598_ = (_zz_614_ == _zz_615_);
  assign _zz_599_ = (1'b0);
  assign _zz_600_ = (_zz_616_ != (1'b0));
  assign _zz_601_ = (_zz_617_ != _zz_618_);
  assign _zz_602_ = {_zz_619_,{_zz_620_,_zz_621_}};
  assign _zz_603_ = (32'b00000000000000000011000001000000);
  assign _zz_604_ = (32'b00000000000000000000000000111000);
  assign _zz_605_ = (32'b00000000000000000000000001000100);
  assign _zz_606_ = (decode_INSTRUCTION & (32'b00000000000000000000000000011000));
  assign _zz_607_ = (32'b00000000000000000000000000000000);
  assign _zz_608_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000000100)) == (32'b00000000000000000010000000000000));
  assign _zz_609_ = ((decode_INSTRUCTION & (32'b00000000000000000101000000000100)) == (32'b00000000000000000001000000000000));
  assign _zz_610_ = (decode_INSTRUCTION & (32'b00000000000000000001000001010000));
  assign _zz_611_ = (32'b00000000000000000001000001010000);
  assign _zz_612_ = (decode_INSTRUCTION & (32'b00000000000000000010000001010000));
  assign _zz_613_ = (32'b00000000000000000010000001010000);
  assign _zz_614_ = (decode_INSTRUCTION & (32'b00010000000000000011000001010000));
  assign _zz_615_ = (32'b00000000000000000000000001010000);
  assign _zz_616_ = ((decode_INSTRUCTION & (32'b00010000000000000011000001010000)) == (32'b00010000000000000000000001010000));
  assign _zz_617_ = ((decode_INSTRUCTION & _zz_622_) == (32'b00000000000000000001000000000000));
  assign _zz_618_ = (1'b0);
  assign _zz_619_ = ((_zz_623_ == _zz_624_) != (1'b0));
  assign _zz_620_ = (_zz_625_ != (1'b0));
  assign _zz_621_ = {(_zz_626_ != _zz_627_),(_zz_628_ != _zz_629_)};
  assign _zz_622_ = (32'b00000000000000000001000000000000);
  assign _zz_623_ = (decode_INSTRUCTION & (32'b00000000000000000011000000000000));
  assign _zz_624_ = (32'b00000000000000000010000000000000);
  assign _zz_625_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000000000000));
  assign _zz_626_ = ((decode_INSTRUCTION & (32'b00000000000000000100000000010100)) == (32'b00000000000000000100000000010000));
  assign _zz_627_ = (1'b0);
  assign _zz_628_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000010100)) == (32'b00000000000000000010000000010000));
  assign _zz_629_ = (1'b0);
  assign _zz_630_ = execute_INSTRUCTION[31];
  assign _zz_631_ = execute_INSTRUCTION[31];
  assign _zz_632_ = execute_INSTRUCTION[7];
  always @ (posedge io_axiClk) begin
    if(_zz_438_) begin
      _zz_242_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_439_) begin
      _zz_243_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_42_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  NoDebug_InstructionCache IBusCachedPlugin_cache ( 
    .io_flush(_zz_225_),
    .io_cpu_prefetch_isValid(_zz_226_),
    .io_cpu_prefetch_haltIt(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt),
    .io_cpu_prefetch_pc(IBusCachedPlugin_iBusRsp_stages_0_input_payload),
    .io_cpu_fetch_isValid(_zz_227_),
    .io_cpu_fetch_isStuck(_zz_228_),
    .io_cpu_fetch_isRemoved(IBusCachedPlugin_fetcherflushIt),
    .io_cpu_fetch_pc(IBusCachedPlugin_iBusRsp_stages_1_input_payload),
    .io_cpu_fetch_data(IBusCachedPlugin_cache_io_cpu_fetch_data),
    .io_cpu_fetch_mmuBus_cmd_isValid(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid),
    .io_cpu_fetch_mmuBus_cmd_virtualAddress(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress),
    .io_cpu_fetch_mmuBus_cmd_bypassTranslation(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation),
    .io_cpu_fetch_mmuBus_rsp_physicalAddress(IBusCachedPlugin_mmuBus_rsp_physicalAddress),
    .io_cpu_fetch_mmuBus_rsp_isIoAccess(IBusCachedPlugin_mmuBus_rsp_isIoAccess),
    .io_cpu_fetch_mmuBus_rsp_allowRead(IBusCachedPlugin_mmuBus_rsp_allowRead),
    .io_cpu_fetch_mmuBus_rsp_allowWrite(IBusCachedPlugin_mmuBus_rsp_allowWrite),
    .io_cpu_fetch_mmuBus_rsp_allowExecute(IBusCachedPlugin_mmuBus_rsp_allowExecute),
    .io_cpu_fetch_mmuBus_rsp_exception(IBusCachedPlugin_mmuBus_rsp_exception),
    .io_cpu_fetch_mmuBus_rsp_refilling(IBusCachedPlugin_mmuBus_rsp_refilling),
    .io_cpu_fetch_mmuBus_end(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end),
    .io_cpu_fetch_mmuBus_busy(IBusCachedPlugin_mmuBus_busy),
    .io_cpu_fetch_physicalAddress(IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress),
    .io_cpu_fetch_haltIt(IBusCachedPlugin_cache_io_cpu_fetch_haltIt),
    .io_cpu_decode_isValid(_zz_229_),
    .io_cpu_decode_isStuck(_zz_230_),
    .io_cpu_decode_pc(IBusCachedPlugin_iBusRsp_stages_2_input_payload),
    .io_cpu_decode_physicalAddress(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_cpu_decode_data(IBusCachedPlugin_cache_io_cpu_decode_data),
    .io_cpu_decode_cacheMiss(IBusCachedPlugin_cache_io_cpu_decode_cacheMiss),
    .io_cpu_decode_error(IBusCachedPlugin_cache_io_cpu_decode_error),
    .io_cpu_decode_mmuRefilling(IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling),
    .io_cpu_decode_mmuException(IBusCachedPlugin_cache_io_cpu_decode_mmuException),
    .io_cpu_decode_isUser(_zz_231_),
    .io_cpu_fill_valid(_zz_232_),
    .io_cpu_fill_payload(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_mem_cmd_valid(IBusCachedPlugin_cache_io_mem_cmd_valid),
    .io_mem_cmd_ready(iBus_cmd_ready),
    .io_mem_cmd_payload_address(IBusCachedPlugin_cache_io_mem_cmd_payload_address),
    .io_mem_cmd_payload_size(IBusCachedPlugin_cache_io_mem_cmd_payload_size),
    .io_mem_rsp_valid(iBus_rsp_valid),
    .io_mem_rsp_payload_data(iBus_rsp_payload_data),
    .io_mem_rsp_payload_error(iBus_rsp_payload_error),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_DataCache dataCache ( 
    .io_cpu_execute_isValid(_zz_233_),
    .io_cpu_execute_address(_zz_234_),
    .io_cpu_execute_args_wr(execute_MEMORY_WR),
    .io_cpu_execute_args_data(_zz_117_),
    .io_cpu_execute_args_size(execute_DBusCachedPlugin_size),
    .io_cpu_memory_isValid(_zz_235_),
    .io_cpu_memory_isStuck(memory_arbitration_isStuck),
    .io_cpu_memory_isRemoved(memory_arbitration_removeIt),
    .io_cpu_memory_isWrite(dataCache_io_cpu_memory_isWrite),
    .io_cpu_memory_address(_zz_236_),
    .io_cpu_memory_mmuBus_cmd_isValid(dataCache_io_cpu_memory_mmuBus_cmd_isValid),
    .io_cpu_memory_mmuBus_cmd_virtualAddress(dataCache_io_cpu_memory_mmuBus_cmd_virtualAddress),
    .io_cpu_memory_mmuBus_cmd_bypassTranslation(dataCache_io_cpu_memory_mmuBus_cmd_bypassTranslation),
    .io_cpu_memory_mmuBus_rsp_physicalAddress(DBusCachedPlugin_mmuBus_rsp_physicalAddress),
    .io_cpu_memory_mmuBus_rsp_isIoAccess(_zz_237_),
    .io_cpu_memory_mmuBus_rsp_allowRead(DBusCachedPlugin_mmuBus_rsp_allowRead),
    .io_cpu_memory_mmuBus_rsp_allowWrite(DBusCachedPlugin_mmuBus_rsp_allowWrite),
    .io_cpu_memory_mmuBus_rsp_allowExecute(DBusCachedPlugin_mmuBus_rsp_allowExecute),
    .io_cpu_memory_mmuBus_rsp_exception(DBusCachedPlugin_mmuBus_rsp_exception),
    .io_cpu_memory_mmuBus_rsp_refilling(DBusCachedPlugin_mmuBus_rsp_refilling),
    .io_cpu_memory_mmuBus_end(dataCache_io_cpu_memory_mmuBus_end),
    .io_cpu_memory_mmuBus_busy(DBusCachedPlugin_mmuBus_busy),
    .io_cpu_writeBack_isValid(_zz_238_),
    .io_cpu_writeBack_isStuck(writeBack_arbitration_isStuck),
    .io_cpu_writeBack_isUser(_zz_239_),
    .io_cpu_writeBack_haltIt(dataCache_io_cpu_writeBack_haltIt),
    .io_cpu_writeBack_isWrite(dataCache_io_cpu_writeBack_isWrite),
    .io_cpu_writeBack_data(dataCache_io_cpu_writeBack_data),
    .io_cpu_writeBack_address(_zz_240_),
    .io_cpu_writeBack_mmuException(dataCache_io_cpu_writeBack_mmuException),
    .io_cpu_writeBack_unalignedAccess(dataCache_io_cpu_writeBack_unalignedAccess),
    .io_cpu_writeBack_accessError(dataCache_io_cpu_writeBack_accessError),
    .io_cpu_redo(dataCache_io_cpu_redo),
    .io_cpu_flush_valid(_zz_241_),
    .io_cpu_flush_ready(dataCache_io_cpu_flush_ready),
    .io_mem_cmd_valid(dataCache_io_mem_cmd_valid),
    .io_mem_cmd_ready(dBus_cmd_ready),
    .io_mem_cmd_payload_wr(dataCache_io_mem_cmd_payload_wr),
    .io_mem_cmd_payload_address(dataCache_io_mem_cmd_payload_address),
    .io_mem_cmd_payload_data(dataCache_io_mem_cmd_payload_data),
    .io_mem_cmd_payload_mask(dataCache_io_mem_cmd_payload_mask),
    .io_mem_cmd_payload_length(dataCache_io_mem_cmd_payload_length),
    .io_mem_cmd_payload_last(dataCache_io_mem_cmd_payload_last),
    .io_mem_rsp_valid(dBus_rsp_valid),
    .io_mem_rsp_payload_data(dBus_rsp_payload_data),
    .io_mem_rsp_payload_error(dBus_rsp_payload_error),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  always @(*) begin
    case(_zz_440_)
      3'b000 : begin
        _zz_244_ = DBusCachedPlugin_redoBranch_payload;
      end
      3'b001 : begin
        _zz_244_ = CsrPlugin_jumpInterface_payload;
      end
      3'b010 : begin
        _zz_244_ = BranchPlugin_jumpInterface_payload;
      end
      3'b011 : begin
        _zz_244_ = IBusCachedPlugin_redoBranch_payload;
      end
      default : begin
        _zz_244_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_1_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_1__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_1__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_1__string = "ECALL";
      default : _zz_1__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_2__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_2__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_2__string = "ECALL";
      default : _zz_2__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_3__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_3__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_3__string = "ECALL";
      default : _zz_3__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_4__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_4__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_4__string = "ECALL";
      default : _zz_4__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL";
      default : decode_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_5__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_5__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_5__string = "ECALL";
      default : _zz_5__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_6__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_6__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_6__string = "ECALL";
      default : _zz_6__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_7__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_7__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_7__string = "ECALL";
      default : _zz_7__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_8__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_8__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_8__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_8__string = "SRA_1    ";
      default : _zz_8__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_9__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_9__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_9__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_9__string = "SRA_1    ";
      default : _zz_9__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_10__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_10__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_10__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_10__string = "SRA_1    ";
      default : _zz_10__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_11__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_11__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_11__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_11__string = "SRA_1    ";
      default : _zz_11__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_12__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_12__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_12__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_12__string = "SRA_1    ";
      default : _zz_12__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_13__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_13__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_13__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_13__string = "PC ";
      default : _zz_13__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_14__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_14__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_14__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_14__string = "PC ";
      default : _zz_14__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_15__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_15__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_15__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_15__string = "PC ";
      default : _zz_15__string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_16__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_16__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_16__string = "BITWISE ";
      default : _zz_16__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_17__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_17__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_17__string = "BITWISE ";
      default : _zz_17__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_18__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_18__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_18__string = "BITWISE ";
      default : _zz_18__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_19__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_19__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_19__string = "AND_1";
      default : _zz_19__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_20__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_20__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_20__string = "AND_1";
      default : _zz_20__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_21__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_21__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_21__string = "AND_1";
      default : _zz_21__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_22__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_22__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_22__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_22__string = "JALR";
      default : _zz_22__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_23__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_23__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_23__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_23__string = "JALR";
      default : _zz_23__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_24__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_24__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_24__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_24__string = "URS1        ";
      default : _zz_24__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_25_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_25__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_25__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_25__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_25__string = "URS1        ";
      default : _zz_25__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_26_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_26__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_26__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_26__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_26__string = "URS1        ";
      default : _zz_26__string = "????????????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL";
      default : memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_27__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_27__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_27__string = "ECALL";
      default : _zz_27__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL";
      default : execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_28_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_28__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_28__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_28__string = "ECALL";
      default : _zz_28__string = "?????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL";
      default : writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_29_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_29__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_29__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_29__string = "ECALL";
      default : _zz_29__string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_30__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_30__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_30__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_30__string = "JALR";
      default : _zz_30__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_33_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_33__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_33__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_33__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_33__string = "SRA_1    ";
      default : _zz_33__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_34_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_34__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_34__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_34__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_34__string = "SRA_1    ";
      default : _zz_34__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_36_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_36__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_36__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_36__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_36__string = "PC ";
      default : _zz_36__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_37_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_37__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_37__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_37__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_37__string = "URS1        ";
      default : _zz_37__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_38_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_38__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_38__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_38__string = "BITWISE ";
      default : _zz_38__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_39_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_39__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_39__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_39__string = "AND_1";
      default : _zz_39__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_43_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_43__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_43__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_43__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_43__string = "URS1        ";
      default : _zz_43__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_44_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_44__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_44__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_44__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_44__string = "JALR";
      default : _zz_44__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_45_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_45__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_45__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_45__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_45__string = "PC ";
      default : _zz_45__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_46_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_46__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_46__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_46__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_46__string = "SRA_1    ";
      default : _zz_46__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_47_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_47__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_47__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_47__string = "ECALL";
      default : _zz_47__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_48__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_48__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_48__string = "AND_1";
      default : _zz_48__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_49_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_49__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_49__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_49__string = "BITWISE ";
      default : _zz_49__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_59_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_59__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_59__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_59__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_59__string = "JALR";
      default : _zz_59__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_175_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_175__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_175__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_175__string = "BITWISE ";
      default : _zz_175__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_176_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_176__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_176__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_176__string = "AND_1";
      default : _zz_176__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_177_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_177__string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_177__string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_177__string = "ECALL";
      default : _zz_177__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_178_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_178__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_178__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_178__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_178__string = "SRA_1    ";
      default : _zz_178__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_179_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_179__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_179__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_179__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_179__string = "PC ";
      default : _zz_179__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_180_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_180__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_180__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_180__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_180__string = "JALR";
      default : _zz_180__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_181_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_181__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_181__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_181__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_181__string = "URS1        ";
      default : _zz_181__string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL";
      default : decode_to_execute_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL";
      default : execute_to_memory_ENV_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL";
      default : memory_to_writeBack_ENV_CTRL_string = "?????";
    endcase
  end
  `endif

  assign _zz_1_ = _zz_2_;
  assign _zz_3_ = _zz_4_;
  assign decode_ENV_CTRL = _zz_5_;
  assign _zz_6_ = _zz_7_;
  assign decode_SRC_LESS_UNSIGNED = _zz_334_[0];
  assign memory_MEMORY_WR = execute_to_memory_MEMORY_WR;
  assign decode_MEMORY_WR = _zz_335_[0];
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_336_[0];
  assign _zz_8_ = _zz_9_;
  assign decode_SHIFT_CTRL = _zz_10_;
  assign _zz_11_ = _zz_12_;
  assign decode_IS_DIV = _zz_337_[0];
  assign execute_SHIFT_RIGHT = _zz_339_;
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign decode_SRC2_CTRL = _zz_13_;
  assign _zz_14_ = _zz_15_;
  assign memory_PC = execute_to_memory_PC;
  assign decode_ALU_CTRL = _zz_16_;
  assign _zz_17_ = _zz_18_;
  assign memory_MUL_LOW = ($signed(_zz_341_) + $signed(_zz_349_));
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign decode_IS_CSR = _zz_350_[0];
  assign decode_IS_RS2_SIGNED = _zz_351_[0];
  assign decode_MEMORY_MANAGMENT = _zz_352_[0];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_353_[0];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_354_[0];
  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign execute_MUL_HL = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign execute_MUL_LH = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign decode_ALU_BITWISE_CTRL = _zz_19_;
  assign _zz_20_ = _zz_21_;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_234_[1 : 0];
  assign execute_REGFILE_WRITE_DATA = _zz_183_;
  assign _zz_22_ = _zz_23_;
  assign decode_SRC1_CTRL = _zz_24_;
  assign _zz_25_ = _zz_26_;
  assign execute_MUL_LL = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign decode_IS_RS1_SIGNED = _zz_355_[0];
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + _zz_357_);
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_27_;
  assign execute_ENV_CTRL = _zz_28_;
  assign writeBack_ENV_CTRL = _zz_29_;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_PC = decode_to_execute_PC;
  assign execute_BRANCH_COND_RESULT = _zz_212_;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_BRANCH_CTRL = _zz_30_;
  assign decode_RS2_USE = _zz_358_[0];
  assign decode_RS1_USE = _zz_359_[0];
  always @ (*) begin
    _zz_31_ = execute_REGFILE_WRITE_DATA;
    if(_zz_245_)begin
      _zz_31_ = execute_CsrPlugin_readData;
    end
  end

  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(_zz_201_)begin
      if((_zz_202_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_203_;
      end
    end
    if(_zz_246_)begin
      if(_zz_247_)begin
        if(_zz_205_)begin
          decode_RS2 = _zz_58_;
        end
      end
    end
    if(_zz_248_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_207_)begin
          decode_RS2 = _zz_32_;
        end
      end
    end
    if(_zz_249_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_209_)begin
          decode_RS2 = _zz_31_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_201_)begin
      if((_zz_202_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_203_;
      end
    end
    if(_zz_246_)begin
      if(_zz_247_)begin
        if(_zz_204_)begin
          decode_RS1 = _zz_58_;
        end
      end
    end
    if(_zz_248_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_206_)begin
          decode_RS1 = _zz_32_;
        end
      end
    end
    if(_zz_249_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_208_)begin
          decode_RS1 = _zz_31_;
        end
      end
    end
  end

  assign execute_IS_RS1_SIGNED = decode_to_execute_IS_RS1_SIGNED;
  assign execute_IS_DIV = decode_to_execute_IS_DIV;
  assign execute_IS_RS2_SIGNED = decode_to_execute_IS_RS2_SIGNED;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_IS_DIV = execute_to_memory_IS_DIV;
  assign writeBack_IS_MUL = memory_to_writeBack_IS_MUL;
  assign writeBack_MUL_HH = memory_to_writeBack_MUL_HH;
  assign writeBack_MUL_LOW = memory_to_writeBack_MUL_LOW;
  assign memory_MUL_HL = execute_to_memory_MUL_HL;
  assign memory_MUL_LH = execute_to_memory_MUL_LH;
  assign memory_MUL_LL = execute_to_memory_MUL_LL;
  assign execute_RS1 = decode_to_execute_RS1;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_32_ = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_32_ = _zz_191_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_32_ = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(_zz_250_)begin
      _zz_32_ = memory_DivPlugin_div_result;
    end
  end

  assign memory_SHIFT_CTRL = _zz_33_;
  assign execute_SHIFT_CTRL = _zz_34_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_35_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_36_;
  assign execute_IS_RVC = decode_to_execute_IS_RVC;
  assign execute_SRC1_CTRL = _zz_37_;
  assign decode_SRC_USE_SUB_LESS = _zz_360_[0];
  assign decode_SRC_ADD_ZERO = _zz_361_[0];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_38_;
  assign execute_SRC2 = _zz_189_;
  assign execute_SRC1 = _zz_184_;
  assign execute_ALU_BITWISE_CTRL = _zz_39_;
  assign _zz_40_ = writeBack_INSTRUCTION;
  assign _zz_41_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_42_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_42_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_decompressor_output_payload_rsp_inst);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_362_[0];
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_441_) == (32'b00000000000000000001000001110011)),{(_zz_442_ == _zz_443_),{_zz_444_,{_zz_445_,_zz_446_}}}}}}} != (20'b00000000000000000000));
  assign decode_INSTRUCTION_READY = 1'b1;
  always @ (*) begin
    PMPPlugin_ports_1_matched = PMPPlugin_ports_1_matched_6;
    if(_zz_251_)begin
      if(_zz_252_)begin
        PMPPlugin_ports_1_matched = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x = PMPPlugin_ports_1_matched_x_6;
    if(_zz_251_)begin
      if(_zz_252_)begin
        PMPPlugin_ports_1_matched_x = PMPPlugin_shadow_pmpcfg_7[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w = PMPPlugin_ports_1_matched_w_6;
    if(_zz_251_)begin
      if(_zz_252_)begin
        PMPPlugin_ports_1_matched_w = PMPPlugin_shadow_pmpcfg_7[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r = PMPPlugin_ports_1_matched_r_6;
    if(_zz_251_)begin
      if(_zz_252_)begin
        PMPPlugin_ports_1_matched_r = PMPPlugin_shadow_pmpcfg_7[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled = PMPPlugin_ports_1_enabled_6;
    if((_zz_167_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_6 = PMPPlugin_ports_1_matched_5;
    if(_zz_253_)begin
      if(_zz_254_)begin
        PMPPlugin_ports_1_matched_6 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_6 = PMPPlugin_ports_1_matched_x_5;
    if(_zz_253_)begin
      if(_zz_254_)begin
        PMPPlugin_ports_1_matched_x_6 = PMPPlugin_shadow_pmpcfg_6[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_6 = PMPPlugin_ports_1_matched_w_5;
    if(_zz_253_)begin
      if(_zz_254_)begin
        PMPPlugin_ports_1_matched_w_6 = PMPPlugin_shadow_pmpcfg_6[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_6 = PMPPlugin_ports_1_matched_r_5;
    if(_zz_253_)begin
      if(_zz_254_)begin
        PMPPlugin_ports_1_matched_r_6 = PMPPlugin_shadow_pmpcfg_6[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_6 = PMPPlugin_ports_1_enabled_5;
    if((_zz_164_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_6 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_5 = PMPPlugin_ports_1_matched_4;
    if(_zz_255_)begin
      if(_zz_256_)begin
        PMPPlugin_ports_1_matched_5 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_5 = PMPPlugin_ports_1_matched_x_4;
    if(_zz_255_)begin
      if(_zz_256_)begin
        PMPPlugin_ports_1_matched_x_5 = PMPPlugin_shadow_pmpcfg_5[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_5 = PMPPlugin_ports_1_matched_w_4;
    if(_zz_255_)begin
      if(_zz_256_)begin
        PMPPlugin_ports_1_matched_w_5 = PMPPlugin_shadow_pmpcfg_5[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_5 = PMPPlugin_ports_1_matched_r_4;
    if(_zz_255_)begin
      if(_zz_256_)begin
        PMPPlugin_ports_1_matched_r_5 = PMPPlugin_shadow_pmpcfg_5[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_5 = PMPPlugin_ports_1_enabled_4;
    if((_zz_161_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_5 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_4 = PMPPlugin_ports_1_matched_3;
    if(_zz_257_)begin
      if(_zz_258_)begin
        PMPPlugin_ports_1_matched_4 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_4 = PMPPlugin_ports_1_matched_x_3;
    if(_zz_257_)begin
      if(_zz_258_)begin
        PMPPlugin_ports_1_matched_x_4 = PMPPlugin_shadow_pmpcfg_4[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_4 = PMPPlugin_ports_1_matched_w_3;
    if(_zz_257_)begin
      if(_zz_258_)begin
        PMPPlugin_ports_1_matched_w_4 = PMPPlugin_shadow_pmpcfg_4[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_4 = PMPPlugin_ports_1_matched_r_3;
    if(_zz_257_)begin
      if(_zz_258_)begin
        PMPPlugin_ports_1_matched_r_4 = PMPPlugin_shadow_pmpcfg_4[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_4 = PMPPlugin_ports_1_enabled_3;
    if((_zz_158_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_4 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_3 = PMPPlugin_ports_1_matched_2;
    if(_zz_259_)begin
      if(_zz_260_)begin
        PMPPlugin_ports_1_matched_3 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_3 = PMPPlugin_ports_1_matched_x_2;
    if(_zz_259_)begin
      if(_zz_260_)begin
        PMPPlugin_ports_1_matched_x_3 = PMPPlugin_shadow_pmpcfg_3[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_3 = PMPPlugin_ports_1_matched_w_2;
    if(_zz_259_)begin
      if(_zz_260_)begin
        PMPPlugin_ports_1_matched_w_3 = PMPPlugin_shadow_pmpcfg_3[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_3 = PMPPlugin_ports_1_matched_r_2;
    if(_zz_259_)begin
      if(_zz_260_)begin
        PMPPlugin_ports_1_matched_r_3 = PMPPlugin_shadow_pmpcfg_3[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_3 = PMPPlugin_ports_1_enabled_2;
    if((_zz_155_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_3 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_2 = PMPPlugin_ports_1_matched_1;
    if(_zz_261_)begin
      if(_zz_262_)begin
        PMPPlugin_ports_1_matched_2 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_2 = PMPPlugin_ports_1_matched_x_1;
    if(_zz_261_)begin
      if(_zz_262_)begin
        PMPPlugin_ports_1_matched_x_2 = PMPPlugin_shadow_pmpcfg_2[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_2 = PMPPlugin_ports_1_matched_w_1;
    if(_zz_261_)begin
      if(_zz_262_)begin
        PMPPlugin_ports_1_matched_w_2 = PMPPlugin_shadow_pmpcfg_2[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_2 = PMPPlugin_ports_1_matched_r_1;
    if(_zz_261_)begin
      if(_zz_262_)begin
        PMPPlugin_ports_1_matched_r_2 = PMPPlugin_shadow_pmpcfg_2[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_2 = PMPPlugin_ports_1_enabled_1;
    if((_zz_152_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_2 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_1 = PMPPlugin_ports_1_matched_0;
    if(_zz_263_)begin
      if(_zz_264_)begin
        PMPPlugin_ports_1_matched_1 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_1 = PMPPlugin_ports_1_matched_x_0;
    if(_zz_263_)begin
      if(_zz_264_)begin
        PMPPlugin_ports_1_matched_x_1 = PMPPlugin_shadow_pmpcfg_1[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_1 = PMPPlugin_ports_1_matched_w_0;
    if(_zz_263_)begin
      if(_zz_264_)begin
        PMPPlugin_ports_1_matched_w_1 = PMPPlugin_shadow_pmpcfg_1[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_1 = PMPPlugin_ports_1_matched_r_0;
    if(_zz_263_)begin
      if(_zz_264_)begin
        PMPPlugin_ports_1_matched_r_1 = PMPPlugin_shadow_pmpcfg_1[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_1 = PMPPlugin_ports_1_enabled_0;
    if((_zz_149_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_1 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_0 = 1'b0;
    if(_zz_265_)begin
      if(_zz_266_)begin
        PMPPlugin_ports_1_matched_0 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_x_0 = 1'b0;
    if(_zz_265_)begin
      if(_zz_266_)begin
        PMPPlugin_ports_1_matched_x_0 = PMPPlugin_shadow_pmpcfg_0[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_w_0 = 1'b0;
    if(_zz_265_)begin
      if(_zz_266_)begin
        PMPPlugin_ports_1_matched_w_0 = PMPPlugin_shadow_pmpcfg_0[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_matched_r_0 = 1'b0;
    if(_zz_265_)begin
      if(_zz_266_)begin
        PMPPlugin_ports_1_matched_r_0 = PMPPlugin_shadow_pmpcfg_0[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_1_enabled_0 = 1'b0;
    if((_zz_146_ != (2'b00)))begin
      PMPPlugin_ports_1_enabled_0 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched = PMPPlugin_ports_0_matched_6;
    if(_zz_267_)begin
      if(_zz_268_)begin
        PMPPlugin_ports_0_matched = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x = PMPPlugin_ports_0_matched_x_6;
    if(_zz_267_)begin
      if(_zz_268_)begin
        PMPPlugin_ports_0_matched_x = PMPPlugin_shadow_pmpcfg_7[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w = PMPPlugin_ports_0_matched_w_6;
    if(_zz_267_)begin
      if(_zz_268_)begin
        PMPPlugin_ports_0_matched_w = PMPPlugin_shadow_pmpcfg_7[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r = PMPPlugin_ports_0_matched_r_6;
    if(_zz_267_)begin
      if(_zz_268_)begin
        PMPPlugin_ports_0_matched_r = PMPPlugin_shadow_pmpcfg_7[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled = PMPPlugin_ports_0_enabled_6;
    if((_zz_143_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_6 = PMPPlugin_ports_0_matched_5;
    if(_zz_269_)begin
      if(_zz_270_)begin
        PMPPlugin_ports_0_matched_6 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_6 = PMPPlugin_ports_0_matched_x_5;
    if(_zz_269_)begin
      if(_zz_270_)begin
        PMPPlugin_ports_0_matched_x_6 = PMPPlugin_shadow_pmpcfg_6[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_6 = PMPPlugin_ports_0_matched_w_5;
    if(_zz_269_)begin
      if(_zz_270_)begin
        PMPPlugin_ports_0_matched_w_6 = PMPPlugin_shadow_pmpcfg_6[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_6 = PMPPlugin_ports_0_matched_r_5;
    if(_zz_269_)begin
      if(_zz_270_)begin
        PMPPlugin_ports_0_matched_r_6 = PMPPlugin_shadow_pmpcfg_6[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_6 = PMPPlugin_ports_0_enabled_5;
    if((_zz_140_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_6 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_5 = PMPPlugin_ports_0_matched_4;
    if(_zz_271_)begin
      if(_zz_272_)begin
        PMPPlugin_ports_0_matched_5 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_5 = PMPPlugin_ports_0_matched_x_4;
    if(_zz_271_)begin
      if(_zz_272_)begin
        PMPPlugin_ports_0_matched_x_5 = PMPPlugin_shadow_pmpcfg_5[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_5 = PMPPlugin_ports_0_matched_w_4;
    if(_zz_271_)begin
      if(_zz_272_)begin
        PMPPlugin_ports_0_matched_w_5 = PMPPlugin_shadow_pmpcfg_5[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_5 = PMPPlugin_ports_0_matched_r_4;
    if(_zz_271_)begin
      if(_zz_272_)begin
        PMPPlugin_ports_0_matched_r_5 = PMPPlugin_shadow_pmpcfg_5[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_5 = PMPPlugin_ports_0_enabled_4;
    if((_zz_137_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_5 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_4 = PMPPlugin_ports_0_matched_3;
    if(_zz_273_)begin
      if(_zz_274_)begin
        PMPPlugin_ports_0_matched_4 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_4 = PMPPlugin_ports_0_matched_x_3;
    if(_zz_273_)begin
      if(_zz_274_)begin
        PMPPlugin_ports_0_matched_x_4 = PMPPlugin_shadow_pmpcfg_4[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_4 = PMPPlugin_ports_0_matched_w_3;
    if(_zz_273_)begin
      if(_zz_274_)begin
        PMPPlugin_ports_0_matched_w_4 = PMPPlugin_shadow_pmpcfg_4[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_4 = PMPPlugin_ports_0_matched_r_3;
    if(_zz_273_)begin
      if(_zz_274_)begin
        PMPPlugin_ports_0_matched_r_4 = PMPPlugin_shadow_pmpcfg_4[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_4 = PMPPlugin_ports_0_enabled_3;
    if((_zz_134_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_4 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_3 = PMPPlugin_ports_0_matched_2;
    if(_zz_275_)begin
      if(_zz_276_)begin
        PMPPlugin_ports_0_matched_3 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_3 = PMPPlugin_ports_0_matched_x_2;
    if(_zz_275_)begin
      if(_zz_276_)begin
        PMPPlugin_ports_0_matched_x_3 = PMPPlugin_shadow_pmpcfg_3[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_3 = PMPPlugin_ports_0_matched_w_2;
    if(_zz_275_)begin
      if(_zz_276_)begin
        PMPPlugin_ports_0_matched_w_3 = PMPPlugin_shadow_pmpcfg_3[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_3 = PMPPlugin_ports_0_matched_r_2;
    if(_zz_275_)begin
      if(_zz_276_)begin
        PMPPlugin_ports_0_matched_r_3 = PMPPlugin_shadow_pmpcfg_3[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_3 = PMPPlugin_ports_0_enabled_2;
    if((_zz_131_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_3 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_2 = PMPPlugin_ports_0_matched_1;
    if(_zz_277_)begin
      if(_zz_278_)begin
        PMPPlugin_ports_0_matched_2 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_2 = PMPPlugin_ports_0_matched_x_1;
    if(_zz_277_)begin
      if(_zz_278_)begin
        PMPPlugin_ports_0_matched_x_2 = PMPPlugin_shadow_pmpcfg_2[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_2 = PMPPlugin_ports_0_matched_w_1;
    if(_zz_277_)begin
      if(_zz_278_)begin
        PMPPlugin_ports_0_matched_w_2 = PMPPlugin_shadow_pmpcfg_2[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_2 = PMPPlugin_ports_0_matched_r_1;
    if(_zz_277_)begin
      if(_zz_278_)begin
        PMPPlugin_ports_0_matched_r_2 = PMPPlugin_shadow_pmpcfg_2[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_2 = PMPPlugin_ports_0_enabled_1;
    if((_zz_128_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_2 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_1 = PMPPlugin_ports_0_matched_0;
    if(_zz_279_)begin
      if(_zz_280_)begin
        PMPPlugin_ports_0_matched_1 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_1 = PMPPlugin_ports_0_matched_x_0;
    if(_zz_279_)begin
      if(_zz_280_)begin
        PMPPlugin_ports_0_matched_x_1 = PMPPlugin_shadow_pmpcfg_1[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_1 = PMPPlugin_ports_0_matched_w_0;
    if(_zz_279_)begin
      if(_zz_280_)begin
        PMPPlugin_ports_0_matched_w_1 = PMPPlugin_shadow_pmpcfg_1[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_1 = PMPPlugin_ports_0_matched_r_0;
    if(_zz_279_)begin
      if(_zz_280_)begin
        PMPPlugin_ports_0_matched_r_1 = PMPPlugin_shadow_pmpcfg_1[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_1 = PMPPlugin_ports_0_enabled_0;
    if((_zz_125_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_1 = 1'b1;
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_0 = 1'b0;
    if(_zz_281_)begin
      if(_zz_282_)begin
        PMPPlugin_ports_0_matched_0 = 1'b1;
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_x_0 = 1'b0;
    if(_zz_281_)begin
      if(_zz_282_)begin
        PMPPlugin_ports_0_matched_x_0 = PMPPlugin_shadow_pmpcfg_0[2];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_w_0 = 1'b0;
    if(_zz_281_)begin
      if(_zz_282_)begin
        PMPPlugin_ports_0_matched_w_0 = PMPPlugin_shadow_pmpcfg_0[1];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_matched_r_0 = 1'b0;
    if(_zz_281_)begin
      if(_zz_282_)begin
        PMPPlugin_ports_0_matched_r_0 = PMPPlugin_shadow_pmpcfg_0[0];
      end
    end
  end

  always @ (*) begin
    PMPPlugin_ports_0_enabled_0 = 1'b0;
    if((_zz_122_ != (2'b00)))begin
      PMPPlugin_ports_0_enabled_0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_50_ = _zz_50__0;
    if(! PMPPlugin_shadow_pmpcfg_7[7]) begin
      _zz_50_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_50__0 = 1'b0;
    if(PMPPlugin_shadow_pmpcfg_7[7])begin
      _zz_50__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_51_ = _zz_51__0;
    if(! _zz_283_) begin
      if((PMPPlugin_shadow_pmpcfg_7[7] && (PMPPlugin_shadow_pmpcfg_7[4 : 3] == (2'b01))))begin
        _zz_51_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_51__0 = 1'b0;
    if(_zz_283_)begin
      _zz_51__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_52_ = _zz_52__0;
    if(! _zz_284_) begin
      if((PMPPlugin_shadow_pmpcfg_6[7] && (PMPPlugin_shadow_pmpcfg_6[4 : 3] == (2'b01))))begin
        _zz_52_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_52__0 = 1'b0;
    if(_zz_284_)begin
      _zz_52__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_53_ = _zz_53__0;
    if(! _zz_285_) begin
      if((PMPPlugin_shadow_pmpcfg_5[7] && (PMPPlugin_shadow_pmpcfg_5[4 : 3] == (2'b01))))begin
        _zz_53_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_53__0 = 1'b0;
    if(_zz_285_)begin
      _zz_53__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_54_ = _zz_54__0;
    if(! _zz_286_) begin
      if((PMPPlugin_shadow_pmpcfg_4[7] && (PMPPlugin_shadow_pmpcfg_4[4 : 3] == (2'b01))))begin
        _zz_54_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_54__0 = 1'b0;
    if(_zz_286_)begin
      _zz_54__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_55_ = _zz_55__0;
    if(! _zz_287_) begin
      if((PMPPlugin_shadow_pmpcfg_3[7] && (PMPPlugin_shadow_pmpcfg_3[4 : 3] == (2'b01))))begin
        _zz_55_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_55__0 = 1'b0;
    if(_zz_287_)begin
      _zz_55__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_56_ = _zz_56__0;
    if(! _zz_288_) begin
      if((PMPPlugin_shadow_pmpcfg_2[7] && (PMPPlugin_shadow_pmpcfg_2[4 : 3] == (2'b01))))begin
        _zz_56_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_56__0 = 1'b0;
    if(_zz_288_)begin
      _zz_56__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_57_ = _zz_57__0;
    if(! _zz_289_) begin
      if((PMPPlugin_shadow_pmpcfg_1[7] && (PMPPlugin_shadow_pmpcfg_1[4 : 3] == (2'b01))))begin
        _zz_57_ = 1'b1;
      end
    end
  end

  always @ (*) begin
    _zz_57__0 = 1'b0;
    if(_zz_289_)begin
      _zz_57__0 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_58_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_58_ = writeBack_DBusCachedPlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_332_)
        2'b00 : begin
          _zz_58_ = _zz_409_;
        end
        default : begin
          _zz_58_ = _zz_410_;
        end
      endcase
    end
  end

  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_WR = memory_to_writeBack_MEMORY_WR;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MEMORY_MANAGMENT = decode_to_execute_MEMORY_MANAGMENT;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_MEMORY_WR = decode_to_execute_MEMORY_WR;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign decode_MEMORY_ENABLE = _zz_363_[0];
  assign decode_FLUSH_ALL = _zz_364_[0];
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected = IBusCachedPlugin_rsp_issueDetected_2;
    if(_zz_290_)begin
      IBusCachedPlugin_rsp_issueDetected = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_2 = IBusCachedPlugin_rsp_issueDetected_1;
    if(_zz_291_)begin
      IBusCachedPlugin_rsp_issueDetected_2 = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_1 = IBusCachedPlugin_rsp_issueDetected_0;
    if(_zz_292_)begin
      IBusCachedPlugin_rsp_issueDetected_1 = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_0 = 1'b0;
    if(_zz_293_)begin
      IBusCachedPlugin_rsp_issueDetected_0 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_59_;
  always @ (*) begin
    _zz_60_ = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_60_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_61_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_61_ = IBusCachedPlugin_predictionJumpInterface_payload;
    end
    if(IBusCachedPlugin_redoBranch_valid)begin
      _zz_61_ = IBusCachedPlugin_redoBranch_payload;
    end
  end

  assign decode_PC = IBusCachedPlugin_decodePc_pcReg;
  assign decode_INSTRUCTION = IBusCachedPlugin_injector_decodeInput_payload_rsp_inst;
  assign decode_IS_RVC = IBusCachedPlugin_injector_decodeInput_payload_isRvc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && (_zz_199_ || _zz_200_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts))begin
      decode_arbitration_haltByOther = decode_arbitration_isValid;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(_zz_294_)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_redoBranch_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(_zz_294_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((_zz_241_ && (! dataCache_io_cpu_flush_ready)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(((dataCache_io_cpu_redo && execute_arbitration_isValid) && execute_MEMORY_ENABLE))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_245_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(CsrPlugin_selfException_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if(_zz_250_)begin
      if(_zz_295_)begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if(dataCache_io_cpu_writeBack_haltIt)begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_296_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_297_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusCachedPlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_296_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_297_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetcherflushIt = 1'b0;
    if(({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
    if((IBusCachedPlugin_predictionJumpInterface_valid && decode_arbitration_isFiring))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_stages_2_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
    if((IBusCachedPlugin_decompressor_bufferValid && (IBusCachedPlugin_decompressor_bufferData[1 : 0] != (2'b11))))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
    if(IBusCachedPlugin_injector_decodeInput_valid)begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  assign CsrPlugin_thirdPartyWake = 1'b0;
  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_296_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_297_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_296_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_297_)begin
      case(_zz_298_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  assign CsrPlugin_forceMachineWire = 1'b0;
  assign CsrPlugin_allowInterrupts = 1'b1;
  assign CsrPlugin_allowException = 1'b1;
  assign IBusCachedPlugin_jump_pcLoad_valid = ({CsrPlugin_jumpInterface_valid,{BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,{IBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}}} != (5'b00000));
  assign _zz_62_ = {IBusCachedPlugin_predictionJumpInterface_valid,{IBusCachedPlugin_redoBranch_valid,{BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}}}};
  assign _zz_63_ = (_zz_62_ & (~ _zz_365_));
  assign _zz_64_ = _zz_63_[3];
  assign _zz_65_ = _zz_63_[4];
  assign _zz_66_ = (_zz_63_[1] || _zz_64_);
  assign _zz_67_ = (_zz_63_[2] || _zz_64_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_244_;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_corrected = 1'b0;
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_corrected = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_367_);
    if(IBusCachedPlugin_fetchPc_inc)begin
      IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  assign IBusCachedPlugin_decodePc_pcPlus = (IBusCachedPlugin_decodePc_pcReg + _zz_369_);
  assign IBusCachedPlugin_decodePc_injectedDecode = 1'b0;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_inputSample = 1'b1;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_68_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_68_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_68_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_69_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_69_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_69_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_70_ = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_70_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_70_);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_71_;
  assign _zz_71_ = ((1'b0 && (! _zz_72_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_72_ = _zz_73_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_72_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_74_)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_74_ = _zz_75_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_74_;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_76_;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((IBusCachedPlugin_decompressor_bufferValid && IBusCachedPlugin_decompressor_isRvc))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
    if(IBusCachedPlugin_injector_decodeInput_valid)begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_decompressor_raw = (IBusCachedPlugin_decompressor_bufferValid ? {IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[15 : 0],IBusCachedPlugin_decompressor_bufferData} : {IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[31 : 16],(IBusCachedPlugin_iBusRsp_output_payload_pc[1] ? IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[31 : 16] : IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[15 : 0])});
  assign IBusCachedPlugin_decompressor_isRvc = (IBusCachedPlugin_decompressor_raw[1 : 0] != (2'b11));
  assign _zz_77_ = IBusCachedPlugin_decompressor_raw[15 : 0];
  always @ (*) begin
    IBusCachedPlugin_decompressor_decompressed = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(_zz_328_)
      5'b00000 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{{{{{(2'b00),_zz_77_[10 : 7]},_zz_77_[12 : 11]},_zz_77_[5]},_zz_77_[6]},(2'b00)},(5'b00010)},(3'b000)},_zz_79_},(7'b0010011)};
      end
      5'b00010 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{_zz_80_,_zz_78_},(3'b010)},_zz_79_},(7'b0000011)};
      end
      5'b00110 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{_zz_80_[11 : 5],_zz_79_},_zz_78_},(3'b010)},_zz_80_[4 : 0]},(7'b0100011)};
      end
      5'b01000 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{_zz_82_,_zz_77_[11 : 7]},(3'b000)},_zz_77_[11 : 7]},(7'b0010011)};
      end
      5'b01001 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{_zz_85_[20],_zz_85_[10 : 1]},_zz_85_[11]},_zz_85_[19 : 12]},_zz_97_},(7'b1101111)};
      end
      5'b01010 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{_zz_82_,(5'b00000)},(3'b000)},_zz_77_[11 : 7]},(7'b0010011)};
      end
      5'b01011 : begin
        IBusCachedPlugin_decompressor_decompressed = ((_zz_77_[11 : 7] == (5'b00010)) ? {{{{{{{{{_zz_89_,_zz_77_[4 : 3]},_zz_77_[5]},_zz_77_[2]},_zz_77_[6]},(4'b0000)},_zz_77_[11 : 7]},(3'b000)},_zz_77_[11 : 7]},(7'b0010011)} : {{_zz_370_[31 : 12],_zz_77_[11 : 7]},(7'b0110111)});
      end
      5'b01100 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{((_zz_77_[11 : 10] == (2'b10)) ? _zz_103_ : {{(1'b0),(_zz_459_ || _zz_460_)},(5'b00000)}),(((! _zz_77_[11]) || _zz_99_) ? _zz_77_[6 : 2] : _zz_79_)},_zz_78_},_zz_101_},_zz_78_},(_zz_99_ ? (7'b0010011) : (7'b0110011))};
      end
      5'b01101 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{_zz_92_[20],_zz_92_[10 : 1]},_zz_92_[11]},_zz_92_[19 : 12]},_zz_96_},(7'b1101111)};
      end
      5'b01110 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{{{_zz_95_[12],_zz_95_[10 : 5]},_zz_96_},_zz_78_},(3'b000)},_zz_95_[4 : 1]},_zz_95_[11]},(7'b1100011)};
      end
      5'b01111 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{{{_zz_95_[12],_zz_95_[10 : 5]},_zz_96_},_zz_78_},(3'b001)},_zz_95_[4 : 1]},_zz_95_[11]},(7'b1100011)};
      end
      5'b10000 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{(7'b0000000),_zz_77_[6 : 2]},_zz_77_[11 : 7]},(3'b001)},_zz_77_[11 : 7]},(7'b0010011)};
      end
      5'b10010 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{{{{(4'b0000),_zz_77_[3 : 2]},_zz_77_[12]},_zz_77_[6 : 4]},(2'b00)},_zz_98_},(3'b010)},_zz_77_[11 : 7]},(7'b0000011)};
      end
      5'b10100 : begin
        IBusCachedPlugin_decompressor_decompressed = ((_zz_77_[12 : 2] == (11'b10000000000)) ? (32'b00000000000100000000000001110011) : ((_zz_77_[6 : 2] == (5'b00000)) ? {{{{(12'b000000000000),_zz_77_[11 : 7]},(3'b000)},(_zz_77_[12] ? _zz_97_ : _zz_96_)},(7'b1100111)} : {{{{{_zz_461_,_zz_462_},(_zz_463_ ? _zz_464_ : _zz_96_)},(3'b000)},_zz_77_[11 : 7]},(7'b0110011)}));
      end
      5'b10110 : begin
        IBusCachedPlugin_decompressor_decompressed = {{{{{_zz_371_[11 : 5],_zz_77_[6 : 2]},_zz_98_},(3'b010)},_zz_372_[4 : 0]},(7'b0100011)};
      end
      default : begin
      end
    endcase
  end

  assign _zz_78_ = {(2'b01),_zz_77_[9 : 7]};
  assign _zz_79_ = {(2'b01),_zz_77_[4 : 2]};
  assign _zz_80_ = {{{{(5'b00000),_zz_77_[5]},_zz_77_[12 : 10]},_zz_77_[6]},(2'b00)};
  assign _zz_81_ = _zz_77_[12];
  always @ (*) begin
    _zz_82_[11] = _zz_81_;
    _zz_82_[10] = _zz_81_;
    _zz_82_[9] = _zz_81_;
    _zz_82_[8] = _zz_81_;
    _zz_82_[7] = _zz_81_;
    _zz_82_[6] = _zz_81_;
    _zz_82_[5] = _zz_81_;
    _zz_82_[4 : 0] = _zz_77_[6 : 2];
  end

  assign _zz_83_ = _zz_77_[12];
  always @ (*) begin
    _zz_84_[9] = _zz_83_;
    _zz_84_[8] = _zz_83_;
    _zz_84_[7] = _zz_83_;
    _zz_84_[6] = _zz_83_;
    _zz_84_[5] = _zz_83_;
    _zz_84_[4] = _zz_83_;
    _zz_84_[3] = _zz_83_;
    _zz_84_[2] = _zz_83_;
    _zz_84_[1] = _zz_83_;
    _zz_84_[0] = _zz_83_;
  end

  assign _zz_85_ = {{{{{{{{_zz_84_,_zz_77_[8]},_zz_77_[10 : 9]},_zz_77_[6]},_zz_77_[7]},_zz_77_[2]},_zz_77_[11]},_zz_77_[5 : 3]},(1'b0)};
  assign _zz_86_ = _zz_77_[12];
  always @ (*) begin
    _zz_87_[14] = _zz_86_;
    _zz_87_[13] = _zz_86_;
    _zz_87_[12] = _zz_86_;
    _zz_87_[11] = _zz_86_;
    _zz_87_[10] = _zz_86_;
    _zz_87_[9] = _zz_86_;
    _zz_87_[8] = _zz_86_;
    _zz_87_[7] = _zz_86_;
    _zz_87_[6] = _zz_86_;
    _zz_87_[5] = _zz_86_;
    _zz_87_[4] = _zz_86_;
    _zz_87_[3] = _zz_86_;
    _zz_87_[2] = _zz_86_;
    _zz_87_[1] = _zz_86_;
    _zz_87_[0] = _zz_86_;
  end

  assign _zz_88_ = _zz_77_[12];
  always @ (*) begin
    _zz_89_[2] = _zz_88_;
    _zz_89_[1] = _zz_88_;
    _zz_89_[0] = _zz_88_;
  end

  assign _zz_90_ = _zz_77_[12];
  always @ (*) begin
    _zz_91_[9] = _zz_90_;
    _zz_91_[8] = _zz_90_;
    _zz_91_[7] = _zz_90_;
    _zz_91_[6] = _zz_90_;
    _zz_91_[5] = _zz_90_;
    _zz_91_[4] = _zz_90_;
    _zz_91_[3] = _zz_90_;
    _zz_91_[2] = _zz_90_;
    _zz_91_[1] = _zz_90_;
    _zz_91_[0] = _zz_90_;
  end

  assign _zz_92_ = {{{{{{{{_zz_91_,_zz_77_[8]},_zz_77_[10 : 9]},_zz_77_[6]},_zz_77_[7]},_zz_77_[2]},_zz_77_[11]},_zz_77_[5 : 3]},(1'b0)};
  assign _zz_93_ = _zz_77_[12];
  always @ (*) begin
    _zz_94_[4] = _zz_93_;
    _zz_94_[3] = _zz_93_;
    _zz_94_[2] = _zz_93_;
    _zz_94_[1] = _zz_93_;
    _zz_94_[0] = _zz_93_;
  end

  assign _zz_95_ = {{{{{_zz_94_,_zz_77_[6 : 5]},_zz_77_[2]},_zz_77_[11 : 10]},_zz_77_[4 : 3]},(1'b0)};
  assign _zz_96_ = (5'b00000);
  assign _zz_97_ = (5'b00001);
  assign _zz_98_ = (5'b00010);
  assign _zz_99_ = (_zz_77_[11 : 10] != (2'b11));
  always @ (*) begin
    case(_zz_329_)
      2'b00 : begin
        _zz_100_ = (3'b000);
      end
      2'b01 : begin
        _zz_100_ = (3'b100);
      end
      2'b10 : begin
        _zz_100_ = (3'b110);
      end
      default : begin
        _zz_100_ = (3'b111);
      end
    endcase
  end

  always @ (*) begin
    case(_zz_330_)
      2'b00 : begin
        _zz_101_ = (3'b101);
      end
      2'b01 : begin
        _zz_101_ = (3'b101);
      end
      2'b10 : begin
        _zz_101_ = (3'b111);
      end
      default : begin
        _zz_101_ = _zz_100_;
      end
    endcase
  end

  assign _zz_102_ = _zz_77_[12];
  always @ (*) begin
    _zz_103_[6] = _zz_102_;
    _zz_103_[5] = _zz_102_;
    _zz_103_[4] = _zz_102_;
    _zz_103_[3] = _zz_102_;
    _zz_103_[2] = _zz_102_;
    _zz_103_[1] = _zz_102_;
    _zz_103_[0] = _zz_102_;
  end

  assign IBusCachedPlugin_decompressor_output_valid = (IBusCachedPlugin_decompressor_isRvc ? (IBusCachedPlugin_decompressor_bufferValid || IBusCachedPlugin_iBusRsp_output_valid) : (IBusCachedPlugin_iBusRsp_output_valid && (IBusCachedPlugin_decompressor_bufferValid || (! IBusCachedPlugin_iBusRsp_output_payload_pc[1]))));
  assign IBusCachedPlugin_decompressor_output_payload_pc = IBusCachedPlugin_iBusRsp_output_payload_pc;
  assign IBusCachedPlugin_decompressor_output_payload_isRvc = IBusCachedPlugin_decompressor_isRvc;
  assign IBusCachedPlugin_decompressor_output_payload_rsp_inst = (IBusCachedPlugin_decompressor_isRvc ? IBusCachedPlugin_decompressor_decompressed : IBusCachedPlugin_decompressor_raw);
  assign IBusCachedPlugin_iBusRsp_output_ready = ((! IBusCachedPlugin_decompressor_output_valid) || (! (((! IBusCachedPlugin_decompressor_output_ready) || ((IBusCachedPlugin_decompressor_isRvc && (! IBusCachedPlugin_iBusRsp_output_payload_pc[1])) && (IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11)))) || (((! IBusCachedPlugin_decompressor_isRvc) && IBusCachedPlugin_decompressor_bufferValid) && (IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11))))));
  always @ (*) begin
    IBusCachedPlugin_decompressor_bufferFill = 1'b0;
    if(_zz_299_)begin
      if(_zz_300_)begin
        IBusCachedPlugin_decompressor_bufferFill = 1'b1;
      end
    end
  end

  assign IBusCachedPlugin_decompressor_output_ready = ((1'b0 && (! IBusCachedPlugin_injector_decodeInput_valid)) || IBusCachedPlugin_injector_decodeInput_ready);
  assign IBusCachedPlugin_injector_decodeInput_valid = _zz_104_;
  assign IBusCachedPlugin_injector_decodeInput_payload_pc = _zz_105_;
  assign IBusCachedPlugin_injector_decodeInput_payload_rsp_error = _zz_106_;
  assign IBusCachedPlugin_injector_decodeInput_payload_rsp_inst = _zz_107_;
  assign IBusCachedPlugin_injector_decodeInput_payload_isRvc = _zz_108_;
  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_0;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = (IBusCachedPlugin_injector_decodeInput_valid && (! IBusCachedPlugin_injector_decodeRemoved));
  assign _zz_109_ = _zz_373_[11];
  always @ (*) begin
    _zz_110_[18] = _zz_109_;
    _zz_110_[17] = _zz_109_;
    _zz_110_[16] = _zz_109_;
    _zz_110_[15] = _zz_109_;
    _zz_110_[14] = _zz_109_;
    _zz_110_[13] = _zz_109_;
    _zz_110_[12] = _zz_109_;
    _zz_110_[11] = _zz_109_;
    _zz_110_[10] = _zz_109_;
    _zz_110_[9] = _zz_109_;
    _zz_110_[8] = _zz_109_;
    _zz_110_[7] = _zz_109_;
    _zz_110_[6] = _zz_109_;
    _zz_110_[5] = _zz_109_;
    _zz_110_[4] = _zz_109_;
    _zz_110_[3] = _zz_109_;
    _zz_110_[2] = _zz_109_;
    _zz_110_[1] = _zz_109_;
    _zz_110_[0] = _zz_109_;
  end

  assign IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_374_[31]));
  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_111_ = _zz_375_[19];
  always @ (*) begin
    _zz_112_[10] = _zz_111_;
    _zz_112_[9] = _zz_111_;
    _zz_112_[8] = _zz_111_;
    _zz_112_[7] = _zz_111_;
    _zz_112_[6] = _zz_111_;
    _zz_112_[5] = _zz_111_;
    _zz_112_[4] = _zz_111_;
    _zz_112_[3] = _zz_111_;
    _zz_112_[2] = _zz_111_;
    _zz_112_[1] = _zz_111_;
    _zz_112_[0] = _zz_111_;
  end

  assign _zz_113_ = _zz_376_[11];
  always @ (*) begin
    _zz_114_[18] = _zz_113_;
    _zz_114_[17] = _zz_113_;
    _zz_114_[16] = _zz_113_;
    _zz_114_[15] = _zz_113_;
    _zz_114_[14] = _zz_113_;
    _zz_114_[13] = _zz_113_;
    _zz_114_[12] = _zz_113_;
    _zz_114_[11] = _zz_113_;
    _zz_114_[10] = _zz_113_;
    _zz_114_[9] = _zz_113_;
    _zz_114_[8] = _zz_113_;
    _zz_114_[7] = _zz_113_;
    _zz_114_[6] = _zz_113_;
    _zz_114_[5] = _zz_113_;
    _zz_114_[4] = _zz_113_;
    _zz_114_[3] = _zz_113_;
    _zz_114_[2] = _zz_113_;
    _zz_114_[1] = _zz_113_;
    _zz_114_[0] = _zz_113_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_112_,{{{_zz_465_,_zz_466_},_zz_467_},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_114_,{{{_zz_468_,_zz_469_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_226_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_227_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_228_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_229_ = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_230_ = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_231_ = (CsrPlugin_privilege == (2'b00));
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_293_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_291_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_301_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b0;
    end
  end

  always @ (*) begin
    _zz_232_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_291_)begin
      _zz_232_ = 1'b1;
    end
    if(_zz_301_)begin
      _zz_232_ = 1'b0;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_292_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_290_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_292_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_290_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b0001);
    end
  end

  assign IBusCachedPlugin_decodeExceptionPort_payload_badAddr = {IBusCachedPlugin_iBusRsp_stages_2_input_payload[31 : 2],(2'b00)};
  assign IBusCachedPlugin_redoBranch_valid = IBusCachedPlugin_rsp_redoFetch;
  assign IBusCachedPlugin_redoBranch_payload = decode_PC;
  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign IBusCachedPlugin_mmuBus_cmd_isValid = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_virtualAddress = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_cmd_bypassTranslation = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  assign IBusCachedPlugin_mmuBus_end = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  assign _zz_225_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dBus_cmd_valid = dataCache_io_mem_cmd_valid;
  assign dBus_cmd_payload_wr = dataCache_io_mem_cmd_payload_wr;
  assign dBus_cmd_payload_address = dataCache_io_mem_cmd_payload_address;
  assign dBus_cmd_payload_data = dataCache_io_mem_cmd_payload_data;
  assign dBus_cmd_payload_mask = dataCache_io_mem_cmd_payload_mask;
  assign dBus_cmd_payload_length = dataCache_io_mem_cmd_payload_length;
  assign dBus_cmd_payload_last = dataCache_io_mem_cmd_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign _zz_233_ = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_234_ = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_117_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_117_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_117_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_241_ = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_235_ = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_236_ = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_isValid = dataCache_io_cpu_memory_mmuBus_cmd_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_virtualAddress = dataCache_io_cpu_memory_mmuBus_cmd_virtualAddress;
  assign DBusCachedPlugin_mmuBus_cmd_bypassTranslation = dataCache_io_cpu_memory_mmuBus_cmd_bypassTranslation;
  always @ (*) begin
    _zz_237_ = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_io_cpu_memory_isWrite)))begin
      _zz_237_ = 1'b1;
    end
  end

  assign DBusCachedPlugin_mmuBus_end = dataCache_io_cpu_memory_mmuBus_end;
  assign _zz_238_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_239_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_240_ = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(_zz_302_)begin
      if(dataCache_io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_valid = 1'b0;
    if(_zz_302_)begin
      if(dataCache_io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_io_cpu_redo)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b0;
      end
    end
  end

  assign DBusCachedPlugin_exceptionBus_payload_badAddr = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_payload_code = (4'bxxxx);
    if(_zz_302_)begin
      if(dataCache_io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_377_};
      end
      if(dataCache_io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_378_};
      end
      if(dataCache_io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_payload_code = (writeBack_MEMORY_WR ? (4'b1111) : (4'b1101));
      end
    end
  end

  always @ (*) begin
    writeBack_DBusCachedPlugin_rspShifted = dataCache_io_cpu_writeBack_data;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_io_cpu_writeBack_data[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusCachedPlugin_rspShifted[15 : 0] = dataCache_io_cpu_writeBack_data[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_io_cpu_writeBack_data[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_118_ = (writeBack_DBusCachedPlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_119_[31] = _zz_118_;
    _zz_119_[30] = _zz_118_;
    _zz_119_[29] = _zz_118_;
    _zz_119_[28] = _zz_118_;
    _zz_119_[27] = _zz_118_;
    _zz_119_[26] = _zz_118_;
    _zz_119_[25] = _zz_118_;
    _zz_119_[24] = _zz_118_;
    _zz_119_[23] = _zz_118_;
    _zz_119_[22] = _zz_118_;
    _zz_119_[21] = _zz_118_;
    _zz_119_[20] = _zz_118_;
    _zz_119_[19] = _zz_118_;
    _zz_119_[18] = _zz_118_;
    _zz_119_[17] = _zz_118_;
    _zz_119_[16] = _zz_118_;
    _zz_119_[15] = _zz_118_;
    _zz_119_[14] = _zz_118_;
    _zz_119_[13] = _zz_118_;
    _zz_119_[12] = _zz_118_;
    _zz_119_[11] = _zz_118_;
    _zz_119_[10] = _zz_118_;
    _zz_119_[9] = _zz_118_;
    _zz_119_[8] = _zz_118_;
    _zz_119_[7 : 0] = writeBack_DBusCachedPlugin_rspShifted[7 : 0];
  end

  assign _zz_120_ = (writeBack_DBusCachedPlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_121_[31] = _zz_120_;
    _zz_121_[30] = _zz_120_;
    _zz_121_[29] = _zz_120_;
    _zz_121_[28] = _zz_120_;
    _zz_121_[27] = _zz_120_;
    _zz_121_[26] = _zz_120_;
    _zz_121_[25] = _zz_120_;
    _zz_121_[24] = _zz_120_;
    _zz_121_[23] = _zz_120_;
    _zz_121_[22] = _zz_120_;
    _zz_121_[21] = _zz_120_;
    _zz_121_[20] = _zz_120_;
    _zz_121_[19] = _zz_120_;
    _zz_121_[18] = _zz_120_;
    _zz_121_[17] = _zz_120_;
    _zz_121_[16] = _zz_120_;
    _zz_121_[15 : 0] = writeBack_DBusCachedPlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_331_)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_119_;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_121_;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspShifted;
      end
    endcase
  end

  assign PMPPlugin_pmpcfg_0 = PMPPlugin_pmpcfgPacked_0[7 : 0];
  assign PMPPlugin_pmpcfg_1 = PMPPlugin_pmpcfgPacked_0[15 : 8];
  assign PMPPlugin_pmpcfg_2 = PMPPlugin_pmpcfgPacked_0[23 : 16];
  assign PMPPlugin_pmpcfg_3 = PMPPlugin_pmpcfgPacked_0[31 : 24];
  assign PMPPlugin_pmpcfg_4 = PMPPlugin_pmpcfgPacked_1[7 : 0];
  assign PMPPlugin_pmpcfg_5 = PMPPlugin_pmpcfgPacked_1[15 : 8];
  assign PMPPlugin_pmpcfg_6 = PMPPlugin_pmpcfgPacked_1[23 : 16];
  assign PMPPlugin_pmpcfg_7 = PMPPlugin_pmpcfgPacked_1[31 : 24];
  always @ (*) begin
    PMPPlugin_tmp_pmpcfgPacked_0[7 : 0] = PMPPlugin_shadow_pmpcfg_0;
    PMPPlugin_tmp_pmpcfgPacked_0[15 : 8] = PMPPlugin_shadow_pmpcfg_1;
    PMPPlugin_tmp_pmpcfgPacked_0[23 : 16] = PMPPlugin_shadow_pmpcfg_2;
    PMPPlugin_tmp_pmpcfgPacked_0[31 : 24] = PMPPlugin_shadow_pmpcfg_3;
  end

  always @ (*) begin
    PMPPlugin_tmp_pmpcfgPacked_1[7 : 0] = PMPPlugin_shadow_pmpcfg_4;
    PMPPlugin_tmp_pmpcfgPacked_1[15 : 8] = PMPPlugin_shadow_pmpcfg_5;
    PMPPlugin_tmp_pmpcfgPacked_1[23 : 16] = PMPPlugin_shadow_pmpcfg_6;
    PMPPlugin_tmp_pmpcfgPacked_1[31 : 24] = PMPPlugin_shadow_pmpcfg_7;
  end

  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PMPPlugin_ports_0_physAddr = {(2'b00),IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 2]};
  assign _zz_122_ = PMPPlugin_shadow_pmpcfg_0[4 : 3];
  assign _zz_123_ = PMPPlugin_shadow_pmpcfg_0[6 : 5];
  assign _zz_124_ = (~ (PMPPlugin_shadow_pmpaddr_0 ^ _zz_379_));
  assign _zz_125_ = PMPPlugin_shadow_pmpcfg_1[4 : 3];
  assign _zz_126_ = PMPPlugin_shadow_pmpcfg_1[6 : 5];
  assign _zz_127_ = (~ (PMPPlugin_shadow_pmpaddr_1 ^ _zz_380_));
  assign _zz_128_ = PMPPlugin_shadow_pmpcfg_2[4 : 3];
  assign _zz_129_ = PMPPlugin_shadow_pmpcfg_2[6 : 5];
  assign _zz_130_ = (~ (PMPPlugin_shadow_pmpaddr_2 ^ _zz_381_));
  assign _zz_131_ = PMPPlugin_shadow_pmpcfg_3[4 : 3];
  assign _zz_132_ = PMPPlugin_shadow_pmpcfg_3[6 : 5];
  assign _zz_133_ = (~ (PMPPlugin_shadow_pmpaddr_3 ^ _zz_382_));
  assign _zz_134_ = PMPPlugin_shadow_pmpcfg_4[4 : 3];
  assign _zz_135_ = PMPPlugin_shadow_pmpcfg_4[6 : 5];
  assign _zz_136_ = (~ (PMPPlugin_shadow_pmpaddr_4 ^ _zz_383_));
  assign _zz_137_ = PMPPlugin_shadow_pmpcfg_5[4 : 3];
  assign _zz_138_ = PMPPlugin_shadow_pmpcfg_5[6 : 5];
  assign _zz_139_ = (~ (PMPPlugin_shadow_pmpaddr_5 ^ _zz_384_));
  assign _zz_140_ = PMPPlugin_shadow_pmpcfg_6[4 : 3];
  assign _zz_141_ = PMPPlugin_shadow_pmpcfg_6[6 : 5];
  assign _zz_142_ = (~ (PMPPlugin_shadow_pmpaddr_6 ^ _zz_385_));
  assign _zz_143_ = PMPPlugin_shadow_pmpcfg_7[4 : 3];
  assign _zz_144_ = PMPPlugin_shadow_pmpcfg_7[6 : 5];
  assign _zz_145_ = (~ (PMPPlugin_shadow_pmpaddr_7 ^ _zz_386_));
  always @ (*) begin
    if(_zz_303_)begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
    end else begin
      if(PMPPlugin_ports_0_matched)begin
        IBusCachedPlugin_mmuBus_rsp_allowRead = PMPPlugin_ports_0_matched_r;
      end else begin
        if(_zz_304_)begin
          IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
        end else begin
          IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b0;
        end
      end
    end
  end

  always @ (*) begin
    if(_zz_303_)begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
    end else begin
      if(PMPPlugin_ports_0_matched)begin
        IBusCachedPlugin_mmuBus_rsp_allowWrite = PMPPlugin_ports_0_matched_w;
      end else begin
        if(_zz_304_)begin
          IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
        end else begin
          IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b0;
        end
      end
    end
  end

  always @ (*) begin
    if(_zz_303_)begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
    end else begin
      if(PMPPlugin_ports_0_matched)begin
        IBusCachedPlugin_mmuBus_rsp_allowExecute = PMPPlugin_ports_0_matched_x;
      end else begin
        if(_zz_304_)begin
          IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
        end else begin
          IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b0;
        end
      end
    end
  end

  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1111));
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  assign PMPPlugin_ports_1_physAddr = {(2'b00),DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 2]};
  assign _zz_146_ = PMPPlugin_shadow_pmpcfg_0[4 : 3];
  assign _zz_147_ = PMPPlugin_shadow_pmpcfg_0[6 : 5];
  assign _zz_148_ = (~ (PMPPlugin_shadow_pmpaddr_0 ^ _zz_387_));
  assign _zz_149_ = PMPPlugin_shadow_pmpcfg_1[4 : 3];
  assign _zz_150_ = PMPPlugin_shadow_pmpcfg_1[6 : 5];
  assign _zz_151_ = (~ (PMPPlugin_shadow_pmpaddr_1 ^ _zz_388_));
  assign _zz_152_ = PMPPlugin_shadow_pmpcfg_2[4 : 3];
  assign _zz_153_ = PMPPlugin_shadow_pmpcfg_2[6 : 5];
  assign _zz_154_ = (~ (PMPPlugin_shadow_pmpaddr_2 ^ _zz_389_));
  assign _zz_155_ = PMPPlugin_shadow_pmpcfg_3[4 : 3];
  assign _zz_156_ = PMPPlugin_shadow_pmpcfg_3[6 : 5];
  assign _zz_157_ = (~ (PMPPlugin_shadow_pmpaddr_3 ^ _zz_390_));
  assign _zz_158_ = PMPPlugin_shadow_pmpcfg_4[4 : 3];
  assign _zz_159_ = PMPPlugin_shadow_pmpcfg_4[6 : 5];
  assign _zz_160_ = (~ (PMPPlugin_shadow_pmpaddr_4 ^ _zz_391_));
  assign _zz_161_ = PMPPlugin_shadow_pmpcfg_5[4 : 3];
  assign _zz_162_ = PMPPlugin_shadow_pmpcfg_5[6 : 5];
  assign _zz_163_ = (~ (PMPPlugin_shadow_pmpaddr_5 ^ _zz_392_));
  assign _zz_164_ = PMPPlugin_shadow_pmpcfg_6[4 : 3];
  assign _zz_165_ = PMPPlugin_shadow_pmpcfg_6[6 : 5];
  assign _zz_166_ = (~ (PMPPlugin_shadow_pmpaddr_6 ^ _zz_393_));
  assign _zz_167_ = PMPPlugin_shadow_pmpcfg_7[4 : 3];
  assign _zz_168_ = PMPPlugin_shadow_pmpcfg_7[6 : 5];
  assign _zz_169_ = (~ (PMPPlugin_shadow_pmpaddr_7 ^ _zz_394_));
  always @ (*) begin
    if(_zz_305_)begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
    end else begin
      if(PMPPlugin_ports_1_matched)begin
        DBusCachedPlugin_mmuBus_rsp_allowRead = PMPPlugin_ports_1_matched_r;
      end else begin
        if(_zz_306_)begin
          DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
        end else begin
          DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b0;
        end
      end
    end
  end

  always @ (*) begin
    if(_zz_305_)begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
    end else begin
      if(PMPPlugin_ports_1_matched)begin
        DBusCachedPlugin_mmuBus_rsp_allowWrite = PMPPlugin_ports_1_matched_w;
      end else begin
        if(_zz_306_)begin
          DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
        end else begin
          DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b0;
        end
      end
    end
  end

  always @ (*) begin
    if(_zz_305_)begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
    end else begin
      if(PMPPlugin_ports_1_matched)begin
        DBusCachedPlugin_mmuBus_rsp_allowExecute = PMPPlugin_ports_1_matched_x;
      end else begin
        if(_zz_306_)begin
          DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
        end else begin
          DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b0;
        end
      end
    end
  end

  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1111));
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_171_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_172_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001000)) == (32'b00000000000000000000000001001000));
  assign _zz_173_ = ((decode_INSTRUCTION & (32'b00000000000000000001000000000000)) == (32'b00000000000000000000000000000000));
  assign _zz_174_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_170_ = {(((decode_INSTRUCTION & _zz_470_) == (32'b00000000000000000001000000001000)) != (1'b0)),{({_zz_471_,_zz_174_} != (2'b00)),{({_zz_472_,_zz_473_} != (2'b00)),{(_zz_474_ != _zz_475_),{_zz_476_,{_zz_477_,_zz_478_}}}}}};
  assign _zz_175_ = _zz_170_[1 : 0];
  assign _zz_49_ = _zz_175_;
  assign _zz_176_ = _zz_170_[4 : 3];
  assign _zz_48_ = _zz_176_;
  assign _zz_177_ = _zz_170_[6 : 5];
  assign _zz_47_ = _zz_177_;
  assign _zz_178_ = _zz_170_[21 : 20];
  assign _zz_46_ = _zz_178_;
  assign _zz_179_ = _zz_170_[23 : 22];
  assign _zz_45_ = _zz_179_;
  assign _zz_180_ = _zz_170_[27 : 26];
  assign _zz_44_ = _zz_180_;
  assign _zz_181_ = _zz_170_[30 : 29];
  assign _zz_43_ = _zz_181_;
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_242_;
  assign decode_RegFilePlugin_rs2Data = _zz_243_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_41_ && writeBack_arbitration_isFiring);
    if(_zz_182_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_40_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_58_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_183_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_183_ = {31'd0, _zz_395_};
      end
      default : begin
        _zz_183_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_184_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_184_ = {29'd0, _zz_396_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_184_ = {execute_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_184_ = {27'd0, _zz_397_};
      end
    endcase
  end

  assign _zz_185_ = _zz_398_[11];
  always @ (*) begin
    _zz_186_[19] = _zz_185_;
    _zz_186_[18] = _zz_185_;
    _zz_186_[17] = _zz_185_;
    _zz_186_[16] = _zz_185_;
    _zz_186_[15] = _zz_185_;
    _zz_186_[14] = _zz_185_;
    _zz_186_[13] = _zz_185_;
    _zz_186_[12] = _zz_185_;
    _zz_186_[11] = _zz_185_;
    _zz_186_[10] = _zz_185_;
    _zz_186_[9] = _zz_185_;
    _zz_186_[8] = _zz_185_;
    _zz_186_[7] = _zz_185_;
    _zz_186_[6] = _zz_185_;
    _zz_186_[5] = _zz_185_;
    _zz_186_[4] = _zz_185_;
    _zz_186_[3] = _zz_185_;
    _zz_186_[2] = _zz_185_;
    _zz_186_[1] = _zz_185_;
    _zz_186_[0] = _zz_185_;
  end

  assign _zz_187_ = _zz_399_[11];
  always @ (*) begin
    _zz_188_[19] = _zz_187_;
    _zz_188_[18] = _zz_187_;
    _zz_188_[17] = _zz_187_;
    _zz_188_[16] = _zz_187_;
    _zz_188_[15] = _zz_187_;
    _zz_188_[14] = _zz_187_;
    _zz_188_[13] = _zz_187_;
    _zz_188_[12] = _zz_187_;
    _zz_188_[11] = _zz_187_;
    _zz_188_[10] = _zz_187_;
    _zz_188_[9] = _zz_187_;
    _zz_188_[8] = _zz_187_;
    _zz_188_[7] = _zz_187_;
    _zz_188_[6] = _zz_187_;
    _zz_188_[5] = _zz_187_;
    _zz_188_[4] = _zz_187_;
    _zz_188_[3] = _zz_187_;
    _zz_188_[2] = _zz_187_;
    _zz_188_[1] = _zz_187_;
    _zz_188_[0] = _zz_187_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_189_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_189_ = {_zz_186_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_189_ = {_zz_188_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_189_ = _zz_35_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_400_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_190_[0] = execute_SRC1[31];
    _zz_190_[1] = execute_SRC1[30];
    _zz_190_[2] = execute_SRC1[29];
    _zz_190_[3] = execute_SRC1[28];
    _zz_190_[4] = execute_SRC1[27];
    _zz_190_[5] = execute_SRC1[26];
    _zz_190_[6] = execute_SRC1[25];
    _zz_190_[7] = execute_SRC1[24];
    _zz_190_[8] = execute_SRC1[23];
    _zz_190_[9] = execute_SRC1[22];
    _zz_190_[10] = execute_SRC1[21];
    _zz_190_[11] = execute_SRC1[20];
    _zz_190_[12] = execute_SRC1[19];
    _zz_190_[13] = execute_SRC1[18];
    _zz_190_[14] = execute_SRC1[17];
    _zz_190_[15] = execute_SRC1[16];
    _zz_190_[16] = execute_SRC1[15];
    _zz_190_[17] = execute_SRC1[14];
    _zz_190_[18] = execute_SRC1[13];
    _zz_190_[19] = execute_SRC1[12];
    _zz_190_[20] = execute_SRC1[11];
    _zz_190_[21] = execute_SRC1[10];
    _zz_190_[22] = execute_SRC1[9];
    _zz_190_[23] = execute_SRC1[8];
    _zz_190_[24] = execute_SRC1[7];
    _zz_190_[25] = execute_SRC1[6];
    _zz_190_[26] = execute_SRC1[5];
    _zz_190_[27] = execute_SRC1[4];
    _zz_190_[28] = execute_SRC1[3];
    _zz_190_[29] = execute_SRC1[2];
    _zz_190_[30] = execute_SRC1[1];
    _zz_190_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_190_ : execute_SRC1);
  always @ (*) begin
    _zz_191_[0] = memory_SHIFT_RIGHT[31];
    _zz_191_[1] = memory_SHIFT_RIGHT[30];
    _zz_191_[2] = memory_SHIFT_RIGHT[29];
    _zz_191_[3] = memory_SHIFT_RIGHT[28];
    _zz_191_[4] = memory_SHIFT_RIGHT[27];
    _zz_191_[5] = memory_SHIFT_RIGHT[26];
    _zz_191_[6] = memory_SHIFT_RIGHT[25];
    _zz_191_[7] = memory_SHIFT_RIGHT[24];
    _zz_191_[8] = memory_SHIFT_RIGHT[23];
    _zz_191_[9] = memory_SHIFT_RIGHT[22];
    _zz_191_[10] = memory_SHIFT_RIGHT[21];
    _zz_191_[11] = memory_SHIFT_RIGHT[20];
    _zz_191_[12] = memory_SHIFT_RIGHT[19];
    _zz_191_[13] = memory_SHIFT_RIGHT[18];
    _zz_191_[14] = memory_SHIFT_RIGHT[17];
    _zz_191_[15] = memory_SHIFT_RIGHT[16];
    _zz_191_[16] = memory_SHIFT_RIGHT[15];
    _zz_191_[17] = memory_SHIFT_RIGHT[14];
    _zz_191_[18] = memory_SHIFT_RIGHT[13];
    _zz_191_[19] = memory_SHIFT_RIGHT[12];
    _zz_191_[20] = memory_SHIFT_RIGHT[11];
    _zz_191_[21] = memory_SHIFT_RIGHT[10];
    _zz_191_[22] = memory_SHIFT_RIGHT[9];
    _zz_191_[23] = memory_SHIFT_RIGHT[8];
    _zz_191_[24] = memory_SHIFT_RIGHT[7];
    _zz_191_[25] = memory_SHIFT_RIGHT[6];
    _zz_191_[26] = memory_SHIFT_RIGHT[5];
    _zz_191_[27] = memory_SHIFT_RIGHT[4];
    _zz_191_[28] = memory_SHIFT_RIGHT[3];
    _zz_191_[29] = memory_SHIFT_RIGHT[2];
    _zz_191_[30] = memory_SHIFT_RIGHT[1];
    _zz_191_[31] = memory_SHIFT_RIGHT[0];
  end

  assign execute_MulPlugin_a = execute_RS1;
  assign execute_MulPlugin_b = execute_RS2;
  always @ (*) begin
    case(_zz_307_)
      2'b01 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      default : begin
        execute_MulPlugin_aSigned = 1'b0;
      end
    endcase
  end

  always @ (*) begin
    case(_zz_307_)
      2'b01 : begin
        execute_MulPlugin_bSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
      default : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
    endcase
  end

  assign execute_MulPlugin_aULow = execute_MulPlugin_a[15 : 0];
  assign execute_MulPlugin_bULow = execute_MulPlugin_b[15 : 0];
  assign execute_MulPlugin_aSLow = {1'b0,execute_MulPlugin_a[15 : 0]};
  assign execute_MulPlugin_bSLow = {1'b0,execute_MulPlugin_b[15 : 0]};
  assign execute_MulPlugin_aHigh = {(execute_MulPlugin_aSigned && execute_MulPlugin_a[31]),execute_MulPlugin_a[31 : 16]};
  assign execute_MulPlugin_bHigh = {(execute_MulPlugin_bSigned && execute_MulPlugin_b[31]),execute_MulPlugin_b[31 : 16]};
  assign writeBack_MulPlugin_result = ($signed(_zz_407_) + $signed(_zz_408_));
  always @ (*) begin
    memory_DivPlugin_div_counter_willIncrement = 1'b0;
    if(_zz_250_)begin
      if(_zz_295_)begin
        memory_DivPlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_DivPlugin_div_counter_willClear = 1'b0;
    if(_zz_308_)begin
      memory_DivPlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_DivPlugin_div_counter_willOverflowIfInc = (memory_DivPlugin_div_counter_value == (6'b100001));
  assign memory_DivPlugin_div_counter_willOverflow = (memory_DivPlugin_div_counter_willOverflowIfInc && memory_DivPlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_DivPlugin_div_counter_willOverflow)begin
      memory_DivPlugin_div_counter_valueNext = (6'b000000);
    end else begin
      memory_DivPlugin_div_counter_valueNext = (memory_DivPlugin_div_counter_value + _zz_412_);
    end
    if(memory_DivPlugin_div_counter_willClear)begin
      memory_DivPlugin_div_counter_valueNext = (6'b000000);
    end
  end

  assign _zz_192_ = memory_DivPlugin_rs1[31 : 0];
  assign _zz_193_ = {memory_DivPlugin_accumulator[31 : 0],_zz_192_[31]};
  assign _zz_194_ = (_zz_193_ - _zz_413_);
  assign _zz_195_ = (memory_INSTRUCTION[13] ? memory_DivPlugin_accumulator[31 : 0] : memory_DivPlugin_rs1[31 : 0]);
  assign _zz_196_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_197_ = (1'b0 || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_198_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_198_[31 : 0] = execute_RS1;
  end

  always @ (*) begin
    _zz_199_ = 1'b0;
    if(_zz_309_)begin
      if(_zz_310_)begin
        if(_zz_204_)begin
          _zz_199_ = 1'b1;
        end
      end
    end
    if(_zz_311_)begin
      if(_zz_312_)begin
        if(_zz_206_)begin
          _zz_199_ = 1'b1;
        end
      end
    end
    if(_zz_313_)begin
      if(_zz_314_)begin
        if(_zz_208_)begin
          _zz_199_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_199_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_200_ = 1'b0;
    if(_zz_309_)begin
      if(_zz_310_)begin
        if(_zz_205_)begin
          _zz_200_ = 1'b1;
        end
      end
    end
    if(_zz_311_)begin
      if(_zz_312_)begin
        if(_zz_207_)begin
          _zz_200_ = 1'b1;
        end
      end
    end
    if(_zz_313_)begin
      if(_zz_314_)begin
        if(_zz_209_)begin
          _zz_200_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_200_ = 1'b0;
    end
  end

  assign _zz_204_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_205_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_206_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_207_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_208_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_209_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_210_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_210_ == (3'b000))) begin
        _zz_211_ = execute_BranchPlugin_eq;
    end else if((_zz_210_ == (3'b001))) begin
        _zz_211_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_210_ & (3'b101)) == (3'b101)))) begin
        _zz_211_ = (! execute_SRC_LESS);
    end else begin
        _zz_211_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_212_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_212_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_212_ = 1'b1;
      end
      default : begin
        _zz_212_ = _zz_211_;
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = 1'b0;
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_213_ = _zz_426_[11];
  always @ (*) begin
    _zz_214_[19] = _zz_213_;
    _zz_214_[18] = _zz_213_;
    _zz_214_[17] = _zz_213_;
    _zz_214_[16] = _zz_213_;
    _zz_214_[15] = _zz_213_;
    _zz_214_[14] = _zz_213_;
    _zz_214_[13] = _zz_213_;
    _zz_214_[12] = _zz_213_;
    _zz_214_[11] = _zz_213_;
    _zz_214_[10] = _zz_213_;
    _zz_214_[9] = _zz_213_;
    _zz_214_[8] = _zz_213_;
    _zz_214_[7] = _zz_213_;
    _zz_214_[6] = _zz_213_;
    _zz_214_[5] = _zz_213_;
    _zz_214_[4] = _zz_213_;
    _zz_214_[3] = _zz_213_;
    _zz_214_[2] = _zz_213_;
    _zz_214_[1] = _zz_213_;
    _zz_214_[0] = _zz_213_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_214_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_216_,{{{_zz_630_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_218_,{{{_zz_631_,_zz_632_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_429_};
        end
      end
    endcase
  end

  assign _zz_215_ = _zz_427_[19];
  always @ (*) begin
    _zz_216_[10] = _zz_215_;
    _zz_216_[9] = _zz_215_;
    _zz_216_[8] = _zz_215_;
    _zz_216_[7] = _zz_215_;
    _zz_216_[6] = _zz_215_;
    _zz_216_[5] = _zz_215_;
    _zz_216_[4] = _zz_215_;
    _zz_216_[3] = _zz_215_;
    _zz_216_[2] = _zz_215_;
    _zz_216_[1] = _zz_215_;
    _zz_216_[0] = _zz_215_;
  end

  assign _zz_217_ = _zz_428_[11];
  always @ (*) begin
    _zz_218_[18] = _zz_217_;
    _zz_218_[17] = _zz_217_;
    _zz_218_[16] = _zz_217_;
    _zz_218_[15] = _zz_217_;
    _zz_218_[14] = _zz_217_;
    _zz_218_[13] = _zz_217_;
    _zz_218_[12] = _zz_217_;
    _zz_218_[11] = _zz_217_;
    _zz_218_[10] = _zz_217_;
    _zz_218_[9] = _zz_217_;
    _zz_218_[8] = _zz_217_;
    _zz_218_[7] = _zz_217_;
    _zz_218_[6] = _zz_217_;
    _zz_218_[5] = _zz_217_;
    _zz_218_[4] = _zz_217_;
    _zz_218_[3] = _zz_217_;
    _zz_218_[2] = _zz_217_;
    _zz_218_[1] = _zz_217_;
    _zz_218_[0] = _zz_217_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  always @ (*) begin
    CsrPlugin_privilege = _zz_219_;
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = (26'b00000000000000000001000010);
  assign CsrPlugin_mtvec_mode = (2'b00);
  assign CsrPlugin_mtvec_base = (30'b000000000000000000000000001000);
  assign _zz_220_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_221_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_222_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_223_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_224_ = _zz_430_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_294_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  assign CsrPlugin_lastStageWasWfi = 1'b0;
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusCachedPlugin_pcValids_3);
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = (30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign execute_CsrPlugin_inWfi = 1'b0;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110110 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110011 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110100001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110101 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000011 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001110100000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001110110100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000010 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001110110111 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      default : begin
      end
    endcase
    if((CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]))begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_valid = 1'b0;
    if(_zz_315_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_315_)begin
      case(CsrPlugin_privilege)
        2'b00 : begin
          CsrPlugin_selfException_payload_code = (4'b1000);
        end
        default : begin
          CsrPlugin_selfException_payload_code = (4'b1011);
        end
      endcase
    end
  end

  assign CsrPlugin_selfException_payload_badAddr = execute_INSTRUCTION;
  always @ (*) begin
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
      end
      12'b001110110110 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_6;
      end
      12'b001110110000 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_0;
      end
      12'b001110110011 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_3;
      end
      12'b001110100001 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_tmp_pmpcfgPacked_1;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mepc;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
      end
      12'b001110110010 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_2;
      end
      12'b001110110101 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_5;
      end
      12'b001101000011 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mtval;
      end
      12'b001110100000 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_tmp_pmpcfgPacked_0;
      end
      12'b001101000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mscratch;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
      end
      12'b001110110001 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_1;
      end
      12'b001110110100 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_4;
      end
      12'b001101000010 : begin
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_mcause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_mcause_exceptionCode;
      end
      12'b001110110111 : begin
        execute_CsrPlugin_readData[31 : 0] = PMPPlugin_shadow_pmpaddr_7;
      end
      default : begin
      end
    endcase
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_333_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_26_ = decode_SRC1_CTRL;
  assign _zz_24_ = _zz_43_;
  assign _zz_37_ = decode_to_execute_SRC1_CTRL;
  assign _zz_23_ = decode_BRANCH_CTRL;
  assign _zz_59_ = _zz_44_;
  assign _zz_30_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_21_ = decode_ALU_BITWISE_CTRL;
  assign _zz_19_ = _zz_48_;
  assign _zz_39_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_18_ = decode_ALU_CTRL;
  assign _zz_16_ = _zz_49_;
  assign _zz_38_ = decode_to_execute_ALU_CTRL;
  assign _zz_15_ = decode_SRC2_CTRL;
  assign _zz_13_ = _zz_45_;
  assign _zz_36_ = decode_to_execute_SRC2_CTRL;
  assign _zz_12_ = decode_SHIFT_CTRL;
  assign _zz_9_ = execute_SHIFT_CTRL;
  assign _zz_10_ = _zz_46_;
  assign _zz_34_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_33_ = execute_to_memory_SHIFT_CTRL;
  assign _zz_7_ = decode_ENV_CTRL;
  assign _zz_4_ = execute_ENV_CTRL;
  assign _zz_2_ = memory_ENV_CTRL;
  assign _zz_5_ = _zz_47_;
  assign _zz_28_ = decode_to_execute_ENV_CTRL;
  assign _zz_27_ = execute_to_memory_ENV_CTRL;
  assign _zz_29_ = memory_to_writeBack_ENV_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      IBusCachedPlugin_fetchPc_pcReg <= (32'b00000000000000000000000000000000);
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      IBusCachedPlugin_decodePc_pcReg <= (32'b00000000000000000000000000000000);
      _zz_73_ <= 1'b0;
      _zz_75_ <= 1'b0;
      IBusCachedPlugin_decompressor_bufferValid <= 1'b0;
      _zz_104_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_115_;
      IBusCachedPlugin_rspCounter <= (32'b00000000000000000000000000000000);
      DBusCachedPlugin_rspCounter <= _zz_116_;
      DBusCachedPlugin_rspCounter <= (32'b00000000000000000000000000000000);
      PMPPlugin_pmpcfgPacked_0 <= (32'b00000000000000000000000000000000);
      PMPPlugin_pmpcfgPacked_1 <= (32'b00000000000000000000000000000000);
      PMPPlugin_shadow_pmpcfg_0 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_1 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_2 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_3 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_4 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_5 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_6 <= (8'b00000000);
      PMPPlugin_shadow_pmpcfg_7 <= (8'b00000000);
      _zz_182_ <= 1'b1;
      memory_DivPlugin_div_counter_value <= (6'b000000);
      _zz_201_ <= 1'b0;
      _zz_219_ <= (2'b11);
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
    end else begin
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_corrected || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetcherflushIt) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if((decode_arbitration_isFiring && (! IBusCachedPlugin_decodePc_injectedDecode)))begin
        IBusCachedPlugin_decodePc_pcReg <= IBusCachedPlugin_decodePc_pcPlus;
      end
      if((IBusCachedPlugin_jump_pcLoad_valid && ((! decode_arbitration_isStuck) || decode_arbitration_removeIt)))begin
        IBusCachedPlugin_decodePc_pcReg <= IBusCachedPlugin_jump_pcLoad_payload;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_73_ <= 1'b0;
      end
      if(_zz_71_)begin
        _zz_73_ <= IBusCachedPlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_75_ <= IBusCachedPlugin_iBusRsp_stages_1_output_valid;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_75_ <= 1'b0;
      end
      if((IBusCachedPlugin_decompressor_output_valid && IBusCachedPlugin_decompressor_output_ready))begin
        IBusCachedPlugin_decompressor_bufferValid <= 1'b0;
      end
      if(_zz_299_)begin
        if(_zz_300_)begin
          IBusCachedPlugin_decompressor_bufferValid <= 1'b1;
        end else begin
          IBusCachedPlugin_decompressor_bufferValid <= 1'b0;
        end
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_decompressor_bufferValid <= 1'b0;
      end
      if(IBusCachedPlugin_decompressor_output_ready)begin
        _zz_104_ <= IBusCachedPlugin_decompressor_output_valid;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_104_ <= 1'b0;
      end
      if((! 1'b0))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + (32'b00000000000000000000000000000001));
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + (32'b00000000000000000000000000000001));
      end
      if(_zz_316_)begin
        PMPPlugin_shadow_pmpcfg_0 <= PMPPlugin_pmpcfg_0;
      end
      if(_zz_317_)begin
        PMPPlugin_shadow_pmpcfg_1 <= PMPPlugin_pmpcfg_1;
      end
      if(_zz_318_)begin
        PMPPlugin_shadow_pmpcfg_2 <= PMPPlugin_pmpcfg_2;
      end
      if(_zz_319_)begin
        PMPPlugin_shadow_pmpcfg_3 <= PMPPlugin_pmpcfg_3;
      end
      if(_zz_320_)begin
        PMPPlugin_shadow_pmpcfg_4 <= PMPPlugin_pmpcfg_4;
      end
      if(_zz_321_)begin
        PMPPlugin_shadow_pmpcfg_5 <= PMPPlugin_pmpcfg_5;
      end
      if(_zz_322_)begin
        PMPPlugin_shadow_pmpcfg_6 <= PMPPlugin_pmpcfg_6;
      end
      if(_zz_323_)begin
        PMPPlugin_shadow_pmpcfg_7 <= PMPPlugin_pmpcfg_7;
      end
      _zz_182_ <= 1'b0;
      memory_DivPlugin_div_counter_value <= memory_DivPlugin_div_counter_valueNext;
      _zz_201_ <= (_zz_41_ && writeBack_arbitration_isFiring);
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_324_)begin
        if(_zz_325_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_326_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_327_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_296_)begin
        _zz_219_ <= CsrPlugin_targetPrivilege;
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_297_)begin
        case(_zz_298_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
            _zz_219_ <= CsrPlugin_mstatus_MPP;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_222_,{_zz_221_,_zz_220_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_32_;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      case(execute_CsrPlugin_csrAddress)
        12'b001100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
            CsrPlugin_mstatus_MPIE <= _zz_432_[0];
            CsrPlugin_mstatus_MIE <= _zz_433_[0];
          end
        end
        12'b001110110110 : begin
        end
        12'b001110110000 : begin
        end
        12'b001110110011 : begin
        end
        12'b001110100001 : begin
          if(execute_CsrPlugin_writeEnable)begin
            PMPPlugin_pmpcfgPacked_1 <= execute_CsrPlugin_writeData[31 : 0];
          end
        end
        12'b001101000001 : begin
        end
        12'b001101000100 : begin
        end
        12'b001110110010 : begin
        end
        12'b001110110101 : begin
        end
        12'b001101000011 : begin
        end
        12'b001110100000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            PMPPlugin_pmpcfgPacked_0 <= execute_CsrPlugin_writeData[31 : 0];
          end
        end
        12'b001101000000 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_435_[0];
            CsrPlugin_mie_MTIE <= _zz_436_[0];
            CsrPlugin_mie_MSIE <= _zz_437_[0];
          end
        end
        12'b001110110001 : begin
        end
        12'b001110110100 : begin
        end
        12'b001101000010 : begin
        end
        12'b001110110111 : begin
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge io_axiClk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_76_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(_zz_299_)begin
      IBusCachedPlugin_decompressor_bufferData <= IBusCachedPlugin_iBusRsp_output_payload_rsp_inst[31 : 16];
    end
    if(IBusCachedPlugin_decompressor_output_ready)begin
      _zz_105_ <= IBusCachedPlugin_decompressor_output_payload_pc;
      _zz_106_ <= IBusCachedPlugin_decompressor_output_payload_rsp_error;
      _zz_107_ <= IBusCachedPlugin_decompressor_output_payload_rsp_inst;
      _zz_108_ <= IBusCachedPlugin_decompressor_output_payload_isRvc;
    end
    if(IBusCachedPlugin_injector_decodeInput_ready)begin
      IBusCachedPlugin_injector_formal_rawInDecode <= IBusCachedPlugin_decompressor_raw;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_316_)begin
      PMPPlugin_shadow_pmpaddr_0 <= PMPPlugin_pmpaddr_0;
    end
    if(_zz_317_)begin
      PMPPlugin_shadow_pmpaddr_1 <= PMPPlugin_pmpaddr_1;
    end
    if(_zz_318_)begin
      PMPPlugin_shadow_pmpaddr_2 <= PMPPlugin_pmpaddr_2;
    end
    if(_zz_319_)begin
      PMPPlugin_shadow_pmpaddr_3 <= PMPPlugin_pmpaddr_3;
    end
    if(_zz_320_)begin
      PMPPlugin_shadow_pmpaddr_4 <= PMPPlugin_pmpaddr_4;
    end
    if(_zz_321_)begin
      PMPPlugin_shadow_pmpaddr_5 <= PMPPlugin_pmpaddr_5;
    end
    if(_zz_322_)begin
      PMPPlugin_shadow_pmpaddr_6 <= PMPPlugin_pmpaddr_6;
    end
    if(_zz_323_)begin
      PMPPlugin_shadow_pmpaddr_7 <= PMPPlugin_pmpaddr_7;
    end
    if((memory_DivPlugin_div_counter_value == (6'b100000)))begin
      memory_DivPlugin_div_done <= 1'b1;
    end
    if((! memory_arbitration_isStuck))begin
      memory_DivPlugin_div_done <= 1'b0;
    end
    if(_zz_250_)begin
      if(_zz_295_)begin
        memory_DivPlugin_rs1[31 : 0] <= _zz_414_[31:0];
        memory_DivPlugin_accumulator[31 : 0] <= ((! _zz_194_[32]) ? _zz_415_ : _zz_416_);
        if((memory_DivPlugin_div_counter_value == (6'b100000)))begin
          memory_DivPlugin_div_result <= _zz_417_[31:0];
        end
      end
    end
    if(_zz_308_)begin
      memory_DivPlugin_accumulator <= (65'b00000000000000000000000000000000000000000000000000000000000000000);
      memory_DivPlugin_rs1 <= ((_zz_197_ ? (~ _zz_198_) : _zz_198_) + _zz_423_);
      memory_DivPlugin_rs2 <= ((_zz_196_ ? (~ execute_RS2) : execute_RS2) + _zz_425_);
      memory_DivPlugin_div_needRevert <= ((_zz_197_ ^ (_zz_196_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == (32'b00000000000000000000000000000000)) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    _zz_202_ <= _zz_40_[11 : 7];
    _zz_203_ <= _zz_58_;
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(_zz_294_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_224_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_224_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
    end
    if(CsrPlugin_selfException_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= CsrPlugin_selfException_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= CsrPlugin_selfException_payload_badAddr;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusCachedPlugin_exceptionBus_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusCachedPlugin_exceptionBus_payload_badAddr;
    end
    if(_zz_324_)begin
      if(_zz_325_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_326_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_327_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_296_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_61_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_60_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_25_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_22_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_31_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_20_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RVC <= decode_IS_RVC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_17_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_35_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_14_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_11_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_8_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_MUL <= memory_IS_MUL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_WR <= execute_MEMORY_WR;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_WR <= memory_MEMORY_WR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_6_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_3_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_1_;
    end
    if((((! IBusCachedPlugin_iBusRsp_output_ready) && (IBusCachedPlugin_decompressor_output_valid && IBusCachedPlugin_decompressor_output_ready)) && (! IBusCachedPlugin_fetcherflushIt)))begin
      _zz_76_[1] <= 1'b1;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
      end
      12'b001110110110 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_6 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001110110000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_0 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001110110011 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_3 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001110100001 : begin
      end
      12'b001101000001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001101000100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mip_MSIP <= _zz_434_[0];
        end
      end
      12'b001110110010 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_2 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001110110101 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_5 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001101000011 : begin
      end
      12'b001110100000 : begin
      end
      12'b001101000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mscratch <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001100000100 : begin
      end
      12'b001110110001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_1 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001110110100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_4 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001101000010 : begin
      end
      12'b001110110111 : begin
        if(execute_CsrPlugin_writeEnable)begin
          PMPPlugin_pmpaddr_7 <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      default : begin
      end
    endcase
  end

endmodule

module NoDebug_StreamFork_4_ (
      input   io_input_valid,
      output reg  io_input_ready,
      input   io_input_payload_wr,
      input  [31:0] io_input_payload_address,
      input  [31:0] io_input_payload_data,
      input  [3:0] io_input_payload_mask,
      input  [2:0] io_input_payload_length,
      input   io_input_payload_last,
      output  io_outputs_0_valid,
      input   io_outputs_0_ready,
      output  io_outputs_0_payload_wr,
      output [31:0] io_outputs_0_payload_address,
      output [31:0] io_outputs_0_payload_data,
      output [3:0] io_outputs_0_payload_mask,
      output [2:0] io_outputs_0_payload_length,
      output  io_outputs_0_payload_last,
      output  io_outputs_1_valid,
      input   io_outputs_1_ready,
      output  io_outputs_1_payload_wr,
      output [31:0] io_outputs_1_payload_address,
      output [31:0] io_outputs_1_payload_data,
      output [3:0] io_outputs_1_payload_mask,
      output [2:0] io_outputs_1_payload_length,
      output  io_outputs_1_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  linkEnable_0;
  reg  linkEnable_1;
  always @ (*) begin
    io_input_ready = 1'b1;
    if(((! io_outputs_0_ready) && linkEnable_0))begin
      io_input_ready = 1'b0;
    end
    if(((! io_outputs_1_ready) && linkEnable_1))begin
      io_input_ready = 1'b0;
    end
  end

  assign io_outputs_0_valid = (io_input_valid && linkEnable_0);
  assign io_outputs_0_payload_wr = io_input_payload_wr;
  assign io_outputs_0_payload_address = io_input_payload_address;
  assign io_outputs_0_payload_data = io_input_payload_data;
  assign io_outputs_0_payload_mask = io_input_payload_mask;
  assign io_outputs_0_payload_length = io_input_payload_length;
  assign io_outputs_0_payload_last = io_input_payload_last;
  assign io_outputs_1_valid = (io_input_valid && linkEnable_1);
  assign io_outputs_1_payload_wr = io_input_payload_wr;
  assign io_outputs_1_payload_address = io_input_payload_address;
  assign io_outputs_1_payload_data = io_input_payload_data;
  assign io_outputs_1_payload_mask = io_input_payload_mask;
  assign io_outputs_1_payload_length = io_input_payload_length;
  assign io_outputs_1_payload_last = io_input_payload_last;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      linkEnable_0 <= 1'b1;
      linkEnable_1 <= 1'b1;
    end else begin
      if((io_outputs_0_valid && io_outputs_0_ready))begin
        linkEnable_0 <= 1'b0;
      end
      if((io_outputs_1_valid && io_outputs_1_ready))begin
        linkEnable_1 <= 1'b0;
      end
      if(io_input_ready)begin
        linkEnable_0 <= 1'b1;
        linkEnable_1 <= 1'b1;
      end
    end
  end

endmodule

module NoDebug_BufferCC_1_ (
      input   io_dataIn,
      output  io_dataOut,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  buffers_0;
  reg  buffers_1;
  assign io_dataOut = buffers_1;
  always @ (posedge io_axiClk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end

endmodule


//NoDebug_BufferCC_2_ remplaced by NoDebug_BufferCC_1_

module NoDebug_Axi4ReadOnlyDecoder (
      input   io_input_ar_valid,
      output  io_input_ar_ready,
      input  [31:0] io_input_ar_payload_addr,
      input  [7:0] io_input_ar_payload_len,
      input  [1:0] io_input_ar_payload_burst,
      input  [3:0] io_input_ar_payload_cache,
      input  [2:0] io_input_ar_payload_prot,
      output reg  io_input_r_valid,
      input   io_input_r_ready,
      output [31:0] io_input_r_payload_data,
      output reg [1:0] io_input_r_payload_resp,
      output reg  io_input_r_payload_last,
      output  io_outputs_0_ar_valid,
      input   io_outputs_0_ar_ready,
      output [31:0] io_outputs_0_ar_payload_addr,
      output [7:0] io_outputs_0_ar_payload_len,
      output [1:0] io_outputs_0_ar_payload_burst,
      output [3:0] io_outputs_0_ar_payload_cache,
      output [2:0] io_outputs_0_ar_payload_prot,
      input   io_outputs_0_r_valid,
      output  io_outputs_0_r_ready,
      input  [31:0] io_outputs_0_r_payload_data,
      input  [1:0] io_outputs_0_r_payload_resp,
      input   io_outputs_0_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_1_;
  wire  errorSlave_io_axi_ar_ready;
  wire  errorSlave_io_axi_r_valid;
  wire [31:0] errorSlave_io_axi_r_payload_data;
  wire [1:0] errorSlave_io_axi_r_payload_resp;
  wire  errorSlave_io_axi_r_payload_last;
  reg  pendingCmdCounter_incrementIt;
  reg  pendingCmdCounter_decrementIt;
  wire [2:0] pendingCmdCounter_valueNext;
  reg [2:0] pendingCmdCounter_value;
  wire  pendingCmdCounter_willOverflowIfInc;
  wire  pendingCmdCounter_willOverflow;
  reg [2:0] pendingCmdCounter_finalIncrement;
  wire [0:0] decodedCmdSels;
  wire  decodedCmdError;
  reg [0:0] pendingSels;
  reg  pendingError;
  wire  allowCmd;
  NoDebug_Axi4ReadOnlyErrorSlave errorSlave ( 
    .io_axi_ar_valid(_zz_1_),
    .io_axi_ar_ready(errorSlave_io_axi_ar_ready),
    .io_axi_ar_payload_addr(io_input_ar_payload_addr),
    .io_axi_ar_payload_len(io_input_ar_payload_len),
    .io_axi_ar_payload_burst(io_input_ar_payload_burst),
    .io_axi_ar_payload_cache(io_input_ar_payload_cache),
    .io_axi_ar_payload_prot(io_input_ar_payload_prot),
    .io_axi_r_valid(errorSlave_io_axi_r_valid),
    .io_axi_r_ready(io_input_r_ready),
    .io_axi_r_payload_data(errorSlave_io_axi_r_payload_data),
    .io_axi_r_payload_resp(errorSlave_io_axi_r_payload_resp),
    .io_axi_r_payload_last(errorSlave_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  always @ (*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if((io_input_ar_valid && io_input_ar_ready))begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @ (*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(((io_input_r_valid && io_input_r_ready) && io_input_r_payload_last))begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_willOverflowIfInc = ((pendingCmdCounter_value == (3'b111)) && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  always @ (*) begin
    if((pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt)))begin
      pendingCmdCounter_finalIncrement = (3'b001);
    end else begin
      if(((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt))begin
        pendingCmdCounter_finalIncrement = (3'b111);
      end else begin
        pendingCmdCounter_finalIncrement = (3'b000);
      end
    end
  end

  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_ar_payload_addr & (~ (32'b00000000000000011111111111111111))) == (32'b00000000000000000000000000000000)) && io_input_ar_valid);
  assign decodedCmdError = (decodedCmdSels == (1'b0));
  assign allowCmd = ((pendingCmdCounter_value == (3'b000)) || ((pendingCmdCounter_value != (3'b111)) && (pendingSels == decodedCmdSels)));
  assign io_input_ar_ready = ((((decodedCmdSels & io_outputs_0_ar_ready) != (1'b0)) || (decodedCmdError && errorSlave_io_axi_ar_ready)) && allowCmd);
  assign _zz_1_ = ((io_input_ar_valid && decodedCmdError) && allowCmd);
  assign io_outputs_0_ar_valid = ((io_input_ar_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_0_ar_payload_len = io_input_ar_payload_len;
  assign io_outputs_0_ar_payload_burst = io_input_ar_payload_burst;
  assign io_outputs_0_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_0_ar_payload_prot = io_input_ar_payload_prot;
  always @ (*) begin
    io_input_r_valid = (io_outputs_0_r_valid != (1'b0));
    if(errorSlave_io_axi_r_valid)begin
      io_input_r_valid = 1'b1;
    end
  end

  assign io_input_r_payload_data = io_outputs_0_r_payload_data;
  always @ (*) begin
    io_input_r_payload_resp = io_outputs_0_r_payload_resp;
    if(pendingError)begin
      io_input_r_payload_resp = errorSlave_io_axi_r_payload_resp;
    end
  end

  always @ (*) begin
    io_input_r_payload_last = io_outputs_0_r_payload_last;
    if(pendingError)begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_outputs_0_r_ready = io_input_r_ready;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      pendingCmdCounter_value <= (3'b000);
      pendingSels <= (1'b0);
      pendingError <= 1'b0;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      if(io_input_ar_ready)begin
        pendingSels <= decodedCmdSels;
      end
      if(io_input_ar_ready)begin
        pendingError <= decodedCmdError;
      end
    end
  end

endmodule

module NoDebug_Axi4SharedDecoder (
      input   io_input_arw_valid,
      output  io_input_arw_ready,
      input  [31:0] io_input_arw_payload_addr,
      input  [7:0] io_input_arw_payload_len,
      input  [2:0] io_input_arw_payload_size,
      input  [3:0] io_input_arw_payload_cache,
      input  [2:0] io_input_arw_payload_prot,
      input   io_input_arw_payload_write,
      input   io_input_w_valid,
      output  io_input_w_ready,
      input  [31:0] io_input_w_payload_data,
      input  [3:0] io_input_w_payload_strb,
      input   io_input_w_payload_last,
      output  io_input_b_valid,
      input   io_input_b_ready,
      output reg [1:0] io_input_b_payload_resp,
      output  io_input_r_valid,
      input   io_input_r_ready,
      output [31:0] io_input_r_payload_data,
      output reg [1:0] io_input_r_payload_resp,
      output reg  io_input_r_payload_last,
      output  io_readOutputs_0_ar_valid,
      input   io_readOutputs_0_ar_ready,
      output [31:0] io_readOutputs_0_ar_payload_addr,
      output [7:0] io_readOutputs_0_ar_payload_len,
      output [2:0] io_readOutputs_0_ar_payload_size,
      output [3:0] io_readOutputs_0_ar_payload_cache,
      output [2:0] io_readOutputs_0_ar_payload_prot,
      input   io_readOutputs_0_r_valid,
      output  io_readOutputs_0_r_ready,
      input  [31:0] io_readOutputs_0_r_payload_data,
      input  [1:0] io_readOutputs_0_r_payload_resp,
      input   io_readOutputs_0_r_payload_last,
      output  io_writeOutputs_0_aw_valid,
      input   io_writeOutputs_0_aw_ready,
      output [31:0] io_writeOutputs_0_aw_payload_addr,
      output [7:0] io_writeOutputs_0_aw_payload_len,
      output [2:0] io_writeOutputs_0_aw_payload_size,
      output [3:0] io_writeOutputs_0_aw_payload_cache,
      output [2:0] io_writeOutputs_0_aw_payload_prot,
      output  io_writeOutputs_0_w_valid,
      input   io_writeOutputs_0_w_ready,
      output [31:0] io_writeOutputs_0_w_payload_data,
      output [3:0] io_writeOutputs_0_w_payload_strb,
      output  io_writeOutputs_0_w_payload_last,
      input   io_writeOutputs_0_b_valid,
      output  io_writeOutputs_0_b_ready,
      input  [1:0] io_writeOutputs_0_b_payload_resp,
      output  io_sharedOutputs_0_arw_valid,
      input   io_sharedOutputs_0_arw_ready,
      output [31:0] io_sharedOutputs_0_arw_payload_addr,
      output [7:0] io_sharedOutputs_0_arw_payload_len,
      output [2:0] io_sharedOutputs_0_arw_payload_size,
      output [3:0] io_sharedOutputs_0_arw_payload_cache,
      output [2:0] io_sharedOutputs_0_arw_payload_prot,
      output  io_sharedOutputs_0_arw_payload_write,
      output  io_sharedOutputs_0_w_valid,
      input   io_sharedOutputs_0_w_ready,
      output [31:0] io_sharedOutputs_0_w_payload_data,
      output [3:0] io_sharedOutputs_0_w_payload_strb,
      output  io_sharedOutputs_0_w_payload_last,
      input   io_sharedOutputs_0_b_valid,
      output  io_sharedOutputs_0_b_ready,
      input  [1:0] io_sharedOutputs_0_b_payload_resp,
      input   io_sharedOutputs_0_r_valid,
      output  io_sharedOutputs_0_r_ready,
      input  [31:0] io_sharedOutputs_0_r_payload_data,
      input  [1:0] io_sharedOutputs_0_r_payload_resp,
      input   io_sharedOutputs_0_r_payload_last,
      output  io_sharedOutputs_1_arw_valid,
      input   io_sharedOutputs_1_arw_ready,
      output [31:0] io_sharedOutputs_1_arw_payload_addr,
      output [7:0] io_sharedOutputs_1_arw_payload_len,
      output [2:0] io_sharedOutputs_1_arw_payload_size,
      output [3:0] io_sharedOutputs_1_arw_payload_cache,
      output [2:0] io_sharedOutputs_1_arw_payload_prot,
      output  io_sharedOutputs_1_arw_payload_write,
      output  io_sharedOutputs_1_w_valid,
      input   io_sharedOutputs_1_w_ready,
      output [31:0] io_sharedOutputs_1_w_payload_data,
      output [3:0] io_sharedOutputs_1_w_payload_strb,
      output  io_sharedOutputs_1_w_payload_last,
      input   io_sharedOutputs_1_b_valid,
      output  io_sharedOutputs_1_b_ready,
      input  [1:0] io_sharedOutputs_1_b_payload_resp,
      input   io_sharedOutputs_1_r_valid,
      output  io_sharedOutputs_1_r_ready,
      input  [31:0] io_sharedOutputs_1_r_payload_data,
      input  [1:0] io_sharedOutputs_1_r_payload_resp,
      input   io_sharedOutputs_1_r_payload_last,
      output  io_sharedOutputs_2_arw_valid,
      input   io_sharedOutputs_2_arw_ready,
      output [31:0] io_sharedOutputs_2_arw_payload_addr,
      output [7:0] io_sharedOutputs_2_arw_payload_len,
      output [2:0] io_sharedOutputs_2_arw_payload_size,
      output [3:0] io_sharedOutputs_2_arw_payload_cache,
      output [2:0] io_sharedOutputs_2_arw_payload_prot,
      output  io_sharedOutputs_2_arw_payload_write,
      output  io_sharedOutputs_2_w_valid,
      input   io_sharedOutputs_2_w_ready,
      output [31:0] io_sharedOutputs_2_w_payload_data,
      output [3:0] io_sharedOutputs_2_w_payload_strb,
      output  io_sharedOutputs_2_w_payload_last,
      input   io_sharedOutputs_2_b_valid,
      output  io_sharedOutputs_2_b_ready,
      input  [1:0] io_sharedOutputs_2_b_payload_resp,
      input   io_sharedOutputs_2_r_valid,
      output  io_sharedOutputs_2_r_ready,
      input  [31:0] io_sharedOutputs_2_r_payload_data,
      input  [1:0] io_sharedOutputs_2_r_payload_resp,
      input   io_sharedOutputs_2_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_14_;
  wire  _zz_15_;
  reg [1:0] _zz_16_;
  reg [31:0] _zz_17_;
  reg [1:0] _zz_18_;
  reg  _zz_19_;
  wire  errorSlave_io_axi_arw_ready;
  wire  errorSlave_io_axi_w_ready;
  wire  errorSlave_io_axi_b_valid;
  wire [1:0] errorSlave_io_axi_b_payload_resp;
  wire  errorSlave_io_axi_r_valid;
  wire [31:0] errorSlave_io_axi_r_payload_data;
  wire [1:0] errorSlave_io_axi_r_payload_resp;
  wire  errorSlave_io_axi_r_payload_last;
  wire [0:0] _zz_20_;
  wire [0:0] _zz_21_;
  wire [0:0] _zz_22_;
  wire [31:0] _zz_23_;
  wire [31:0] _zz_24_;
  wire [31:0] _zz_25_;
  wire [31:0] _zz_26_;
  wire [31:0] _zz_27_;
  wire [31:0] _zz_28_;
  wire [31:0] _zz_29_;
  reg [2:0] _zz_1_;
  reg [2:0] _zz_1__1;
  reg [2:0] _zz_1__0;
  wire  cmdAllowedStart;
  reg [2:0] pendingCmdCounter;
  wire [2:0] _zz_2_;
  reg  pendingDataCounter_incrementIt;
  reg  pendingDataCounter_decrementIt;
  wire [2:0] pendingDataCounter_valueNext;
  reg [2:0] pendingDataCounter_value;
  wire  pendingDataCounter_willOverflowIfInc;
  wire  pendingDataCounter_willOverflow;
  reg [2:0] pendingDataCounter_finalIncrement;
  wire [4:0] decodedCmdSels;
  wire  decodedCmdError;
  reg [4:0] pendingSels;
  reg  pendingError;
  wire  allowCmd;
  wire  allowData;
  reg  _zz_3_;
  wire [2:0] _zz_4_;
  wire [2:0] _zz_5_;
  wire [3:0] _zz_6_;
  wire  _zz_7_;
  wire  _zz_8_;
  wire  _zz_9_;
  wire [1:0] writeRspIndex;
  wire [3:0] _zz_10_;
  wire  _zz_11_;
  wire  _zz_12_;
  wire  _zz_13_;
  wire [1:0] readRspIndex;
  assign _zz_20_ = decodedCmdSels[0 : 0];
  assign _zz_21_ = decodedCmdSels[1 : 1];
  assign _zz_22_ = pendingSels[1 : 1];
  assign _zz_23_ = (32'b00000000000000011111111111111111);
  assign _zz_24_ = (~ (32'b00000000000000011111111111111111));
  assign _zz_25_ = (~ (32'b00000000000000000000111111111111));
  assign _zz_26_ = (32'b11110001000000000000000000000000);
  assign _zz_27_ = (32'b11110101000000000000000000000000);
  assign _zz_28_ = (32'b11110001000000000000000000000000);
  assign _zz_29_ = (32'b11110101000000000000000000000000);
  NoDebug_Axi4SharedErrorSlave errorSlave ( 
    .io_axi_arw_valid(_zz_14_),
    .io_axi_arw_ready(errorSlave_io_axi_arw_ready),
    .io_axi_arw_payload_addr(io_input_arw_payload_addr),
    .io_axi_arw_payload_len(io_input_arw_payload_len),
    .io_axi_arw_payload_size(io_input_arw_payload_size),
    .io_axi_arw_payload_cache(io_input_arw_payload_cache),
    .io_axi_arw_payload_prot(io_input_arw_payload_prot),
    .io_axi_arw_payload_write(io_input_arw_payload_write),
    .io_axi_w_valid(_zz_15_),
    .io_axi_w_ready(errorSlave_io_axi_w_ready),
    .io_axi_w_payload_data(io_input_w_payload_data),
    .io_axi_w_payload_strb(io_input_w_payload_strb),
    .io_axi_w_payload_last(io_input_w_payload_last),
    .io_axi_b_valid(errorSlave_io_axi_b_valid),
    .io_axi_b_ready(io_input_b_ready),
    .io_axi_b_payload_resp(errorSlave_io_axi_b_payload_resp),
    .io_axi_r_valid(errorSlave_io_axi_r_valid),
    .io_axi_r_ready(io_input_r_ready),
    .io_axi_r_payload_data(errorSlave_io_axi_r_payload_data),
    .io_axi_r_payload_resp(errorSlave_io_axi_r_payload_resp),
    .io_axi_r_payload_last(errorSlave_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  always @(*) begin
    case(writeRspIndex)
      2'b00 : begin
        _zz_16_ = io_writeOutputs_0_b_payload_resp;
      end
      2'b01 : begin
        _zz_16_ = io_sharedOutputs_0_b_payload_resp;
      end
      2'b10 : begin
        _zz_16_ = io_sharedOutputs_1_b_payload_resp;
      end
      default : begin
        _zz_16_ = io_sharedOutputs_2_b_payload_resp;
      end
    endcase
  end

  always @(*) begin
    case(readRspIndex)
      2'b00 : begin
        _zz_17_ = io_readOutputs_0_r_payload_data;
        _zz_18_ = io_readOutputs_0_r_payload_resp;
        _zz_19_ = io_readOutputs_0_r_payload_last;
      end
      2'b01 : begin
        _zz_17_ = io_sharedOutputs_0_r_payload_data;
        _zz_18_ = io_sharedOutputs_0_r_payload_resp;
        _zz_19_ = io_sharedOutputs_0_r_payload_last;
      end
      2'b10 : begin
        _zz_17_ = io_sharedOutputs_1_r_payload_data;
        _zz_18_ = io_sharedOutputs_1_r_payload_resp;
        _zz_19_ = io_sharedOutputs_1_r_payload_last;
      end
      default : begin
        _zz_17_ = io_sharedOutputs_2_r_payload_data;
        _zz_18_ = io_sharedOutputs_2_r_payload_resp;
        _zz_19_ = io_sharedOutputs_2_r_payload_last;
      end
    endcase
  end

  always @ (*) begin
    _zz_1_ = _zz_1__1;
    if(((io_input_r_valid && io_input_r_ready) && io_input_r_payload_last))begin
      _zz_1_ = (_zz_1__1 - (3'b001));
    end
  end

  always @ (*) begin
    _zz_1__1 = _zz_1__0;
    if((io_input_b_valid && io_input_b_ready))begin
      _zz_1__1 = (_zz_1__0 - (3'b001));
    end
  end

  always @ (*) begin
    _zz_1__0 = _zz_2_;
    if((io_input_arw_valid && io_input_arw_ready))begin
      _zz_1__0 = (_zz_2_ + (3'b001));
    end
  end

  assign _zz_2_ = pendingCmdCounter;
  always @ (*) begin
    pendingDataCounter_incrementIt = 1'b0;
    if((cmdAllowedStart && io_input_arw_payload_write))begin
      pendingDataCounter_incrementIt = 1'b1;
    end
  end

  always @ (*) begin
    pendingDataCounter_decrementIt = 1'b0;
    if(((io_input_w_valid && io_input_w_ready) && io_input_w_payload_last))begin
      pendingDataCounter_decrementIt = 1'b1;
    end
  end

  assign pendingDataCounter_willOverflowIfInc = ((pendingDataCounter_value == (3'b111)) && (! pendingDataCounter_decrementIt));
  assign pendingDataCounter_willOverflow = (pendingDataCounter_willOverflowIfInc && pendingDataCounter_incrementIt);
  always @ (*) begin
    if((pendingDataCounter_incrementIt && (! pendingDataCounter_decrementIt)))begin
      pendingDataCounter_finalIncrement = (3'b001);
    end else begin
      if(((! pendingDataCounter_incrementIt) && pendingDataCounter_decrementIt))begin
        pendingDataCounter_finalIncrement = (3'b111);
      end else begin
        pendingDataCounter_finalIncrement = (3'b000);
      end
    end
  end

  assign pendingDataCounter_valueNext = (pendingDataCounter_value + pendingDataCounter_finalIncrement);
  assign decodedCmdSels = {{((io_input_arw_payload_addr & (~ _zz_23_)) == (32'b10000000000000000000000000000000)),{((io_input_arw_payload_addr & _zz_24_) == (32'b00000000000000000000000000000000)),((io_input_arw_payload_addr & _zz_25_) == (32'b10000100000000000000000000000000))}},{(((_zz_26_ <= io_input_arw_payload_addr) && (io_input_arw_payload_addr < _zz_27_)) && io_input_arw_payload_write),(((_zz_28_ <= io_input_arw_payload_addr) && (io_input_arw_payload_addr < _zz_29_)) && (! io_input_arw_payload_write))}};
  assign decodedCmdError = (decodedCmdSels == (5'b00000));
  assign allowCmd = ((pendingCmdCounter == (3'b000)) || ((pendingCmdCounter != (3'b111)) && (pendingSels == decodedCmdSels)));
  assign allowData = (pendingDataCounter_value != (3'b000));
  assign cmdAllowedStart = ((io_input_arw_valid && allowCmd) && _zz_3_);
  assign io_input_arw_ready = ((((decodedCmdSels & {io_sharedOutputs_2_arw_ready,{io_sharedOutputs_1_arw_ready,{io_sharedOutputs_0_arw_ready,{io_writeOutputs_0_aw_ready,io_readOutputs_0_ar_ready}}}}) != (5'b00000)) || (decodedCmdError && errorSlave_io_axi_arw_ready)) && allowCmd);
  assign _zz_14_ = ((io_input_arw_valid && decodedCmdError) && allowCmd);
  assign io_readOutputs_0_ar_valid = ((io_input_arw_valid && _zz_20_[0]) && allowCmd);
  assign io_readOutputs_0_ar_payload_addr = io_input_arw_payload_addr;
  assign io_readOutputs_0_ar_payload_len = io_input_arw_payload_len;
  assign io_readOutputs_0_ar_payload_size = io_input_arw_payload_size;
  assign io_readOutputs_0_ar_payload_cache = io_input_arw_payload_cache;
  assign io_readOutputs_0_ar_payload_prot = io_input_arw_payload_prot;
  assign io_writeOutputs_0_aw_valid = ((io_input_arw_valid && _zz_21_[0]) && allowCmd);
  assign io_writeOutputs_0_aw_payload_addr = io_input_arw_payload_addr;
  assign io_writeOutputs_0_aw_payload_len = io_input_arw_payload_len;
  assign io_writeOutputs_0_aw_payload_size = io_input_arw_payload_size;
  assign io_writeOutputs_0_aw_payload_cache = io_input_arw_payload_cache;
  assign io_writeOutputs_0_aw_payload_prot = io_input_arw_payload_prot;
  assign _zz_4_ = decodedCmdSels[4 : 2];
  assign io_sharedOutputs_0_arw_valid = ((io_input_arw_valid && _zz_4_[0]) && allowCmd);
  assign io_sharedOutputs_0_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_0_arw_payload_len = io_input_arw_payload_len;
  assign io_sharedOutputs_0_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_0_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_0_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_0_arw_payload_write = io_input_arw_payload_write;
  assign io_sharedOutputs_1_arw_valid = ((io_input_arw_valid && _zz_4_[1]) && allowCmd);
  assign io_sharedOutputs_1_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_1_arw_payload_len = io_input_arw_payload_len;
  assign io_sharedOutputs_1_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_1_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_1_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_1_arw_payload_write = io_input_arw_payload_write;
  assign io_sharedOutputs_2_arw_valid = ((io_input_arw_valid && _zz_4_[2]) && allowCmd);
  assign io_sharedOutputs_2_arw_payload_addr = io_input_arw_payload_addr;
  assign io_sharedOutputs_2_arw_payload_len = io_input_arw_payload_len;
  assign io_sharedOutputs_2_arw_payload_size = io_input_arw_payload_size;
  assign io_sharedOutputs_2_arw_payload_cache = io_input_arw_payload_cache;
  assign io_sharedOutputs_2_arw_payload_prot = io_input_arw_payload_prot;
  assign io_sharedOutputs_2_arw_payload_write = io_input_arw_payload_write;
  assign io_input_w_ready = (((({pendingSels[4 : 2],pendingSels[1 : 1]} & {io_sharedOutputs_2_w_ready,{io_sharedOutputs_1_w_ready,{io_sharedOutputs_0_w_ready,io_writeOutputs_0_w_ready}}}) != (4'b0000)) || (pendingError && errorSlave_io_axi_w_ready)) && allowData);
  assign _zz_15_ = ((io_input_w_valid && pendingError) && allowData);
  assign io_writeOutputs_0_w_valid = ((io_input_w_valid && _zz_22_[0]) && allowData);
  assign io_writeOutputs_0_w_payload_data = io_input_w_payload_data;
  assign io_writeOutputs_0_w_payload_strb = io_input_w_payload_strb;
  assign io_writeOutputs_0_w_payload_last = io_input_w_payload_last;
  assign _zz_5_ = pendingSels[4 : 2];
  assign io_sharedOutputs_0_w_valid = ((io_input_w_valid && _zz_5_[0]) && allowData);
  assign io_sharedOutputs_0_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_0_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_0_w_payload_last = io_input_w_payload_last;
  assign io_sharedOutputs_1_w_valid = ((io_input_w_valid && _zz_5_[1]) && allowData);
  assign io_sharedOutputs_1_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_1_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_1_w_payload_last = io_input_w_payload_last;
  assign io_sharedOutputs_2_w_valid = ((io_input_w_valid && _zz_5_[2]) && allowData);
  assign io_sharedOutputs_2_w_payload_data = io_input_w_payload_data;
  assign io_sharedOutputs_2_w_payload_strb = io_input_w_payload_strb;
  assign io_sharedOutputs_2_w_payload_last = io_input_w_payload_last;
  assign _zz_6_ = {pendingSels[4 : 2],pendingSels[1 : 1]};
  assign _zz_7_ = _zz_6_[3];
  assign _zz_8_ = (_zz_6_[1] || _zz_7_);
  assign _zz_9_ = (_zz_6_[2] || _zz_7_);
  assign writeRspIndex = {_zz_9_,_zz_8_};
  assign io_input_b_valid = (({io_sharedOutputs_2_b_valid,{io_sharedOutputs_1_b_valid,{io_sharedOutputs_0_b_valid,io_writeOutputs_0_b_valid}}} != (4'b0000)) || errorSlave_io_axi_b_valid);
  always @ (*) begin
    io_input_b_payload_resp = _zz_16_;
    if(pendingError)begin
      io_input_b_payload_resp = errorSlave_io_axi_b_payload_resp;
    end
  end

  assign io_writeOutputs_0_b_ready = io_input_b_ready;
  assign io_sharedOutputs_0_b_ready = io_input_b_ready;
  assign io_sharedOutputs_1_b_ready = io_input_b_ready;
  assign io_sharedOutputs_2_b_ready = io_input_b_ready;
  assign _zz_10_ = {pendingSels[4 : 2],pendingSels[0 : 0]};
  assign _zz_11_ = _zz_10_[3];
  assign _zz_12_ = (_zz_10_[1] || _zz_11_);
  assign _zz_13_ = (_zz_10_[2] || _zz_11_);
  assign readRspIndex = {_zz_13_,_zz_12_};
  assign io_input_r_valid = (({io_sharedOutputs_2_r_valid,{io_sharedOutputs_1_r_valid,{io_sharedOutputs_0_r_valid,io_readOutputs_0_r_valid}}} != (4'b0000)) || errorSlave_io_axi_r_valid);
  assign io_input_r_payload_data = _zz_17_;
  always @ (*) begin
    io_input_r_payload_resp = _zz_18_;
    if(pendingError)begin
      io_input_r_payload_resp = errorSlave_io_axi_r_payload_resp;
    end
  end

  always @ (*) begin
    io_input_r_payload_last = _zz_19_;
    if(pendingError)begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_readOutputs_0_r_ready = io_input_r_ready;
  assign io_sharedOutputs_0_r_ready = io_input_r_ready;
  assign io_sharedOutputs_1_r_ready = io_input_r_ready;
  assign io_sharedOutputs_2_r_ready = io_input_r_ready;
  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      pendingCmdCounter <= (3'b000);
      pendingDataCounter_value <= (3'b000);
      pendingSels <= (5'b00000);
      pendingError <= 1'b0;
      _zz_3_ <= 1'b1;
    end else begin
      pendingCmdCounter <= _zz_1_;
      pendingDataCounter_value <= pendingDataCounter_valueNext;
      if(cmdAllowedStart)begin
        pendingSels <= decodedCmdSels;
      end
      if(cmdAllowedStart)begin
        pendingError <= decodedCmdError;
      end
      if(cmdAllowedStart)begin
        _zz_3_ <= 1'b0;
      end
      if(io_input_arw_ready)begin
        _zz_3_ <= 1'b1;
      end
    end
  end

endmodule

module NoDebug_Axi4SharedArbiter (
      input   io_sharedInputs_0_arw_valid,
      output  io_sharedInputs_0_arw_ready,
      input  [16:0] io_sharedInputs_0_arw_payload_addr,
      input  [3:0] io_sharedInputs_0_arw_payload_id,
      input  [7:0] io_sharedInputs_0_arw_payload_len,
      input  [2:0] io_sharedInputs_0_arw_payload_size,
      input  [1:0] io_sharedInputs_0_arw_payload_burst,
      input   io_sharedInputs_0_arw_payload_write,
      input   io_sharedInputs_0_w_valid,
      output  io_sharedInputs_0_w_ready,
      input  [31:0] io_sharedInputs_0_w_payload_data,
      input  [3:0] io_sharedInputs_0_w_payload_strb,
      input   io_sharedInputs_0_w_payload_last,
      output  io_sharedInputs_0_b_valid,
      input   io_sharedInputs_0_b_ready,
      output [3:0] io_sharedInputs_0_b_payload_id,
      output [1:0] io_sharedInputs_0_b_payload_resp,
      output  io_sharedInputs_0_r_valid,
      input   io_sharedInputs_0_r_ready,
      output [31:0] io_sharedInputs_0_r_payload_data,
      output [3:0] io_sharedInputs_0_r_payload_id,
      output [1:0] io_sharedInputs_0_r_payload_resp,
      output  io_sharedInputs_0_r_payload_last,
      output  io_output_arw_valid,
      input   io_output_arw_ready,
      output [16:0] io_output_arw_payload_addr,
      output [3:0] io_output_arw_payload_id,
      output [7:0] io_output_arw_payload_len,
      output [2:0] io_output_arw_payload_size,
      output [1:0] io_output_arw_payload_burst,
      output  io_output_arw_payload_write,
      output  io_output_w_valid,
      input   io_output_w_ready,
      output [31:0] io_output_w_payload_data,
      output [3:0] io_output_w_payload_strb,
      output  io_output_w_payload_last,
      input   io_output_b_valid,
      output  io_output_b_ready,
      input  [3:0] io_output_b_payload_id,
      input  [1:0] io_output_b_payload_resp,
      input   io_output_r_valid,
      output  io_output_r_ready,
      input  [31:0] io_output_r_payload_data,
      input  [3:0] io_output_r_payload_id,
      input  [1:0] io_output_r_payload_resp,
      input   io_output_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  _zz_1_;
  wire  _zz_2_;
  wire  _zz_3_;
  wire  cmdArbiter_io_inputs_0_ready;
  wire  cmdArbiter_io_output_valid;
  wire [16:0] cmdArbiter_io_output_payload_addr;
  wire [3:0] cmdArbiter_io_output_payload_id;
  wire [7:0] cmdArbiter_io_output_payload_len;
  wire [2:0] cmdArbiter_io_output_payload_size;
  wire [1:0] cmdArbiter_io_output_payload_burst;
  wire  cmdArbiter_io_output_payload_write;
  wire [0:0] cmdArbiter_io_chosenOH;
  wire  streamFork_io_input_ready;
  wire  streamFork_io_outputs_0_valid;
  wire [16:0] streamFork_io_outputs_0_payload_addr;
  wire [3:0] streamFork_io_outputs_0_payload_id;
  wire [7:0] streamFork_io_outputs_0_payload_len;
  wire [2:0] streamFork_io_outputs_0_payload_size;
  wire [1:0] streamFork_io_outputs_0_payload_burst;
  wire  streamFork_io_outputs_0_payload_write;
  wire  streamFork_io_outputs_1_valid;
  wire [16:0] streamFork_io_outputs_1_payload_addr;
  wire [3:0] streamFork_io_outputs_1_payload_id;
  wire [7:0] streamFork_io_outputs_1_payload_len;
  wire [2:0] streamFork_io_outputs_1_payload_size;
  wire [1:0] streamFork_io_outputs_1_payload_burst;
  wire  streamFork_io_outputs_1_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid;
  wire [2:0] streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy;
  wire  _zz_4_;
  wire  inputsCmd_0_valid;
  wire  inputsCmd_0_ready;
  wire [16:0] inputsCmd_0_payload_addr;
  wire [3:0] inputsCmd_0_payload_id;
  wire [7:0] inputsCmd_0_payload_len;
  wire [2:0] inputsCmd_0_payload_size;
  wire [1:0] inputsCmd_0_payload_burst;
  wire  inputsCmd_0_payload_write;
  reg  streamFork_io_outputs_1_thrown_valid;
  wire  streamFork_io_outputs_1_thrown_ready;
  wire [16:0] streamFork_io_outputs_1_thrown_payload_addr;
  wire [3:0] streamFork_io_outputs_1_thrown_payload_id;
  wire [7:0] streamFork_io_outputs_1_thrown_payload_len;
  wire [2:0] streamFork_io_outputs_1_thrown_payload_size;
  wire [1:0] streamFork_io_outputs_1_thrown_payload_burst;
  wire  streamFork_io_outputs_1_thrown_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_valid;
  wire  streamFork_io_outputs_1_thrown_translated_ready;
  wire  writeLogic_routeDataInput_valid;
  wire  writeLogic_routeDataInput_ready;
  wire [31:0] writeLogic_routeDataInput_payload_data;
  wire [3:0] writeLogic_routeDataInput_payload_strb;
  wire  writeLogic_routeDataInput_payload_last;
  wire  writeLogic_writeRspSels_0;
  wire  readRspSels_0;
  assign _zz_4_ = (! streamFork_io_outputs_1_payload_write);
  NoDebug_StreamArbiter cmdArbiter ( 
    .io_inputs_0_valid(inputsCmd_0_valid),
    .io_inputs_0_ready(cmdArbiter_io_inputs_0_ready),
    .io_inputs_0_payload_addr(inputsCmd_0_payload_addr),
    .io_inputs_0_payload_id(inputsCmd_0_payload_id),
    .io_inputs_0_payload_len(inputsCmd_0_payload_len),
    .io_inputs_0_payload_size(inputsCmd_0_payload_size),
    .io_inputs_0_payload_burst(inputsCmd_0_payload_burst),
    .io_inputs_0_payload_write(inputsCmd_0_payload_write),
    .io_output_valid(cmdArbiter_io_output_valid),
    .io_output_ready(streamFork_io_input_ready),
    .io_output_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_output_payload_id(cmdArbiter_io_output_payload_id),
    .io_output_payload_len(cmdArbiter_io_output_payload_len),
    .io_output_payload_size(cmdArbiter_io_output_payload_size),
    .io_output_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_output_payload_write(cmdArbiter_io_output_payload_write),
    .io_chosenOH(cmdArbiter_io_chosenOH),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFork streamFork ( 
    .io_input_valid(cmdArbiter_io_output_valid),
    .io_input_ready(streamFork_io_input_ready),
    .io_input_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_input_payload_id(cmdArbiter_io_output_payload_id),
    .io_input_payload_len(cmdArbiter_io_output_payload_len),
    .io_input_payload_size(cmdArbiter_io_output_payload_size),
    .io_input_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_input_payload_write(cmdArbiter_io_output_payload_write),
    .io_outputs_0_valid(streamFork_io_outputs_0_valid),
    .io_outputs_0_ready(io_output_arw_ready),
    .io_outputs_0_payload_addr(streamFork_io_outputs_0_payload_addr),
    .io_outputs_0_payload_id(streamFork_io_outputs_0_payload_id),
    .io_outputs_0_payload_len(streamFork_io_outputs_0_payload_len),
    .io_outputs_0_payload_size(streamFork_io_outputs_0_payload_size),
    .io_outputs_0_payload_burst(streamFork_io_outputs_0_payload_burst),
    .io_outputs_0_payload_write(streamFork_io_outputs_0_payload_write),
    .io_outputs_1_valid(streamFork_io_outputs_1_valid),
    .io_outputs_1_ready(_zz_1_),
    .io_outputs_1_payload_addr(streamFork_io_outputs_1_payload_addr),
    .io_outputs_1_payload_id(streamFork_io_outputs_1_payload_id),
    .io_outputs_1_payload_len(streamFork_io_outputs_1_payload_len),
    .io_outputs_1_payload_size(streamFork_io_outputs_1_payload_size),
    .io_outputs_1_payload_burst(streamFork_io_outputs_1_payload_burst),
    .io_outputs_1_payload_write(streamFork_io_outputs_1_payload_write),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFifoLowLatency streamFork_io_outputs_1_thrown_translated_fifo ( 
    .io_push_valid(streamFork_io_outputs_1_thrown_translated_valid),
    .io_push_ready(streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready),
    .io_pop_valid(streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid),
    .io_pop_ready(_zz_2_),
    .io_flush(_zz_3_),
    .io_occupancy(streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  assign inputsCmd_0_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_0_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_0_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_0_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_0_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_0_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign io_output_arw_valid = streamFork_io_outputs_0_valid;
  assign io_output_arw_payload_addr = streamFork_io_outputs_0_payload_addr;
  assign io_output_arw_payload_len = streamFork_io_outputs_0_payload_len;
  assign io_output_arw_payload_size = streamFork_io_outputs_0_payload_size;
  assign io_output_arw_payload_burst = streamFork_io_outputs_0_payload_burst;
  assign io_output_arw_payload_write = streamFork_io_outputs_0_payload_write;
  assign io_output_arw_payload_id = (streamFork_io_outputs_0_payload_write ? streamFork_io_outputs_0_payload_id : streamFork_io_outputs_0_payload_id);
  always @ (*) begin
    streamFork_io_outputs_1_thrown_valid = streamFork_io_outputs_1_valid;
    if(_zz_4_)begin
      streamFork_io_outputs_1_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_1_ = streamFork_io_outputs_1_thrown_ready;
    if(_zz_4_)begin
      _zz_1_ = 1'b1;
    end
  end

  assign streamFork_io_outputs_1_thrown_payload_addr = streamFork_io_outputs_1_payload_addr;
  assign streamFork_io_outputs_1_thrown_payload_id = streamFork_io_outputs_1_payload_id;
  assign streamFork_io_outputs_1_thrown_payload_len = streamFork_io_outputs_1_payload_len;
  assign streamFork_io_outputs_1_thrown_payload_size = streamFork_io_outputs_1_payload_size;
  assign streamFork_io_outputs_1_thrown_payload_burst = streamFork_io_outputs_1_payload_burst;
  assign streamFork_io_outputs_1_thrown_payload_write = streamFork_io_outputs_1_payload_write;
  assign streamFork_io_outputs_1_thrown_translated_valid = streamFork_io_outputs_1_thrown_valid;
  assign streamFork_io_outputs_1_thrown_ready = streamFork_io_outputs_1_thrown_translated_ready;
  assign streamFork_io_outputs_1_thrown_translated_ready = streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign _zz_2_ = ((io_output_w_valid && io_output_w_ready) && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id;
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspSels_0 = 1'b1;
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id;
  assign io_output_r_ready = io_sharedInputs_0_r_ready;
  assign _zz_3_ = 1'b0;
endmodule

module NoDebug_Axi4SharedArbiter_1_ (
      input   io_sharedInputs_0_arw_valid,
      output  io_sharedInputs_0_arw_ready,
      input  [11:0] io_sharedInputs_0_arw_payload_addr,
      input  [3:0] io_sharedInputs_0_arw_payload_id,
      input  [7:0] io_sharedInputs_0_arw_payload_len,
      input  [2:0] io_sharedInputs_0_arw_payload_size,
      input  [1:0] io_sharedInputs_0_arw_payload_burst,
      input   io_sharedInputs_0_arw_payload_write,
      input   io_sharedInputs_0_w_valid,
      output  io_sharedInputs_0_w_ready,
      input  [31:0] io_sharedInputs_0_w_payload_data,
      input  [3:0] io_sharedInputs_0_w_payload_strb,
      input   io_sharedInputs_0_w_payload_last,
      output  io_sharedInputs_0_b_valid,
      input   io_sharedInputs_0_b_ready,
      output [3:0] io_sharedInputs_0_b_payload_id,
      output [1:0] io_sharedInputs_0_b_payload_resp,
      output  io_sharedInputs_0_r_valid,
      input   io_sharedInputs_0_r_ready,
      output [31:0] io_sharedInputs_0_r_payload_data,
      output [3:0] io_sharedInputs_0_r_payload_id,
      output [1:0] io_sharedInputs_0_r_payload_resp,
      output  io_sharedInputs_0_r_payload_last,
      output  io_output_arw_valid,
      input   io_output_arw_ready,
      output [11:0] io_output_arw_payload_addr,
      output [3:0] io_output_arw_payload_id,
      output [7:0] io_output_arw_payload_len,
      output [2:0] io_output_arw_payload_size,
      output [1:0] io_output_arw_payload_burst,
      output  io_output_arw_payload_write,
      output  io_output_w_valid,
      input   io_output_w_ready,
      output [31:0] io_output_w_payload_data,
      output [3:0] io_output_w_payload_strb,
      output  io_output_w_payload_last,
      input   io_output_b_valid,
      output  io_output_b_ready,
      input  [3:0] io_output_b_payload_id,
      input  [1:0] io_output_b_payload_resp,
      input   io_output_r_valid,
      output  io_output_r_ready,
      input  [31:0] io_output_r_payload_data,
      input  [3:0] io_output_r_payload_id,
      input  [1:0] io_output_r_payload_resp,
      input   io_output_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  _zz_1_;
  wire  _zz_2_;
  wire  _zz_3_;
  wire  cmdArbiter_io_inputs_0_ready;
  wire  cmdArbiter_io_output_valid;
  wire [11:0] cmdArbiter_io_output_payload_addr;
  wire [3:0] cmdArbiter_io_output_payload_id;
  wire [7:0] cmdArbiter_io_output_payload_len;
  wire [2:0] cmdArbiter_io_output_payload_size;
  wire [1:0] cmdArbiter_io_output_payload_burst;
  wire  cmdArbiter_io_output_payload_write;
  wire [0:0] cmdArbiter_io_chosenOH;
  wire  streamFork_io_input_ready;
  wire  streamFork_io_outputs_0_valid;
  wire [11:0] streamFork_io_outputs_0_payload_addr;
  wire [3:0] streamFork_io_outputs_0_payload_id;
  wire [7:0] streamFork_io_outputs_0_payload_len;
  wire [2:0] streamFork_io_outputs_0_payload_size;
  wire [1:0] streamFork_io_outputs_0_payload_burst;
  wire  streamFork_io_outputs_0_payload_write;
  wire  streamFork_io_outputs_1_valid;
  wire [11:0] streamFork_io_outputs_1_payload_addr;
  wire [3:0] streamFork_io_outputs_1_payload_id;
  wire [7:0] streamFork_io_outputs_1_payload_len;
  wire [2:0] streamFork_io_outputs_1_payload_size;
  wire [1:0] streamFork_io_outputs_1_payload_burst;
  wire  streamFork_io_outputs_1_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid;
  wire [2:0] streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy;
  wire  _zz_4_;
  wire  inputsCmd_0_valid;
  wire  inputsCmd_0_ready;
  wire [11:0] inputsCmd_0_payload_addr;
  wire [3:0] inputsCmd_0_payload_id;
  wire [7:0] inputsCmd_0_payload_len;
  wire [2:0] inputsCmd_0_payload_size;
  wire [1:0] inputsCmd_0_payload_burst;
  wire  inputsCmd_0_payload_write;
  reg  streamFork_io_outputs_1_thrown_valid;
  wire  streamFork_io_outputs_1_thrown_ready;
  wire [11:0] streamFork_io_outputs_1_thrown_payload_addr;
  wire [3:0] streamFork_io_outputs_1_thrown_payload_id;
  wire [7:0] streamFork_io_outputs_1_thrown_payload_len;
  wire [2:0] streamFork_io_outputs_1_thrown_payload_size;
  wire [1:0] streamFork_io_outputs_1_thrown_payload_burst;
  wire  streamFork_io_outputs_1_thrown_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_valid;
  wire  streamFork_io_outputs_1_thrown_translated_ready;
  wire  writeLogic_routeDataInput_valid;
  wire  writeLogic_routeDataInput_ready;
  wire [31:0] writeLogic_routeDataInput_payload_data;
  wire [3:0] writeLogic_routeDataInput_payload_strb;
  wire  writeLogic_routeDataInput_payload_last;
  wire  writeLogic_writeRspSels_0;
  wire  readRspSels_0;
  assign _zz_4_ = (! streamFork_io_outputs_1_payload_write);
  NoDebug_StreamArbiter_1_ cmdArbiter ( 
    .io_inputs_0_valid(inputsCmd_0_valid),
    .io_inputs_0_ready(cmdArbiter_io_inputs_0_ready),
    .io_inputs_0_payload_addr(inputsCmd_0_payload_addr),
    .io_inputs_0_payload_id(inputsCmd_0_payload_id),
    .io_inputs_0_payload_len(inputsCmd_0_payload_len),
    .io_inputs_0_payload_size(inputsCmd_0_payload_size),
    .io_inputs_0_payload_burst(inputsCmd_0_payload_burst),
    .io_inputs_0_payload_write(inputsCmd_0_payload_write),
    .io_output_valid(cmdArbiter_io_output_valid),
    .io_output_ready(streamFork_io_input_ready),
    .io_output_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_output_payload_id(cmdArbiter_io_output_payload_id),
    .io_output_payload_len(cmdArbiter_io_output_payload_len),
    .io_output_payload_size(cmdArbiter_io_output_payload_size),
    .io_output_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_output_payload_write(cmdArbiter_io_output_payload_write),
    .io_chosenOH(cmdArbiter_io_chosenOH),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFork_1_ streamFork ( 
    .io_input_valid(cmdArbiter_io_output_valid),
    .io_input_ready(streamFork_io_input_ready),
    .io_input_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_input_payload_id(cmdArbiter_io_output_payload_id),
    .io_input_payload_len(cmdArbiter_io_output_payload_len),
    .io_input_payload_size(cmdArbiter_io_output_payload_size),
    .io_input_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_input_payload_write(cmdArbiter_io_output_payload_write),
    .io_outputs_0_valid(streamFork_io_outputs_0_valid),
    .io_outputs_0_ready(io_output_arw_ready),
    .io_outputs_0_payload_addr(streamFork_io_outputs_0_payload_addr),
    .io_outputs_0_payload_id(streamFork_io_outputs_0_payload_id),
    .io_outputs_0_payload_len(streamFork_io_outputs_0_payload_len),
    .io_outputs_0_payload_size(streamFork_io_outputs_0_payload_size),
    .io_outputs_0_payload_burst(streamFork_io_outputs_0_payload_burst),
    .io_outputs_0_payload_write(streamFork_io_outputs_0_payload_write),
    .io_outputs_1_valid(streamFork_io_outputs_1_valid),
    .io_outputs_1_ready(_zz_1_),
    .io_outputs_1_payload_addr(streamFork_io_outputs_1_payload_addr),
    .io_outputs_1_payload_id(streamFork_io_outputs_1_payload_id),
    .io_outputs_1_payload_len(streamFork_io_outputs_1_payload_len),
    .io_outputs_1_payload_size(streamFork_io_outputs_1_payload_size),
    .io_outputs_1_payload_burst(streamFork_io_outputs_1_payload_burst),
    .io_outputs_1_payload_write(streamFork_io_outputs_1_payload_write),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFifoLowLatency streamFork_io_outputs_1_thrown_translated_fifo ( 
    .io_push_valid(streamFork_io_outputs_1_thrown_translated_valid),
    .io_push_ready(streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready),
    .io_pop_valid(streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid),
    .io_pop_ready(_zz_2_),
    .io_flush(_zz_3_),
    .io_occupancy(streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  assign inputsCmd_0_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_0_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_0_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_0_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_0_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_0_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign io_output_arw_valid = streamFork_io_outputs_0_valid;
  assign io_output_arw_payload_addr = streamFork_io_outputs_0_payload_addr;
  assign io_output_arw_payload_len = streamFork_io_outputs_0_payload_len;
  assign io_output_arw_payload_size = streamFork_io_outputs_0_payload_size;
  assign io_output_arw_payload_burst = streamFork_io_outputs_0_payload_burst;
  assign io_output_arw_payload_write = streamFork_io_outputs_0_payload_write;
  assign io_output_arw_payload_id = (streamFork_io_outputs_0_payload_write ? streamFork_io_outputs_0_payload_id : streamFork_io_outputs_0_payload_id);
  always @ (*) begin
    streamFork_io_outputs_1_thrown_valid = streamFork_io_outputs_1_valid;
    if(_zz_4_)begin
      streamFork_io_outputs_1_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_1_ = streamFork_io_outputs_1_thrown_ready;
    if(_zz_4_)begin
      _zz_1_ = 1'b1;
    end
  end

  assign streamFork_io_outputs_1_thrown_payload_addr = streamFork_io_outputs_1_payload_addr;
  assign streamFork_io_outputs_1_thrown_payload_id = streamFork_io_outputs_1_payload_id;
  assign streamFork_io_outputs_1_thrown_payload_len = streamFork_io_outputs_1_payload_len;
  assign streamFork_io_outputs_1_thrown_payload_size = streamFork_io_outputs_1_payload_size;
  assign streamFork_io_outputs_1_thrown_payload_burst = streamFork_io_outputs_1_payload_burst;
  assign streamFork_io_outputs_1_thrown_payload_write = streamFork_io_outputs_1_payload_write;
  assign streamFork_io_outputs_1_thrown_translated_valid = streamFork_io_outputs_1_thrown_valid;
  assign streamFork_io_outputs_1_thrown_ready = streamFork_io_outputs_1_thrown_translated_ready;
  assign streamFork_io_outputs_1_thrown_translated_ready = streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign _zz_2_ = ((io_output_w_valid && io_output_w_ready) && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id;
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspSels_0 = 1'b1;
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id;
  assign io_output_r_ready = io_sharedInputs_0_r_ready;
  assign _zz_3_ = 1'b0;
endmodule

module NoDebug_Axi4SharedArbiter_2_ (
      input   io_readInputs_0_ar_valid,
      output  io_readInputs_0_ar_ready,
      input  [16:0] io_readInputs_0_ar_payload_addr,
      input  [2:0] io_readInputs_0_ar_payload_id,
      input  [7:0] io_readInputs_0_ar_payload_len,
      input  [2:0] io_readInputs_0_ar_payload_size,
      input  [1:0] io_readInputs_0_ar_payload_burst,
      output  io_readInputs_0_r_valid,
      input   io_readInputs_0_r_ready,
      output [31:0] io_readInputs_0_r_payload_data,
      output [2:0] io_readInputs_0_r_payload_id,
      output [1:0] io_readInputs_0_r_payload_resp,
      output  io_readInputs_0_r_payload_last,
      input   io_sharedInputs_0_arw_valid,
      output  io_sharedInputs_0_arw_ready,
      input  [16:0] io_sharedInputs_0_arw_payload_addr,
      input  [2:0] io_sharedInputs_0_arw_payload_id,
      input  [7:0] io_sharedInputs_0_arw_payload_len,
      input  [2:0] io_sharedInputs_0_arw_payload_size,
      input  [1:0] io_sharedInputs_0_arw_payload_burst,
      input   io_sharedInputs_0_arw_payload_write,
      input   io_sharedInputs_0_w_valid,
      output  io_sharedInputs_0_w_ready,
      input  [31:0] io_sharedInputs_0_w_payload_data,
      input  [3:0] io_sharedInputs_0_w_payload_strb,
      input   io_sharedInputs_0_w_payload_last,
      output  io_sharedInputs_0_b_valid,
      input   io_sharedInputs_0_b_ready,
      output [2:0] io_sharedInputs_0_b_payload_id,
      output [1:0] io_sharedInputs_0_b_payload_resp,
      output  io_sharedInputs_0_r_valid,
      input   io_sharedInputs_0_r_ready,
      output [31:0] io_sharedInputs_0_r_payload_data,
      output [2:0] io_sharedInputs_0_r_payload_id,
      output [1:0] io_sharedInputs_0_r_payload_resp,
      output  io_sharedInputs_0_r_payload_last,
      output  io_output_arw_valid,
      input   io_output_arw_ready,
      output [16:0] io_output_arw_payload_addr,
      output [3:0] io_output_arw_payload_id,
      output [7:0] io_output_arw_payload_len,
      output [2:0] io_output_arw_payload_size,
      output [1:0] io_output_arw_payload_burst,
      output  io_output_arw_payload_write,
      output  io_output_w_valid,
      input   io_output_w_ready,
      output [31:0] io_output_w_payload_data,
      output [3:0] io_output_w_payload_strb,
      output  io_output_w_payload_last,
      input   io_output_b_valid,
      output  io_output_b_ready,
      input  [3:0] io_output_b_payload_id,
      input  [1:0] io_output_b_payload_resp,
      input   io_output_r_valid,
      output  io_output_r_ready,
      input  [31:0] io_output_r_payload_data,
      input  [3:0] io_output_r_payload_id,
      input  [1:0] io_output_r_payload_resp,
      input   io_output_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  reg  _zz_2_;
  wire  _zz_3_;
  wire  _zz_4_;
  reg  _zz_5_;
  wire  cmdArbiter_io_inputs_0_ready;
  wire  cmdArbiter_io_inputs_1_ready;
  wire  cmdArbiter_io_output_valid;
  wire [16:0] cmdArbiter_io_output_payload_addr;
  wire [2:0] cmdArbiter_io_output_payload_id;
  wire [7:0] cmdArbiter_io_output_payload_len;
  wire [2:0] cmdArbiter_io_output_payload_size;
  wire [1:0] cmdArbiter_io_output_payload_burst;
  wire  cmdArbiter_io_output_payload_write;
  wire [0:0] cmdArbiter_io_chosen;
  wire [1:0] cmdArbiter_io_chosenOH;
  wire  streamFork_io_input_ready;
  wire  streamFork_io_outputs_0_valid;
  wire [16:0] streamFork_io_outputs_0_payload_addr;
  wire [2:0] streamFork_io_outputs_0_payload_id;
  wire [7:0] streamFork_io_outputs_0_payload_len;
  wire [2:0] streamFork_io_outputs_0_payload_size;
  wire [1:0] streamFork_io_outputs_0_payload_burst;
  wire  streamFork_io_outputs_0_payload_write;
  wire  streamFork_io_outputs_1_valid;
  wire [16:0] streamFork_io_outputs_1_payload_addr;
  wire [2:0] streamFork_io_outputs_1_payload_id;
  wire [7:0] streamFork_io_outputs_1_payload_len;
  wire [2:0] streamFork_io_outputs_1_payload_size;
  wire [1:0] streamFork_io_outputs_1_payload_burst;
  wire  streamFork_io_outputs_1_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  wire  streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid;
  wire [2:0] streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy;
  wire  _zz_6_;
  wire [1:0] _zz_7_;
  wire [2:0] _zz_8_;
  wire [3:0] _zz_9_;
  wire  inputsCmd_0_valid;
  wire  inputsCmd_0_ready;
  wire [16:0] inputsCmd_0_payload_addr;
  wire [2:0] inputsCmd_0_payload_id;
  wire [7:0] inputsCmd_0_payload_len;
  wire [2:0] inputsCmd_0_payload_size;
  wire [1:0] inputsCmd_0_payload_burst;
  wire  inputsCmd_0_payload_write;
  wire  inputsCmd_1_valid;
  wire  inputsCmd_1_ready;
  wire [16:0] inputsCmd_1_payload_addr;
  wire [2:0] inputsCmd_1_payload_id;
  wire [7:0] inputsCmd_1_payload_len;
  wire [2:0] inputsCmd_1_payload_size;
  wire [1:0] inputsCmd_1_payload_burst;
  wire  inputsCmd_1_payload_write;
  wire  _zz_1_;
  reg  streamFork_io_outputs_1_thrown_valid;
  wire  streamFork_io_outputs_1_thrown_ready;
  wire [16:0] streamFork_io_outputs_1_thrown_payload_addr;
  wire [2:0] streamFork_io_outputs_1_thrown_payload_id;
  wire [7:0] streamFork_io_outputs_1_thrown_payload_len;
  wire [2:0] streamFork_io_outputs_1_thrown_payload_size;
  wire [1:0] streamFork_io_outputs_1_thrown_payload_burst;
  wire  streamFork_io_outputs_1_thrown_payload_write;
  wire  streamFork_io_outputs_1_thrown_translated_valid;
  wire  streamFork_io_outputs_1_thrown_translated_ready;
  wire  writeLogic_routeDataInput_valid;
  wire  writeLogic_routeDataInput_ready;
  wire [31:0] writeLogic_routeDataInput_payload_data;
  wire [3:0] writeLogic_routeDataInput_payload_strb;
  wire  writeLogic_routeDataInput_payload_last;
  wire  writeLogic_writeRspSels_0;
  wire [0:0] readRspIndex;
  wire  readRspSels_0;
  wire  readRspSels_1;
  assign _zz_6_ = (! streamFork_io_outputs_1_payload_write);
  assign _zz_7_ = {cmdArbiter_io_chosenOH[1 : 1],cmdArbiter_io_chosenOH[0 : 0]};
  assign _zz_8_ = streamFork_io_outputs_0_payload_id;
  assign _zz_9_ = {1'd0, _zz_8_};
  NoDebug_StreamArbiter_2_ cmdArbiter ( 
    .io_inputs_0_valid(inputsCmd_0_valid),
    .io_inputs_0_ready(cmdArbiter_io_inputs_0_ready),
    .io_inputs_0_payload_addr(inputsCmd_0_payload_addr),
    .io_inputs_0_payload_id(inputsCmd_0_payload_id),
    .io_inputs_0_payload_len(inputsCmd_0_payload_len),
    .io_inputs_0_payload_size(inputsCmd_0_payload_size),
    .io_inputs_0_payload_burst(inputsCmd_0_payload_burst),
    .io_inputs_0_payload_write(inputsCmd_0_payload_write),
    .io_inputs_1_valid(inputsCmd_1_valid),
    .io_inputs_1_ready(cmdArbiter_io_inputs_1_ready),
    .io_inputs_1_payload_addr(inputsCmd_1_payload_addr),
    .io_inputs_1_payload_id(inputsCmd_1_payload_id),
    .io_inputs_1_payload_len(inputsCmd_1_payload_len),
    .io_inputs_1_payload_size(inputsCmd_1_payload_size),
    .io_inputs_1_payload_burst(inputsCmd_1_payload_burst),
    .io_inputs_1_payload_write(inputsCmd_1_payload_write),
    .io_output_valid(cmdArbiter_io_output_valid),
    .io_output_ready(streamFork_io_input_ready),
    .io_output_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_output_payload_id(cmdArbiter_io_output_payload_id),
    .io_output_payload_len(cmdArbiter_io_output_payload_len),
    .io_output_payload_size(cmdArbiter_io_output_payload_size),
    .io_output_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_output_payload_write(cmdArbiter_io_output_payload_write),
    .io_chosen(cmdArbiter_io_chosen),
    .io_chosenOH(cmdArbiter_io_chosenOH),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFork_2_ streamFork ( 
    .io_input_valid(cmdArbiter_io_output_valid),
    .io_input_ready(streamFork_io_input_ready),
    .io_input_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_input_payload_id(cmdArbiter_io_output_payload_id),
    .io_input_payload_len(cmdArbiter_io_output_payload_len),
    .io_input_payload_size(cmdArbiter_io_output_payload_size),
    .io_input_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_input_payload_write(cmdArbiter_io_output_payload_write),
    .io_outputs_0_valid(streamFork_io_outputs_0_valid),
    .io_outputs_0_ready(io_output_arw_ready),
    .io_outputs_0_payload_addr(streamFork_io_outputs_0_payload_addr),
    .io_outputs_0_payload_id(streamFork_io_outputs_0_payload_id),
    .io_outputs_0_payload_len(streamFork_io_outputs_0_payload_len),
    .io_outputs_0_payload_size(streamFork_io_outputs_0_payload_size),
    .io_outputs_0_payload_burst(streamFork_io_outputs_0_payload_burst),
    .io_outputs_0_payload_write(streamFork_io_outputs_0_payload_write),
    .io_outputs_1_valid(streamFork_io_outputs_1_valid),
    .io_outputs_1_ready(_zz_2_),
    .io_outputs_1_payload_addr(streamFork_io_outputs_1_payload_addr),
    .io_outputs_1_payload_id(streamFork_io_outputs_1_payload_id),
    .io_outputs_1_payload_len(streamFork_io_outputs_1_payload_len),
    .io_outputs_1_payload_size(streamFork_io_outputs_1_payload_size),
    .io_outputs_1_payload_burst(streamFork_io_outputs_1_payload_burst),
    .io_outputs_1_payload_write(streamFork_io_outputs_1_payload_write),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFifoLowLatency streamFork_io_outputs_1_thrown_translated_fifo ( 
    .io_push_valid(streamFork_io_outputs_1_thrown_translated_valid),
    .io_push_ready(streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready),
    .io_pop_valid(streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid),
    .io_pop_ready(_zz_3_),
    .io_flush(_zz_4_),
    .io_occupancy(streamFork_io_outputs_1_thrown_translated_fifo_io_occupancy),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  always @(*) begin
    case(readRspIndex)
      1'b0 : begin
        _zz_5_ = io_readInputs_0_r_ready;
      end
      default : begin
        _zz_5_ = io_sharedInputs_0_r_ready;
      end
    endcase
  end

  assign inputsCmd_0_valid = io_readInputs_0_ar_valid;
  assign io_readInputs_0_ar_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_readInputs_0_ar_payload_addr;
  assign inputsCmd_0_payload_id = io_readInputs_0_ar_payload_id;
  assign inputsCmd_0_payload_len = io_readInputs_0_ar_payload_len;
  assign inputsCmd_0_payload_size = io_readInputs_0_ar_payload_size;
  assign inputsCmd_0_payload_burst = io_readInputs_0_ar_payload_burst;
  assign inputsCmd_0_payload_write = 1'b0;
  assign inputsCmd_1_valid = io_sharedInputs_0_arw_valid;
  assign io_sharedInputs_0_arw_ready = inputsCmd_1_ready;
  assign inputsCmd_1_payload_addr = io_sharedInputs_0_arw_payload_addr;
  assign inputsCmd_1_payload_id = io_sharedInputs_0_arw_payload_id;
  assign inputsCmd_1_payload_len = io_sharedInputs_0_arw_payload_len;
  assign inputsCmd_1_payload_size = io_sharedInputs_0_arw_payload_size;
  assign inputsCmd_1_payload_burst = io_sharedInputs_0_arw_payload_burst;
  assign inputsCmd_1_payload_write = io_sharedInputs_0_arw_payload_write;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign inputsCmd_1_ready = cmdArbiter_io_inputs_1_ready;
  assign io_output_arw_valid = streamFork_io_outputs_0_valid;
  assign io_output_arw_payload_addr = streamFork_io_outputs_0_payload_addr;
  assign io_output_arw_payload_len = streamFork_io_outputs_0_payload_len;
  assign io_output_arw_payload_size = streamFork_io_outputs_0_payload_size;
  assign io_output_arw_payload_burst = streamFork_io_outputs_0_payload_burst;
  assign io_output_arw_payload_write = streamFork_io_outputs_0_payload_write;
  assign _zz_1_ = _zz_7_[1];
  assign io_output_arw_payload_id = (streamFork_io_outputs_0_payload_write ? _zz_9_ : {_zz_1_,streamFork_io_outputs_0_payload_id});
  always @ (*) begin
    streamFork_io_outputs_1_thrown_valid = streamFork_io_outputs_1_valid;
    if(_zz_6_)begin
      streamFork_io_outputs_1_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_2_ = streamFork_io_outputs_1_thrown_ready;
    if(_zz_6_)begin
      _zz_2_ = 1'b1;
    end
  end

  assign streamFork_io_outputs_1_thrown_payload_addr = streamFork_io_outputs_1_payload_addr;
  assign streamFork_io_outputs_1_thrown_payload_id = streamFork_io_outputs_1_payload_id;
  assign streamFork_io_outputs_1_thrown_payload_len = streamFork_io_outputs_1_payload_len;
  assign streamFork_io_outputs_1_thrown_payload_size = streamFork_io_outputs_1_payload_size;
  assign streamFork_io_outputs_1_thrown_payload_burst = streamFork_io_outputs_1_payload_burst;
  assign streamFork_io_outputs_1_thrown_payload_write = streamFork_io_outputs_1_payload_write;
  assign streamFork_io_outputs_1_thrown_translated_valid = streamFork_io_outputs_1_thrown_valid;
  assign streamFork_io_outputs_1_thrown_ready = streamFork_io_outputs_1_thrown_translated_ready;
  assign streamFork_io_outputs_1_thrown_translated_ready = streamFork_io_outputs_1_thrown_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = io_sharedInputs_0_w_valid;
  assign writeLogic_routeDataInput_ready = io_sharedInputs_0_w_ready;
  assign writeLogic_routeDataInput_payload_data = io_sharedInputs_0_w_payload_data;
  assign writeLogic_routeDataInput_payload_strb = io_sharedInputs_0_w_payload_strb;
  assign writeLogic_routeDataInput_payload_last = io_sharedInputs_0_w_payload_last;
  assign io_output_w_valid = (streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_sharedInputs_0_w_ready = ((streamFork_io_outputs_1_thrown_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign _zz_3_ = ((io_output_w_valid && io_output_w_ready) && io_output_w_payload_last);
  assign writeLogic_writeRspSels_0 = 1'b1;
  assign io_sharedInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_sharedInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_sharedInputs_0_b_payload_id = io_output_b_payload_id[2:0];
  assign io_output_b_ready = io_sharedInputs_0_b_ready;
  assign readRspIndex = io_output_r_payload_id[3 : 3];
  assign readRspSels_0 = (readRspIndex == (1'b0));
  assign readRspSels_1 = (readRspIndex == (1'b1));
  assign io_readInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_readInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_0_r_payload_id = io_output_r_payload_id[2:0];
  assign io_sharedInputs_0_r_valid = (io_output_r_valid && readRspSels_1);
  assign io_sharedInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_sharedInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_sharedInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_sharedInputs_0_r_payload_id = io_output_r_payload_id[2:0];
  assign io_output_r_ready = _zz_5_;
  assign _zz_4_ = 1'b0;
endmodule

module NoDebug_Axi4ReadOnlyArbiter (
      input   io_inputs_0_ar_valid,
      output  io_inputs_0_ar_ready,
      input  [31:0] io_inputs_0_ar_payload_addr,
      input  [3:0] io_inputs_0_ar_payload_id,
      input  [3:0] io_inputs_0_ar_payload_region,
      input  [7:0] io_inputs_0_ar_payload_len,
      input  [2:0] io_inputs_0_ar_payload_size,
      input  [1:0] io_inputs_0_ar_payload_burst,
      input  [0:0] io_inputs_0_ar_payload_lock,
      input  [3:0] io_inputs_0_ar_payload_cache,
      input  [3:0] io_inputs_0_ar_payload_qos,
      input  [2:0] io_inputs_0_ar_payload_prot,
      output  io_inputs_0_r_valid,
      input   io_inputs_0_r_ready,
      output [31:0] io_inputs_0_r_payload_data,
      output [3:0] io_inputs_0_r_payload_id,
      output [1:0] io_inputs_0_r_payload_resp,
      output  io_inputs_0_r_payload_last,
      output  io_output_ar_valid,
      input   io_output_ar_ready,
      output [31:0] io_output_ar_payload_addr,
      output [3:0] io_output_ar_payload_id,
      output [3:0] io_output_ar_payload_region,
      output [7:0] io_output_ar_payload_len,
      output [2:0] io_output_ar_payload_size,
      output [1:0] io_output_ar_payload_burst,
      output [0:0] io_output_ar_payload_lock,
      output [3:0] io_output_ar_payload_cache,
      output [3:0] io_output_ar_payload_qos,
      output [2:0] io_output_ar_payload_prot,
      input   io_output_r_valid,
      output  io_output_r_ready,
      input  [31:0] io_output_r_payload_data,
      input  [3:0] io_output_r_payload_id,
      input  [1:0] io_output_r_payload_resp,
      input   io_output_r_payload_last,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  cmdArbiter_io_inputs_0_ready;
  wire  cmdArbiter_io_output_valid;
  wire [31:0] cmdArbiter_io_output_payload_addr;
  wire [3:0] cmdArbiter_io_output_payload_id;
  wire [3:0] cmdArbiter_io_output_payload_region;
  wire [7:0] cmdArbiter_io_output_payload_len;
  wire [2:0] cmdArbiter_io_output_payload_size;
  wire [1:0] cmdArbiter_io_output_payload_burst;
  wire [0:0] cmdArbiter_io_output_payload_lock;
  wire [3:0] cmdArbiter_io_output_payload_cache;
  wire [3:0] cmdArbiter_io_output_payload_qos;
  wire [2:0] cmdArbiter_io_output_payload_prot;
  wire [0:0] cmdArbiter_io_chosenOH;
  wire  readRspSels_0;
  NoDebug_StreamArbiter_3_ cmdArbiter ( 
    .io_inputs_0_valid(io_inputs_0_ar_valid),
    .io_inputs_0_ready(cmdArbiter_io_inputs_0_ready),
    .io_inputs_0_payload_addr(io_inputs_0_ar_payload_addr),
    .io_inputs_0_payload_id(io_inputs_0_ar_payload_id),
    .io_inputs_0_payload_region(io_inputs_0_ar_payload_region),
    .io_inputs_0_payload_len(io_inputs_0_ar_payload_len),
    .io_inputs_0_payload_size(io_inputs_0_ar_payload_size),
    .io_inputs_0_payload_burst(io_inputs_0_ar_payload_burst),
    .io_inputs_0_payload_lock(io_inputs_0_ar_payload_lock),
    .io_inputs_0_payload_cache(io_inputs_0_ar_payload_cache),
    .io_inputs_0_payload_qos(io_inputs_0_ar_payload_qos),
    .io_inputs_0_payload_prot(io_inputs_0_ar_payload_prot),
    .io_output_valid(cmdArbiter_io_output_valid),
    .io_output_ready(io_output_ar_ready),
    .io_output_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_output_payload_id(cmdArbiter_io_output_payload_id),
    .io_output_payload_region(cmdArbiter_io_output_payload_region),
    .io_output_payload_len(cmdArbiter_io_output_payload_len),
    .io_output_payload_size(cmdArbiter_io_output_payload_size),
    .io_output_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_output_payload_lock(cmdArbiter_io_output_payload_lock),
    .io_output_payload_cache(cmdArbiter_io_output_payload_cache),
    .io_output_payload_qos(cmdArbiter_io_output_payload_qos),
    .io_output_payload_prot(cmdArbiter_io_output_payload_prot),
    .io_chosenOH(cmdArbiter_io_chosenOH),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  assign io_inputs_0_ar_ready = cmdArbiter_io_inputs_0_ready;
  assign io_output_ar_valid = cmdArbiter_io_output_valid;
  assign io_output_ar_payload_addr = cmdArbiter_io_output_payload_addr;
  assign io_output_ar_payload_region = cmdArbiter_io_output_payload_region;
  assign io_output_ar_payload_len = cmdArbiter_io_output_payload_len;
  assign io_output_ar_payload_size = cmdArbiter_io_output_payload_size;
  assign io_output_ar_payload_burst = cmdArbiter_io_output_payload_burst;
  assign io_output_ar_payload_lock = cmdArbiter_io_output_payload_lock;
  assign io_output_ar_payload_cache = cmdArbiter_io_output_payload_cache;
  assign io_output_ar_payload_qos = cmdArbiter_io_output_payload_qos;
  assign io_output_ar_payload_prot = cmdArbiter_io_output_payload_prot;
  assign io_output_ar_payload_id = cmdArbiter_io_output_payload_id;
  assign readRspSels_0 = 1'b1;
  assign io_inputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_inputs_0_r_payload_data = io_output_r_payload_data;
  assign io_inputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_inputs_0_r_payload_last = io_output_r_payload_last;
  assign io_inputs_0_r_payload_id = io_output_r_payload_id[3 : 0];
  assign io_output_r_ready = io_inputs_0_r_ready;
endmodule

module NoDebug_Axi4WriteOnlyArbiter (
      input   io_inputs_0_aw_valid,
      output  io_inputs_0_aw_ready,
      input  [31:0] io_inputs_0_aw_payload_addr,
      input  [3:0] io_inputs_0_aw_payload_id,
      input  [3:0] io_inputs_0_aw_payload_region,
      input  [7:0] io_inputs_0_aw_payload_len,
      input  [2:0] io_inputs_0_aw_payload_size,
      input  [1:0] io_inputs_0_aw_payload_burst,
      input  [0:0] io_inputs_0_aw_payload_lock,
      input  [3:0] io_inputs_0_aw_payload_cache,
      input  [3:0] io_inputs_0_aw_payload_qos,
      input  [2:0] io_inputs_0_aw_payload_prot,
      input   io_inputs_0_w_valid,
      output  io_inputs_0_w_ready,
      input  [31:0] io_inputs_0_w_payload_data,
      input  [3:0] io_inputs_0_w_payload_strb,
      input   io_inputs_0_w_payload_last,
      output  io_inputs_0_b_valid,
      input   io_inputs_0_b_ready,
      output [3:0] io_inputs_0_b_payload_id,
      output [1:0] io_inputs_0_b_payload_resp,
      output  io_output_aw_valid,
      input   io_output_aw_ready,
      output [31:0] io_output_aw_payload_addr,
      output [3:0] io_output_aw_payload_id,
      output [3:0] io_output_aw_payload_region,
      output [7:0] io_output_aw_payload_len,
      output [2:0] io_output_aw_payload_size,
      output [1:0] io_output_aw_payload_burst,
      output [0:0] io_output_aw_payload_lock,
      output [3:0] io_output_aw_payload_cache,
      output [3:0] io_output_aw_payload_qos,
      output [2:0] io_output_aw_payload_prot,
      output  io_output_w_valid,
      input   io_output_w_ready,
      output [31:0] io_output_w_payload_data,
      output [3:0] io_output_w_payload_strb,
      output  io_output_w_payload_last,
      input   io_output_b_valid,
      output  io_output_b_ready,
      input  [3:0] io_output_b_payload_id,
      input  [1:0] io_output_b_payload_resp,
      input   io_axiClk,
      input   resetCtrl_axiReset);
  wire  _zz_1_;
  wire  _zz_2_;
  wire  cmdArbiter_io_inputs_0_ready;
  wire  cmdArbiter_io_output_valid;
  wire [31:0] cmdArbiter_io_output_payload_addr;
  wire [3:0] cmdArbiter_io_output_payload_id;
  wire [3:0] cmdArbiter_io_output_payload_region;
  wire [7:0] cmdArbiter_io_output_payload_len;
  wire [2:0] cmdArbiter_io_output_payload_size;
  wire [1:0] cmdArbiter_io_output_payload_burst;
  wire [0:0] cmdArbiter_io_output_payload_lock;
  wire [3:0] cmdArbiter_io_output_payload_cache;
  wire [3:0] cmdArbiter_io_output_payload_qos;
  wire [2:0] cmdArbiter_io_output_payload_prot;
  wire [0:0] cmdArbiter_io_chosenOH;
  wire  streamFork_io_input_ready;
  wire  streamFork_io_outputs_0_valid;
  wire [31:0] streamFork_io_outputs_0_payload_addr;
  wire [3:0] streamFork_io_outputs_0_payload_id;
  wire [3:0] streamFork_io_outputs_0_payload_region;
  wire [7:0] streamFork_io_outputs_0_payload_len;
  wire [2:0] streamFork_io_outputs_0_payload_size;
  wire [1:0] streamFork_io_outputs_0_payload_burst;
  wire [0:0] streamFork_io_outputs_0_payload_lock;
  wire [3:0] streamFork_io_outputs_0_payload_cache;
  wire [3:0] streamFork_io_outputs_0_payload_qos;
  wire [2:0] streamFork_io_outputs_0_payload_prot;
  wire  streamFork_io_outputs_1_valid;
  wire [31:0] streamFork_io_outputs_1_payload_addr;
  wire [3:0] streamFork_io_outputs_1_payload_id;
  wire [3:0] streamFork_io_outputs_1_payload_region;
  wire [7:0] streamFork_io_outputs_1_payload_len;
  wire [2:0] streamFork_io_outputs_1_payload_size;
  wire [1:0] streamFork_io_outputs_1_payload_burst;
  wire [0:0] streamFork_io_outputs_1_payload_lock;
  wire [3:0] streamFork_io_outputs_1_payload_cache;
  wire [3:0] streamFork_io_outputs_1_payload_qos;
  wire [2:0] streamFork_io_outputs_1_payload_prot;
  wire  streamFork_io_outputs_1_translated_fifo_io_push_ready;
  wire  streamFork_io_outputs_1_translated_fifo_io_pop_valid;
  wire [2:0] streamFork_io_outputs_1_translated_fifo_io_occupancy;
  wire  streamFork_io_outputs_1_translated_valid;
  wire  streamFork_io_outputs_1_translated_ready;
  wire  routeDataInput_valid;
  wire  routeDataInput_ready;
  wire [31:0] routeDataInput_payload_data;
  wire [3:0] routeDataInput_payload_strb;
  wire  routeDataInput_payload_last;
  wire  writeRspSels_0;
  NoDebug_StreamArbiter_3_ cmdArbiter ( 
    .io_inputs_0_valid(io_inputs_0_aw_valid),
    .io_inputs_0_ready(cmdArbiter_io_inputs_0_ready),
    .io_inputs_0_payload_addr(io_inputs_0_aw_payload_addr),
    .io_inputs_0_payload_id(io_inputs_0_aw_payload_id),
    .io_inputs_0_payload_region(io_inputs_0_aw_payload_region),
    .io_inputs_0_payload_len(io_inputs_0_aw_payload_len),
    .io_inputs_0_payload_size(io_inputs_0_aw_payload_size),
    .io_inputs_0_payload_burst(io_inputs_0_aw_payload_burst),
    .io_inputs_0_payload_lock(io_inputs_0_aw_payload_lock),
    .io_inputs_0_payload_cache(io_inputs_0_aw_payload_cache),
    .io_inputs_0_payload_qos(io_inputs_0_aw_payload_qos),
    .io_inputs_0_payload_prot(io_inputs_0_aw_payload_prot),
    .io_output_valid(cmdArbiter_io_output_valid),
    .io_output_ready(streamFork_io_input_ready),
    .io_output_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_output_payload_id(cmdArbiter_io_output_payload_id),
    .io_output_payload_region(cmdArbiter_io_output_payload_region),
    .io_output_payload_len(cmdArbiter_io_output_payload_len),
    .io_output_payload_size(cmdArbiter_io_output_payload_size),
    .io_output_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_output_payload_lock(cmdArbiter_io_output_payload_lock),
    .io_output_payload_cache(cmdArbiter_io_output_payload_cache),
    .io_output_payload_qos(cmdArbiter_io_output_payload_qos),
    .io_output_payload_prot(cmdArbiter_io_output_payload_prot),
    .io_chosenOH(cmdArbiter_io_chosenOH),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFork_3_ streamFork ( 
    .io_input_valid(cmdArbiter_io_output_valid),
    .io_input_ready(streamFork_io_input_ready),
    .io_input_payload_addr(cmdArbiter_io_output_payload_addr),
    .io_input_payload_id(cmdArbiter_io_output_payload_id),
    .io_input_payload_region(cmdArbiter_io_output_payload_region),
    .io_input_payload_len(cmdArbiter_io_output_payload_len),
    .io_input_payload_size(cmdArbiter_io_output_payload_size),
    .io_input_payload_burst(cmdArbiter_io_output_payload_burst),
    .io_input_payload_lock(cmdArbiter_io_output_payload_lock),
    .io_input_payload_cache(cmdArbiter_io_output_payload_cache),
    .io_input_payload_qos(cmdArbiter_io_output_payload_qos),
    .io_input_payload_prot(cmdArbiter_io_output_payload_prot),
    .io_outputs_0_valid(streamFork_io_outputs_0_valid),
    .io_outputs_0_ready(io_output_aw_ready),
    .io_outputs_0_payload_addr(streamFork_io_outputs_0_payload_addr),
    .io_outputs_0_payload_id(streamFork_io_outputs_0_payload_id),
    .io_outputs_0_payload_region(streamFork_io_outputs_0_payload_region),
    .io_outputs_0_payload_len(streamFork_io_outputs_0_payload_len),
    .io_outputs_0_payload_size(streamFork_io_outputs_0_payload_size),
    .io_outputs_0_payload_burst(streamFork_io_outputs_0_payload_burst),
    .io_outputs_0_payload_lock(streamFork_io_outputs_0_payload_lock),
    .io_outputs_0_payload_cache(streamFork_io_outputs_0_payload_cache),
    .io_outputs_0_payload_qos(streamFork_io_outputs_0_payload_qos),
    .io_outputs_0_payload_prot(streamFork_io_outputs_0_payload_prot),
    .io_outputs_1_valid(streamFork_io_outputs_1_valid),
    .io_outputs_1_ready(streamFork_io_outputs_1_translated_ready),
    .io_outputs_1_payload_addr(streamFork_io_outputs_1_payload_addr),
    .io_outputs_1_payload_id(streamFork_io_outputs_1_payload_id),
    .io_outputs_1_payload_region(streamFork_io_outputs_1_payload_region),
    .io_outputs_1_payload_len(streamFork_io_outputs_1_payload_len),
    .io_outputs_1_payload_size(streamFork_io_outputs_1_payload_size),
    .io_outputs_1_payload_burst(streamFork_io_outputs_1_payload_burst),
    .io_outputs_1_payload_lock(streamFork_io_outputs_1_payload_lock),
    .io_outputs_1_payload_cache(streamFork_io_outputs_1_payload_cache),
    .io_outputs_1_payload_qos(streamFork_io_outputs_1_payload_qos),
    .io_outputs_1_payload_prot(streamFork_io_outputs_1_payload_prot),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFifoLowLatency streamFork_io_outputs_1_translated_fifo ( 
    .io_push_valid(streamFork_io_outputs_1_translated_valid),
    .io_push_ready(streamFork_io_outputs_1_translated_fifo_io_push_ready),
    .io_pop_valid(streamFork_io_outputs_1_translated_fifo_io_pop_valid),
    .io_pop_ready(_zz_1_),
    .io_flush(_zz_2_),
    .io_occupancy(streamFork_io_outputs_1_translated_fifo_io_occupancy),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  assign io_inputs_0_aw_ready = cmdArbiter_io_inputs_0_ready;
  assign io_output_aw_valid = streamFork_io_outputs_0_valid;
  assign io_output_aw_payload_addr = streamFork_io_outputs_0_payload_addr;
  assign io_output_aw_payload_region = streamFork_io_outputs_0_payload_region;
  assign io_output_aw_payload_len = streamFork_io_outputs_0_payload_len;
  assign io_output_aw_payload_size = streamFork_io_outputs_0_payload_size;
  assign io_output_aw_payload_burst = streamFork_io_outputs_0_payload_burst;
  assign io_output_aw_payload_lock = streamFork_io_outputs_0_payload_lock;
  assign io_output_aw_payload_cache = streamFork_io_outputs_0_payload_cache;
  assign io_output_aw_payload_qos = streamFork_io_outputs_0_payload_qos;
  assign io_output_aw_payload_prot = streamFork_io_outputs_0_payload_prot;
  assign io_output_aw_payload_id = cmdArbiter_io_output_payload_id;
  assign streamFork_io_outputs_1_translated_valid = streamFork_io_outputs_1_valid;
  assign streamFork_io_outputs_1_translated_ready = streamFork_io_outputs_1_translated_fifo_io_push_ready;
  assign routeDataInput_valid = io_inputs_0_w_valid;
  assign routeDataInput_ready = io_inputs_0_w_ready;
  assign routeDataInput_payload_data = io_inputs_0_w_payload_data;
  assign routeDataInput_payload_strb = io_inputs_0_w_payload_strb;
  assign routeDataInput_payload_last = io_inputs_0_w_payload_last;
  assign io_output_w_valid = (streamFork_io_outputs_1_translated_fifo_io_pop_valid && routeDataInput_valid);
  assign io_output_w_payload_data = routeDataInput_payload_data;
  assign io_output_w_payload_strb = routeDataInput_payload_strb;
  assign io_output_w_payload_last = routeDataInput_payload_last;
  assign io_inputs_0_w_ready = ((streamFork_io_outputs_1_translated_fifo_io_pop_valid && io_output_w_ready) && 1'b1);
  assign _zz_1_ = ((io_output_w_valid && io_output_w_ready) && io_output_w_payload_last);
  assign writeRspSels_0 = 1'b1;
  assign io_inputs_0_b_valid = (io_output_b_valid && writeRspSels_0);
  assign io_inputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_inputs_0_b_payload_id = io_output_b_payload_id[3 : 0];
  assign io_output_b_ready = io_inputs_0_b_ready;
  assign _zz_2_ = 1'b0;
endmodule

module NoDebug_ICCFPGA (
      input   io_asyncReset,
      input   io_axiClk,
      input   io_jtag_tms,
      input   io_jtag_tdi,
      output  io_jtag_tdo,
      input   io_jtag_tck,
      output  io_axiIO_aw_valid,
      input   io_axiIO_aw_ready,
      output [31:0] io_axiIO_aw_payload_addr,
      output [3:0] io_axiIO_aw_payload_id,
      output [3:0] io_axiIO_aw_payload_region,
      output [7:0] io_axiIO_aw_payload_len,
      output [2:0] io_axiIO_aw_payload_size,
      output [1:0] io_axiIO_aw_payload_burst,
      output [0:0] io_axiIO_aw_payload_lock,
      output [3:0] io_axiIO_aw_payload_cache,
      output [3:0] io_axiIO_aw_payload_qos,
      output [2:0] io_axiIO_aw_payload_prot,
      output  io_axiIO_w_valid,
      input   io_axiIO_w_ready,
      output [31:0] io_axiIO_w_payload_data,
      output [3:0] io_axiIO_w_payload_strb,
      output  io_axiIO_w_payload_last,
      input   io_axiIO_b_valid,
      output  io_axiIO_b_ready,
      input  [3:0] io_axiIO_b_payload_id,
      input  [1:0] io_axiIO_b_payload_resp,
      output  io_axiIO_ar_valid,
      input   io_axiIO_ar_ready,
      output [31:0] io_axiIO_ar_payload_addr,
      output [3:0] io_axiIO_ar_payload_id,
      output [3:0] io_axiIO_ar_payload_region,
      output [7:0] io_axiIO_ar_payload_len,
      output [2:0] io_axiIO_ar_payload_size,
      output [1:0] io_axiIO_ar_payload_burst,
      output [0:0] io_axiIO_ar_payload_lock,
      output [3:0] io_axiIO_ar_payload_cache,
      output [3:0] io_axiIO_ar_payload_qos,
      output [2:0] io_axiIO_ar_payload_prot,
      input   io_axiIO_r_valid,
      output  io_axiIO_r_ready,
      input  [31:0] io_axiIO_r_payload_data,
      input  [3:0] io_axiIO_r_payload_id,
      input  [1:0] io_axiIO_r_payload_resp,
      input   io_axiIO_r_payload_last,
      input   io_timerInterrupt,
      input   io_coreInterrupt);
  wire  _zz_34_;
  wire  _zz_35_;
  wire  _zz_36_;
  wire  _zz_37_;
  wire  _zz_38_;
  reg  _zz_39_;
  reg  _zz_40_;
  wire  _zz_41_;
  wire  _zz_42_;
  wire  _zz_43_;
  wire  _zz_44_;
  wire  _zz_45_;
  wire  _zz_46_;
  wire  _zz_47_;
  wire [16:0] _zz_48_;
  wire [1:0] _zz_49_;
  wire  _zz_50_;
  wire [11:0] _zz_51_;
  wire [1:0] _zz_52_;
  wire  _zz_53_;
  wire [16:0] _zz_54_;
  wire [2:0] _zz_55_;
  wire [16:0] _zz_56_;
  wire [1:0] _zz_57_;
  wire  _zz_58_;
  wire [1:0] _zz_59_;
  wire [0:0] _zz_60_;
  wire [3:0] _zz_61_;
  wire [1:0] _zz_62_;
  wire [0:0] _zz_63_;
  wire [3:0] _zz_64_;
  wire  bufferCC_io_dataOut;
  wire  axi_ram_io_axi_arw_ready;
  wire  axi_ram_io_axi_w_ready;
  wire  axi_ram_io_axi_b_valid;
  wire [3:0] axi_ram_io_axi_b_payload_id;
  wire [1:0] axi_ram_io_axi_b_payload_resp;
  wire  axi_ram_io_axi_r_valid;
  wire [31:0] axi_ram_io_axi_r_payload_data;
  wire [3:0] axi_ram_io_axi_r_payload_id;
  wire [1:0] axi_ram_io_axi_r_payload_resp;
  wire  axi_ram_io_axi_r_payload_last;
  wire  axi_svram_io_axi_arw_ready;
  wire  axi_svram_io_axi_w_ready;
  wire  axi_svram_io_axi_b_valid;
  wire [3:0] axi_svram_io_axi_b_payload_id;
  wire [1:0] axi_svram_io_axi_b_payload_resp;
  wire  axi_svram_io_axi_r_valid;
  wire [31:0] axi_svram_io_axi_r_payload_data;
  wire [3:0] axi_svram_io_axi_r_payload_id;
  wire [1:0] axi_svram_io_axi_r_payload_resp;
  wire  axi_svram_io_axi_r_payload_last;
  wire  axi_rom_io_axi_arw_ready;
  wire  axi_rom_io_axi_w_ready;
  wire  axi_rom_io_axi_b_valid;
  wire [3:0] axi_rom_io_axi_b_payload_id;
  wire [1:0] axi_rom_io_axi_b_payload_resp;
  wire  axi_rom_io_axi_r_valid;
  wire [31:0] axi_rom_io_axi_r_payload_data;
  wire [3:0] axi_rom_io_axi_r_payload_id;
  wire [1:0] axi_rom_io_axi_r_payload_resp;
  wire  axi_rom_io_axi_r_payload_last;
  wire  axi_core_cpu_iBus_cmd_valid;
  wire [31:0] axi_core_cpu_iBus_cmd_payload_address;
  wire [2:0] axi_core_cpu_iBus_cmd_payload_size;
  wire  axi_core_cpu_dBus_cmd_valid;
  wire  axi_core_cpu_dBus_cmd_payload_wr;
  wire [31:0] axi_core_cpu_dBus_cmd_payload_address;
  wire [31:0] axi_core_cpu_dBus_cmd_payload_data;
  wire [3:0] axi_core_cpu_dBus_cmd_payload_mask;
  wire [2:0] axi_core_cpu_dBus_cmd_payload_length;
  wire  axi_core_cpu_dBus_cmd_payload_last;
  wire  streamFork_io_input_ready;
  wire  streamFork_io_outputs_0_valid;
  wire  streamFork_io_outputs_0_payload_wr;
  wire [31:0] streamFork_io_outputs_0_payload_address;
  wire [31:0] streamFork_io_outputs_0_payload_data;
  wire [3:0] streamFork_io_outputs_0_payload_mask;
  wire [2:0] streamFork_io_outputs_0_payload_length;
  wire  streamFork_io_outputs_0_payload_last;
  wire  streamFork_io_outputs_1_valid;
  wire  streamFork_io_outputs_1_payload_wr;
  wire [31:0] streamFork_io_outputs_1_payload_address;
  wire [31:0] streamFork_io_outputs_1_payload_data;
  wire [3:0] streamFork_io_outputs_1_payload_mask;
  wire [2:0] streamFork_io_outputs_1_payload_length;
  wire  streamFork_io_outputs_1_payload_last;
  wire  bufferCC_1__io_dataOut;
  wire  bufferCC_2__io_dataOut;
  wire  axi_core_iBus_decoder_io_input_ar_ready;
  wire  axi_core_iBus_decoder_io_input_r_valid;
  wire [31:0] axi_core_iBus_decoder_io_input_r_payload_data;
  wire [1:0] axi_core_iBus_decoder_io_input_r_payload_resp;
  wire  axi_core_iBus_decoder_io_input_r_payload_last;
  wire  axi_core_iBus_decoder_io_outputs_0_ar_valid;
  wire [31:0] axi_core_iBus_decoder_io_outputs_0_ar_payload_addr;
  wire [7:0] axi_core_iBus_decoder_io_outputs_0_ar_payload_len;
  wire [1:0] axi_core_iBus_decoder_io_outputs_0_ar_payload_burst;
  wire [3:0] axi_core_iBus_decoder_io_outputs_0_ar_payload_cache;
  wire [2:0] axi_core_iBus_decoder_io_outputs_0_ar_payload_prot;
  wire  axi_core_iBus_decoder_io_outputs_0_r_ready;
  wire  axi_core_dBus_decoder_io_input_arw_ready;
  wire  axi_core_dBus_decoder_io_input_w_ready;
  wire  axi_core_dBus_decoder_io_input_b_valid;
  wire [1:0] axi_core_dBus_decoder_io_input_b_payload_resp;
  wire  axi_core_dBus_decoder_io_input_r_valid;
  wire [31:0] axi_core_dBus_decoder_io_input_r_payload_data;
  wire [1:0] axi_core_dBus_decoder_io_input_r_payload_resp;
  wire  axi_core_dBus_decoder_io_input_r_payload_last;
  wire  axi_core_dBus_decoder_io_readOutputs_0_ar_valid;
  wire [31:0] axi_core_dBus_decoder_io_readOutputs_0_ar_payload_addr;
  wire [7:0] axi_core_dBus_decoder_io_readOutputs_0_ar_payload_len;
  wire [2:0] axi_core_dBus_decoder_io_readOutputs_0_ar_payload_size;
  wire [3:0] axi_core_dBus_decoder_io_readOutputs_0_ar_payload_cache;
  wire [2:0] axi_core_dBus_decoder_io_readOutputs_0_ar_payload_prot;
  wire  axi_core_dBus_decoder_io_readOutputs_0_r_ready;
  wire  axi_core_dBus_decoder_io_writeOutputs_0_aw_valid;
  wire [31:0] axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_addr;
  wire [7:0] axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_len;
  wire [2:0] axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_size;
  wire [3:0] axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_cache;
  wire [2:0] axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_prot;
  wire  axi_core_dBus_decoder_io_writeOutputs_0_w_valid;
  wire [31:0] axi_core_dBus_decoder_io_writeOutputs_0_w_payload_data;
  wire [3:0] axi_core_dBus_decoder_io_writeOutputs_0_w_payload_strb;
  wire  axi_core_dBus_decoder_io_writeOutputs_0_w_payload_last;
  wire  axi_core_dBus_decoder_io_writeOutputs_0_b_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_arw_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_addr;
  wire [7:0] axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_len;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_size;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_cache;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_prot;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_write;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_w_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_data;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_strb;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_last;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_b_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_0_r_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_arw_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_addr;
  wire [7:0] axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_len;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_size;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_cache;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_prot;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_write;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_w_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_data;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_strb;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_last;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_b_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_1_r_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_arw_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_addr;
  wire [7:0] axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_len;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_size;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_cache;
  wire [2:0] axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_prot;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_write;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_w_valid;
  wire [31:0] axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_data;
  wire [3:0] axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_strb;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_last;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_b_ready;
  wire  axi_core_dBus_decoder_io_sharedOutputs_2_r_ready;
  wire  axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire  axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire  axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire [3:0] axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire [1:0] axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire  axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire [31:0] axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire [3:0] axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire [1:0] axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire  axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire  axi_ram_io_axi_arbiter_io_output_arw_valid;
  wire [16:0] axi_ram_io_axi_arbiter_io_output_arw_payload_addr;
  wire [3:0] axi_ram_io_axi_arbiter_io_output_arw_payload_id;
  wire [7:0] axi_ram_io_axi_arbiter_io_output_arw_payload_len;
  wire [2:0] axi_ram_io_axi_arbiter_io_output_arw_payload_size;
  wire [1:0] axi_ram_io_axi_arbiter_io_output_arw_payload_burst;
  wire  axi_ram_io_axi_arbiter_io_output_arw_payload_write;
  wire  axi_ram_io_axi_arbiter_io_output_w_valid;
  wire [31:0] axi_ram_io_axi_arbiter_io_output_w_payload_data;
  wire [3:0] axi_ram_io_axi_arbiter_io_output_w_payload_strb;
  wire  axi_ram_io_axi_arbiter_io_output_w_payload_last;
  wire  axi_ram_io_axi_arbiter_io_output_b_ready;
  wire  axi_ram_io_axi_arbiter_io_output_r_ready;
  wire  axi_svram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire  axi_svram_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire  axi_svram_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire [3:0] axi_svram_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire [1:0] axi_svram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire  axi_svram_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire [31:0] axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire [3:0] axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire [1:0] axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire  axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire  axi_svram_io_axi_arbiter_io_output_arw_valid;
  wire [11:0] axi_svram_io_axi_arbiter_io_output_arw_payload_addr;
  wire [3:0] axi_svram_io_axi_arbiter_io_output_arw_payload_id;
  wire [7:0] axi_svram_io_axi_arbiter_io_output_arw_payload_len;
  wire [2:0] axi_svram_io_axi_arbiter_io_output_arw_payload_size;
  wire [1:0] axi_svram_io_axi_arbiter_io_output_arw_payload_burst;
  wire  axi_svram_io_axi_arbiter_io_output_arw_payload_write;
  wire  axi_svram_io_axi_arbiter_io_output_w_valid;
  wire [31:0] axi_svram_io_axi_arbiter_io_output_w_payload_data;
  wire [3:0] axi_svram_io_axi_arbiter_io_output_w_payload_strb;
  wire  axi_svram_io_axi_arbiter_io_output_w_payload_last;
  wire  axi_svram_io_axi_arbiter_io_output_b_ready;
  wire  axi_svram_io_axi_arbiter_io_output_r_ready;
  wire  axi_rom_io_axi_arbiter_io_readInputs_0_ar_ready;
  wire  axi_rom_io_axi_arbiter_io_readInputs_0_r_valid;
  wire [31:0] axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_data;
  wire [2:0] axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_id;
  wire [1:0] axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_resp;
  wire  axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_last;
  wire  axi_rom_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  wire  axi_rom_io_axi_arbiter_io_sharedInputs_0_w_ready;
  wire  axi_rom_io_axi_arbiter_io_sharedInputs_0_b_valid;
  wire [2:0] axi_rom_io_axi_arbiter_io_sharedInputs_0_b_payload_id;
  wire [1:0] axi_rom_io_axi_arbiter_io_sharedInputs_0_b_payload_resp;
  wire  axi_rom_io_axi_arbiter_io_sharedInputs_0_r_valid;
  wire [31:0] axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_data;
  wire [2:0] axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_id;
  wire [1:0] axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_resp;
  wire  axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_last;
  wire  axi_rom_io_axi_arbiter_io_output_arw_valid;
  wire [16:0] axi_rom_io_axi_arbiter_io_output_arw_payload_addr;
  wire [3:0] axi_rom_io_axi_arbiter_io_output_arw_payload_id;
  wire [7:0] axi_rom_io_axi_arbiter_io_output_arw_payload_len;
  wire [2:0] axi_rom_io_axi_arbiter_io_output_arw_payload_size;
  wire [1:0] axi_rom_io_axi_arbiter_io_output_arw_payload_burst;
  wire  axi_rom_io_axi_arbiter_io_output_arw_payload_write;
  wire  axi_rom_io_axi_arbiter_io_output_w_valid;
  wire [31:0] axi_rom_io_axi_arbiter_io_output_w_payload_data;
  wire [3:0] axi_rom_io_axi_arbiter_io_output_w_payload_strb;
  wire  axi_rom_io_axi_arbiter_io_output_w_payload_last;
  wire  axi_rom_io_axi_arbiter_io_output_b_ready;
  wire  axi_rom_io_axi_arbiter_io_output_r_ready;
  wire  io_axiIO_readOnly_arbiter_io_inputs_0_ar_ready;
  wire  io_axiIO_readOnly_arbiter_io_inputs_0_r_valid;
  wire [31:0] io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_data;
  wire [3:0] io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_id;
  wire [1:0] io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_resp;
  wire  io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_last;
  wire  io_axiIO_readOnly_arbiter_io_output_ar_valid;
  wire [31:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_addr;
  wire [3:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_id;
  wire [3:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_region;
  wire [7:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_len;
  wire [2:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_size;
  wire [1:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_burst;
  wire [0:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_lock;
  wire [3:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_cache;
  wire [3:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_qos;
  wire [2:0] io_axiIO_readOnly_arbiter_io_output_ar_payload_prot;
  wire  io_axiIO_readOnly_arbiter_io_output_r_ready;
  wire  io_axiIO_writeOnly_arbiter_io_inputs_0_aw_ready;
  wire  io_axiIO_writeOnly_arbiter_io_inputs_0_w_ready;
  wire  io_axiIO_writeOnly_arbiter_io_inputs_0_b_valid;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_inputs_0_b_payload_id;
  wire [1:0] io_axiIO_writeOnly_arbiter_io_inputs_0_b_payload_resp;
  wire  io_axiIO_writeOnly_arbiter_io_output_aw_valid;
  wire [31:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_addr;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_id;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_region;
  wire [7:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_len;
  wire [2:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_size;
  wire [1:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_burst;
  wire [0:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_lock;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_cache;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_qos;
  wire [2:0] io_axiIO_writeOnly_arbiter_io_output_aw_payload_prot;
  wire  io_axiIO_writeOnly_arbiter_io_output_w_valid;
  wire [31:0] io_axiIO_writeOnly_arbiter_io_output_w_payload_data;
  wire [3:0] io_axiIO_writeOnly_arbiter_io_output_w_payload_strb;
  wire  io_axiIO_writeOnly_arbiter_io_output_w_payload_last;
  wire  io_axiIO_writeOnly_arbiter_io_output_b_ready;
  wire  _zz_65_;
  wire  _zz_66_;
  wire  _zz_67_;
  wire  _zz_68_;
  wire  _zz_69_;
  wire  _zz_70_;
  wire  _zz_71_;
  wire  _zz_72_;
  wire  _zz_73_;
  reg  resetCtrl_systemResetUnbuffered;
  reg [5:0] resetCtrl_systemResetCounter = (6'b000000);
  wire [5:0] _zz_1_;
  reg  resetCtrl_systemReset;
  reg  resetCtrl_axiReset;
  wire  axi_core_iBus_ar_valid;
  wire  axi_core_iBus_ar_ready;
  wire [31:0] axi_core_iBus_ar_payload_addr;
  wire [7:0] axi_core_iBus_ar_payload_len;
  wire [1:0] axi_core_iBus_ar_payload_burst;
  wire [3:0] axi_core_iBus_ar_payload_cache;
  wire [2:0] axi_core_iBus_ar_payload_prot;
  wire  axi_core_iBus_r_valid;
  wire  axi_core_iBus_r_ready;
  wire [31:0] axi_core_iBus_r_payload_data;
  wire [1:0] axi_core_iBus_r_payload_resp;
  wire  axi_core_iBus_r_payload_last;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_valid;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_ready;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_payload_wr;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_payload_address;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_payload_data;
  wire [3:0] axi_core_cpu_dBus_cmd_m2sPipe_payload_mask;
  wire [2:0] axi_core_cpu_dBus_cmd_m2sPipe_payload_length;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_payload_last;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_rValid;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_rData_wr;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_rData_address;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_rData_data;
  reg [3:0] axi_core_cpu_dBus_cmd_m2sPipe_rData_mask;
  reg [2:0] axi_core_cpu_dBus_cmd_m2sPipe_rData_length;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_rData_last;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_valid;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_ready;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_wr;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_address;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_data;
  wire [3:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_mask;
  wire [2:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_length;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_last;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rValid;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_wr;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_address;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_data;
  reg [3:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_mask;
  reg [2:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_length;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_last;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_valid;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_ready;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_wr;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_address;
  wire [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_data;
  wire [3:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_mask;
  wire [2:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_length;
  wire  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_last;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_wr;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_address;
  reg [31:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_data;
  reg [3:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_mask;
  reg [2:0] axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_length;
  reg  axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_last;
  reg  _zz_2_;
  reg  _zz_3_;
  reg [2:0] _zz_4_;
  reg [2:0] _zz_5_;
  wire  _zz_6_;
  reg  _zz_7_;
  reg  streamFork_io_outputs_0_thrown_valid;
  wire  streamFork_io_outputs_0_thrown_ready;
  wire  streamFork_io_outputs_0_thrown_payload_wr;
  wire [31:0] streamFork_io_outputs_0_thrown_payload_address;
  wire [31:0] streamFork_io_outputs_0_thrown_payload_data;
  wire [3:0] streamFork_io_outputs_0_thrown_payload_mask;
  wire [2:0] streamFork_io_outputs_0_thrown_payload_length;
  wire  streamFork_io_outputs_0_thrown_payload_last;
  reg  streamFork_io_outputs_1_thrown_valid;
  wire  streamFork_io_outputs_1_thrown_ready;
  wire  streamFork_io_outputs_1_thrown_payload_wr;
  wire [31:0] streamFork_io_outputs_1_thrown_payload_address;
  wire [31:0] streamFork_io_outputs_1_thrown_payload_data;
  wire [3:0] streamFork_io_outputs_1_thrown_payload_mask;
  wire [2:0] streamFork_io_outputs_1_thrown_payload_length;
  wire  streamFork_io_outputs_1_thrown_payload_last;
  wire  axi_core_dBus_arw_valid;
  wire  axi_core_dBus_arw_ready;
  wire [31:0] axi_core_dBus_arw_payload_addr;
  wire [7:0] axi_core_dBus_arw_payload_len;
  wire [2:0] axi_core_dBus_arw_payload_size;
  wire [3:0] axi_core_dBus_arw_payload_cache;
  wire [2:0] axi_core_dBus_arw_payload_prot;
  wire  axi_core_dBus_arw_payload_write;
  wire  axi_core_dBus_w_valid;
  wire  axi_core_dBus_w_ready;
  wire [31:0] axi_core_dBus_w_payload_data;
  wire [3:0] axi_core_dBus_w_payload_strb;
  wire  axi_core_dBus_w_payload_last;
  wire  axi_core_dBus_b_valid;
  wire  axi_core_dBus_b_ready;
  wire [1:0] axi_core_dBus_b_payload_resp;
  wire  axi_core_dBus_r_valid;
  wire  axi_core_dBus_r_ready;
  wire [31:0] axi_core_dBus_r_payload_data;
  wire [1:0] axi_core_dBus_r_payload_resp;
  wire  axi_core_dBus_r_payload_last;
  wire  io_axiIO_readOnly_ar_valid;
  wire  io_axiIO_readOnly_ar_ready;
  wire [31:0] io_axiIO_readOnly_ar_payload_addr;
  wire [3:0] io_axiIO_readOnly_ar_payload_id;
  wire [3:0] io_axiIO_readOnly_ar_payload_region;
  wire [7:0] io_axiIO_readOnly_ar_payload_len;
  wire [2:0] io_axiIO_readOnly_ar_payload_size;
  wire [1:0] io_axiIO_readOnly_ar_payload_burst;
  wire [0:0] io_axiIO_readOnly_ar_payload_lock;
  wire [3:0] io_axiIO_readOnly_ar_payload_cache;
  wire [3:0] io_axiIO_readOnly_ar_payload_qos;
  wire [2:0] io_axiIO_readOnly_ar_payload_prot;
  wire  io_axiIO_readOnly_r_valid;
  wire  io_axiIO_readOnly_r_ready;
  wire [31:0] io_axiIO_readOnly_r_payload_data;
  wire [3:0] io_axiIO_readOnly_r_payload_id;
  wire [1:0] io_axiIO_readOnly_r_payload_resp;
  wire  io_axiIO_readOnly_r_payload_last;
  wire  io_axiIO_writeOnly_aw_valid;
  wire  io_axiIO_writeOnly_aw_ready;
  wire [31:0] io_axiIO_writeOnly_aw_payload_addr;
  wire [3:0] io_axiIO_writeOnly_aw_payload_id;
  wire [3:0] io_axiIO_writeOnly_aw_payload_region;
  wire [7:0] io_axiIO_writeOnly_aw_payload_len;
  wire [2:0] io_axiIO_writeOnly_aw_payload_size;
  wire [1:0] io_axiIO_writeOnly_aw_payload_burst;
  wire [0:0] io_axiIO_writeOnly_aw_payload_lock;
  wire [3:0] io_axiIO_writeOnly_aw_payload_cache;
  wire [3:0] io_axiIO_writeOnly_aw_payload_qos;
  wire [2:0] io_axiIO_writeOnly_aw_payload_prot;
  wire  io_axiIO_writeOnly_w_valid;
  wire  io_axiIO_writeOnly_w_ready;
  wire [31:0] io_axiIO_writeOnly_w_payload_data;
  wire [3:0] io_axiIO_writeOnly_w_payload_strb;
  wire  io_axiIO_writeOnly_w_payload_last;
  wire  io_axiIO_writeOnly_b_valid;
  wire  io_axiIO_writeOnly_b_ready;
  wire [3:0] io_axiIO_writeOnly_b_payload_id;
  wire [1:0] io_axiIO_writeOnly_b_payload_resp;
  wire  _zz_8_;
  wire  _zz_9_;
  reg  _zz_10_;
  wire  _zz_11_;
  wire  _zz_12_;
  reg  _zz_13_;
  wire  _zz_14_;
  wire  _zz_15_;
  reg  _zz_16_;
  wire  _zz_17_;
  wire  _zz_18_;
  reg  _zz_19_;
  wire  _zz_20_;
  wire  _zz_21_;
  reg  _zz_22_;
  wire  _zz_23_;
  wire  _zz_24_;
  reg  _zz_25_;
  wire  axi_core_dBus_decoder_io_input_r_m2sPipe_valid;
  wire  axi_core_dBus_decoder_io_input_r_m2sPipe_ready;
  wire [31:0] axi_core_dBus_decoder_io_input_r_m2sPipe_payload_data;
  wire [1:0] axi_core_dBus_decoder_io_input_r_m2sPipe_payload_resp;
  wire  axi_core_dBus_decoder_io_input_r_m2sPipe_payload_last;
  reg  axi_core_dBus_decoder_io_input_r_m2sPipe_rValid;
  reg [31:0] axi_core_dBus_decoder_io_input_r_m2sPipe_rData_data;
  reg [1:0] axi_core_dBus_decoder_io_input_r_m2sPipe_rData_resp;
  reg  axi_core_dBus_decoder_io_input_r_m2sPipe_rData_last;
  wire [3:0] _zz_26_;
  wire  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_valid;
  wire  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_ready;
  wire [16:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr;
  wire [3:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_id;
  wire [7:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_len;
  wire [2:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_size;
  wire [1:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst;
  wire  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_write;
  reg  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  reg  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready;
  reg [16:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  reg [3:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  reg [7:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  reg [2:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  reg [1:0] axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  reg  axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_valid;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready;
  wire [31:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
  wire [3:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
  reg  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid;
  reg [31:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_data;
  reg [3:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb;
  reg  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_last;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready;
  wire [31:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data;
  wire [3:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb;
  wire  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last;
  reg  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  reg [31:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  reg [3:0] axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  reg  axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  wire [3:0] _zz_27_;
  wire  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_valid;
  wire  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_ready;
  wire [11:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr;
  wire [3:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_id;
  wire [7:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_len;
  wire [2:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_size;
  wire [1:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst;
  wire  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_write;
  reg  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  reg  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready;
  reg [11:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  reg [3:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  reg [7:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  reg [2:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  reg [1:0] axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  reg  axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_valid;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready;
  wire [31:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
  wire [3:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
  reg  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid;
  reg [31:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_data;
  reg [3:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb;
  reg  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_last;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready;
  wire [31:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data;
  wire [3:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb;
  wire  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last;
  reg  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  reg [31:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  reg [3:0] axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  reg  axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  wire [2:0] _zz_28_;
  wire [2:0] _zz_29_;
  wire  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_valid;
  wire  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_ready;
  wire [16:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_addr;
  wire [3:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_id;
  wire [7:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_len;
  wire [2:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_size;
  wire [1:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_burst;
  wire  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_write;
  reg  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  reg  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_ready;
  reg [16:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  reg [3:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  reg [7:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  reg [2:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  reg [1:0] axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  reg  axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_valid;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready;
  wire [31:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
  wire [3:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
  reg  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid;
  reg [31:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_data;
  reg [3:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_strb;
  reg  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_last;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready;
  wire [31:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data;
  wire [3:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb;
  wire  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last;
  reg  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  reg [31:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  reg [3:0] axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  reg  axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  wire [3:0] _zz_30_;
  wire [3:0] _zz_31_;
  wire [3:0] _zz_32_;
  wire [3:0] _zz_33_;
  assign _zz_65_ = (resetCtrl_systemResetCounter != _zz_1_);
  assign _zz_66_ = (! streamFork_io_outputs_1_payload_wr);
  assign _zz_67_ = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_ready && (! axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_ready));
  assign _zz_68_ = (! axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid);
  assign _zz_69_ = (_zz_50_ && (! axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready));
  assign _zz_70_ = (! axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid);
  assign _zz_71_ = (_zz_53_ && (! axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready));
  assign _zz_72_ = (! axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid);
  assign _zz_73_ = (_zz_58_ && (! axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready));
  NoDebug_BufferCC bufferCC ( 
    .io_dataIn(io_asyncReset),
    .io_dataOut(bufferCC_io_dataOut),
    .io_axiClk(io_axiClk) 
  );
  NoDebug_Axi4SharedOnChipRam axi_ram ( 
    .io_axi_arw_valid(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_valid),
    .io_axi_arw_ready(axi_ram_io_axi_arw_ready),
    .io_axi_arw_payload_addr(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr),
    .io_axi_arw_payload_id(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_id),
    .io_axi_arw_payload_len(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_len),
    .io_axi_arw_payload_size(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_size),
    .io_axi_arw_payload_burst(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst),
    .io_axi_arw_payload_write(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_write),
    .io_axi_w_valid(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid),
    .io_axi_w_ready(axi_ram_io_axi_w_ready),
    .io_axi_w_payload_data(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data),
    .io_axi_w_payload_strb(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb),
    .io_axi_w_payload_last(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last),
    .io_axi_b_valid(axi_ram_io_axi_b_valid),
    .io_axi_b_ready(axi_ram_io_axi_arbiter_io_output_b_ready),
    .io_axi_b_payload_id(axi_ram_io_axi_b_payload_id),
    .io_axi_b_payload_resp(axi_ram_io_axi_b_payload_resp),
    .io_axi_r_valid(axi_ram_io_axi_r_valid),
    .io_axi_r_ready(axi_ram_io_axi_arbiter_io_output_r_ready),
    .io_axi_r_payload_data(axi_ram_io_axi_r_payload_data),
    .io_axi_r_payload_id(axi_ram_io_axi_r_payload_id),
    .io_axi_r_payload_resp(axi_ram_io_axi_r_payload_resp),
    .io_axi_r_payload_last(axi_ram_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedOnChipRam_1_ axi_svram ( 
    .io_axi_arw_valid(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_valid),
    .io_axi_arw_ready(axi_svram_io_axi_arw_ready),
    .io_axi_arw_payload_addr(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr),
    .io_axi_arw_payload_id(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_id),
    .io_axi_arw_payload_len(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_len),
    .io_axi_arw_payload_size(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_size),
    .io_axi_arw_payload_burst(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst),
    .io_axi_arw_payload_write(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_write),
    .io_axi_w_valid(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid),
    .io_axi_w_ready(axi_svram_io_axi_w_ready),
    .io_axi_w_payload_data(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data),
    .io_axi_w_payload_strb(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb),
    .io_axi_w_payload_last(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last),
    .io_axi_b_valid(axi_svram_io_axi_b_valid),
    .io_axi_b_ready(axi_svram_io_axi_arbiter_io_output_b_ready),
    .io_axi_b_payload_id(axi_svram_io_axi_b_payload_id),
    .io_axi_b_payload_resp(axi_svram_io_axi_b_payload_resp),
    .io_axi_r_valid(axi_svram_io_axi_r_valid),
    .io_axi_r_ready(axi_svram_io_axi_arbiter_io_output_r_ready),
    .io_axi_r_payload_data(axi_svram_io_axi_r_payload_data),
    .io_axi_r_payload_id(axi_svram_io_axi_r_payload_id),
    .io_axi_r_payload_resp(axi_svram_io_axi_r_payload_resp),
    .io_axi_r_payload_last(axi_svram_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedOnChipRam_2_ axi_rom ( 
    .io_axi_arw_valid(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_valid),
    .io_axi_arw_ready(axi_rom_io_axi_arw_ready),
    .io_axi_arw_payload_addr(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_addr),
    .io_axi_arw_payload_id(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_id),
    .io_axi_arw_payload_len(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_len),
    .io_axi_arw_payload_size(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_size),
    .io_axi_arw_payload_burst(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_burst),
    .io_axi_arw_payload_write(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_write),
    .io_axi_w_valid(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid),
    .io_axi_w_ready(axi_rom_io_axi_w_ready),
    .io_axi_w_payload_data(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data),
    .io_axi_w_payload_strb(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb),
    .io_axi_w_payload_last(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last),
    .io_axi_b_valid(axi_rom_io_axi_b_valid),
    .io_axi_b_ready(axi_rom_io_axi_arbiter_io_output_b_ready),
    .io_axi_b_payload_id(axi_rom_io_axi_b_payload_id),
    .io_axi_b_payload_resp(axi_rom_io_axi_b_payload_resp),
    .io_axi_r_valid(axi_rom_io_axi_r_valid),
    .io_axi_r_ready(axi_rom_io_axi_arbiter_io_output_r_ready),
    .io_axi_r_payload_data(axi_rom_io_axi_r_payload_data),
    .io_axi_r_payload_id(axi_rom_io_axi_r_payload_id),
    .io_axi_r_payload_resp(axi_rom_io_axi_r_payload_resp),
    .io_axi_r_payload_last(axi_rom_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_VexRiscv axi_core_cpu ( 
    .timerInterrupt(bufferCC_2__io_dataOut),
    .externalInterrupt(bufferCC_1__io_dataOut),
    .softwareInterrupt(_zz_34_),
    .iBus_cmd_valid(axi_core_cpu_iBus_cmd_valid),
    .iBus_cmd_ready(axi_core_iBus_ar_ready),
    .iBus_cmd_payload_address(axi_core_cpu_iBus_cmd_payload_address),
    .iBus_cmd_payload_size(axi_core_cpu_iBus_cmd_payload_size),
    .iBus_rsp_valid(axi_core_iBus_r_valid),
    .iBus_rsp_payload_data(axi_core_iBus_r_payload_data),
    .iBus_rsp_payload_error(_zz_35_),
    .dBus_cmd_valid(axi_core_cpu_dBus_cmd_valid),
    .dBus_cmd_ready(_zz_36_),
    .dBus_cmd_payload_wr(axi_core_cpu_dBus_cmd_payload_wr),
    .dBus_cmd_payload_address(axi_core_cpu_dBus_cmd_payload_address),
    .dBus_cmd_payload_data(axi_core_cpu_dBus_cmd_payload_data),
    .dBus_cmd_payload_mask(axi_core_cpu_dBus_cmd_payload_mask),
    .dBus_cmd_payload_length(axi_core_cpu_dBus_cmd_payload_length),
    .dBus_cmd_payload_last(axi_core_cpu_dBus_cmd_payload_last),
    .dBus_rsp_valid(axi_core_dBus_r_valid),
    .dBus_rsp_payload_data(axi_core_dBus_r_payload_data),
    .dBus_rsp_payload_error(_zz_37_),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_StreamFork_4_ streamFork ( 
    .io_input_valid(_zz_38_),
    .io_input_ready(streamFork_io_input_ready),
    .io_input_payload_wr(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_wr),
    .io_input_payload_address(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_address),
    .io_input_payload_data(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_data),
    .io_input_payload_mask(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_mask),
    .io_input_payload_length(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_length),
    .io_input_payload_last(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_last),
    .io_outputs_0_valid(streamFork_io_outputs_0_valid),
    .io_outputs_0_ready(_zz_39_),
    .io_outputs_0_payload_wr(streamFork_io_outputs_0_payload_wr),
    .io_outputs_0_payload_address(streamFork_io_outputs_0_payload_address),
    .io_outputs_0_payload_data(streamFork_io_outputs_0_payload_data),
    .io_outputs_0_payload_mask(streamFork_io_outputs_0_payload_mask),
    .io_outputs_0_payload_length(streamFork_io_outputs_0_payload_length),
    .io_outputs_0_payload_last(streamFork_io_outputs_0_payload_last),
    .io_outputs_1_valid(streamFork_io_outputs_1_valid),
    .io_outputs_1_ready(_zz_40_),
    .io_outputs_1_payload_wr(streamFork_io_outputs_1_payload_wr),
    .io_outputs_1_payload_address(streamFork_io_outputs_1_payload_address),
    .io_outputs_1_payload_data(streamFork_io_outputs_1_payload_data),
    .io_outputs_1_payload_mask(streamFork_io_outputs_1_payload_mask),
    .io_outputs_1_payload_length(streamFork_io_outputs_1_payload_length),
    .io_outputs_1_payload_last(streamFork_io_outputs_1_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_BufferCC_1_ bufferCC_1_ ( 
    .io_dataIn(io_coreInterrupt),
    .io_dataOut(bufferCC_1__io_dataOut),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_BufferCC_1_ bufferCC_2_ ( 
    .io_dataIn(io_timerInterrupt),
    .io_dataOut(bufferCC_2__io_dataOut),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4ReadOnlyDecoder axi_core_iBus_decoder ( 
    .io_input_ar_valid(axi_core_iBus_ar_valid),
    .io_input_ar_ready(axi_core_iBus_decoder_io_input_ar_ready),
    .io_input_ar_payload_addr(axi_core_iBus_ar_payload_addr),
    .io_input_ar_payload_len(axi_core_iBus_ar_payload_len),
    .io_input_ar_payload_burst(axi_core_iBus_ar_payload_burst),
    .io_input_ar_payload_cache(axi_core_iBus_ar_payload_cache),
    .io_input_ar_payload_prot(axi_core_iBus_ar_payload_prot),
    .io_input_r_valid(axi_core_iBus_decoder_io_input_r_valid),
    .io_input_r_ready(axi_core_iBus_r_ready),
    .io_input_r_payload_data(axi_core_iBus_decoder_io_input_r_payload_data),
    .io_input_r_payload_resp(axi_core_iBus_decoder_io_input_r_payload_resp),
    .io_input_r_payload_last(axi_core_iBus_decoder_io_input_r_payload_last),
    .io_outputs_0_ar_valid(axi_core_iBus_decoder_io_outputs_0_ar_valid),
    .io_outputs_0_ar_ready(_zz_41_),
    .io_outputs_0_ar_payload_addr(axi_core_iBus_decoder_io_outputs_0_ar_payload_addr),
    .io_outputs_0_ar_payload_len(axi_core_iBus_decoder_io_outputs_0_ar_payload_len),
    .io_outputs_0_ar_payload_burst(axi_core_iBus_decoder_io_outputs_0_ar_payload_burst),
    .io_outputs_0_ar_payload_cache(axi_core_iBus_decoder_io_outputs_0_ar_payload_cache),
    .io_outputs_0_ar_payload_prot(axi_core_iBus_decoder_io_outputs_0_ar_payload_prot),
    .io_outputs_0_r_valid(axi_rom_io_axi_arbiter_io_readInputs_0_r_valid),
    .io_outputs_0_r_ready(axi_core_iBus_decoder_io_outputs_0_r_ready),
    .io_outputs_0_r_payload_data(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_data),
    .io_outputs_0_r_payload_resp(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_resp),
    .io_outputs_0_r_payload_last(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedDecoder axi_core_dBus_decoder ( 
    .io_input_arw_valid(axi_core_dBus_arw_valid),
    .io_input_arw_ready(axi_core_dBus_decoder_io_input_arw_ready),
    .io_input_arw_payload_addr(axi_core_dBus_arw_payload_addr),
    .io_input_arw_payload_len(axi_core_dBus_arw_payload_len),
    .io_input_arw_payload_size(axi_core_dBus_arw_payload_size),
    .io_input_arw_payload_cache(axi_core_dBus_arw_payload_cache),
    .io_input_arw_payload_prot(axi_core_dBus_arw_payload_prot),
    .io_input_arw_payload_write(axi_core_dBus_arw_payload_write),
    .io_input_w_valid(axi_core_dBus_w_valid),
    .io_input_w_ready(axi_core_dBus_decoder_io_input_w_ready),
    .io_input_w_payload_data(axi_core_dBus_w_payload_data),
    .io_input_w_payload_strb(axi_core_dBus_w_payload_strb),
    .io_input_w_payload_last(axi_core_dBus_w_payload_last),
    .io_input_b_valid(axi_core_dBus_decoder_io_input_b_valid),
    .io_input_b_ready(axi_core_dBus_b_ready),
    .io_input_b_payload_resp(axi_core_dBus_decoder_io_input_b_payload_resp),
    .io_input_r_valid(axi_core_dBus_decoder_io_input_r_valid),
    .io_input_r_ready(_zz_42_),
    .io_input_r_payload_data(axi_core_dBus_decoder_io_input_r_payload_data),
    .io_input_r_payload_resp(axi_core_dBus_decoder_io_input_r_payload_resp),
    .io_input_r_payload_last(axi_core_dBus_decoder_io_input_r_payload_last),
    .io_readOutputs_0_ar_valid(axi_core_dBus_decoder_io_readOutputs_0_ar_valid),
    .io_readOutputs_0_ar_ready(_zz_43_),
    .io_readOutputs_0_ar_payload_addr(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_addr),
    .io_readOutputs_0_ar_payload_len(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_len),
    .io_readOutputs_0_ar_payload_size(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_size),
    .io_readOutputs_0_ar_payload_cache(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_cache),
    .io_readOutputs_0_ar_payload_prot(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_prot),
    .io_readOutputs_0_r_valid(io_axiIO_readOnly_arbiter_io_inputs_0_r_valid),
    .io_readOutputs_0_r_ready(axi_core_dBus_decoder_io_readOutputs_0_r_ready),
    .io_readOutputs_0_r_payload_data(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_data),
    .io_readOutputs_0_r_payload_resp(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_resp),
    .io_readOutputs_0_r_payload_last(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_last),
    .io_writeOutputs_0_aw_valid(axi_core_dBus_decoder_io_writeOutputs_0_aw_valid),
    .io_writeOutputs_0_aw_ready(_zz_44_),
    .io_writeOutputs_0_aw_payload_addr(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_addr),
    .io_writeOutputs_0_aw_payload_len(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_len),
    .io_writeOutputs_0_aw_payload_size(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_size),
    .io_writeOutputs_0_aw_payload_cache(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_cache),
    .io_writeOutputs_0_aw_payload_prot(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_prot),
    .io_writeOutputs_0_w_valid(axi_core_dBus_decoder_io_writeOutputs_0_w_valid),
    .io_writeOutputs_0_w_ready(io_axiIO_writeOnly_arbiter_io_inputs_0_w_ready),
    .io_writeOutputs_0_w_payload_data(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_data),
    .io_writeOutputs_0_w_payload_strb(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_strb),
    .io_writeOutputs_0_w_payload_last(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_last),
    .io_writeOutputs_0_b_valid(io_axiIO_writeOnly_arbiter_io_inputs_0_b_valid),
    .io_writeOutputs_0_b_ready(axi_core_dBus_decoder_io_writeOutputs_0_b_ready),
    .io_writeOutputs_0_b_payload_resp(io_axiIO_writeOnly_arbiter_io_inputs_0_b_payload_resp),
    .io_sharedOutputs_0_arw_valid(axi_core_dBus_decoder_io_sharedOutputs_0_arw_valid),
    .io_sharedOutputs_0_arw_ready(_zz_45_),
    .io_sharedOutputs_0_arw_payload_addr(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_addr),
    .io_sharedOutputs_0_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_len),
    .io_sharedOutputs_0_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_size),
    .io_sharedOutputs_0_arw_payload_cache(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_cache),
    .io_sharedOutputs_0_arw_payload_prot(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_prot),
    .io_sharedOutputs_0_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_write),
    .io_sharedOutputs_0_w_valid(axi_core_dBus_decoder_io_sharedOutputs_0_w_valid),
    .io_sharedOutputs_0_w_ready(axi_svram_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedOutputs_0_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_data),
    .io_sharedOutputs_0_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_strb),
    .io_sharedOutputs_0_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_last),
    .io_sharedOutputs_0_b_valid(axi_svram_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedOutputs_0_b_ready(axi_core_dBus_decoder_io_sharedOutputs_0_b_ready),
    .io_sharedOutputs_0_b_payload_resp(axi_svram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedOutputs_0_r_valid(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedOutputs_0_r_ready(axi_core_dBus_decoder_io_sharedOutputs_0_r_ready),
    .io_sharedOutputs_0_r_payload_data(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedOutputs_0_r_payload_resp(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedOutputs_0_r_payload_last(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_sharedOutputs_1_arw_valid(axi_core_dBus_decoder_io_sharedOutputs_1_arw_valid),
    .io_sharedOutputs_1_arw_ready(_zz_46_),
    .io_sharedOutputs_1_arw_payload_addr(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_addr),
    .io_sharedOutputs_1_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_len),
    .io_sharedOutputs_1_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_size),
    .io_sharedOutputs_1_arw_payload_cache(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_cache),
    .io_sharedOutputs_1_arw_payload_prot(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_prot),
    .io_sharedOutputs_1_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_write),
    .io_sharedOutputs_1_w_valid(axi_core_dBus_decoder_io_sharedOutputs_1_w_valid),
    .io_sharedOutputs_1_w_ready(axi_rom_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedOutputs_1_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_data),
    .io_sharedOutputs_1_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_strb),
    .io_sharedOutputs_1_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_last),
    .io_sharedOutputs_1_b_valid(axi_rom_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedOutputs_1_b_ready(axi_core_dBus_decoder_io_sharedOutputs_1_b_ready),
    .io_sharedOutputs_1_b_payload_resp(axi_rom_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedOutputs_1_r_valid(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedOutputs_1_r_ready(axi_core_dBus_decoder_io_sharedOutputs_1_r_ready),
    .io_sharedOutputs_1_r_payload_data(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedOutputs_1_r_payload_resp(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedOutputs_1_r_payload_last(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_sharedOutputs_2_arw_valid(axi_core_dBus_decoder_io_sharedOutputs_2_arw_valid),
    .io_sharedOutputs_2_arw_ready(_zz_47_),
    .io_sharedOutputs_2_arw_payload_addr(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_addr),
    .io_sharedOutputs_2_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_len),
    .io_sharedOutputs_2_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_size),
    .io_sharedOutputs_2_arw_payload_cache(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_cache),
    .io_sharedOutputs_2_arw_payload_prot(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_prot),
    .io_sharedOutputs_2_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_write),
    .io_sharedOutputs_2_w_valid(axi_core_dBus_decoder_io_sharedOutputs_2_w_valid),
    .io_sharedOutputs_2_w_ready(axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedOutputs_2_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_data),
    .io_sharedOutputs_2_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_strb),
    .io_sharedOutputs_2_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_last),
    .io_sharedOutputs_2_b_valid(axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedOutputs_2_b_ready(axi_core_dBus_decoder_io_sharedOutputs_2_b_ready),
    .io_sharedOutputs_2_b_payload_resp(axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedOutputs_2_r_valid(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedOutputs_2_r_ready(axi_core_dBus_decoder_io_sharedOutputs_2_r_ready),
    .io_sharedOutputs_2_r_payload_data(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedOutputs_2_r_payload_resp(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedOutputs_2_r_payload_last(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedArbiter axi_ram_io_axi_arbiter ( 
    .io_sharedInputs_0_arw_valid(_zz_23_),
    .io_sharedInputs_0_arw_ready(axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready),
    .io_sharedInputs_0_arw_payload_addr(_zz_48_),
    .io_sharedInputs_0_arw_payload_id(_zz_26_),
    .io_sharedInputs_0_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_len),
    .io_sharedInputs_0_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_size),
    .io_sharedInputs_0_arw_payload_burst(_zz_49_),
    .io_sharedInputs_0_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_write),
    .io_sharedInputs_0_w_valid(axi_core_dBus_decoder_io_sharedOutputs_2_w_valid),
    .io_sharedInputs_0_w_ready(axi_ram_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedInputs_0_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_data),
    .io_sharedInputs_0_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_strb),
    .io_sharedInputs_0_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_2_w_payload_last),
    .io_sharedInputs_0_b_valid(axi_ram_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedInputs_0_b_ready(axi_core_dBus_decoder_io_sharedOutputs_2_b_ready),
    .io_sharedInputs_0_b_payload_id(axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_id),
    .io_sharedInputs_0_b_payload_resp(axi_ram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedInputs_0_r_valid(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedInputs_0_r_ready(axi_core_dBus_decoder_io_sharedOutputs_2_r_ready),
    .io_sharedInputs_0_r_payload_data(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedInputs_0_r_payload_id(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_id),
    .io_sharedInputs_0_r_payload_resp(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedInputs_0_r_payload_last(axi_ram_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_output_arw_valid(axi_ram_io_axi_arbiter_io_output_arw_valid),
    .io_output_arw_ready(axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready),
    .io_output_arw_payload_addr(axi_ram_io_axi_arbiter_io_output_arw_payload_addr),
    .io_output_arw_payload_id(axi_ram_io_axi_arbiter_io_output_arw_payload_id),
    .io_output_arw_payload_len(axi_ram_io_axi_arbiter_io_output_arw_payload_len),
    .io_output_arw_payload_size(axi_ram_io_axi_arbiter_io_output_arw_payload_size),
    .io_output_arw_payload_burst(axi_ram_io_axi_arbiter_io_output_arw_payload_burst),
    .io_output_arw_payload_write(axi_ram_io_axi_arbiter_io_output_arw_payload_write),
    .io_output_w_valid(axi_ram_io_axi_arbiter_io_output_w_valid),
    .io_output_w_ready(_zz_50_),
    .io_output_w_payload_data(axi_ram_io_axi_arbiter_io_output_w_payload_data),
    .io_output_w_payload_strb(axi_ram_io_axi_arbiter_io_output_w_payload_strb),
    .io_output_w_payload_last(axi_ram_io_axi_arbiter_io_output_w_payload_last),
    .io_output_b_valid(axi_ram_io_axi_b_valid),
    .io_output_b_ready(axi_ram_io_axi_arbiter_io_output_b_ready),
    .io_output_b_payload_id(axi_ram_io_axi_b_payload_id),
    .io_output_b_payload_resp(axi_ram_io_axi_b_payload_resp),
    .io_output_r_valid(axi_ram_io_axi_r_valid),
    .io_output_r_ready(axi_ram_io_axi_arbiter_io_output_r_ready),
    .io_output_r_payload_data(axi_ram_io_axi_r_payload_data),
    .io_output_r_payload_id(axi_ram_io_axi_r_payload_id),
    .io_output_r_payload_resp(axi_ram_io_axi_r_payload_resp),
    .io_output_r_payload_last(axi_ram_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedArbiter_1_ axi_svram_io_axi_arbiter ( 
    .io_sharedInputs_0_arw_valid(_zz_17_),
    .io_sharedInputs_0_arw_ready(axi_svram_io_axi_arbiter_io_sharedInputs_0_arw_ready),
    .io_sharedInputs_0_arw_payload_addr(_zz_51_),
    .io_sharedInputs_0_arw_payload_id(_zz_27_),
    .io_sharedInputs_0_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_len),
    .io_sharedInputs_0_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_size),
    .io_sharedInputs_0_arw_payload_burst(_zz_52_),
    .io_sharedInputs_0_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_write),
    .io_sharedInputs_0_w_valid(axi_core_dBus_decoder_io_sharedOutputs_0_w_valid),
    .io_sharedInputs_0_w_ready(axi_svram_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedInputs_0_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_data),
    .io_sharedInputs_0_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_strb),
    .io_sharedInputs_0_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_0_w_payload_last),
    .io_sharedInputs_0_b_valid(axi_svram_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedInputs_0_b_ready(axi_core_dBus_decoder_io_sharedOutputs_0_b_ready),
    .io_sharedInputs_0_b_payload_id(axi_svram_io_axi_arbiter_io_sharedInputs_0_b_payload_id),
    .io_sharedInputs_0_b_payload_resp(axi_svram_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedInputs_0_r_valid(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedInputs_0_r_ready(axi_core_dBus_decoder_io_sharedOutputs_0_r_ready),
    .io_sharedInputs_0_r_payload_data(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedInputs_0_r_payload_id(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_id),
    .io_sharedInputs_0_r_payload_resp(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedInputs_0_r_payload_last(axi_svram_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_output_arw_valid(axi_svram_io_axi_arbiter_io_output_arw_valid),
    .io_output_arw_ready(axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready),
    .io_output_arw_payload_addr(axi_svram_io_axi_arbiter_io_output_arw_payload_addr),
    .io_output_arw_payload_id(axi_svram_io_axi_arbiter_io_output_arw_payload_id),
    .io_output_arw_payload_len(axi_svram_io_axi_arbiter_io_output_arw_payload_len),
    .io_output_arw_payload_size(axi_svram_io_axi_arbiter_io_output_arw_payload_size),
    .io_output_arw_payload_burst(axi_svram_io_axi_arbiter_io_output_arw_payload_burst),
    .io_output_arw_payload_write(axi_svram_io_axi_arbiter_io_output_arw_payload_write),
    .io_output_w_valid(axi_svram_io_axi_arbiter_io_output_w_valid),
    .io_output_w_ready(_zz_53_),
    .io_output_w_payload_data(axi_svram_io_axi_arbiter_io_output_w_payload_data),
    .io_output_w_payload_strb(axi_svram_io_axi_arbiter_io_output_w_payload_strb),
    .io_output_w_payload_last(axi_svram_io_axi_arbiter_io_output_w_payload_last),
    .io_output_b_valid(axi_svram_io_axi_b_valid),
    .io_output_b_ready(axi_svram_io_axi_arbiter_io_output_b_ready),
    .io_output_b_payload_id(axi_svram_io_axi_b_payload_id),
    .io_output_b_payload_resp(axi_svram_io_axi_b_payload_resp),
    .io_output_r_valid(axi_svram_io_axi_r_valid),
    .io_output_r_ready(axi_svram_io_axi_arbiter_io_output_r_ready),
    .io_output_r_payload_data(axi_svram_io_axi_r_payload_data),
    .io_output_r_payload_id(axi_svram_io_axi_r_payload_id),
    .io_output_r_payload_resp(axi_svram_io_axi_r_payload_resp),
    .io_output_r_payload_last(axi_svram_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4SharedArbiter_2_ axi_rom_io_axi_arbiter ( 
    .io_readInputs_0_ar_valid(_zz_8_),
    .io_readInputs_0_ar_ready(axi_rom_io_axi_arbiter_io_readInputs_0_ar_ready),
    .io_readInputs_0_ar_payload_addr(_zz_54_),
    .io_readInputs_0_ar_payload_id(_zz_28_),
    .io_readInputs_0_ar_payload_len(axi_core_iBus_decoder_io_outputs_0_ar_payload_len),
    .io_readInputs_0_ar_payload_size(_zz_55_),
    .io_readInputs_0_ar_payload_burst(axi_core_iBus_decoder_io_outputs_0_ar_payload_burst),
    .io_readInputs_0_r_valid(axi_rom_io_axi_arbiter_io_readInputs_0_r_valid),
    .io_readInputs_0_r_ready(axi_core_iBus_decoder_io_outputs_0_r_ready),
    .io_readInputs_0_r_payload_data(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_data),
    .io_readInputs_0_r_payload_id(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_id),
    .io_readInputs_0_r_payload_resp(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_resp),
    .io_readInputs_0_r_payload_last(axi_rom_io_axi_arbiter_io_readInputs_0_r_payload_last),
    .io_sharedInputs_0_arw_valid(_zz_20_),
    .io_sharedInputs_0_arw_ready(axi_rom_io_axi_arbiter_io_sharedInputs_0_arw_ready),
    .io_sharedInputs_0_arw_payload_addr(_zz_56_),
    .io_sharedInputs_0_arw_payload_id(_zz_29_),
    .io_sharedInputs_0_arw_payload_len(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_len),
    .io_sharedInputs_0_arw_payload_size(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_size),
    .io_sharedInputs_0_arw_payload_burst(_zz_57_),
    .io_sharedInputs_0_arw_payload_write(axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_write),
    .io_sharedInputs_0_w_valid(axi_core_dBus_decoder_io_sharedOutputs_1_w_valid),
    .io_sharedInputs_0_w_ready(axi_rom_io_axi_arbiter_io_sharedInputs_0_w_ready),
    .io_sharedInputs_0_w_payload_data(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_data),
    .io_sharedInputs_0_w_payload_strb(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_strb),
    .io_sharedInputs_0_w_payload_last(axi_core_dBus_decoder_io_sharedOutputs_1_w_payload_last),
    .io_sharedInputs_0_b_valid(axi_rom_io_axi_arbiter_io_sharedInputs_0_b_valid),
    .io_sharedInputs_0_b_ready(axi_core_dBus_decoder_io_sharedOutputs_1_b_ready),
    .io_sharedInputs_0_b_payload_id(axi_rom_io_axi_arbiter_io_sharedInputs_0_b_payload_id),
    .io_sharedInputs_0_b_payload_resp(axi_rom_io_axi_arbiter_io_sharedInputs_0_b_payload_resp),
    .io_sharedInputs_0_r_valid(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_valid),
    .io_sharedInputs_0_r_ready(axi_core_dBus_decoder_io_sharedOutputs_1_r_ready),
    .io_sharedInputs_0_r_payload_data(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_data),
    .io_sharedInputs_0_r_payload_id(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_id),
    .io_sharedInputs_0_r_payload_resp(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_resp),
    .io_sharedInputs_0_r_payload_last(axi_rom_io_axi_arbiter_io_sharedInputs_0_r_payload_last),
    .io_output_arw_valid(axi_rom_io_axi_arbiter_io_output_arw_valid),
    .io_output_arw_ready(axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_ready),
    .io_output_arw_payload_addr(axi_rom_io_axi_arbiter_io_output_arw_payload_addr),
    .io_output_arw_payload_id(axi_rom_io_axi_arbiter_io_output_arw_payload_id),
    .io_output_arw_payload_len(axi_rom_io_axi_arbiter_io_output_arw_payload_len),
    .io_output_arw_payload_size(axi_rom_io_axi_arbiter_io_output_arw_payload_size),
    .io_output_arw_payload_burst(axi_rom_io_axi_arbiter_io_output_arw_payload_burst),
    .io_output_arw_payload_write(axi_rom_io_axi_arbiter_io_output_arw_payload_write),
    .io_output_w_valid(axi_rom_io_axi_arbiter_io_output_w_valid),
    .io_output_w_ready(_zz_58_),
    .io_output_w_payload_data(axi_rom_io_axi_arbiter_io_output_w_payload_data),
    .io_output_w_payload_strb(axi_rom_io_axi_arbiter_io_output_w_payload_strb),
    .io_output_w_payload_last(axi_rom_io_axi_arbiter_io_output_w_payload_last),
    .io_output_b_valid(axi_rom_io_axi_b_valid),
    .io_output_b_ready(axi_rom_io_axi_arbiter_io_output_b_ready),
    .io_output_b_payload_id(axi_rom_io_axi_b_payload_id),
    .io_output_b_payload_resp(axi_rom_io_axi_b_payload_resp),
    .io_output_r_valid(axi_rom_io_axi_r_valid),
    .io_output_r_ready(axi_rom_io_axi_arbiter_io_output_r_ready),
    .io_output_r_payload_data(axi_rom_io_axi_r_payload_data),
    .io_output_r_payload_id(axi_rom_io_axi_r_payload_id),
    .io_output_r_payload_resp(axi_rom_io_axi_r_payload_resp),
    .io_output_r_payload_last(axi_rom_io_axi_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4ReadOnlyArbiter io_axiIO_readOnly_arbiter ( 
    .io_inputs_0_ar_valid(_zz_11_),
    .io_inputs_0_ar_ready(io_axiIO_readOnly_arbiter_io_inputs_0_ar_ready),
    .io_inputs_0_ar_payload_addr(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_addr),
    .io_inputs_0_ar_payload_id(_zz_30_),
    .io_inputs_0_ar_payload_region(_zz_31_),
    .io_inputs_0_ar_payload_len(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_len),
    .io_inputs_0_ar_payload_size(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_size),
    .io_inputs_0_ar_payload_burst(_zz_59_),
    .io_inputs_0_ar_payload_lock(_zz_60_),
    .io_inputs_0_ar_payload_cache(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_cache),
    .io_inputs_0_ar_payload_qos(_zz_61_),
    .io_inputs_0_ar_payload_prot(axi_core_dBus_decoder_io_readOutputs_0_ar_payload_prot),
    .io_inputs_0_r_valid(io_axiIO_readOnly_arbiter_io_inputs_0_r_valid),
    .io_inputs_0_r_ready(axi_core_dBus_decoder_io_readOutputs_0_r_ready),
    .io_inputs_0_r_payload_data(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_data),
    .io_inputs_0_r_payload_id(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_id),
    .io_inputs_0_r_payload_resp(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_resp),
    .io_inputs_0_r_payload_last(io_axiIO_readOnly_arbiter_io_inputs_0_r_payload_last),
    .io_output_ar_valid(io_axiIO_readOnly_arbiter_io_output_ar_valid),
    .io_output_ar_ready(io_axiIO_readOnly_ar_ready),
    .io_output_ar_payload_addr(io_axiIO_readOnly_arbiter_io_output_ar_payload_addr),
    .io_output_ar_payload_id(io_axiIO_readOnly_arbiter_io_output_ar_payload_id),
    .io_output_ar_payload_region(io_axiIO_readOnly_arbiter_io_output_ar_payload_region),
    .io_output_ar_payload_len(io_axiIO_readOnly_arbiter_io_output_ar_payload_len),
    .io_output_ar_payload_size(io_axiIO_readOnly_arbiter_io_output_ar_payload_size),
    .io_output_ar_payload_burst(io_axiIO_readOnly_arbiter_io_output_ar_payload_burst),
    .io_output_ar_payload_lock(io_axiIO_readOnly_arbiter_io_output_ar_payload_lock),
    .io_output_ar_payload_cache(io_axiIO_readOnly_arbiter_io_output_ar_payload_cache),
    .io_output_ar_payload_qos(io_axiIO_readOnly_arbiter_io_output_ar_payload_qos),
    .io_output_ar_payload_prot(io_axiIO_readOnly_arbiter_io_output_ar_payload_prot),
    .io_output_r_valid(io_axiIO_readOnly_r_valid),
    .io_output_r_ready(io_axiIO_readOnly_arbiter_io_output_r_ready),
    .io_output_r_payload_data(io_axiIO_readOnly_r_payload_data),
    .io_output_r_payload_id(io_axiIO_readOnly_r_payload_id),
    .io_output_r_payload_resp(io_axiIO_readOnly_r_payload_resp),
    .io_output_r_payload_last(io_axiIO_readOnly_r_payload_last),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  NoDebug_Axi4WriteOnlyArbiter io_axiIO_writeOnly_arbiter ( 
    .io_inputs_0_aw_valid(_zz_14_),
    .io_inputs_0_aw_ready(io_axiIO_writeOnly_arbiter_io_inputs_0_aw_ready),
    .io_inputs_0_aw_payload_addr(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_addr),
    .io_inputs_0_aw_payload_id(_zz_32_),
    .io_inputs_0_aw_payload_region(_zz_33_),
    .io_inputs_0_aw_payload_len(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_len),
    .io_inputs_0_aw_payload_size(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_size),
    .io_inputs_0_aw_payload_burst(_zz_62_),
    .io_inputs_0_aw_payload_lock(_zz_63_),
    .io_inputs_0_aw_payload_cache(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_cache),
    .io_inputs_0_aw_payload_qos(_zz_64_),
    .io_inputs_0_aw_payload_prot(axi_core_dBus_decoder_io_writeOutputs_0_aw_payload_prot),
    .io_inputs_0_w_valid(axi_core_dBus_decoder_io_writeOutputs_0_w_valid),
    .io_inputs_0_w_ready(io_axiIO_writeOnly_arbiter_io_inputs_0_w_ready),
    .io_inputs_0_w_payload_data(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_data),
    .io_inputs_0_w_payload_strb(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_strb),
    .io_inputs_0_w_payload_last(axi_core_dBus_decoder_io_writeOutputs_0_w_payload_last),
    .io_inputs_0_b_valid(io_axiIO_writeOnly_arbiter_io_inputs_0_b_valid),
    .io_inputs_0_b_ready(axi_core_dBus_decoder_io_writeOutputs_0_b_ready),
    .io_inputs_0_b_payload_id(io_axiIO_writeOnly_arbiter_io_inputs_0_b_payload_id),
    .io_inputs_0_b_payload_resp(io_axiIO_writeOnly_arbiter_io_inputs_0_b_payload_resp),
    .io_output_aw_valid(io_axiIO_writeOnly_arbiter_io_output_aw_valid),
    .io_output_aw_ready(io_axiIO_writeOnly_aw_ready),
    .io_output_aw_payload_addr(io_axiIO_writeOnly_arbiter_io_output_aw_payload_addr),
    .io_output_aw_payload_id(io_axiIO_writeOnly_arbiter_io_output_aw_payload_id),
    .io_output_aw_payload_region(io_axiIO_writeOnly_arbiter_io_output_aw_payload_region),
    .io_output_aw_payload_len(io_axiIO_writeOnly_arbiter_io_output_aw_payload_len),
    .io_output_aw_payload_size(io_axiIO_writeOnly_arbiter_io_output_aw_payload_size),
    .io_output_aw_payload_burst(io_axiIO_writeOnly_arbiter_io_output_aw_payload_burst),
    .io_output_aw_payload_lock(io_axiIO_writeOnly_arbiter_io_output_aw_payload_lock),
    .io_output_aw_payload_cache(io_axiIO_writeOnly_arbiter_io_output_aw_payload_cache),
    .io_output_aw_payload_qos(io_axiIO_writeOnly_arbiter_io_output_aw_payload_qos),
    .io_output_aw_payload_prot(io_axiIO_writeOnly_arbiter_io_output_aw_payload_prot),
    .io_output_w_valid(io_axiIO_writeOnly_arbiter_io_output_w_valid),
    .io_output_w_ready(io_axiIO_writeOnly_w_ready),
    .io_output_w_payload_data(io_axiIO_writeOnly_arbiter_io_output_w_payload_data),
    .io_output_w_payload_strb(io_axiIO_writeOnly_arbiter_io_output_w_payload_strb),
    .io_output_w_payload_last(io_axiIO_writeOnly_arbiter_io_output_w_payload_last),
    .io_output_b_valid(io_axiIO_writeOnly_b_valid),
    .io_output_b_ready(io_axiIO_writeOnly_arbiter_io_output_b_ready),
    .io_output_b_payload_id(io_axiIO_writeOnly_b_payload_id),
    .io_output_b_payload_resp(io_axiIO_writeOnly_b_payload_resp),
    .io_axiClk(io_axiClk),
    .resetCtrl_axiReset(resetCtrl_axiReset) 
  );
  always @ (*) begin
    resetCtrl_systemResetUnbuffered = 1'b0;
    if(_zz_65_)begin
      resetCtrl_systemResetUnbuffered = 1'b1;
    end
  end

  assign _zz_1_[5 : 0] = (6'b111111);
  assign axi_core_iBus_ar_valid = axi_core_cpu_iBus_cmd_valid;
  assign axi_core_iBus_ar_payload_len = (8'b00000111);
  assign axi_core_iBus_ar_payload_addr = axi_core_cpu_iBus_cmd_payload_address;
  assign axi_core_iBus_ar_payload_prot = (3'b110);
  assign axi_core_iBus_ar_payload_cache = (4'b1111);
  assign axi_core_iBus_ar_payload_burst = (2'b01);
  assign _zz_35_ = (! (axi_core_iBus_r_payload_resp == (2'b00)));
  assign axi_core_iBus_r_ready = 1'b1;
  assign _zz_36_ = ((1'b1 && (! axi_core_cpu_dBus_cmd_m2sPipe_valid)) || axi_core_cpu_dBus_cmd_m2sPipe_ready);
  assign axi_core_cpu_dBus_cmd_m2sPipe_valid = axi_core_cpu_dBus_cmd_m2sPipe_rValid;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_wr = axi_core_cpu_dBus_cmd_m2sPipe_rData_wr;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_address = axi_core_cpu_dBus_cmd_m2sPipe_rData_address;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_data = axi_core_cpu_dBus_cmd_m2sPipe_rData_data;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_mask = axi_core_cpu_dBus_cmd_m2sPipe_rData_mask;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_length = axi_core_cpu_dBus_cmd_m2sPipe_rData_length;
  assign axi_core_cpu_dBus_cmd_m2sPipe_payload_last = axi_core_cpu_dBus_cmd_m2sPipe_rData_last;
  assign axi_core_cpu_dBus_cmd_m2sPipe_ready = ((1'b1 && (! axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_valid)) || axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_ready);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_valid = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rValid;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_wr = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_wr;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_address = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_address;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_data = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_data;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_mask = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_mask;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_length = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_length;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_last = axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_last;
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_valid = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_valid || axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_ready = (! axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_wr = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_wr : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_wr);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_address = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_address : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_address);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_data = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_data : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_data);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_mask = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_mask : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_mask);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_length = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_length : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_length);
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_last = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid ? axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_last : axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_last);
  always @ (*) begin
    _zz_2_ = 1'b0;
    if(((axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_valid && axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_ready) && axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_wr))begin
      _zz_2_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_3_ = 1'b0;
    if((axi_core_dBus_b_valid && 1'b1))begin
      _zz_3_ = 1'b1;
    end
  end

  always @ (*) begin
    if((_zz_2_ && (! _zz_3_)))begin
      _zz_5_ = (3'b001);
    end else begin
      if(((! _zz_2_) && _zz_3_))begin
        _zz_5_ = (3'b111);
      end else begin
        _zz_5_ = (3'b000);
      end
    end
  end

  assign _zz_6_ = (! (((_zz_4_ != (3'b000)) && (! axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_payload_wr)) || (_zz_4_ == (3'b111))));
  assign axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_ready = (streamFork_io_input_ready && _zz_6_);
  assign _zz_38_ = (axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_valid && _zz_6_);
  always @ (*) begin
    streamFork_io_outputs_0_thrown_valid = streamFork_io_outputs_0_valid;
    if(_zz_7_)begin
      streamFork_io_outputs_0_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_39_ = streamFork_io_outputs_0_thrown_ready;
    if(_zz_7_)begin
      _zz_39_ = 1'b1;
    end
  end

  assign streamFork_io_outputs_0_thrown_payload_wr = streamFork_io_outputs_0_payload_wr;
  assign streamFork_io_outputs_0_thrown_payload_address = streamFork_io_outputs_0_payload_address;
  assign streamFork_io_outputs_0_thrown_payload_data = streamFork_io_outputs_0_payload_data;
  assign streamFork_io_outputs_0_thrown_payload_mask = streamFork_io_outputs_0_payload_mask;
  assign streamFork_io_outputs_0_thrown_payload_length = streamFork_io_outputs_0_payload_length;
  assign streamFork_io_outputs_0_thrown_payload_last = streamFork_io_outputs_0_payload_last;
  always @ (*) begin
    streamFork_io_outputs_1_thrown_valid = streamFork_io_outputs_1_valid;
    if(_zz_66_)begin
      streamFork_io_outputs_1_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    _zz_40_ = streamFork_io_outputs_1_thrown_ready;
    if(_zz_66_)begin
      _zz_40_ = 1'b1;
    end
  end

  assign streamFork_io_outputs_1_thrown_payload_wr = streamFork_io_outputs_1_payload_wr;
  assign streamFork_io_outputs_1_thrown_payload_address = streamFork_io_outputs_1_payload_address;
  assign streamFork_io_outputs_1_thrown_payload_data = streamFork_io_outputs_1_payload_data;
  assign streamFork_io_outputs_1_thrown_payload_mask = streamFork_io_outputs_1_payload_mask;
  assign streamFork_io_outputs_1_thrown_payload_length = streamFork_io_outputs_1_payload_length;
  assign streamFork_io_outputs_1_thrown_payload_last = streamFork_io_outputs_1_payload_last;
  assign streamFork_io_outputs_0_thrown_ready = axi_core_dBus_arw_ready;
  assign streamFork_io_outputs_1_thrown_ready = axi_core_dBus_w_ready;
  assign _zz_37_ = (! (axi_core_dBus_r_payload_resp == (2'b00)));
  assign axi_core_dBus_arw_valid = streamFork_io_outputs_0_thrown_valid;
  assign axi_core_dBus_arw_payload_addr = streamFork_io_outputs_0_thrown_payload_address;
  assign axi_core_dBus_arw_payload_len = {5'd0, streamFork_io_outputs_0_thrown_payload_length};
  assign axi_core_dBus_arw_payload_size = (3'b010);
  assign axi_core_dBus_arw_payload_cache = (4'b1111);
  assign axi_core_dBus_arw_payload_prot = (3'b010);
  assign axi_core_dBus_arw_payload_write = streamFork_io_outputs_0_thrown_payload_wr;
  assign axi_core_dBus_w_valid = streamFork_io_outputs_1_thrown_valid;
  assign axi_core_dBus_w_payload_data = streamFork_io_outputs_1_thrown_payload_data;
  assign axi_core_dBus_w_payload_strb = streamFork_io_outputs_1_thrown_payload_mask;
  assign axi_core_dBus_w_payload_last = streamFork_io_outputs_1_thrown_payload_last;
  assign axi_core_dBus_b_ready = 1'b1;
  assign axi_core_dBus_r_ready = 1'b1;
  assign io_axiIO_ar_valid = io_axiIO_readOnly_ar_valid;
  assign io_axiIO_readOnly_ar_ready = io_axiIO_ar_ready;
  assign io_axiIO_ar_payload_addr = io_axiIO_readOnly_ar_payload_addr;
  assign io_axiIO_ar_payload_id = io_axiIO_readOnly_ar_payload_id;
  assign io_axiIO_ar_payload_region = io_axiIO_readOnly_ar_payload_region;
  assign io_axiIO_ar_payload_len = io_axiIO_readOnly_ar_payload_len;
  assign io_axiIO_ar_payload_size = io_axiIO_readOnly_ar_payload_size;
  assign io_axiIO_ar_payload_burst = io_axiIO_readOnly_ar_payload_burst;
  assign io_axiIO_ar_payload_lock = io_axiIO_readOnly_ar_payload_lock;
  assign io_axiIO_ar_payload_cache = io_axiIO_readOnly_ar_payload_cache;
  assign io_axiIO_ar_payload_qos = io_axiIO_readOnly_ar_payload_qos;
  assign io_axiIO_ar_payload_prot = io_axiIO_readOnly_ar_payload_prot;
  assign io_axiIO_readOnly_r_valid = io_axiIO_r_valid;
  assign io_axiIO_r_ready = io_axiIO_readOnly_r_ready;
  assign io_axiIO_readOnly_r_payload_data = io_axiIO_r_payload_data;
  assign io_axiIO_readOnly_r_payload_last = io_axiIO_r_payload_last;
  assign io_axiIO_readOnly_r_payload_id = io_axiIO_r_payload_id;
  assign io_axiIO_readOnly_r_payload_resp = io_axiIO_r_payload_resp;
  assign io_axiIO_aw_valid = io_axiIO_writeOnly_aw_valid;
  assign io_axiIO_writeOnly_aw_ready = io_axiIO_aw_ready;
  assign io_axiIO_aw_payload_addr = io_axiIO_writeOnly_aw_payload_addr;
  assign io_axiIO_aw_payload_id = io_axiIO_writeOnly_aw_payload_id;
  assign io_axiIO_aw_payload_region = io_axiIO_writeOnly_aw_payload_region;
  assign io_axiIO_aw_payload_len = io_axiIO_writeOnly_aw_payload_len;
  assign io_axiIO_aw_payload_size = io_axiIO_writeOnly_aw_payload_size;
  assign io_axiIO_aw_payload_burst = io_axiIO_writeOnly_aw_payload_burst;
  assign io_axiIO_aw_payload_lock = io_axiIO_writeOnly_aw_payload_lock;
  assign io_axiIO_aw_payload_cache = io_axiIO_writeOnly_aw_payload_cache;
  assign io_axiIO_aw_payload_qos = io_axiIO_writeOnly_aw_payload_qos;
  assign io_axiIO_aw_payload_prot = io_axiIO_writeOnly_aw_payload_prot;
  assign io_axiIO_w_valid = io_axiIO_writeOnly_w_valid;
  assign io_axiIO_writeOnly_w_ready = io_axiIO_w_ready;
  assign io_axiIO_w_payload_data = io_axiIO_writeOnly_w_payload_data;
  assign io_axiIO_w_payload_strb = io_axiIO_writeOnly_w_payload_strb;
  assign io_axiIO_w_payload_last = io_axiIO_writeOnly_w_payload_last;
  assign io_axiIO_writeOnly_b_valid = io_axiIO_b_valid;
  assign io_axiIO_b_ready = io_axiIO_writeOnly_b_ready;
  assign io_axiIO_writeOnly_b_payload_id = io_axiIO_b_payload_id;
  assign io_axiIO_writeOnly_b_payload_resp = io_axiIO_b_payload_resp;
  assign _zz_8_ = _zz_10_;
  assign _zz_41_ = (_zz_9_ && _zz_10_);
  assign _zz_9_ = axi_rom_io_axi_arbiter_io_readInputs_0_ar_ready;
  assign axi_core_iBus_ar_ready = axi_core_iBus_decoder_io_input_ar_ready;
  assign axi_core_iBus_r_valid = axi_core_iBus_decoder_io_input_r_valid;
  assign axi_core_iBus_r_payload_data = axi_core_iBus_decoder_io_input_r_payload_data;
  assign axi_core_iBus_r_payload_last = axi_core_iBus_decoder_io_input_r_payload_last;
  assign axi_core_iBus_r_payload_resp = axi_core_iBus_decoder_io_input_r_payload_resp;
  assign _zz_11_ = _zz_13_;
  assign _zz_43_ = (_zz_12_ && _zz_13_);
  assign _zz_12_ = io_axiIO_readOnly_arbiter_io_inputs_0_ar_ready;
  assign _zz_14_ = _zz_16_;
  assign _zz_44_ = (_zz_15_ && _zz_16_);
  assign _zz_15_ = io_axiIO_writeOnly_arbiter_io_inputs_0_aw_ready;
  assign _zz_17_ = _zz_19_;
  assign _zz_45_ = (_zz_18_ && _zz_19_);
  assign _zz_18_ = axi_svram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign _zz_20_ = _zz_22_;
  assign _zz_46_ = (_zz_21_ && _zz_22_);
  assign _zz_21_ = axi_rom_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign _zz_23_ = _zz_25_;
  assign _zz_47_ = (_zz_24_ && _zz_25_);
  assign _zz_24_ = axi_ram_io_axi_arbiter_io_sharedInputs_0_arw_ready;
  assign axi_core_dBus_arw_ready = axi_core_dBus_decoder_io_input_arw_ready;
  assign axi_core_dBus_w_ready = axi_core_dBus_decoder_io_input_w_ready;
  assign axi_core_dBus_b_valid = axi_core_dBus_decoder_io_input_b_valid;
  assign axi_core_dBus_b_payload_resp = axi_core_dBus_decoder_io_input_b_payload_resp;
  assign _zz_42_ = ((1'b1 && (! axi_core_dBus_decoder_io_input_r_m2sPipe_valid)) || axi_core_dBus_decoder_io_input_r_m2sPipe_ready);
  assign axi_core_dBus_decoder_io_input_r_m2sPipe_valid = axi_core_dBus_decoder_io_input_r_m2sPipe_rValid;
  assign axi_core_dBus_decoder_io_input_r_m2sPipe_payload_data = axi_core_dBus_decoder_io_input_r_m2sPipe_rData_data;
  assign axi_core_dBus_decoder_io_input_r_m2sPipe_payload_resp = axi_core_dBus_decoder_io_input_r_m2sPipe_rData_resp;
  assign axi_core_dBus_decoder_io_input_r_m2sPipe_payload_last = axi_core_dBus_decoder_io_input_r_m2sPipe_rData_last;
  assign axi_core_dBus_r_valid = axi_core_dBus_decoder_io_input_r_m2sPipe_valid;
  assign axi_core_dBus_decoder_io_input_r_m2sPipe_ready = axi_core_dBus_r_ready;
  assign axi_core_dBus_r_payload_data = axi_core_dBus_decoder_io_input_r_m2sPipe_payload_data;
  assign axi_core_dBus_r_payload_resp = axi_core_dBus_decoder_io_input_r_m2sPipe_payload_resp;
  assign axi_core_dBus_r_payload_last = axi_core_dBus_decoder_io_input_r_m2sPipe_payload_last;
  assign _zz_48_ = axi_core_dBus_decoder_io_sharedOutputs_2_arw_payload_addr[16:0];
  assign _zz_26_[3 : 0] = (4'b0000);
  assign _zz_49_ = (2'b01);
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_valid = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_id = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_len = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_size = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_payload_write = axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  assign axi_ram_io_axi_arbiter_io_output_arw_halfPipe_ready = axi_ram_io_axi_arw_ready;
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_valid = (axi_ram_io_axi_arbiter_io_output_w_valid || axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign _zz_50_ = (! axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_data = (axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_data : axi_ram_io_axi_arbiter_io_output_w_payload_data);
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb = (axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb : axi_ram_io_axi_arbiter_io_output_w_payload_strb);
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_last = (axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_last : axi_ram_io_axi_arbiter_io_output_w_payload_last);
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready = ((1'b1 && (! axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid)) || axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready);
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid = axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data = axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb = axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last = axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  assign axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready = axi_ram_io_axi_w_ready;
  assign _zz_51_ = axi_core_dBus_decoder_io_sharedOutputs_0_arw_payload_addr[11:0];
  assign _zz_27_[3 : 0] = (4'b0000);
  assign _zz_52_ = (2'b01);
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_valid = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_addr = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_id = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_len = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_size = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_burst = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_payload_write = axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  assign axi_svram_io_axi_arbiter_io_output_arw_halfPipe_ready = axi_svram_io_axi_arw_ready;
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_valid = (axi_svram_io_axi_arbiter_io_output_w_valid || axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign _zz_53_ = (! axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_data = (axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_data : axi_svram_io_axi_arbiter_io_output_w_payload_data);
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb = (axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb : axi_svram_io_axi_arbiter_io_output_w_payload_strb);
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_last = (axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_last : axi_svram_io_axi_arbiter_io_output_w_payload_last);
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready = ((1'b1 && (! axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid)) || axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready);
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid = axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data = axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb = axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last = axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  assign axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready = axi_svram_io_axi_w_ready;
  assign _zz_54_ = axi_core_iBus_decoder_io_outputs_0_ar_payload_addr[16:0];
  assign _zz_28_[2 : 0] = (3'b000);
  assign _zz_55_ = (3'b010);
  assign _zz_56_ = axi_core_dBus_decoder_io_sharedOutputs_1_arw_payload_addr[16:0];
  assign _zz_29_[2 : 0] = (3'b000);
  assign _zz_57_ = (2'b01);
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_valid = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_addr = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_id = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_len = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_size = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_burst = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_payload_write = axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write;
  assign axi_rom_io_axi_arbiter_io_output_arw_halfPipe_ready = axi_rom_io_axi_arw_ready;
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_valid = (axi_rom_io_axi_arbiter_io_output_w_valid || axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign _zz_58_ = (! axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid);
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_data = (axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_data : axi_rom_io_axi_arbiter_io_output_w_payload_data);
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_strb = (axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_strb : axi_rom_io_axi_arbiter_io_output_w_payload_strb);
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_last = (axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid ? axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_last : axi_rom_io_axi_arbiter_io_output_w_payload_last);
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready = ((1'b1 && (! axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid)) || axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready);
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_valid = axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid;
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_data = axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data;
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_strb = axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb;
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_payload_last = axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last;
  assign axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_ready = axi_rom_io_axi_w_ready;
  assign _zz_30_[3 : 0] = (4'b0000);
  assign _zz_31_[3 : 0] = (4'b0000);
  assign _zz_59_ = (2'b01);
  assign _zz_60_ = (1'b0);
  assign _zz_61_ = (4'b0000);
  assign io_axiIO_readOnly_ar_valid = io_axiIO_readOnly_arbiter_io_output_ar_valid;
  assign io_axiIO_readOnly_ar_payload_addr = io_axiIO_readOnly_arbiter_io_output_ar_payload_addr;
  assign io_axiIO_readOnly_ar_payload_id = io_axiIO_readOnly_arbiter_io_output_ar_payload_id;
  assign io_axiIO_readOnly_ar_payload_region = io_axiIO_readOnly_arbiter_io_output_ar_payload_region;
  assign io_axiIO_readOnly_ar_payload_len = io_axiIO_readOnly_arbiter_io_output_ar_payload_len;
  assign io_axiIO_readOnly_ar_payload_size = io_axiIO_readOnly_arbiter_io_output_ar_payload_size;
  assign io_axiIO_readOnly_ar_payload_burst = io_axiIO_readOnly_arbiter_io_output_ar_payload_burst;
  assign io_axiIO_readOnly_ar_payload_lock = io_axiIO_readOnly_arbiter_io_output_ar_payload_lock;
  assign io_axiIO_readOnly_ar_payload_cache = io_axiIO_readOnly_arbiter_io_output_ar_payload_cache;
  assign io_axiIO_readOnly_ar_payload_qos = io_axiIO_readOnly_arbiter_io_output_ar_payload_qos;
  assign io_axiIO_readOnly_ar_payload_prot = io_axiIO_readOnly_arbiter_io_output_ar_payload_prot;
  assign io_axiIO_readOnly_r_ready = io_axiIO_readOnly_arbiter_io_output_r_ready;
  assign _zz_32_[3 : 0] = (4'b0000);
  assign _zz_33_[3 : 0] = (4'b0000);
  assign _zz_62_ = (2'b01);
  assign _zz_63_ = (1'b0);
  assign _zz_64_ = (4'b0000);
  assign io_axiIO_writeOnly_aw_valid = io_axiIO_writeOnly_arbiter_io_output_aw_valid;
  assign io_axiIO_writeOnly_aw_payload_addr = io_axiIO_writeOnly_arbiter_io_output_aw_payload_addr;
  assign io_axiIO_writeOnly_aw_payload_id = io_axiIO_writeOnly_arbiter_io_output_aw_payload_id;
  assign io_axiIO_writeOnly_aw_payload_region = io_axiIO_writeOnly_arbiter_io_output_aw_payload_region;
  assign io_axiIO_writeOnly_aw_payload_len = io_axiIO_writeOnly_arbiter_io_output_aw_payload_len;
  assign io_axiIO_writeOnly_aw_payload_size = io_axiIO_writeOnly_arbiter_io_output_aw_payload_size;
  assign io_axiIO_writeOnly_aw_payload_burst = io_axiIO_writeOnly_arbiter_io_output_aw_payload_burst;
  assign io_axiIO_writeOnly_aw_payload_lock = io_axiIO_writeOnly_arbiter_io_output_aw_payload_lock;
  assign io_axiIO_writeOnly_aw_payload_cache = io_axiIO_writeOnly_arbiter_io_output_aw_payload_cache;
  assign io_axiIO_writeOnly_aw_payload_qos = io_axiIO_writeOnly_arbiter_io_output_aw_payload_qos;
  assign io_axiIO_writeOnly_aw_payload_prot = io_axiIO_writeOnly_arbiter_io_output_aw_payload_prot;
  assign io_axiIO_writeOnly_w_valid = io_axiIO_writeOnly_arbiter_io_output_w_valid;
  assign io_axiIO_writeOnly_w_payload_data = io_axiIO_writeOnly_arbiter_io_output_w_payload_data;
  assign io_axiIO_writeOnly_w_payload_strb = io_axiIO_writeOnly_arbiter_io_output_w_payload_strb;
  assign io_axiIO_writeOnly_w_payload_last = io_axiIO_writeOnly_arbiter_io_output_w_payload_last;
  assign io_axiIO_writeOnly_b_ready = io_axiIO_writeOnly_arbiter_io_output_b_ready;
  assign io_jtag_tdo = 1'b0;
  assign _zz_34_ = 1'b0;
  always @ (posedge io_axiClk) begin
    if(_zz_65_)begin
      resetCtrl_systemResetCounter <= (resetCtrl_systemResetCounter + (6'b000001));
    end
    if(bufferCC_io_dataOut)begin
      resetCtrl_systemResetCounter <= (6'b000000);
    end
  end

  always @ (posedge io_axiClk) begin
    resetCtrl_systemReset <= resetCtrl_systemResetUnbuffered;
    resetCtrl_axiReset <= resetCtrl_systemResetUnbuffered;
  end

  always @ (posedge io_axiClk or posedge resetCtrl_axiReset) begin
    if (resetCtrl_axiReset) begin
      axi_core_cpu_dBus_cmd_m2sPipe_rValid <= 1'b0;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rValid <= 1'b0;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid <= 1'b0;
      _zz_4_ <= (3'b000);
      _zz_7_ <= 1'b0;
      _zz_10_ <= 1'b0;
      _zz_13_ <= 1'b0;
      _zz_16_ <= 1'b0;
      _zz_19_ <= 1'b0;
      _zz_22_ <= 1'b0;
      _zz_25_ <= 1'b0;
      axi_core_dBus_decoder_io_input_r_m2sPipe_rValid <= 1'b0;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= 1'b0;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= 1'b1;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= 1'b0;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= 1'b0;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= 1'b1;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= 1'b0;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= 1'b0;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= 1'b1;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= 1'b0;
    end else begin
      if(_zz_36_)begin
        axi_core_cpu_dBus_cmd_m2sPipe_rValid <= axi_core_cpu_dBus_cmd_valid;
      end
      if(axi_core_cpu_dBus_cmd_m2sPipe_ready)begin
        axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rValid <= axi_core_cpu_dBus_cmd_m2sPipe_valid;
      end
      if(axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_ready)begin
        axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_67_)begin
        axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rValid <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_valid;
      end
      _zz_4_ <= (_zz_4_ + _zz_5_);
      if((streamFork_io_outputs_0_valid && _zz_39_))begin
        _zz_7_ <= (! streamFork_io_outputs_0_payload_last);
      end
      if(axi_core_iBus_decoder_io_outputs_0_ar_valid)begin
        _zz_10_ <= 1'b1;
      end
      if((_zz_8_ && _zz_9_))begin
        _zz_10_ <= 1'b0;
      end
      if(axi_core_dBus_decoder_io_readOutputs_0_ar_valid)begin
        _zz_13_ <= 1'b1;
      end
      if((_zz_11_ && _zz_12_))begin
        _zz_13_ <= 1'b0;
      end
      if(axi_core_dBus_decoder_io_writeOutputs_0_aw_valid)begin
        _zz_16_ <= 1'b1;
      end
      if((_zz_14_ && _zz_15_))begin
        _zz_16_ <= 1'b0;
      end
      if(axi_core_dBus_decoder_io_sharedOutputs_0_arw_valid)begin
        _zz_19_ <= 1'b1;
      end
      if((_zz_17_ && _zz_18_))begin
        _zz_19_ <= 1'b0;
      end
      if(axi_core_dBus_decoder_io_sharedOutputs_1_arw_valid)begin
        _zz_22_ <= 1'b1;
      end
      if((_zz_20_ && _zz_21_))begin
        _zz_22_ <= 1'b0;
      end
      if(axi_core_dBus_decoder_io_sharedOutputs_2_arw_valid)begin
        _zz_25_ <= 1'b1;
      end
      if((_zz_23_ && _zz_24_))begin
        _zz_25_ <= 1'b0;
      end
      if(_zz_42_)begin
        axi_core_dBus_decoder_io_input_r_m2sPipe_rValid <= axi_core_dBus_decoder_io_input_r_valid;
      end
      if(_zz_68_)begin
        axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= axi_ram_io_axi_arbiter_io_output_arw_valid;
        axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= (! axi_ram_io_axi_arbiter_io_output_arw_valid);
      end else begin
        axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= (! axi_ram_io_axi_arbiter_io_output_arw_halfPipe_ready);
        axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= axi_ram_io_axi_arbiter_io_output_arw_halfPipe_ready;
      end
      if(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_69_)begin
        axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= axi_ram_io_axi_arbiter_io_output_w_valid;
      end
      if(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= axi_ram_io_axi_arbiter_io_output_w_s2mPipe_valid;
      end
      if(_zz_70_)begin
        axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= axi_svram_io_axi_arbiter_io_output_arw_valid;
        axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= (! axi_svram_io_axi_arbiter_io_output_arw_valid);
      end else begin
        axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= (! axi_svram_io_axi_arbiter_io_output_arw_halfPipe_ready);
        axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= axi_svram_io_axi_arbiter_io_output_arw_halfPipe_ready;
      end
      if(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_71_)begin
        axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rValid <= axi_svram_io_axi_arbiter_io_output_w_valid;
      end
      if(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= axi_svram_io_axi_arbiter_io_output_w_s2mPipe_valid;
      end
      if(_zz_72_)begin
        axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= axi_rom_io_axi_arbiter_io_output_arw_valid;
        axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= (! axi_rom_io_axi_arbiter_io_output_arw_valid);
      end else begin
        axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_valid <= (! axi_rom_io_axi_arbiter_io_output_arw_halfPipe_ready);
        axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_ready <= axi_rom_io_axi_arbiter_io_output_arw_halfPipe_ready;
      end
      if(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid <= 1'b0;
      end
      if(_zz_73_)begin
        axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rValid <= axi_rom_io_axi_arbiter_io_output_w_valid;
      end
      if(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
        axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rValid <= axi_rom_io_axi_arbiter_io_output_w_s2mPipe_valid;
      end
    end
  end

  always @ (posedge io_axiClk) begin
    if(_zz_36_)begin
      axi_core_cpu_dBus_cmd_m2sPipe_rData_wr <= axi_core_cpu_dBus_cmd_payload_wr;
      axi_core_cpu_dBus_cmd_m2sPipe_rData_address <= axi_core_cpu_dBus_cmd_payload_address;
      axi_core_cpu_dBus_cmd_m2sPipe_rData_data <= axi_core_cpu_dBus_cmd_payload_data;
      axi_core_cpu_dBus_cmd_m2sPipe_rData_mask <= axi_core_cpu_dBus_cmd_payload_mask;
      axi_core_cpu_dBus_cmd_m2sPipe_rData_length <= axi_core_cpu_dBus_cmd_payload_length;
      axi_core_cpu_dBus_cmd_m2sPipe_rData_last <= axi_core_cpu_dBus_cmd_payload_last;
    end
    if(axi_core_cpu_dBus_cmd_m2sPipe_ready)begin
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_wr <= axi_core_cpu_dBus_cmd_m2sPipe_payload_wr;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_address <= axi_core_cpu_dBus_cmd_m2sPipe_payload_address;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_data <= axi_core_cpu_dBus_cmd_m2sPipe_payload_data;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_mask <= axi_core_cpu_dBus_cmd_m2sPipe_payload_mask;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_length <= axi_core_cpu_dBus_cmd_m2sPipe_payload_length;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_rData_last <= axi_core_cpu_dBus_cmd_m2sPipe_payload_last;
    end
    if(_zz_67_)begin
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_wr <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_wr;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_address <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_address;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_data <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_data;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_mask <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_mask;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_length <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_length;
      axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_s2mPipe_rData_last <= axi_core_cpu_dBus_cmd_m2sPipe_m2sPipe_payload_last;
    end
    if(_zz_42_)begin
      axi_core_dBus_decoder_io_input_r_m2sPipe_rData_data <= axi_core_dBus_decoder_io_input_r_payload_data;
      axi_core_dBus_decoder_io_input_r_m2sPipe_rData_resp <= axi_core_dBus_decoder_io_input_r_payload_resp;
      axi_core_dBus_decoder_io_input_r_m2sPipe_rData_last <= axi_core_dBus_decoder_io_input_r_payload_last;
    end
    if(_zz_68_)begin
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr <= axi_ram_io_axi_arbiter_io_output_arw_payload_addr;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id <= axi_ram_io_axi_arbiter_io_output_arw_payload_id;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len <= axi_ram_io_axi_arbiter_io_output_arw_payload_len;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size <= axi_ram_io_axi_arbiter_io_output_arw_payload_size;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst <= axi_ram_io_axi_arbiter_io_output_arw_payload_burst;
      axi_ram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write <= axi_ram_io_axi_arbiter_io_output_arw_payload_write;
    end
    if(_zz_69_)begin
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_data <= axi_ram_io_axi_arbiter_io_output_w_payload_data;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb <= axi_ram_io_axi_arbiter_io_output_w_payload_strb;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_rData_last <= axi_ram_io_axi_arbiter_io_output_w_payload_last;
    end
    if(axi_ram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data <= axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb <= axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
      axi_ram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last <= axi_ram_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
    end
    if(_zz_70_)begin
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr <= axi_svram_io_axi_arbiter_io_output_arw_payload_addr;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id <= axi_svram_io_axi_arbiter_io_output_arw_payload_id;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len <= axi_svram_io_axi_arbiter_io_output_arw_payload_len;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size <= axi_svram_io_axi_arbiter_io_output_arw_payload_size;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst <= axi_svram_io_axi_arbiter_io_output_arw_payload_burst;
      axi_svram_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write <= axi_svram_io_axi_arbiter_io_output_arw_payload_write;
    end
    if(_zz_71_)begin
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_data <= axi_svram_io_axi_arbiter_io_output_w_payload_data;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_strb <= axi_svram_io_axi_arbiter_io_output_w_payload_strb;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_rData_last <= axi_svram_io_axi_arbiter_io_output_w_payload_last;
    end
    if(axi_svram_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data <= axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb <= axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
      axi_svram_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last <= axi_svram_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
    end
    if(_zz_72_)begin
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_addr <= axi_rom_io_axi_arbiter_io_output_arw_payload_addr;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_id <= axi_rom_io_axi_arbiter_io_output_arw_payload_id;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_len <= axi_rom_io_axi_arbiter_io_output_arw_payload_len;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_size <= axi_rom_io_axi_arbiter_io_output_arw_payload_size;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_burst <= axi_rom_io_axi_arbiter_io_output_arw_payload_burst;
      axi_rom_io_axi_arbiter_io_output_arw_halfPipe_regs_payload_write <= axi_rom_io_axi_arbiter_io_output_arw_payload_write;
    end
    if(_zz_73_)begin
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_data <= axi_rom_io_axi_arbiter_io_output_w_payload_data;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_strb <= axi_rom_io_axi_arbiter_io_output_w_payload_strb;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_rData_last <= axi_rom_io_axi_arbiter_io_output_w_payload_last;
    end
    if(axi_rom_io_axi_arbiter_io_output_w_s2mPipe_ready)begin
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_data <= axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_data;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_strb <= axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_strb;
      axi_rom_io_axi_arbiter_io_output_w_s2mPipe_m2sPipe_rData_last <= axi_rom_io_axi_arbiter_io_output_w_s2mPipe_payload_last;
    end
  end

endmodule

