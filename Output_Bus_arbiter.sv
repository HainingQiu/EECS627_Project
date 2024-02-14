module Output_Bus_arbiter(
    input clk,
    input reset,
    input Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in,
    input Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in,
    input Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Vertex_Bank2Req_Output_SRAM_in,
    input Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter,

    output Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out,
    output logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants
);
logic[`Num_Total_reqs2Output-1:0] masked_reqs;
logic [`Num_Banks_FV-1:0] Bank_Busy,nx_Bank_Busy;
// logic [`Num_Total_reqs2Output-1:0] all_eos;
logic [`Num_Total_reqs2Output-1:0][$clog2(`Num_Banks_FV)-1:0] target_bank,nx_target_bank;//
Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] nx_Req2Output_SRAM_Bank_out;
always_comb begin
    masked_reqs='d0;
    // all_eos='d0;
    nx_Bank_Busy=Bank_Busy;
    nx_Req2Output_SRAM_Bank_out='d0;
    nx_target_bank=target_bank;
//granted req;
    for(int i=0;i<`Num_Edge_PE;i++)begin
        if(Edge_PE2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag=Edge_PE2Req_Output_SRAM_in[i].PE_tag;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Edge_PE2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos='d0;
        end
    end
    for(int i=`Num_Edge_PE;i<`Num_Edge_PE+`Num_Edge_PE;i++)begin
        if(Edge_Bank2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Edge_Bank2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data=Edge_Bank2Req_Output_SRAM_in[i].data;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos=Edge_Bank2Req_Output_SRAM_in[i].sos;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos=Edge_Bank2Req_Output_SRAM_in[i].eos;
        end
    end
    for (int i=`Num_Edge_PE+`Num_Edge_PE;i<`Num_Total_reqs2Output;i++)begin
        if(Vertex_Bank2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag='d0;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b1;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Vertex_Bank2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data=Vertex_Bank2Req_Output_SRAM_in[i].data;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos=Vertex_Bank2Req_Output_SRAM_in[i].sos;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos=Vertex_Bank2Req_Output_SRAM_in[i].eos;
        end
    end
    for(int i=0;i<`Num_Total_reqs2Output;i++)begin
        if(Ouput_SRAM_Grants[i])begin
            nx_Bank_Busy[target_bank[i]]=1'b1;
        end
    end
    for(int i=0;i<`Num_Edge_PE;i++)begin
        nx_target_bank[i]=Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Edge_PE2Req_Output_SRAM_in[i].req & (~nx_Bank_Busy[nx_target_bank[i]]);
    end
    for (int i=`Num_Edge_PE;i<`Num_Edge_PE+`Num_Edge_PE;i++)begin
        nx_target_bank[i]=Edge_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Edge_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE].req & (~nx_Bank_Busy[nx_target_bank[i]]); 
    end
    for (int i=`Num_Edge_PE+`Num_Edge_PE;i<`Num_Total_reqs2Output;i++)begin
        nx_target_bank[i]=Vertex_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE-`Num_Edge_PE].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Vertex_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE-`Num_Edge_PE].req & (~nx_Bank_Busy[nx_target_bank[i]]); 
    end
    for(int i=0;i<`Num_Banks_FV;i++)begin
        nx_Bank_Busy[i]=Output_Sram2Arbiter[i].eos?1'b0:nx_Bank_Busy[i];
    end
    for (int i=0;i<`Num_Edge_PE;i++)begin
        if(Edge_Bank2Req_Output_SRAM_in[i].eos)begin
            nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=1'b0;
        end
        else begin
            nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]];
        end
    end
    for (int i=0;i<`Num_Vertex_Unit;i++)begin
        if(Vertex_Bank2Req_Output_SRAM_in[i].eos)begin
            nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=1'b0;
        end
        else begin
            nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]];
        end
    end
end
always_ff@(posedge clk)begin
    if(reset)begin
        Bank_Busy<=#1 'd0;
        Req2Output_SRAM_Bank_out<=#1 'd0;
        target_bank<=#1 'd0;
    end
    else begin
        Bank_Busy<=#1 nx_Bank_Busy;
        Req2Output_SRAM_Bank_out<=#1 nx_Req2Output_SRAM_Bank_out;
        target_bank<=#1 nx_target_bank;
    end
end

rr_arbiter
#(.num_reqs(`Num_Total_reqs2Output))
rr_arbiter_U0(
    .clk(clk),
    .reset(reset),
    .reqs(masked_reqs),
    .grants(Ouput_SRAM_Grants)
);

endmodule