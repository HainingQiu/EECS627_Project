`include "sys_defs.svh"
module FV_Info_integration_tb();
logic clk,reset,winc;
FV_FIFO2FV_info_MEM_CNTL FV_FIFO2FV_info_MEM_CNTL_in;
BUS2FV_info_FIFO BUS2FV_info_FIFO_in;
FV_info2FV_FIFO FV_info2FV_FIFO_out;
FV_info_Integration FV_info_Integration_tb(
    .clk(clk),
    .reset(reset),

    .FV_FIFO2FV_info_MEM_CNTL_in(FV_FIFO2FV_info_MEM_CNTL_in),
    .BUS2FV_info_FIFO_in(BUS2FV_info_FIFO_in),

   .FV_info2FV_FIFO_out(FV_info2FV_FIFO_out)
);


always begin
    #15;
    clk = ~clk;
end


initial begin

init();

repeat (10) @(negedge clk);
//
BUS2FV_info_FIFO_in.valid=1'b1;
BUS2FV_info_FIFO_in.Node_id='d5;
BUS2FV_info_FIFO_in.PE_tag='d2;
//
@(negedge clk)
BUS2FV_info_FIFO_in='d0;
@(negedge clk)
@(negedge clk)
@(negedge clk)
@(negedge clk)
@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;
FV_FIFO2FV_info_MEM_CNTL_in='d0;
BUS2FV_info_FIFO_in='d0;
@(negedge clk) reset = 0;

endtask

endmodule