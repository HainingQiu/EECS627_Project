// `include "sys_defs.svh"
module S_FV_SRAM_Integration(
    input clk,
    input reset,
	// input FV_info2FV_FIFO	wdata,
    input wdata_valid,
    input [`FV_info_bank_width-1:0] wdata_FV_addr,
    input [$clog2(`Num_Edge_PE)-1:0] wdata_PE_tag,

    input [$clog2(`Max_FV_num):0] Num_FV,

    // input FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in,
    input FV_MEM2FV_Bank_in_0_sos,
    input FV_MEM2FV_Bank_in_0_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_0_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_0_A,

    input FV_MEM2FV_Bank_in_1_sos,
    input FV_MEM2FV_Bank_in_1_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_1_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_1_A,

    input FV_MEM2FV_Bank_in_2_sos,
    input FV_MEM2FV_Bank_in_2_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_2_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_2_A,

    input FV_MEM2FV_Bank_in_3_sos,
    input FV_MEM2FV_Bank_in_3_eos,
    input [`FV_bandwidth-1:0] FV_MEM2FV_Bank_in_3_FV_data,
    input [`FV_info_bank_width-2-1:0] FV_MEM2FV_Bank_in_3_A,

    // output FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out,
    output logic FV_SRAM2Edge_PE_out_0_sos,
    output logic FV_SRAM2Edge_PE_out_0_eos,
    output logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_0_FV_data,

    output logic FV_SRAM2Edge_PE_out_1_sos,
    output logic FV_SRAM2Edge_PE_out_1_eos,
    output logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_1_FV_data,

    output logic FV_SRAM2Edge_PE_out_2_sos,
    output logic FV_SRAM2Edge_PE_out_2_eos,
    output logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_2_FV_data,

    output logic FV_SRAM2Edge_PE_out_3_sos,
    output logic FV_SRAM2Edge_PE_out_3_eos,
    output logic[`FV_bandwidth-1:0] FV_SRAM2Edge_PE_out_3_FV_data,

    output logic wfull
);
/// FV_Sync_FIFO, FV_Memcntl, FV Bank_MEMCntl,FV_Bus
FV_CNTL2FV_FIFO temp_FV_CNTL2FV_FIFO_out;
FV_info2FV_FIFO temp_rdata;
FV_FIFO2FV_CNTL FV_FIFO2FV_CNTL_out;
logic rempty;
logic [`Num_Banks_FV-1:0] Bank_busy;
FV_bank_CNTL2Edge_PE[`Num_Banks_FV-1:0] FV_bank_CNTL2Edge_PE_in;
logic [`Num_Banks_all_FV-1:0] [`FV_bandwidth-1:0 ] FV_SRAM_DATA;
FV_MEM_CNTL2FV_Bank_CNTL[`Num_Banks_FV-1:0] FV_MEM_CNTL2FV_Bank_CNTL_out;
FV_bank2SRAM_Interface[`Num_Banks_FV-1:0] FV_bank2SRAM_Interface_out;
FV_info2FV_FIFO	wdata;
FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in;
FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out;
assign FV_FIFO2FV_CNTL_out.valid=temp_rdata.valid;
assign FV_FIFO2FV_CNTL_out.PE_tag=temp_rdata.PE_tag;
assign FV_FIFO2FV_CNTL_out.FV_addr=temp_rdata.FV_addr;
assign FV_FIFO2FV_CNTL_out.empty=rempty;
assign wdata.valid=wdata_valid;
assign wdata.FV_addr=wdata_FV_addr;
assign wdata.PE_tag=wdata_PE_tag;

assign FV_MEM2FV_Bank_in[0].sos=FV_MEM2FV_Bank_in_0_sos;
assign FV_MEM2FV_Bank_in[0].eos=FV_MEM2FV_Bank_in_0_eos;
assign FV_MEM2FV_Bank_in[0].FV_data=FV_MEM2FV_Bank_in_0_FV_data;
assign FV_MEM2FV_Bank_in[0].A=FV_MEM2FV_Bank_in_0_A;

assign FV_MEM2FV_Bank_in[1].sos=FV_MEM2FV_Bank_in_1_sos;
assign FV_MEM2FV_Bank_in[1].eos=FV_MEM2FV_Bank_in_1_eos;
assign FV_MEM2FV_Bank_in[1].FV_data=FV_MEM2FV_Bank_in_1_FV_data;
assign FV_MEM2FV_Bank_in[1].A=FV_MEM2FV_Bank_in_1_A;

assign FV_MEM2FV_Bank_in[2].sos=FV_MEM2FV_Bank_in_2_sos;
assign FV_MEM2FV_Bank_in[2].eos=FV_MEM2FV_Bank_in_2_eos;
assign FV_MEM2FV_Bank_in[2].FV_data=FV_MEM2FV_Bank_in_2_FV_data;
assign FV_MEM2FV_Bank_in[2].A=FV_MEM2FV_Bank_in_2_A;

