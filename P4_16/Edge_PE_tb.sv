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
// logic [$clog2(`Max_Node_id)-1:0] Last_Node_ID;
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

repeat (10) @(negedge clk);
//

//
DP_task2Edge_PE_in.valid=1'b1;
DP_task2Edge_PE_in.packet={4'b0011,3'd2,7'd1};
@(negedge clk);
DP_task2Edge_PE_in='d0;
@(negedge clk);
Grant_Bus_arbiter_in.Grant='b1; //grant req neighbor ids
@(negedge clk);
Grant_Bus_arbiter_in.Grant='b0; //
@(negedge clk);
NeighborID_SRAM2Edge_PE_in.sos=1'b1;
NeighborID_SRAM2Edge_PE_in.eos=1'b1;
NeighborID_SRAM2Edge_PE_in.Neighbor_num_Iter='d2;
NeighborID_SRAM2Edge_PE_in.Neighbor_ids={7'd3,7'd3};
@(negedge clk);
NeighborID_SRAM2Edge_PE_in='d0;
@(negedge clk);
@(negedge clk);
Grant_Bus_arbiter_in.Grant='b1; //grant req fv
@(negedge clk);
Grant_Bus_arbiter_in.Grant='b0;
@(negedge clk);
@(negedge clk);
FV_SRAM2Edge_PE_in.sos=1'b1;
FV_SRAM2Edge_PE_in.eos=1'b0;
FV_SRAM2Edge_PE_in.FV_data={8'd1,8'd2};
@(negedge clk);
FV_SRAM2Edge_PE_in.sos=1'b0;
FV_SRAM2Edge_PE_in.eos=1'b0;
FV_SRAM2Edge_PE_in.FV_data={8'd3,8'd4};
@(negedge clk);
FV_SRAM2Edge_PE_in.sos=1'b0;
FV_SRAM2Edge_PE_in.eos=1'b1;
FV_SRAM2Edge_PE_in.FV_data={8'd5,8'd6};
@(negedge clk);
@(negedge clk);
@(negedge clk);
Grant_WB_Packet=1'b1;
@(negedge clk);
Grant_WB_Packet=1'b0;
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk);
@(negedge clk) $stop;

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
// Last_Node_ID = '0;
Grant_WB_Packet = '0;

@(negedge clk) reset = 0;

endtask

endmodule