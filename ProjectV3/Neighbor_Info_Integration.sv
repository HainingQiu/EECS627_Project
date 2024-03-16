module Neighbor_info_Integration(
    input clk,
    input reset,
    input [$clog2(`Max_replay_Iter)-1:0]  Current_replay_Iter,//from current_replay_iteration
    input Neighbor_CNTL2Neighbor_Info_CNTL_full,
    input BUS2Neighbor_info_MEM_CNTL_in_valid,
    input [$clog2(`Max_Node_id)-1:0] BUS2Neighbor_info_MEM_CNTL_in_Node_id,
    input [$clog2(`Num_Edge_PE)-1:0] BUS2Neighbor_info_MEM_CNTL_PE_tag,

    output 	logic Neighbor_info2Neighbor_FIFO_out_valid, // If low, the data in this struct is garbage
    output  logic [`Neighbor_info_bandwidth-1:0] Neighbor_info2Neighbor_FIFO_out_addr,
    output  logic [$clog2(`Num_Edge_PE)-1:0] Neighbor_info2Neighbor_FIFO_out_PE_tag
);



BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in;

Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out;


assign BUS2Neighbor_info_MEM_CNTL_in.valid=BUS2Neighbor_info_MEM_CNTL_in_valid;
assign BUS2Neighbor_info_MEM_CNTL_in.Node_id=BUS2Neighbor_info_MEM_CNTL_in_Node_id;
assign BUS2Neighbor_info_MEM_CNTL_in.PE_tag=BUS2Neighbor_info_MEM_CNTL_PE_tag;

assign Neighbor_info2Neighbor_FIFO_out_valid =Neighbor_info2Neighbor_FIFO_out.valid;
assign Neighbor_info2Neighbor_FIFO_out_addr =Neighbor_info2Neighbor_FIFO_out.addr;
assign Neighbor_info2Neighbor_FIFO_out_PE_tag =Neighbor_info2Neighbor_FIFO_out.PE_tag;

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
    for(i=0;i<`num_bank_neighbor_info;i=i+1)begin:Nb_Info_SRAM_init
        Nb_info_SRAM_64 Neighbor_Info_SRAM_U(
            .Q(Data_SRAM_in[i]),
            .CLK(clk),
            .CEN(Neighbor_info_CNTL2SRAM_interface_out[i].CEN),
            .WEN(1'b1),
            .A(Neighbor_info_CNTL2SRAM_interface_out[i].A),
            .D(18'd0) // 17'd0
        );
        end 
endgenerate

endmodule