assign FV_MEM2FV_Bank_in[3].sos=FV_MEM2FV_Bank_in_3_sos;
assign FV_MEM2FV_Bank_in[3].eos=FV_MEM2FV_Bank_in_3_eos;
assign FV_MEM2FV_Bank_in[3].FV_data=FV_MEM2FV_Bank_in_3_FV_data;
assign FV_MEM2FV_Bank_in[3].A=FV_MEM2FV_Bank_in_3_A;

assign FV_SRAM2Edge_PE_out_0_sos=FV_SRAM2Edge_PE_out[0].sos;
assign FV_SRAM2Edge_PE_out_0_eos=FV_SRAM2Edge_PE_out[0].eos;
assign FV_SRAM2Edge_PE_out_0_FV_data=FV_SRAM2Edge_PE_out[0].FV_data;

assign FV_SRAM2Edge_PE_out_1_sos=FV_SRAM2Edge_PE_out[1].sos;
assign FV_SRAM2Edge_PE_out_1_eos=FV_SRAM2Edge_PE_out[1].eos;
assign FV_SRAM2Edge_PE_out_1_FV_data=FV_SRAM2Edge_PE_out[1].FV_data;

assign FV_SRAM2Edge_PE_out_2_sos=FV_SRAM2Edge_PE_out[2].sos;
assign FV_SRAM2Edge_PE_out_2_eos=FV_SRAM2Edge_PE_out[2].eos;
assign FV_SRAM2Edge_PE_out_2_FV_data=FV_SRAM2Edge_PE_out[2].FV_data;

assign FV_SRAM2Edge_PE_out_3_sos=FV_SRAM2Edge_PE_out[3].sos;
assign FV_SRAM2Edge_PE_out_3_eos=FV_SRAM2Edge_PE_out[3].eos;
assign FV_SRAM2Edge_PE_out_3_FV_data=FV_SRAM2Edge_PE_out[3].FV_data;
FV_Sync_FIFO FV_Sync_FIFO_U(
	.clk(clk), 
	.rst(reset),
	.winc(wdata.valid),
	.rinc(temp_FV_CNTL2FV_FIFO_out.rinc),
	.wdata(wdata),

	.wfull(wfull),
	.rempty(rempty),
	.rdata(temp_rdata)
);
 FV_MEMcntl FV_MEMcntl_U0(
    .clk(clk),
    .reset(reset),
    .FV_FIFO2FV_CNTL_in(FV_FIFO2FV_CNTL_out),
    .Bank_busy(Bank_busy),

    .FV_CNTL2FV_FIFO_out(temp_FV_CNTL2FV_FIFO_out),
    .FV_MEM_CNTL2FV_Bank_CNTL_out(FV_MEM_CNTL2FV_Bank_CNTL_out)
);


generate
    genvar i;
    for(i=0;i<`Num_Banks_FV;i=i+1)begin: FV_Bank_MEMCntl_Instantiations
        FV_Bank_MEMCntl FV_Bank_MEMCntl_U(
            .clk(clk),
            .reset(reset),
            .Num_FV(Num_FV),
            .FV_MEM_CNTL2FV_Bank_CNTL_in(FV_MEM_CNTL2FV_Bank_CNTL_out[i]),
            .FV_MEM2FV_Bank_in(FV_MEM2FV_Bank_in[i]),
            .FV_SRAM_DATA(FV_SRAM_DATA[i]),

            .FV_bank2SRAM_Interface_out(FV_bank2SRAM_Interface_out[i]),
            .FV_bank_CNTL2Edge_PE_out(FV_bank_CNTL2Edge_PE_in[i]),
            .Busy(Bank_busy[i])
            
        );
    end 
//endgenerate
// SMALL_FV_SRAM bank width iss 16 bits, depth is 256
//generate
    //genvar i;
    for(i=0;i<`Num_Banks_FV;i=i+1)begin:SRAM_Instantiations
        SMALL_FV_SRAM_64 SMALL_FV_SRAM_U(
            .Q(FV_SRAM_DATA[i] ),
            .CLK(clk),
            .CEN(FV_bank2SRAM_Interface_out[i].CEN),
            .WEN(FV_bank2SRAM_Interface_out[i].WEN),
            .A(FV_bank2SRAM_Interface_out[i].A),
            .D(FV_bank2SRAM_Interface_out[i].D)
        );
    end 
endgenerate

FV_BUS FV_WR_BUS(

    .clk(clk),
    .reset(reset),
    .FV_bank_CNTL2Edge_PE_in(FV_bank_CNTL2Edge_PE_in),
    .FV_SRAM2Edge_PE_out(FV_SRAM2Edge_PE_out)
);
endmodule
