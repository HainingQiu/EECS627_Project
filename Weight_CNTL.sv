module Weight_CNTL(
    input clk,
    input reset,
    input[$clog2(`Max_Num_Weight_layer)-1:0] Num_Weight_layer,//Num_Weight_layer-1
    input[$clog2(`Max_FV_num):0]  Num_FV,
    input fire, //from RS

    output logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex,
    output Weight_Cntl2RS Weight_Cntl2RS_out,
    output Weight_Cntl2bank Weight_Cntl2bank_out,
    output logic RS_IDLE
);
//And Wight Buffer
typedef enum reg [$clog2(2)-1:0] {
    IDLE='d0,
    Work='d1
} state_t;
logic [`Max_Num_Weight_layer-1:0][`Max_FV_num-1:0][`FV_size-1:0]Weight_Buffer;
logic[$clog2(`Max_Num_Weight_layer)-1:0] Cur_Weight_layer,nx_Weight_layer;
logic [$clog2(`Max_FV_num):0] Cur_FV_num,nx_FV_num;
logic partial_FV;
logic partial_Weight_layer;
state_t state,nx_state;
logic [`Mult_per_PE-1:0] idx_Weight;
logic[`Mult_per_PE-1:0][`FV_size-1:0] nx_Weight_data2Vertex;
Weight_Cntl2bank nx_Weight_Cntl2bank_out,reg_nx_Weight_Cntl2bank_out,reg_nx_Weight_Cntl2bank_out_q;
logic nx_RS_IDLE;
// logic [$clog2(`Max_FV_num)-1:0]  Num_FV_boundary;
// assign Num_FV_boundary=Num_FV-1'b1;
always_comb begin
        nx_Weight_layer=Cur_Weight_layer;
        nx_FV_num=Cur_FV_num;
        nx_state=state;
        nx_Weight_Cntl2bank_out='d0;
        nx_RS_IDLE='d0;
        Weight_Cntl2RS_out='d0;
        nx_Weight_data2Vertex='d0;
        case(state)
            IDLE:
                if(fire)begin
                    nx_state=Work;
                    nx_Weight_Cntl2bank_out.sos=1'b1;
                    nx_Weight_Cntl2bank_out.eos=1'b0;
                end
                else begin
                    nx_state=IDLE;
                    nx_RS_IDLE=1'b1;
                end
            Work:
                begin
                    nx_FV_num=nx_FV_num+`Mult_per_PE;
                    partial_FV=nx_FV_num==Num_FV;
                    nx_Weight_Cntl2bank_out.change=partial_FV;
                    nx_Weight_layer=partial_FV?nx_Weight_layer+1'b1:nx_Weight_layer;
                    partial_Weight_layer=Num_Weight_layer==Cur_Weight_layer &&partial_FV;
                    // Weight_Cntl2RS_out.Complete=partial_FV&&partial_Weight_layer;
                    Weight_Cntl2RS_out.Cur_FV_num=Cur_FV_num;
                    for(int i=0;i<`Mult_per_PE;i++)begin
                        idx_Weight[i]=Cur_FV_num+i;
                        nx_Weight_data2Vertex[i]=Weight_Buffer[Cur_Weight_layer][idx_Weight[i]];
                    end
                    if(partial_FV)begin
                        nx_FV_num='d0;
                    end
                    else begin
                        nx_FV_num=nx_FV_num;
                    end
                    if(partial_Weight_layer)begin
                        nx_state=IDLE;
                        nx_Weight_layer='d0;
                        
                        nx_Weight_Cntl2bank_out.sos=1'b0;
                        nx_Weight_Cntl2bank_out.eos=1'b1;
                    end
                    else begin
                        nx_state=Work;
                    end
                end
        endcase
end
always_ff@(posedge clk)begin
    if(reset)begin
        // for(int i=0;i<`Max_Num_Weight_layer;i++)begin
        //     for(int j=0;i<`Max_FV_num;j++)begin
        //         Weight_Buffer[i][j]<=#1 1;
        //     end
        // end
        Weight_Buffer[0][0]<=#1 'd2;
        Weight_Buffer[0][1]<=#1 'd2;
        Weight_Buffer[0][2]<=#1 'd0;
        Weight_Buffer[0][3]<=#1 'd2;
        Weight_Buffer[0][4]<=#1 'd1;
        Weight_Buffer[0][5]<=#1 'd0;
        Weight_Buffer[0][6]<=#1 'd0;
        Weight_Buffer[0][7]<=#1 'd1;
        Weight_Buffer[0][8]<=#1 'd2;
        Weight_Buffer[0][9]<=#1 'd2;
        Weight_Buffer[0][10]<=#1 'd0;
        Weight_Buffer[0][11]<=#1 'd2;
        Weight_Buffer[0][12]<=#1 'd2;
        Weight_Buffer[0][13]<=#1 'd1;
        Weight_Buffer[0][14]<=#1 'd2;
        Weight_Buffer[0][15]<=#1 'd0;

        Weight_Buffer[1][0]<=#1 'd1;
        Weight_Buffer[1][1]<=#1 'd2;
        Weight_Buffer[1][2]<=#1 'd2;
        Weight_Buffer[1][3]<=#1 'd2;
        Weight_Buffer[1][4]<=#1 'd1;
        Weight_Buffer[1][5]<=#1 'd0;
        Weight_Buffer[1][6]<=#1 'd2;
        Weight_Buffer[1][7]<=#1 'd2;
        Weight_Buffer[1][8]<=#1 'd2;
        Weight_Buffer[1][9]<=#1 'd2;
        Weight_Buffer[1][10]<=#1 'd2;
        Weight_Buffer[1][11]<=#1 'd1;
        Weight_Buffer[1][12]<=#1 'd1;
        Weight_Buffer[1][13]<=#1 'd0;
        Weight_Buffer[1][14]<=#1 'd2;
        Weight_Buffer[1][15]<=#1 'd0;
        state<=#1 IDLE;
        Cur_Weight_layer<=#1 'd0;
        Cur_FV_num<=#1 'd0;
        Weight_data2Vertex<=#1 'd0;
        Weight_Cntl2bank_out<=#1 'd0;
        reg_nx_Weight_Cntl2bank_out<=#1 'd0;
        reg_nx_Weight_Cntl2bank_out_q<=#1 'd0;
        RS_IDLE<=#1 'd0;
    end
    else begin
        Weight_Buffer<=#1 Weight_Buffer;
        state<=#1 nx_state;
        Cur_Weight_layer<=#1 nx_Weight_layer;
        Cur_FV_num<=#1 nx_FV_num;
        Weight_data2Vertex<=#1 nx_Weight_data2Vertex;
        reg_nx_Weight_Cntl2bank_out<=#1 nx_Weight_Cntl2bank_out;
        reg_nx_Weight_Cntl2bank_out_q<=#1 reg_nx_Weight_Cntl2bank_out;
        Weight_Cntl2bank_out<=#1 reg_nx_Weight_Cntl2bank_out_q;
        RS_IDLE<=#1 nx_RS_IDLE;
    end
end
endmodule