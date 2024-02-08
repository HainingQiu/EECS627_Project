module Neighbor_info_Integration(
    input clk,
    input reset,
    input last_bit_Cur_Replay_Iter,//from current_replay_iteration
    input Neighbor_CNTL2Neighbor_Info_CNTL_full,
    input BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in,


    output Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out
);

logic rempty;
logic wfull;
logic rinc2Neighbor_FIFO;
BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in;
Neighbor_info_CNTL2SRAM_interface[`num_bank_neighbor_info-1:0] Neighbor_info_CNTL2SRAM_interface_out;
logic [`num_bank_neighbor_info-1:0][`Neighbor_info_bandwidth-1:0] Data_SRAM_in;

NeighborInfo_Sync_FIFO NeighborInfo_Sync_FIFO_U(
	.clk(clk), 
	.rst(reset),
	.winc(BUS2Neighbor_info_MEM_CNTL_in.valid),
	.rinc(rinc2Neighbor_FIFO),
	.wdata(BUS2Neighbor_info_MEM_CNTL_in),

	.wfull(wfull),
	.rempty(rempty)	,
	.rdata(BUS2Neighbor_info_MEM_CNTL_in)
);
Neighbor_Info_CNTL Neighbor_Info_CNTL_U(
    .clk(clk),
    .reset(clk),
    .BUS2Neighbor_info_MEM_CNTL_in(BUS2Neighbor_info_MEM_CNTL_in),// from FIFO
    .empty(rempty),//FIFO empty?
    .last_bit_Cur_Replay_Iter(last_bit_Cur_Replay_Iter),
    .Neighbor_ID_FIFO_full(Neighbor_CNTL2Neighbor_Info_CNTL_full),
    .Data_SRAM_in(Data_SRAM_in),

    .rinc2Neighbor_FIFO(rinc2Neighbor_FIFO),
    .Neighbor_info_CNTL2SRAM_interface_out(Neighbor_info_CNTL2SRAM_interface_out),
    .Neighbor_info2Neighbor_FIFO_out(Neighbor_info2Neighbor_FIFO_out)

);
//do not know how to load from tb
// Neighbor_Info_SRAM bank size: width is 16,depth is 128;
generate
    genvar i;
    for(i=0;i<`num_bank_neighbor_info;i=i+1)begin:decode_Instantiations
        Neighbor_Info_SRAM Neighbor_Info_SRAM_U(
            .Q(Neighbor_info_CNTL2SRAM_interface_out[i].Q),
            .CLK(clk),
            .CEN(Neighbor_info_CNTL2SRAM_interface_out[i].CEN),
            .WEN(Neighbor_info_CNTL2SRAM_interface_out[i].WEN),
            .A(Neighbor_info_CNTL2SRAM_interface_out[i].A),
            .D(Data_SRAM_in[i])
        );
        end 
endgenerate

endmodule