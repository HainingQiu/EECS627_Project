
module S_Neighbor_SRAM_integration(
    input clk,
    input reset,
    // input winc,
	input Neighbor_info2Neighbor_FIFO	wdata,

    output NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] NeighborID_SRAM2Edge_PE_out,
    output logic wfull
);
logic rinc_Neighbor_CNTL2FIFO;
Neighbor_info2Neighbor_FIFO rdata;
logic empty;
Neighbor_MEM_CNTL2Neighbor_Bank_CNTL[`Num_Banks_Neighbor-1:0] Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out;
logic [`Num_Banks_Neighbor-1:0][`Neighbor_ID_bandwidth-1:0 ] Neighbor_SRAM_DATA;
logic [`Num_Banks_Neighbor-1:0] Bank_busy;
Neighbor_bank2SRAM_Interface[`Num_Banks_Neighbor-1:0] Neighbor_bank2SRAM_Interface_out;
Neighbor_bank_CNTL2Edge_PE[`Num_Banks_Neighbor-1:0] Neighbor_bank_CNTL2Edge_PE_out;
Neighbor_Sync_FIFO Neighbor_Sync_FIFO(
	.clk(clk), 
	.rst(reset),
	.winc(wdata.valid),
	.rinc(rinc_Neighbor_CNTL2FIFO),
	.wdata(wdata),

	.wfull(wfull),
	.rempty(empty),
	.rdata(rdata)
);

Neighbor_MEM_CNTL Neighbor_MEM_CNTL_U(
    .clk,
    .reset,
    .Neighbor_info2Neighbor_FIFO_in(rdata),
    .Bank_busy(Bank_busy),
    .empty(empty),

    .rinc_Neighbor_CNTL2FIFO(rinc_Neighbor_CNTL2FIFO),
    .Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out(Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out)
);



generate
    genvar i;
    for(i=0;i<`Num_Banks_Neighbor;i=i+1)begin:Neighbor_Bank_MEMCntl
    Neighbor_Bank_MEMCntl Neighbor_Bank_MEMCntl_U(
        .clk(clk),
        .reset(reset),
        .Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_in(Neighbor_MEM_CNTL2Neighbor_Bank_CNTL_out[i]),
        // input FV_MEM2FV_Bank  FV_MEM2FV_Bank_in,
        .Neighbor_SRAM_DATA(Neighbor_SRAM_DATA[i]),

        .Neighbor_bank2SRAM_Interface_out(Neighbor_bank2SRAM_Interface_out[i]),
        .Neighbor_bank_CNTL2Edge_PE_out(Neighbor_bank_CNTL2Edge_PE_out[i]),
        .Busy(Bank_busy[i])
    );
        end 
//endgenerate
//Neighbor_SRAM bank size is Width is 14 bits, depth is 1024
//generate
    //genvar i;
    for(i=0;i<`Num_Banks_FV;i=i+1)begin:SRAM_Instantiations
        Neighbor_SRAM Neighbor_SRAM_U(
            .Q(Neighbor_SRAM_DATA[i]),
            .CLK(clk),
            .CEN(Neighbor_bank2SRAM_Interface_out[i].CEN),
            .WEN(1'b1),
            .A(Neighbor_bank2SRAM_Interface_out[i].A),
            .D(14'd0)
        );
        end 
endgenerate

Neighbor_BUS Neighbor_BUS_U(

    .clk(clk),
    .reset(reset),
    .Neighbor_bank_CNTL2Edge_PE_in(Neighbor_bank_CNTL2Edge_PE_out),
    .NeighborID_SRAM2Edge_PE_out(NeighborID_SRAM2Edge_PE_out)
);
endmodule