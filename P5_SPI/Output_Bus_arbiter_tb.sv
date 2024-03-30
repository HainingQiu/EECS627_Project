`include "sys_defs.svh"
module Output_Bus_arbiter_tb();

logic clk,reset;
Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Vertex_Bank2Req_Output_SRAM_in;
Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out;
Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter;
logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants;
Output_Bus_arbiter Output_Bus_arbiter_tb(
    .clk(clk),
    .reset(reset),
    .Edge_PE2Req_Output_SRAM_in(Edge_PE2Req_Output_SRAM_in),
    .Edge_Bank2Req_Output_SRAM_in(Edge_Bank2Req_Output_SRAM_in),
    .Vertex_Bank2Req_Output_SRAM_in(Vertex_Bank2Req_Output_SRAM_in),
    .Output_Sram2Arbiter(Output_Sram2Arbiter),

    .Req2Output_SRAM_Bank_out(Req2Output_SRAM_Bank_out),
    .Ouput_SRAM_Grants(Ouput_SRAM_Grants)
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
Edge_PE2Req_Output_SRAM_in[1].req=1'b1;
Edge_PE2Req_Output_SRAM_in[1].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[1].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[1].Node_id='d6;//110
Edge_PE2Req_Output_SRAM_in[3].req=1'b1;
Edge_PE2Req_Output_SRAM_in[3].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[3].PE_tag='d2;
Edge_PE2Req_Output_SRAM_in[3].Node_id='d7;
@(negedge clk);
Edge_PE2Req_Output_SRAM_in[1].req=1'b0;
Edge_PE2Req_Output_SRAM_in[1].Grant_valid=1'b1;
Edge_PE2Req_Output_SRAM_in[1].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[1].Node_id='d6;
Edge_PE2Req_Output_SRAM_in[3].req=1'b1;
Edge_PE2Req_Output_SRAM_in[3].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[3].PE_tag='d2;
Edge_PE2Req_Output_SRAM_in[3].Node_id='d7;
Edge_PE2Req_Output_SRAM_in[2].req=1'b1;
Edge_PE2Req_Output_SRAM_in[2].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].Node_id='d6;
@(negedge clk);

Edge_PE2Req_Output_SRAM_in[3].req=1'b0;
Edge_PE2Req_Output_SRAM_in[3].Grant_valid=1'b1;
Edge_PE2Req_Output_SRAM_in[3].PE_tag='d2;
Edge_PE2Req_Output_SRAM_in[3].Node_id='d7;
Edge_PE2Req_Output_SRAM_in[2].req=1'b1;
Edge_PE2Req_Output_SRAM_in[2].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].Node_id='d6;
@(negedge clk);
Output_Sram2Arbiter[2].eos=1'b1;
// Output_Sram2Arbiter[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].req=1'b1;
Edge_PE2Req_Output_SRAM_in[2].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].Node_id='d6;
@(negedge clk);
Output_Sram2Arbiter='d0;
Edge_PE2Req_Output_SRAM_in[2].req=1'b1;
Edge_PE2Req_Output_SRAM_in[2].Grant_valid=1'b0;
Edge_PE2Req_Output_SRAM_in[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].Node_id='d6;
@(negedge clk);
Edge_PE2Req_Output_SRAM_in[2].req=1'b0;
Edge_PE2Req_Output_SRAM_in[2].Grant_valid=1'b1;
Edge_PE2Req_Output_SRAM_in[2].PE_tag='d1;
Edge_PE2Req_Output_SRAM_in[2].Node_id='d6;
repeat (20) @(negedge clk);

//

@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;
Edge_PE2Req_Output_SRAM_in='d0;
Edge_Bank2Req_Output_SRAM_in='d0;
Vertex_Bank2Req_Output_SRAM_in='d0;
Output_Sram2Arbiter='d0;
@(negedge clk) reset = 0;

endtask

endmodule