`include "sys_defs.svh"
`timescale 1ns/1ps
module Top_tb();

logic clk, reset;
logic task_complete;
integer file1, file2, file3, file4;


///// Replay Iteration FF /////

logic [1:0] replay_Iter_ff;
always @(posedge clk or negedge reset) begin
	if (!reset)
		replay_Iter_ff <= '0;
	else
		replay_Iter_ff <= iTop_DUT.replay_Iter;
end

`ifdef SYN
initial begin
//$sdf_annotate("../syn/Top.syn.sdf", iTop_DUT);
repeat (2) @(negedge clk);

/// FV SRAM Initialization /////
$readmemb("../data/feature_value_bank0.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer_0__BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank1.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer_1__BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank2.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer_2__BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank3.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer_3__BIG_FV_SRAM_u.mem);
		  
////// weight data SRAM///////

// $readmemb("../data/weights.txt",
// 		  iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT.mem);

 
///// FV Pointer SRAM /////
$readmemb("../data/feature_value_pointer.txt",
		  iTop_DUT.FV_info_Integration_U.FV_info_SRAM_U.mem);
		  
///// Neighbor Pointer SRAM /////
$readmemb("../data/nb_info_bank0.txt",
		  iTop_DUT.Neighbor_info_Integration_U.Nb_Info_SRAM_init_0__Neighbor_Info_SRAM_U.mem);
$readmemb("../data/nb_info_bank1.txt",
		  iTop_DUT.Neighbor_info_Integration_U.Nb_Info_SRAM_init_1__Neighbor_Info_SRAM_U.mem);
		  
///// Packet SRAM /////
$readmemb("../data/packet_bank.txt",
		  iTop_DUT.PACKET_SRAM_integration_U.IMem_Sram_U.mem);

///// Neighbor SRAM /////
$readmemb("../data/nb_bank0.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations_0__Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank1.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations_1__Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank2.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations_2__Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank3.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations_3__Neighbor_SRAM_U.mem);
end

`else
initial begin
///// FV SRAM Initialization /////
$readmemb("../data/feature_value_bank0.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[0].BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank1.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[1].BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank2.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[2].BIG_FV_SRAM_u.mem);
$readmemb("../data/feature_value_bank3.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[3].BIG_FV_SRAM_u.mem);
		  
////// weight data SRAM///////

// $readmemb("../data/weights.txt",
// 		  iTop_DUT.Weight_CNTL_U.Weight_SRAM_DUT.mem);

 
///// FV Pointer SRAM /////
$readmemb("../data/feature_value_pointer.txt",
		  iTop_DUT.FV_info_Integration_U.FV_info_SRAM_U.mem);
		  
///// Neighbor Pointer SRAM /////
$readmemb("../data/nb_info_bank0.txt",
		  iTop_DUT.Neighbor_info_Integration_U.
		  Nb_Info_SRAM_init[0].Neighbor_Info_SRAM_U.mem);
$readmemb("../data/nb_info_bank1.txt",
		  iTop_DUT.Neighbor_info_Integration_U.
		  Nb_Info_SRAM_init[1].Neighbor_Info_SRAM_U.mem);
		  
///// Packet SRAM /////
$readmemb("../data/packet_bank.txt",
		  iTop_DUT.PACKET_SRAM_integration_U.IMem_Sram_U.mem);

///// Neighbor SRAM /////
$readmemb("../data/nb_bank0.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[0].Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank1.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[1].Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank2.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[2].Neighbor_SRAM_U.mem);
$readmemb("../data/nb_bank3.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[3].Neighbor_SRAM_U.mem);
end
`endif



Top iTop_DUT(
.*
);

///// Clock Gen /////
always #10 clk = ~clk;

initial begin

init();

repeat (5000) @(negedge clk);

///// File Close /////
$fclose(file1);
$fclose(file2);
$fclose(file3);
$fclose(file4);
$display("Sim completed. Check files..");

$finish; 

end

///// Dump Mem /////
always @(iTop_DUT.replay_Iter, task_complete) begin
	if (iTop_DUT.replay_Iter === 2'b01 & !task_complete)
		dumpPongBuf2file(file1);
	if (iTop_DUT.replay_Iter === 2'b10 & !task_complete)
		dumpPongBuf2file(file2);
	if (iTop_DUT.replay_Iter === 2'b11 & !task_complete)
		dumpPongBuf2file(file3);
	if (task_complete)
		dumpPongBuf2file(file4);
end

task automatic init();

///// Output File /////
file1 = $fopen("Iter0.txt", "w");
if (!file1) begin
	$display("Error opening Iter0.txt.");
	$stop;
end
file2 = $fopen("Iter1.txt", "w");
if (!file2) begin
	$display("Error opening Iter1.txt.");
	$stop;
end
file3 = $fopen("Iter2.txt", "w");
if (!file3) begin
	$display("Error opening Iter2.txt.");
	$stop;
end
file4 = $fopen("Iter3.txt", "w");
if (!file4) begin
	$display("Error opening Iter3.txt.");
	$stop;
end

clk = 0;
reset = 1; // avtive high sync reset
repeat (10) @(posedge clk);
#1 reset = 0; // go
repeat (10) @(posedge clk);
reset = 1;
@(posedge clk);
endtask

// Dump all contents in 4 BIG_FV_SRAMs into a single file
// This will be called 4 times for 4 replay iterations
// NOTE that they dump all 4 SRAM contents into one file at a times
// so please access the file in order

task automatic dumpPongBuf2file (integer filex);
`ifdef SYN
	// for (int j = 0; j < 1024; j++) begin
	// 	$fwrite(filex, "%h\n",
	// 	iTop_DUT.Big_FV_wrapper_1_U_ping_buffer_0__BIG_FV_SRAM_u.mem[j][63:0]);
	// end
	// for (int j = 0; j < 1024; j++) begin
	// 	$fwrite(filex, "%h\n",
	// 	iTop_DUT.Big_FV_wrapper_1_U_ping_buffer_1__BIG_FV_SRAM_u.mem[j][63:0]);
	// end
	// for (int j = 0; j < 1024; j++) begin
	// 	$fwrite(filex, "%h\n",
	// 	iTop_DUT.Big_FV_wrapper_1_U_ping_buffer_2__BIG_FV_SRAM_u.mem[j][63:0]);
	// end
	// for (int j = 0; j < 1024; j++) begin
	// 	$fwrite(filex, "%h\n",
	// 	iTop_DUT.Big_FV_wrapper_1_U_ping_buffer_3__BIG_FV_SRAM_u.mem[j][63:0]);
	// end
`else
	for (int j = 0; j < 1024; j++) begin
		$fwrite(filex, "%h\n",
		iTop_DUT.Big_FV_wrapper_1_U.ping_buffer[0].BIG_FV_SRAM_u.mem[j][15:0]);
	end
	for (int j = 0; j < 1024; j++) begin
		$fwrite(filex, "%h\n",
		iTop_DUT.Big_FV_wrapper_1_U.ping_buffer[1].BIG_FV_SRAM_u.mem[j][15:0]);
	end
	for (int j = 0; j < 1024; j++) begin
		$fwrite(filex, "%h\n",
		iTop_DUT.Big_FV_wrapper_1_U.ping_buffer[2].BIG_FV_SRAM_u.mem[j][15:0]);
	end
	for (int j = 0; j < 1024; j++) begin
		$fwrite(filex, "%h\n",
		iTop_DUT.Big_FV_wrapper_1_U.ping_buffer[3].BIG_FV_SRAM_u.mem[j][15:0]);
	end
`endif
endtask

endmodule
