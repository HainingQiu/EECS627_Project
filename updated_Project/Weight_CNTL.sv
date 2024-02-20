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
logic [$clog2(`Max_FV_num):0]  Cur_FV_num,nx_FV_num;
logic partial_FV;
logic partial_Weight_layer;
state_t state,nx_state;
logic [`Mult_per_PE-1:0][$clog2(`Max_FV_num):0] idx_Weight;
logic[`Mult_per_PE-1:0][`FV_size-1:0] nx_Weight_data2Vertex;
Weight_Cntl2bank nx_Weight_Cntl2bank_out,reg_nx_Weight_Cntl2bank_out;//reg_nx_Weight_Cntl2bank_out_q
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

                    //nx_FV_num=nx_FV_num+`Mult_per_PE;
                    // for(int i=0;i<`Mult_per_PE;i++)begin
                    //     idx_Weight[i]=Cur_FV_num+i;
                    //     nx_Weight_data2Vertex[i]=Weight_Buffer[Cur_Weight_layer][idx_Weight[i]];
                    // end
                end
                else begin
                    nx_state=IDLE;
                    nx_RS_IDLE=1'b1;
                end
            Work:
                begin
                    nx_FV_num=nx_FV_num+`Mult_per_PE;
                    partial_FV=nx_FV_num==Num_FV;
                    if(Cur_FV_num=='d0 && Cur_Weight_layer=='d0)begin
                        nx_Weight_Cntl2bank_out.sos=1'b1;
                        nx_Weight_Cntl2bank_out.eos=1'b0;
                    end

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
        // Weight_Buffer[0][0]<=#1 'd2;
        // Weight_Buffer[0][1]<=#1 'd2;
        // Weight_Buffer[0][2]<=#1 'd0;
        // Weight_Buffer[0][3]<=#1 'd2;
        // Weight_Buffer[0][4]<=#1 'd1;
        // Weight_Buffer[0][5]<=#1 'd0;
        // Weight_Buffer[0][6]<=#1 'd0;
        // Weight_Buffer[0][7]<=#1 'd1;
        // Weight_Buffer[0][8]<=#1 'd2;
        // Weight_Buffer[0][9]<=#1 'd2;
        // Weight_Buffer[0][10]<=#1 'd0;
        // Weight_Buffer[0][11]<=#1 'd2;
        // Weight_Buffer[0][12]<=#1 'd2;
        // Weight_Buffer[0][13]<=#1 'd1;
        // Weight_Buffer[0][14]<=#1 'd2;
        // Weight_Buffer[0][15]<=#1 'd0;

        // Weight_Buffer[1][0]<=#1 'd1;
        // Weight_Buffer[1][1]<=#1 'd2;
        // Weight_Buffer[1][2]<=#1 'd2;
        // Weight_Buffer[1][3]<=#1 'd2;
        // Weight_Buffer[1][4]<=#1 'd1;
        // Weight_Buffer[1][5]<=#1 'd0;
        // Weight_Buffer[1][6]<=#1 'd2;
        // Weight_Buffer[1][7]<=#1 'd2;
        // Weight_Buffer[1][8]<=#1 'd2;
        // Weight_Buffer[1][9]<=#1 'd2;
        // Weight_Buffer[1][10]<=#1 'd2;
        // Weight_Buffer[1][11]<=#1 'd1;
        // Weight_Buffer[1][12]<=#1 'd1;
        // Weight_Buffer[1][13]<=#1 'd0;
        // Weight_Buffer[1][14]<=#1 'd2;
        // Weight_Buffer[1][15]<=#1 'd0;
Weight_Buffer[0][0] <= #1 'd0 ;
Weight_Buffer[0][1] <= #1 'd0 ;
Weight_Buffer[0][2] <= #1 'd0 ;
Weight_Buffer[0][3] <= #1 'd0 ;
Weight_Buffer[0][4] <= #1 'd2 ;
Weight_Buffer[0][5] <= #1 'd1 ;
Weight_Buffer[0][6] <= #1 'd1 ;
Weight_Buffer[0][7] <= #1 'd2 ;
Weight_Buffer[0][8] <= #1 'd0 ;
Weight_Buffer[0][9] <= #1 'd2 ;
Weight_Buffer[0][10] <= #1 'd2 ;
Weight_Buffer[0][11] <= #1 'd1 ;
Weight_Buffer[0][12] <= #1 'd0 ;
Weight_Buffer[0][13] <= #1 'd2 ;
Weight_Buffer[0][14] <= #1 'd1 ;
Weight_Buffer[0][15] <= #1 'd1 ;
Weight_Buffer[0][16] <= #1 'd0 ;
Weight_Buffer[0][17] <= #1 'd2 ;
Weight_Buffer[0][18] <= #1 'd1 ;
Weight_Buffer[0][19] <= #1 'd1 ;
Weight_Buffer[0][20] <= #1 'd0 ;
Weight_Buffer[0][21] <= #1 'd0 ;
Weight_Buffer[0][22] <= #1 'd0 ;
Weight_Buffer[0][23] <= #1 'd1 ;
Weight_Buffer[0][24] <= #1 'd2 ;
Weight_Buffer[0][25] <= #1 'd2 ;
Weight_Buffer[0][26] <= #1 'd2 ;
Weight_Buffer[0][27] <= #1 'd2 ;
Weight_Buffer[0][28] <= #1 'd2 ;
Weight_Buffer[0][29] <= #1 'd2 ;
Weight_Buffer[0][30] <= #1 'd1 ;
Weight_Buffer[0][31] <= #1 'd1 ;
Weight_Buffer[0][32] <= #1 'd1 ;
Weight_Buffer[0][33] <= #1 'd2 ;
Weight_Buffer[0][34] <= #1 'd0 ;
Weight_Buffer[0][35] <= #1 'd0 ;
Weight_Buffer[0][36] <= #1 'd1 ;
Weight_Buffer[0][37] <= #1 'd1 ;
Weight_Buffer[0][38] <= #1 'd2 ;
Weight_Buffer[0][39] <= #1 'd2 ;
Weight_Buffer[0][40] <= #1 'd2 ;
Weight_Buffer[0][41] <= #1 'd0 ;
Weight_Buffer[0][42] <= #1 'd1 ;
Weight_Buffer[0][43] <= #1 'd1 ;
Weight_Buffer[0][44] <= #1 'd0 ;
Weight_Buffer[0][45] <= #1 'd0 ;
Weight_Buffer[0][46] <= #1 'd0 ;
Weight_Buffer[0][47] <= #1 'd0 ;
Weight_Buffer[0][48] <= #1 'd1 ;
Weight_Buffer[0][49] <= #1 'd1 ;
Weight_Buffer[0][50] <= #1 'd0 ;
Weight_Buffer[0][51] <= #1 'd2 ;
Weight_Buffer[0][52] <= #1 'd1 ;
Weight_Buffer[0][53] <= #1 'd1 ;
Weight_Buffer[0][54] <= #1 'd2 ;
Weight_Buffer[0][55] <= #1 'd2 ;
Weight_Buffer[0][56] <= #1 'd1 ;
Weight_Buffer[0][57] <= #1 'd2 ;
Weight_Buffer[0][58] <= #1 'd1 ;
Weight_Buffer[0][59] <= #1 'd2 ;
Weight_Buffer[0][60] <= #1 'd1 ;
Weight_Buffer[0][61] <= #1 'd0 ;
Weight_Buffer[0][62] <= #1 'd2 ;
Weight_Buffer[0][63] <= #1 'd2 ;
Weight_Buffer[0][64] <= #1 'd2 ;
Weight_Buffer[0][65] <= #1 'd2 ;
Weight_Buffer[0][66] <= #1 'd0 ;
Weight_Buffer[0][67] <= #1 'd0 ;
Weight_Buffer[0][68] <= #1 'd2 ;
Weight_Buffer[0][69] <= #1 'd0 ;
Weight_Buffer[0][70] <= #1 'd2 ;
Weight_Buffer[0][71] <= #1 'd2 ;
Weight_Buffer[0][72] <= #1 'd2 ;
Weight_Buffer[0][73] <= #1 'd2 ;
Weight_Buffer[0][74] <= #1 'd2 ;
Weight_Buffer[0][75] <= #1 'd0 ;
Weight_Buffer[0][76] <= #1 'd2 ;
Weight_Buffer[0][77] <= #1 'd1 ;
Weight_Buffer[0][78] <= #1 'd2 ;
Weight_Buffer[0][79] <= #1 'd2 ;
Weight_Buffer[0][80] <= #1 'd0 ;
Weight_Buffer[0][81] <= #1 'd1 ;
Weight_Buffer[0][82] <= #1 'd1 ;
Weight_Buffer[0][83] <= #1 'd1 ;
Weight_Buffer[0][84] <= #1 'd2 ;
Weight_Buffer[0][85] <= #1 'd2 ;
Weight_Buffer[0][86] <= #1 'd2 ;
Weight_Buffer[0][87] <= #1 'd2 ;
Weight_Buffer[0][88] <= #1 'd2 ;
Weight_Buffer[0][89] <= #1 'd0 ;
Weight_Buffer[0][90] <= #1 'd0 ;
Weight_Buffer[0][91] <= #1 'd2 ;
Weight_Buffer[0][92] <= #1 'd1 ;
Weight_Buffer[0][93] <= #1 'd1 ;
Weight_Buffer[0][94] <= #1 'd0 ;
Weight_Buffer[0][95] <= #1 'd0 ;
Weight_Buffer[0][96] <= #1 'd0 ;
Weight_Buffer[0][97] <= #1 'd2 ;
Weight_Buffer[0][98] <= #1 'd0 ;
Weight_Buffer[0][99] <= #1 'd0 ;
Weight_Buffer[0][100] <= #1 'd2 ;
Weight_Buffer[0][101] <= #1 'd1 ;
Weight_Buffer[0][102] <= #1 'd1 ;
Weight_Buffer[0][103] <= #1 'd1 ;
Weight_Buffer[0][104] <= #1 'd0 ;
Weight_Buffer[0][105] <= #1 'd1 ;
Weight_Buffer[0][106] <= #1 'd1 ;
Weight_Buffer[0][107] <= #1 'd2 ;
Weight_Buffer[0][108] <= #1 'd2 ;
Weight_Buffer[0][109] <= #1 'd1 ;
Weight_Buffer[0][110] <= #1 'd0 ;
Weight_Buffer[0][111] <= #1 'd0 ;
Weight_Buffer[0][112] <= #1 'd2 ;
Weight_Buffer[0][113] <= #1 'd0 ;
Weight_Buffer[0][114] <= #1 'd0 ;
Weight_Buffer[0][115] <= #1 'd2 ;
Weight_Buffer[0][116] <= #1 'd2 ;
Weight_Buffer[0][117] <= #1 'd2 ;
Weight_Buffer[0][118] <= #1 'd1 ;
Weight_Buffer[0][119] <= #1 'd1 ;
Weight_Buffer[0][120] <= #1 'd1 ;
Weight_Buffer[0][121] <= #1 'd0 ;
Weight_Buffer[0][122] <= #1 'd1 ;
Weight_Buffer[0][123] <= #1 'd2 ;
Weight_Buffer[0][124] <= #1 'd1 ;
Weight_Buffer[0][125] <= #1 'd0 ;
Weight_Buffer[0][126] <= #1 'd2 ;
Weight_Buffer[0][127] <= #1 'd1 ;
Weight_Buffer[1][0] <= #1 'd1 ;
Weight_Buffer[1][1] <= #1 'd0 ;
Weight_Buffer[1][2] <= #1 'd1 ;
Weight_Buffer[1][3] <= #1 'd0 ;
Weight_Buffer[1][4] <= #1 'd2 ;
Weight_Buffer[1][5] <= #1 'd2 ;
Weight_Buffer[1][6] <= #1 'd2 ;
Weight_Buffer[1][7] <= #1 'd1 ;
Weight_Buffer[1][8] <= #1 'd0 ;
Weight_Buffer[1][9] <= #1 'd1 ;
Weight_Buffer[1][10] <= #1 'd1 ;
Weight_Buffer[1][11] <= #1 'd2 ;
Weight_Buffer[1][12] <= #1 'd0 ;
Weight_Buffer[1][13] <= #1 'd0 ;
Weight_Buffer[1][14] <= #1 'd0 ;
Weight_Buffer[1][15] <= #1 'd0 ;
Weight_Buffer[1][16] <= #1 'd1 ;
Weight_Buffer[1][17] <= #1 'd0 ;
Weight_Buffer[1][18] <= #1 'd0 ;
Weight_Buffer[1][19] <= #1 'd1 ;
Weight_Buffer[1][20] <= #1 'd0 ;
Weight_Buffer[1][21] <= #1 'd2 ;
Weight_Buffer[1][22] <= #1 'd1 ;
Weight_Buffer[1][23] <= #1 'd2 ;
Weight_Buffer[1][24] <= #1 'd2 ;
Weight_Buffer[1][25] <= #1 'd1 ;
Weight_Buffer[1][26] <= #1 'd0 ;
Weight_Buffer[1][27] <= #1 'd1 ;
Weight_Buffer[1][28] <= #1 'd1 ;
Weight_Buffer[1][29] <= #1 'd0 ;
Weight_Buffer[1][30] <= #1 'd1 ;
Weight_Buffer[1][31] <= #1 'd2 ;
Weight_Buffer[1][32] <= #1 'd1 ;
Weight_Buffer[1][33] <= #1 'd2 ;
Weight_Buffer[1][34] <= #1 'd1 ;
Weight_Buffer[1][35] <= #1 'd0 ;
Weight_Buffer[1][36] <= #1 'd2 ;
Weight_Buffer[1][37] <= #1 'd1 ;
Weight_Buffer[1][38] <= #1 'd1 ;
Weight_Buffer[1][39] <= #1 'd0 ;
Weight_Buffer[1][40] <= #1 'd0 ;
Weight_Buffer[1][41] <= #1 'd0 ;
Weight_Buffer[1][42] <= #1 'd1 ;
Weight_Buffer[1][43] <= #1 'd0 ;
Weight_Buffer[1][44] <= #1 'd2 ;
Weight_Buffer[1][45] <= #1 'd1 ;
Weight_Buffer[1][46] <= #1 'd2 ;
Weight_Buffer[1][47] <= #1 'd1 ;
Weight_Buffer[1][48] <= #1 'd0 ;
Weight_Buffer[1][49] <= #1 'd1 ;
Weight_Buffer[1][50] <= #1 'd0 ;
Weight_Buffer[1][51] <= #1 'd2 ;
Weight_Buffer[1][52] <= #1 'd0 ;
Weight_Buffer[1][53] <= #1 'd2 ;
Weight_Buffer[1][54] <= #1 'd2 ;
Weight_Buffer[1][55] <= #1 'd1 ;
Weight_Buffer[1][56] <= #1 'd0 ;
Weight_Buffer[1][57] <= #1 'd2 ;
Weight_Buffer[1][58] <= #1 'd0 ;
Weight_Buffer[1][59] <= #1 'd0 ;
Weight_Buffer[1][60] <= #1 'd1 ;
Weight_Buffer[1][61] <= #1 'd2 ;
Weight_Buffer[1][62] <= #1 'd1 ;
Weight_Buffer[1][63] <= #1 'd1 ;
Weight_Buffer[1][64] <= #1 'd2 ;
Weight_Buffer[1][65] <= #1 'd2 ;
Weight_Buffer[1][66] <= #1 'd2 ;
Weight_Buffer[1][67] <= #1 'd1 ;
Weight_Buffer[1][68] <= #1 'd0 ;
Weight_Buffer[1][69] <= #1 'd0 ;
Weight_Buffer[1][70] <= #1 'd2 ;
Weight_Buffer[1][71] <= #1 'd1 ;
Weight_Buffer[1][72] <= #1 'd0 ;
Weight_Buffer[1][73] <= #1 'd0 ;
Weight_Buffer[1][74] <= #1 'd0 ;
Weight_Buffer[1][75] <= #1 'd0 ;
Weight_Buffer[1][76] <= #1 'd0 ;
Weight_Buffer[1][77] <= #1 'd0 ;
Weight_Buffer[1][78] <= #1 'd0 ;
Weight_Buffer[1][79] <= #1 'd1 ;
Weight_Buffer[1][80] <= #1 'd2 ;
Weight_Buffer[1][81] <= #1 'd1 ;
Weight_Buffer[1][82] <= #1 'd1 ;
Weight_Buffer[1][83] <= #1 'd2 ;
Weight_Buffer[1][84] <= #1 'd0 ;
Weight_Buffer[1][85] <= #1 'd1 ;
Weight_Buffer[1][86] <= #1 'd2 ;
Weight_Buffer[1][87] <= #1 'd1 ;
Weight_Buffer[1][88] <= #1 'd0 ;
Weight_Buffer[1][89] <= #1 'd1 ;
Weight_Buffer[1][90] <= #1 'd0 ;
Weight_Buffer[1][91] <= #1 'd1 ;
Weight_Buffer[1][92] <= #1 'd1 ;
Weight_Buffer[1][93] <= #1 'd2 ;
Weight_Buffer[1][94] <= #1 'd1 ;
Weight_Buffer[1][95] <= #1 'd0 ;
Weight_Buffer[1][96] <= #1 'd2 ;
Weight_Buffer[1][97] <= #1 'd2 ;
Weight_Buffer[1][98] <= #1 'd0 ;
Weight_Buffer[1][99] <= #1 'd2 ;
Weight_Buffer[1][100] <= #1 'd2 ;
Weight_Buffer[1][101] <= #1 'd2 ;
Weight_Buffer[1][102] <= #1 'd2 ;
Weight_Buffer[1][103] <= #1 'd1 ;
Weight_Buffer[1][104] <= #1 'd0 ;
Weight_Buffer[1][105] <= #1 'd0 ;
Weight_Buffer[1][106] <= #1 'd0 ;
Weight_Buffer[1][107] <= #1 'd0 ;
Weight_Buffer[1][108] <= #1 'd1 ;
Weight_Buffer[1][109] <= #1 'd1 ;
Weight_Buffer[1][110] <= #1 'd0 ;
Weight_Buffer[1][111] <= #1 'd1 ;
Weight_Buffer[1][112] <= #1 'd1 ;
Weight_Buffer[1][113] <= #1 'd0 ;
Weight_Buffer[1][114] <= #1 'd1 ;
Weight_Buffer[1][115] <= #1 'd2 ;
Weight_Buffer[1][116] <= #1 'd0 ;
Weight_Buffer[1][117] <= #1 'd0 ;
Weight_Buffer[1][118] <= #1 'd1 ;
Weight_Buffer[1][119] <= #1 'd1 ;
Weight_Buffer[1][120] <= #1 'd1 ;
Weight_Buffer[1][121] <= #1 'd1 ;
Weight_Buffer[1][122] <= #1 'd2 ;
Weight_Buffer[1][123] <= #1 'd0 ;
Weight_Buffer[1][124] <= #1 'd0 ;
Weight_Buffer[1][125] <= #1 'd1 ;
Weight_Buffer[1][126] <= #1 'd2 ;
Weight_Buffer[1][127] <= #1 'd2 ;
        state<=#1 IDLE;
        Cur_Weight_layer<=#1 'd0;
        Cur_FV_num<=#1 'd0;
        Weight_data2Vertex<=#1 'd0;
        Weight_Cntl2bank_out<=#1 'd0;
        reg_nx_Weight_Cntl2bank_out<=#1 'd0;
        // reg_nx_Weight_Cntl2bank_out_q<=#1 'd0;
        RS_IDLE<=#1 'd0;
        // reg_Cur_FV_num<=#1 'd0;
    end
    else begin
        Weight_Buffer<=#1 Weight_Buffer;
        state<=#1 nx_state;
        Cur_Weight_layer<=#1 nx_Weight_layer;
        Cur_FV_num<=#1 nx_FV_num;
        Weight_data2Vertex<=#1 nx_Weight_data2Vertex;
        reg_nx_Weight_Cntl2bank_out<=#1 nx_Weight_Cntl2bank_out;
        // reg_nx_Weight_Cntl2bank_out_q<=#1 ;
        Weight_Cntl2bank_out<=#1 reg_nx_Weight_Cntl2bank_out;
        RS_IDLE<=#1 nx_RS_IDLE;
        //reg_Cur_FV_num<=#1 Cur_FV_num;
    end
end
endmodule