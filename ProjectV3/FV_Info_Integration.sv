// `include "sys_defs.svh"
module FV_info_Integration(
input clk,
input reset,

input FV_FIFO2FV_info_MEM_CNTL_in_full,
input BUS2FV_info_FIFO_in_valid,
input [$clog2(`Max_Node_id)-1:0] BUS2FV_info_FIFO_in_Node_id,
input [$clog2(`Num_Edge_PE)-1:0] BUS2FV_info_FIFO_in_PE_tag,


output 	logic FV_info2FV_FIFO_out_valid,
output  logic [`FV_info_bank_width-1:0] FV_info2FV_FIFO_out_FV_addr,
output  logic [$clog2(`Num_Edge_PE)-1:0] FV_info2FV_FIFO_out_PE_tag
);

 BUS2FV_info_FIFO BUS2FV_info_FIFO_in;
FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in;
FV_info2FV_FIFO FV_info2FV_FIFO_out;
assign FV_FIFO2FV_info_MEM_CNTL_in.full=FV_FIFO2FV_info_MEM_CNTL_in_full;
assign BUS2FV_info_FIFO_in.valid=BUS2FV_info_FIFO_in_valid;
assign BUS2FV_info_FIFO_in.Node_id=BUS2FV_info_FIFO_in_Node_id;
assign BUS2FV_info_FIFO_in.PE_tag=BUS2FV_info_FIFO_in_PE_tag;
assign FV_info2FV_FIFO_out_valid=FV_info2FV_FIFO_out.valid;
assign FV_info2FV_FIFO_out_FV_addr=FV_info2FV_FIFO_out.FV_addr;
assign FV_info2FV_FIFO_out_PE_tag=FV_info2FV_FIFO_out.PE_tag;
FV_Info_SRAM2CNTL FV_Info_SRAM2CNTL_in;
FV_info_CNTL2SRAM_Interface FV_info_CNTL2SRAM_Interface_out;
logic rempty;
logic wfull;
FIFO2FV_info_MEM_CNTL FIFO2FV_info_MEM_CNTL_in;
FV_info_MEM_CNTL2FIFO FV_info_MEM_CNTL2FIFO_out;
FV_Info_Sync_FIFO FV_Info_Sync_FIFO_U(
	.clk(clk), 
	.rst(reset),
	.winc(BUS2FV_info_FIFO_in.valid),
	.rinc(FV_info_MEM_CNTL2FIFO_out.rinc),
	.wdata(BUS2FV_info_FIFO_in),

	.wfull(wfull),// not used, bc FIFO Depth to make sure to store all PE reqs
	.rempty(rempty)	,
	.rdata(FIFO2FV_info_MEM_CNTL_in)
);
FV_info_MEMcntl FV_info_MEMcntl_U0(
    .clk(clk),
    .reset(reset),
    .empty(rempty),
    .FIFO2FV_info_MEM_CNTL_in(FIFO2FV_info_MEM_CNTL_in),
    .FV_FIFO2FV_info_MEM_CNTL_in(FV_FIFO2FV_info_MEM_CNTL_in),
    .FV_Info_SRAM2CNTL_in(FV_Info_SRAM2CNTL_in),
    .FV_info_CNTL2SRAM_Interface_out(FV_info_CNTL2SRAM_Interface_out),
    .FV_info_MEM_CNTL2FIFO_out(FV_info_MEM_CNTL2FIFO_out),
    .FV_info2FV_FIFO_out(FV_info2FV_FIFO_out)
);

//do not know how to load from tb
// FV_Info_SRAM bank size: width is 8,depth is 128;
FV_info_SRAM FV_info_SRAM_U(
    .Q(FV_Info_SRAM2CNTL_in.D ),
    .CLK(clk),
    .CEN(FV_info_CNTL2SRAM_Interface_out.CEN),
    .WEN(1'b1),
    .A(FV_info_CNTL2SRAM_Interface_out.A),
    .D(10'd0)
);

endmodule