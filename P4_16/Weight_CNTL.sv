module Weight_CNTL(
    input clk,
    input reset,
    input[$clog2(`Max_Num_Weight_layer)-1:0] Num_Weight_layer,//Num_Weight_layer-1
    input[$clog2(`Max_FV_num):0]  Num_FV,
    input fire, //from RS

    // output logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex,
    output logic[`FV_size-1:0] Weight_data2Vertex_0,
    output logic[`FV_size-1:0] Weight_data2Vertex_1,
    // output logic[`FV_size-1:0] Weight_data2Vertex_2,
    // output logic[`FV_size-1:0] Weight_data2Vertex_3,
    output logic [$clog2(`Max_FV_num)-1:0] Weight_Cntl2RS_out_Cur_FV_num,

    output logic Weight_Cntl2bank_out_sos,
    output logic Weight_Cntl2bank_out_eos,
    output logic Weight_Cntl2bank_out_change,   
    output logic RS_IDLE
);
//And Wight Buffer
typedef enum reg [$clog2(2)-1:0] {
    IDLE='d0,
    Work='d1
} state_t;
logic[`Mult_per_PE-1:0][`FV_size-1:0] Weight_data2Vertex;
logic [`Max_Num_Weight_layer-1:0][`Max_FV_num-1:0][`FV_size-1:0]Weight_Buffer;
logic[$clog2(`Max_Num_Weight_layer)-1:0] Cur_Weight_layer,nx_Weight_layer;
logic [$clog2(`Max_FV_num):0]  Cur_FV_num,nx_FV_num,Cur_Weight_num,nx_Weight_num;
logic partial_FV;
logic partial_Weight_layer;
state_t state,nx_state;
// logic [`Mult_per_PE-1:0][$clog2(`Max_FV_num):0] idx_Weight;
logic[$clog2(8)-1:0] Weight_line_cnt, nx_Weight_line_cnt; //need change if change line number
logic[`Mult_per_PE-1:0][`FV_size-1:0] nx_Weight_data2Vertex;
Weight_Cntl2bank nx_Weight_Cntl2bank_out,reg_nx_Weight_Cntl2bank_out,reg_nx_Weight_Cntl2bank_out_q;//
logic nx_RS_IDLE;
// logic [$clog2(`Max_FV_num)-1:0]  Num_FV_boundary;
// assign Num_FV_boundary=Num_FV-1'b1;
Weight_Cntl2SRAM_Interface Weight_Cntl2SRAM_Interface_out,nx_Weight_Cntl2SRAM_Interface_out;
logic [`Weight_SRAM_BW-1:0] Weight_SRAM_Data_in;
Weight_Cntl2RS nx_Weight_Cntl2RS_out;
Weight_Cntl2RS Weight_Cntl2RS_out;
Weight_Cntl2bank Weight_Cntl2bank_out;
assign Weight_Cntl2RS_out_Cur_FV_num=Weight_Cntl2RS_out.Cur_FV_num;
assign Weight_Cntl2bank_out_sos=Weight_Cntl2bank_out.sos;
assign Weight_Cntl2bank_out_eos=Weight_Cntl2bank_out.eos;
assign Weight_Cntl2bank_out_change=Weight_Cntl2bank_out.change;
assign Weight_data2Vertex_0=Weight_data2Vertex[0];
assign Weight_data2Vertex_1=Weight_data2Vertex[1];
// assign Weight_data2Vertex_2=Weight_data2Vertex[2];
// assign Weight_data2Vertex_3=Weight_data2Vertex[3];
always_comb begin
        nx_Weight_layer=Cur_Weight_layer;
        nx_FV_num=Cur_FV_num;
        nx_state=state;
        nx_Weight_Cntl2bank_out='d0;
        nx_RS_IDLE='d0;
        nx_Weight_Cntl2RS_out='d0;
        nx_Weight_data2Vertex='d0;
        nx_Weight_Cntl2SRAM_Interface_out.WEN=1'b1;
        nx_Weight_Cntl2SRAM_Interface_out.CEN=1'b1;
        nx_Weight_Cntl2SRAM_Interface_out.A='d0;
        nx_Weight_line_cnt=Weight_line_cnt;
        nx_Weight_num=Cur_Weight_num;
        case(state)
            IDLE:
                if(fire)begin
                    nx_state=Work;
                    nx_Weight_Cntl2SRAM_Interface_out.WEN=1'b1;
                    nx_Weight_Cntl2SRAM_Interface_out.CEN=1'b0;
                    nx_Weight_Cntl2SRAM_Interface_out.A=Weight_line_cnt;
                    nx_Weight_line_cnt=Weight_line_cnt+1'b1;
                    nx_Weight_num=nx_Weight_num+`Mult_per_PE;
                end
                else begin
                    nx_state=IDLE;
                    nx_RS_IDLE=1'b1;
                end
            Work:
                begin
                    nx_FV_num=nx_FV_num+`Mult_per_PE;
                    nx_Weight_num=nx_Weight_num+`Mult_per_PE;
                    partial_FV=nx_FV_num==Num_FV;
                    if(Cur_FV_num=='d0 && Cur_Weight_layer=='d0)begin
                        nx_Weight_Cntl2bank_out.sos=1'b1;
                        nx_Weight_Cntl2bank_out.eos=1'b0;
                    end
                    nx_Weight_Cntl2SRAM_Interface_out.WEN=1'b1;
                    nx_Weight_Cntl2SRAM_Interface_out.CEN=1'b0;
                    
                    $display("nx_Weight_Cntl2SRAM_Interface_out.A:",{nx_Weight_layer,Weight_line_cnt});
                    nx_Weight_line_cnt=Weight_line_cnt+1'b1;
                    nx_Weight_Cntl2bank_out.change=partial_FV;
                    nx_Weight_layer=partial_FV?nx_Weight_layer+1'b1:nx_Weight_layer;
                    nx_Weight_Cntl2SRAM_Interface_out.A={nx_Weight_layer,Weight_line_cnt};
                    partial_Weight_layer=Num_Weight_layer==Cur_Weight_layer &&partial_FV;
                    // Weight_Cntl2RS_out.Complete=partial_FV&&partial_Weight_layer;
                    nx_Weight_Cntl2RS_out.Cur_FV_num=Cur_FV_num;
                    // for(int i=0;i<`Mult_per_PE;i++)begin
                    //     idx_Weight[i]=Cur_FV_num+i;
                    //     nx_Weight_data2Vertex[i]=Weight_Buffer[Cur_Weight_layer][idx_Weight[i]];
                    // end

                    nx_Weight_data2Vertex[0]=Weight_SRAM_Data_in[7:0];
                    nx_Weight_data2Vertex[1]=Weight_SRAM_Data_in[15:8];
                    // nx_Weight_data2Vertex[2]=Weight_SRAM_Data_in[47:32];
                    // nx_Weight_data2Vertex[3]=Weight_SRAM_Data_in[63:48];
                    if(nx_Weight_num==Num_FV)begin
                        nx_Weight_num='d0;
                        nx_Weight_line_cnt='d0;
                    end
                    else begin
                        nx_Weight_line_cnt=nx_Weight_line_cnt;
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
                        nx_Weight_line_cnt='d0;
                        
                        nx_Weight_num='d0;
                        nx_Weight_Cntl2bank_out.sos=1'b0;
                        nx_Weight_Cntl2bank_out.eos=1'b1;
                    end
                    else begin
                        nx_state=Work;
                    end
                end
        endcase
end
always_ff@(posedge clk or negedge reset)begin
    if(!reset)begin
        state<=#1 IDLE;
        Cur_Weight_layer<=#1 'd0;
        Cur_FV_num<=#1 'd0;
        Weight_data2Vertex<=#1 'd0;
        Weight_Cntl2bank_out<=#1 'd0;
        reg_nx_Weight_Cntl2bank_out<=#1 'd0;
        reg_nx_Weight_Cntl2bank_out_q<=#1 'd0;
        RS_IDLE<=#1 'd0;
        Weight_Cntl2RS_out<=#1 'd0;
        // reg_Cur_FV_num<=#1 'd0;
        Weight_line_cnt<=#1 'd0;
        Weight_Cntl2SRAM_Interface_out<=#1 'd0;
        Cur_Weight_num<=#1 'd0;
    end
    else begin
        // Weight_Buffer<=#1 Weight_Buffer;
        state<=#1 nx_state;
        Cur_Weight_layer<=#1 nx_Weight_layer;
        Cur_FV_num<=#1 nx_FV_num;
        Weight_data2Vertex<=#1 nx_Weight_data2Vertex;
        reg_nx_Weight_Cntl2bank_out<=#1 nx_Weight_Cntl2bank_out;
        reg_nx_Weight_Cntl2bank_out_q<=#1 reg_nx_Weight_Cntl2bank_out;
        Weight_Cntl2bank_out<=#1 reg_nx_Weight_Cntl2bank_out_q;
        RS_IDLE<=#1 nx_RS_IDLE;
        Weight_Cntl2RS_out<=#1 nx_Weight_Cntl2RS_out;
        Weight_line_cnt<=#1 nx_Weight_line_cnt;
        Weight_Cntl2SRAM_Interface_out<=#1 nx_Weight_Cntl2SRAM_Interface_out;
        Cur_Weight_num<=#1 nx_Weight_num;
        
        //reg_Cur_FV_num<=#1 Cur_FV_num;
    end
end

Weight_SRAM Weight_SRAM_DUT(
                .Q(Weight_SRAM_Data_in),
                .CLK(clk),
                .CEN(Weight_Cntl2SRAM_Interface_out.CEN),
                .WEN(Weight_Cntl2SRAM_Interface_out.WEN),
                .A(Weight_Cntl2SRAM_Interface_out.A),
                .D(64'b0)
                );
endmodule