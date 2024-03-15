`include "sys_defs.svh"
module Neighbor_Info_Integration_tb();
logic clk,reset,last_bit_Cur_Replay_Iter,Neighbor_CNTL2Neighbor_Info_CNTL_full;

BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_in;
Neighbor_info2Neighbor_FIFO Neighbor_info2Neighbor_FIFO_out;
Neighbor_info_Integration Neighbor_info_Integration_tb(
    .clk(clk),
    .reset(reset),
    .last_bit_Cur_Replay_Iter(last_bit_Cur_Replay_Iter),//from current_replay_iteration
    .Neighbor_CNTL2Neighbor_Info_CNTL_full(Neighbor_CNTL2Neighbor_Info_CNTL_full),
    .BUS2Neighbor_info_MEM_CNTL_in(BUS2Neighbor_info_MEM_CNTL_in),

    .Neighbor_info2Neighbor_FIFO_out(Neighbor_info2Neighbor_FIFO_out)
);


always begin
    #15;
    clk = ~clk;
end


initial begin

init();

repeat (10) @(negedge clk);
//
BUS2Neighbor_info_MEM_CNTL_in.valid=1'b1;
BUS2Neighbor_info_MEM_CNTL_in.Node_id='d3;
BUS2Neighbor_info_MEM_CNTL_in.PE_tag='d2;
//
@(negedge clk)
BUS2Neighbor_info_MEM_CNTL_in.valid=1'b1;
BUS2Neighbor_info_MEM_CNTL_in.Node_id='d5;
BUS2Neighbor_info_MEM_CNTL_in.PE_tag='d1;
@(negedge clk)
BUS2Neighbor_info_MEM_CNTL_in='d0;
@(negedge clk)
@(negedge clk)
@(negedge clk)
repeat (10) @(negedge clk);
@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;
last_bit_Cur_Replay_Iter='d0;
Neighbor_CNTL2Neighbor_Info_CNTL_full='d0;
BUS2Neighbor_info_MEM_CNTL_in='d0;
@(negedge clk) reset = 0;

endtask

endmodule