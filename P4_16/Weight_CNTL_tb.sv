`include "sys_defs.svh"
module Weight_CNTL_tb();
logic clk,reset;
logic [$clog2(`Max_Num_Weight_layer):0] Num_Weight_layer;
logic [$clog2(`Max_FV_num):0]  Num_FV;
logic fire;
logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;
Weight_Cntl2RS Weight_Cntl2RS_out;
Weight_Cntl2bank Weight_Cntl2bank_out;
logic RS_IDLE;

Weight_CNTL Weight_CNTL_tb( 
    .clk(clk),
    .reset(reset),
    .Num_Weight_layer(Num_Weight_layer),
    .Num_FV(Num_FV),
    .fire(fire), //from RS

    .Weight_data2Vertex(Weight_data2Vertex),
    .Weight_Cntl2RS_out(Weight_Cntl2RS_out),
    .Weight_Cntl2bank_out(Weight_Cntl2bank_out),
    .RS_IDLE(RS_IDLE)
);
always begin
    #15;
    clk = ~clk;
end


initial begin

init();

repeat (10) @(negedge clk);
//
fire=1'b1;
@(negedge clk);
fire=1'b0;
repeat (30) @(negedge clk);

//

@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;
Num_Weight_layer='d1;//==2-1
Num_FV='d16;
fire='d0;
@(negedge clk) reset = 0;

endtask

endmodule