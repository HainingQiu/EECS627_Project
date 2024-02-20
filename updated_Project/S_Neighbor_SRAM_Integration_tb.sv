`include "sys_defs.svh"
module S_Neighbor_SRAM_Integration_tb();
logic clk,reset;
Neighbor_info2Neighbor_FIFO	wdata;
NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] NeighborID_SRAM2Edge_PE_out;
logic wfull;
S_Neighbor_SRAM_integration S_Neighbor_SRAM_Integration_tb(
    .clk(clk),
    .reset(reset),
    // .winc(winc),
	.wdata(wdata),

    .NeighborID_SRAM2Edge_PE_out(NeighborID_SRAM2Edge_PE_out),
    .wfull(wfull)
);


always begin
    #15;
    clk = ~clk;
end


initial begin

init();

repeat (10) @(negedge clk);
//
@(negedge clk);
wdata.valid=1'b1;
wdata.addr={2'b00,10'd0,5'd5};
wdata.PE_tag='d0;
@(negedge clk);
wdata.valid=1'b1;
wdata.addr={2'b01,10'd2,5'd5};
wdata.PE_tag='d1;
//
@(negedge clk);
wdata='d0;
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);

repeat (10) @(negedge clk);
@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;

wdata='d0;

@(negedge clk) reset = 0;

endtask

endmodule