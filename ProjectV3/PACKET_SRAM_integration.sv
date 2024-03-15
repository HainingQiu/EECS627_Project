
module PACKET_SRAM_integration(
    input clk,
    input reset,
    input grant,
    input [`Num_Edge_PE-1:0]PE_IDLE,
    input [`packet_size-1:0] Edge_PE2IMEM_CNTL_in_packet_0,
    input [`packet_size-1:0] Edge_PE2IMEM_CNTL_in_packet_1,
    input [`packet_size-1:0] Edge_PE2IMEM_CNTL_in_packet_2,
    input [`packet_size-1:0] Edge_PE2IMEM_CNTL_in_packet_3,
    input [`Num_Edge_PE-1:0]  Edge_PE2IMEM_CNTL_in_valid,
    input [`Num_Edge_PE-1:0]bank_busy,
    input stream_end,
    input vertex_done,
    input outbuff_available,

    output logic task_complete,

    output logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_0,
    output logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_1,
    output logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_2,
    output logic [`packet_size-1-2:0] DP_task2Edge_PE_out_packet_3,
    output logic [`Num_Edge_PE-1:0] DP_task2Edge_PE_out_valid,
    output logic Req,
    output logic [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    output logic [$clog2(`MAX_FV_num):0 ]    Num_FV ,
    output logic [$clog2(`Max_Num_Weight_layer)-1:0 ] Weights_boundary,
    output logic stream_begin
);


Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_in;
DP_task2Edge_PE [`Num_Edge_PE-1:0]DP_task2Edge_PE_out;

assign Edge_PE2IMEM_CNTL_in[0].packet=Edge_PE2IMEM_CNTL_in_packet_0;
assign Edge_PE2IMEM_CNTL_in[1].packet=Edge_PE2IMEM_CNTL_in_packet_0;
assign Edge_PE2IMEM_CNTL_in[2].packet=Edge_PE2IMEM_CNTL_in_packet_0;
assign Edge_PE2IMEM_CNTL_in[3].packet=Edge_PE2IMEM_CNTL_in_packet_0;
assign Edge_PE2IMEM_CNTL_in[0].valid=Edge_PE2IMEM_CNTL_in_valid[0];
assign Edge_PE2IMEM_CNTL_in[1].valid=Edge_PE2IMEM_CNTL_in_valid[1];
assign Edge_PE2IMEM_CNTL_in[2].valid=Edge_PE2IMEM_CNTL_in_valid[2];
assign Edge_PE2IMEM_CNTL_in[3].valid=Edge_PE2IMEM_CNTL_in_valid[3];




assign DP_task2Edge_PE_out_packet_0=DP_task2Edge_PE_out[0];
assign DP_task2Edge_PE_out_packet_1=DP_task2Edge_PE_out[1];
assign DP_task2Edge_PE_out_packet_2=DP_task2Edge_PE_out[2];
assign DP_task2Edge_PE_out_packet_3=DP_task2Edge_PE_out[3];
assign DP_task2Edge_PE_out_valid={DP_task2Edge_PE_out[3].valid,DP_task2Edge_PE_out[2].valid,DP_task2Edge_PE_out[1].valid,DP_task2Edge_PE_out[0].valid};




DP2mem_packet DP2mem_packet_in;
logic fifo_full;
logic replay_iter_flag;
com_packet mem2fifo,com2DPpacket;
logic fifo_stall;
logic RS_full;
DP_task2RS DP_task2RS_out;
logic cntl_done;
logic RS_empty;
logic wr_en;
logic [`packet_size-1:0] Data_SRAM_in;
PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out;
IMem_Sram IMem_Sram_U(
    .Q(Data_SRAM_in ),
    .CLK(clk),
    .CEN(1'b0),
    .WEN(PACKET_CNTL_SRAM_out.wen),
    .A(PACKET_CNTL_SRAM_out.SRAM_addr),
    .D(PACKET_CNTL_SRAM_out.SRAM_DATA)
);
 PACKET_CNTL PACKET_CNTL_0(
    .clk(clk),
    .reset(reset),
    .DP2mem_packet_in(DP2mem_packet_in),
    .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_in),
    .full(fifo_full),
    .cntl_done(cntl_done),
    .wr_en(wr_en),
    .fifo_stall(fifo_stall),
    .replay_iter_flag(replay_iter_flag),
    .Data_SRAM_in(Data_SRAM_in),
    .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
    .mem2fifo(mem2fifo)
    // .cntl_done(cntl_done)
    
);

Command_FIFO Command_FIFO_0(
	.clk(clk)		, 
	.reset(reset)	,
	.winc(wr_en)	,
	.rinc( ~fifo_stall & ~RS_full )	,
	.replay_iter_flag(replay_iter_flag),
	.wdata(mem2fifo)	,
	.wfull(fifo_full),
	.rdata(com2DPpacket)
);
decoder decoder_0(
    .clk(clk),
    .reset(reset),
    .com2DPpacket(com2DPpacket),
    .RS_empty(RS_empty),
    .grant(grant), 
    .PE_IDLE(PE_IDLE),
    .bank_busy_in(bank_busy),
    .stream_end(stream_end),
    .DP_task2RS_out(DP_task2RS_out),
    .cntl_done(cntl_done),
    .vertex_done(vertex_done),
    .task_complete(task_complete),
    .Req(Req),
    .fifo_stall(fifo_stall),
    .current_replay_iter_flag(replay_iter_flag),
    .replay_Iter(replay_Iter),
    .Num_FV(Num_FV) ,
    .Weights_boundary(Weights_boundary),
    .DP2mem_packet_out(DP2mem_packet_in),
    .stream_begin(stream_begin),
    .outbuff_available(outbuff_available)
);
RS RS_0(
    .clk(clk),
    .reset(reset),
    .DP_task2RS_in(DP_task2RS_out),
    .replay_Iter(replay_Iter),
    .PE_IDLE(PE_IDLE),
    .bank_busy(bank_busy),
    .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
    .RS_empty(RS_empty),
    .RS_full(RS_full)
);
endmodule