
module PACKET_SRAM_integration(
    input clk,
    input reset,
    input grant,
    input [`Num_Edge_PE-1:0]PE_IDLE,
    input Edge_PE2IMEM_CNTL[`Num_Edge_PE-1:0] Edge_PE2IMEM_CNTL_in,
    input [`packet_size-1:0] Data_SRAM_in,
    input bank_busy,
    input stream_end,
    input vertex_done,
    output logic task_complete,
    output PACKET_CNTL2SRAM  PACKET_CNTL_SRAM_out,
    output DP_task2Edge_PE [`Num_Edge_PE-1:0]DP_task2Edge_PE_out,
    output logic Req,
    output logic [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    output logic [$clog2(16):0 ]    Num_FV ,
    output logic [$clog2(16)-1:0 ] Weights_boundary
);
DP2mem_packet DP2mem_packet_in;
logic fifo_full;
logic replay_iter_flag;
com_packet mem2fifo,com2DPpacket;
logic fifo_stall;
logic RS_full;
DP_task2RS DP_task2RS_out;
logic cntl_done;
logic RS_empty;
 PACKET_CNTL PACKET_CNTL_0(
    .clk(clk),
    .reset(reset),
    .DP2mem_packet_in(DP2mem_packet_in),
    .Edge_PE2IMEM_CNTL_in(Edge_PE2IMEM_CNTL_in),
    .full(fifo_full),
    .cntl_done(cntl_done),
    .stream_end(stream_end),
    .replay_iter_flag(replay_iter_flag),
    .Data_SRAM_in(Data_SRAM_in),
    .PACKET_CNTL_SRAM_out(PACKET_CNTL_SRAM_out),
    .mem2fifo(mem2fifo)
    // .cntl_done(cntl_done)
    
);

Command_FIFO Command_FIFO_0(
	.clk(clk)		, 
	.reset(reset)	,
	.winc(mem2fifo.valid)	,
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
    .bank_busy(bank_busy),
    .stream_end(stream_end),
    .DP_task2RS_out(DP_task2RS_out),
    .cntl_done(cntl_done),
    .vertex_done(vertex_done),
    .task_complete(task_complete),
    .Req(Req),
    .fifo_stall(fifo_stall),
    .replay_iter_flag(replay_iter_flag),
    .replay_Iter(replay_Iter),
    .Num_FV(Num_FV) ,
    .Weights_boundary(Weights_boundary),
    .DP2mem_packet_out(DP2mem_packet_in)
);
RS RS_0(
    .clk(clk),
    .reset(reset),
    .DP_task2RS_in(DP_task2RS_out),
    .replay_Iter(replay_Iter),
    .PE_IDLE(PE_IDLE),
    .DP_task2Edge_PE_out(DP_task2Edge_PE_out),
    .RS_empty(RS_empty),
    .RS_full(RS_full)
);
endmodule