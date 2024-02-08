`include "sys_defs.svh"
module Edge_PE_tb();

logic clk;
logic reset;
DP_task2Edge_PE DP_task2Edge_PE_in;
FV_SRAM2Edge_PE FV_SRAM2Edge_PE_in;
Output_SRAM2Edge_PE Output_SRAM2Edge_PE_in;
NeighborID_SRAM2Edge_PE NeighborID_SRAM2Edge_PE_in;
Grant_Bus_arbiter Grant_Bus_arbiter_in;
logic [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter;
logic [$clog2(`Max_Node_id)-1:0] Last_Node_ID;
logic Grant_WB_Packet;

Req_Bus_arbiter Req_Bus_arbiter_out;
Edge_PE2DP Edge_PE2DP_out;
Edge_PE2IMEM_CNTL Edge_PE2IMEM_CNTL_out;
logic req_WB_Packet;
Edge_PE2Bank Edge_PE2Bank_out;


Edge_PE edge_pe_DUT(.*);

always #5 clk = ~clk;

initial begin

init();

repeat (10) @(posedge clk);
//

//

@(posedge clk) $stop;

end


task automatic init();

clk = 0;
reset = 1;
DP_task2Edge_PE_in = '0;
FV_SRAM2Edge_PE_in = '0;
Output_SRAM2Edge_PE_in = '0;
NeighborID_SRAM2Edge_PE_in = '0;
Grant_Bus_arbiter_in = '0;
Cur_Replay_Iter = '0;
Last_Node_ID = '0;
Grant_WB_Packet = '0;

@(posedge clk) reset = 0;

endtask

endmodule