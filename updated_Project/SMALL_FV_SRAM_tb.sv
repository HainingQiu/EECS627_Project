`timescale 1 ns/1 ps
module SMALL_FV_SRAM_tb();

localparam	BITS = 16;
localparam	WORD_DEPTH = 256;
localparam	ADDR_WIDTH = 8;// `timescale 1 ns/1 ps

logic [BITS-1:0] D, Q;		// SRAM I/O port
logic [ADDR_WIDTH-1:0] A;	// SRAM address port
logic CLK;					// 10MHz clock to SRAM
logic CEN;					// SRAM active low enable
logic WEN;					// SRAM active low write-enable

SMALL_FV_SRAM i256_16SRAM	// DUT
(
.*
);

always #5 CLK = ~CLK;

initial begin

init();
read(16'h0000);
write(16'h0000, 16'h0066);
read(16'h0001);
read(16'h0000);
read(16'h0003);


repeat (5) @(posedge CLK);
$stop();

end

task automatic init();

D = '0;
A = '0;
CLK = 0;
CEN = 0; // keep active
WEN = 1; // don't write

$readmemh("test.hex", i256_16SRAM.mem);
@(posedge CLK);

endtask

task automatic read(input [15:0] addr);

@(negedge CLK); // prepare input
WEN = 1;
CEN = 0;
A = addr;
@(posedge CLK);
#2;
$display("Read addr: %h, out: %h", addr, Q);


endtask

task automatic write(input [15:0] addr, input [15:0] data_in);

@(negedge CLK); // prepare input
WEN = 0;
CEN = 0;
A = addr;
D = data_in;
@(posedge CLK);
$display("Wrote addr: %h, in: %h", addr, D);
#1 WEN = 1; // turn off write enable

endtask

endmodule