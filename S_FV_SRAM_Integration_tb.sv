`include "sys_defs.svh"
module S_FV_SRAM_Integration_tb();
logic clk,reset;
FV_info2FV_FIFO	wdata;
logic [$clog2(`Max_FV_num):0] Num_FV;
FV_MEM2FV_Bank[`Num_Banks_all_FV-1:0]  FV_MEM2FV_Bank_in;
FV_SRAM2Edge_PE[`Num_Edge_PE-1:0] FV_SRAM2Edge_PE_out;
logic wfull;
S_FV_SRAM_integration S_FV_SRAM_integration_TB(
    .clk(clk),
    .reset(reset),
	.wdata(wdata),
    .Num_FV(Num_FV),
    .FV_MEM2FV_Bank_in(FV_MEM2FV_Bank_in),

    .FV_SRAM2Edge_PE_out(FV_SRAM2Edge_PE_out),
    .wfull(wfull)
);

always begin
    #15;
    clk = ~clk;
end


initial begin
$dumpfile("test.dump");
$dumpvars(0,S_FV_SRAM_Integration_tb);
init();

repeat (10) @(negedge clk);
//
@(negedge clk);
Num_FV='d4;
@(negedge clk);

    for(int i=0;i<32;i++)begin
        if(i==0)begin
                FV_MEM2FV_Bank_in[0].sos=1'b1;
                FV_MEM2FV_Bank_in[0].eos=1'b0;
        end
        else if(i==31)begin
                FV_MEM2FV_Bank_in[0].sos=1'b0;
                FV_MEM2FV_Bank_in[0].eos=1'b1;
        end
        else begin
                FV_MEM2FV_Bank_in[0].sos=1'b0;
                FV_MEM2FV_Bank_in[0].eos=1'b0;
        end
        for(int j=0;j<4;j=j+2)begin
            
            @(negedge clk);
            for(int k=0;k<4;k++)begin
            if(j==0)begin
                // FV_MEM2FV_Bank_in[k].sos=1'b1;
                // FV_MEM2FV_Bank_iSMALL_FV_SRAMn[k].eos=1'b0;
                FV_MEM2FV_Bank_in[k].FV_data={j+1, j};
                FV_MEM2FV_Bank_in[k].A=i*2+j;
            end
            else if(j==2)begin
                // FV_MEM2FV_Bank_in[k].sos=1'b0;
                // FV_MEM2FV_Bank_in[k].eos=1'b1;
                FV_MEM2FV_Bank_in[k].FV_data={j+1,j};
                FV_MEM2FV_Bank_in[k].A=i*2+j;
            end
            else begin
                // FV_MEM2FV_Bank_in[k].sos=1'b0;
                // FV_MEM2FV_Bank_in[k].eos=1'b0;
                FV_MEM2FV_Bank_in[k].FV_data={j+1,j};
                FV_MEM2FV_Bank_in[k].A=i*2+j;
            end
    end
end
end
@(negedge clk);

wdata.valid=1'b1;
wdata.FV_addr='d0;
wdata.PE_tag='d0;
@(negedge clk);

wdata.valid=1'b1;
wdata.FV_addr={2'b00,6'b0};
wdata.PE_tag='d1;
@(negedge clk);
wdata='d0;
repeat (20) @(negedge clk);

//

@(negedge clk) $finish;

end


task automatic init();

clk = 0;
reset = 1;
wdata='d0;
Num_FV='d0;
FV_MEM2FV_Bank_in='d0;



@(negedge clk) reset = 0;
$readmemb("./data/feature_value_bank0.txt",
    S_FV_SRAM_integration_TB.SRAM_Instantiations[0].SMALL_FV_SRAM_U.mem);
endtask

endmodule