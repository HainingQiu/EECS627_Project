`include "sys_defs.svh"
module Top_tb();

logic clk, reset;
logic task_complete;

Top iTop_DUT(
.*
);

always #5 clk = ~clk;

initial begin

init();
//forever begin
//	if(task_complete)begin
//		@(posedge clk);
		
//	end
//	@(posedge clk);
//end
repeat (200) @(negedge clk);
$finish; 
end
//
task automatic init();

clk = 0;
reset = 1; // avtive high sync reset
@(negedge clk);
reset = 0; // go
///// FV SRAM Initialization /////
$readmemb("./data/feature_value_bank0.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[0].BIG_FV_SRAM_u.mem);
$readmemb("./data/feature_value_bank1.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[1].BIG_FV_SRAM_u.mem);
$readmemb("./data/feature_value_bank2.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[2].BIG_FV_SRAM_u.mem);
$readmemb("./data/feature_value_bank3.txt",
		  iTop_DUT.Big_FV_wrapper_0_U.ping_buffer[3].BIG_FV_SRAM_u.mem);
		  
		  
///// FV Pointer SRAM /////
$readmemb("./data/feature_value_pointer.txt",
		  iTop_DUT.FV_info_Integration_U.FV_info_SRAM_U.mem);
		  
///// Neighbor Pointer SRAM /////
$readmemb("./data/nb_info_bank0.txt",
		  iTop_DUT.Neighbor_info_Integration_U.
		  Nb_Info_SRAM_init[0].Neighbor_Info_SRAM_U.mem);
$readmemb("./data/nb_info_bank1.txt",
		  iTop_DUT.Neighbor_info_Integration_U.
		  Nb_Info_SRAM_init[1].Neighbor_Info_SRAM_U.mem);
		  
///// Packet SRAM /////
$readmemb("./data/packet_bank.txt",
		  iTop_DUT.IMem_Sram_U.mem);

///// Neighbor SRAM /////
$readmemb("./data/nb_bank0.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[0].Neighbor_SRAM_U.mem);
$readmemb("./data/nb_bank1.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[1].Neighbor_SRAM_U.mem);
$readmemb("./data/nb_bank2.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[2].Neighbor_SRAM_U.mem);
$readmemb("./data/nb_bank3.txt",
		  iTop_DUT.S_Neighbor_SRAM_integration_U.
		  SRAM_Instantiations[3].Neighbor_SRAM_U.mem);





endtask


endmodule
