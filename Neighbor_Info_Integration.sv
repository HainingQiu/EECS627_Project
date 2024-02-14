module Neighbor_info_Integration(
    input clk,
    input reset,
    input [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter,//from current_replay_iteration
    input Neighbor_CNTL2Neighbor_Info_CNTL_full,
    input BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in,

    output Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out
);

logic rempty;
logic wfull;
logic rinc2Neighbor_FIFO;
BUS2Neighbor_info_MEM_CNTL rdata;
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
	.rdata(rdata)
);
Neighbor_Info_CNTL Neighbor_Info_CNTL_U(
    .clk(clk),
    .reset(reset),
    .BUS2Neighbor_info_MEM_CNTL_in(rdata),// from FIFO
    .empty(rempty),//FIFO empty?
    .Current_replay_Iter(Current_replay_Iter),
    .Neighbor_ID_FIFO_full(Neighbor_CNTL2Neighbor_Info_CNTL_full),
    .Data_SRAM_in(Data_SRAM_in),

    .rinc2Neighbor_FIFO(rinc2Neighbor_FIFO),
    .Neighbor_info_CNTL2SRAM_interface_out(Neighbor_info_CNTL2SRAM_interface_out),
    .Neighbor_info2Neighbor_FIFO_out(Neighbor_info2Neighbor_FIFO_out)

);
//do not know how to load from tb
// Neighbor_Info_SRAM bank size: width is 17,depth is 256;
generate
    genvar i;
    for(i=0;i<`num_bank_neighbor_info;i=i+1)begin:Neighbor_Info_SRAM
        Neighbor_Info_SRAM Neighbor_Info_SRAM_U(
            .Q(8'd0),
            .CLK(clk),
            .CEN(Neighbor_info_CNTL2SRAM_interface_out[i].CEN),
            .WEN('d0),
            .A(Neighbor_info_CNTL2SRAM_interface_out[i].A),
            .D(Data_SRAM_in[i])
        );
        end 
endgenerate

endmodule