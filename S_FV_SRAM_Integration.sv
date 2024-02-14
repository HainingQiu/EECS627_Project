// `include "sys_defs.svh"
module S_FV_SRAM_integration(
    input clk,
    input reset,
    // input winc,
	input FV_info2FV_FIFO	wdata,
    input [$clog2(`Max_FV_num):0] Num_FV,
    input FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in,

    output FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out,
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
assign FV_FIFO2FV_CNTL_out.valid=temp_rdata.valid;
assign FV_FIFO2FV_CNTL_out.PE_tag=temp_rdata.PE_tag;
assign FV_FIFO2FV_CNTL_out.FV_addr=temp_rdata.FV_addr;
assign FV_FIFO2FV_CNTL_out.empty=rempty;
FV_bank2SRAM_Interface[`Num_Banks_FV-1:0] FV_bank2SRAM_Interface_out;
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
endgenerate
// SMALL_FV_SRAM bank width iss 16 bits, depth is 256
generate
    //genvar i;
    for(i=0;i<`Num_Banks_FV;i=i+1)begin:SRAM_Instantiations
        SMALL_FV_SRAM SMALL_FV_SRAM(
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