module Vertex_RS (
    input clk,
    input reset,
   // input Bank2RS Bank2RS_in,
    input Bank2RS_in_sos,
    input Bank2RS_in_eos,
    input [`FV_size-1:0] Bank2RS_in_FV_data_0,
    input [`FV_size-1:0] Bank2RS_in_FV_data_1,
    // input [`FV_size-1:0] Bank2RS_in_FV_data_2,
    // input [`FV_size-1:0] Bank2RS_in_FV_data_3,
    input [$clog2(`Max_Node_id)-1:0] Bank2RS_in_Node_id,

    input logic [$clog2(`Max_FV_num)-1:0] start_idx,
    input logic Vertex_buf_idle,
    input logic complete, 

//output RS2Vertex_PE RS2Vertex_PE_out,
    output logic [`FV_size-1:0] RS2Vertex_PE_out_0_0,
    output logic [`FV_size-1:0] RS2Vertex_PE_out_0_1,

    output logic [`FV_size-1:0] RS2Vertex_PE_out_1_0,
    output logic [`FV_size-1:0] RS2Vertex_PE_out_1_1,

    output logic [`FV_size-1:0] RS2Vertex_PE_out_2_0,
    output logic [`FV_size-1:0] RS2Vertex_PE_out_2_1,

    output logic [`FV_size-1:0] RS2Vertex_PE_out_3_0,
    output logic [`FV_size-1:0] RS2Vertex_PE_out_3_1,

    output logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_0,
    output logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_1,
    output logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_2,
    output logic [$clog2(`Max_Node_id)-1:0] RS2Vertex_PE_out_Node_id_3,
   
    output logic fire,
    output logic RS_available,
    output logic Vertex_RS_empty

);
Bank2RS Bank2RS_in;
RS2Vertex_PE RS2Vertex_PE_out;

assign Bank2RS_in.sos = Bank2RS_in_sos;
assign Bank2RS_in.eos = Bank2RS_in_eos;
assign Bank2RS_in.FV_data[0] = Bank2RS_in_FV_data_0;
assign Bank2RS_in.FV_data[1] = Bank2RS_in_FV_data_1;
assign Bank2RS_in.FV_data[2] = Bank2RS_in_FV_data_2;
assign Bank2RS_in.FV_data[3] = Bank2RS_in_FV_data_3;
assign Bank2RS_in.Node_id = Bank2RS_in_Node_id;

assign RS2Vertex_PE_out_0_0 = RS2Vertex_PE_out.FV_data[0][0];
assign RS2Vertex_PE_out_0_1 = RS2Vertex_PE_out.FV_data[0][1];

assign RS2Vertex_PE_out_1_0 = RS2Vertex_PE_out.FV_data[1][0];
assign RS2Vertex_PE_out_1_1 = RS2Vertex_PE_out.FV_data[1][1];

assign RS2Vertex_PE_out_2_0 = RS2Vertex_PE_out.FV_data[2][0];
assign RS2Vertex_PE_out_2_1 = RS2Vertex_PE_out.FV_data[2][1];

assign RS2Vertex_PE_out_3_0 = RS2Vertex_PE_out.FV_data[3][0];
assign RS2Vertex_PE_out_3_1 = RS2Vertex_PE_out.FV_data[3][1];


assign RS2Vertex_PE_out_Node_id_0 = RS2Vertex_PE_out.Node_id[0];
assign RS2Vertex_PE_out_Node_id_1 = RS2Vertex_PE_out.Node_id[1];
assign RS2Vertex_PE_out_Node_id_2 = RS2Vertex_PE_out.Node_id[2];
assign RS2Vertex_PE_out_Node_id_3 = RS2Vertex_PE_out.Node_id[3];

typedef enum reg [$clog2(5)-1:0] {
IDLE='d0,
Rex_FV='d1,
Fire='d2,
Wait_vertex='d3,
Wait_vertex_buffer='d4
} state_t;
state_t state,nx_state;
RS2Vertex_PE nx_RS2Vertex_PE_out;
logic [`Num_RS2Vertex_PE-1:0][`Max_FV_num-1:0][`FV_size-1:0] RS_FV_data,nx_RS_FV_data;
logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] RS_Node_id,nx_RS_Node_id;;
logic [$clog2(`Num_Edge_PE):0] rs_cnt,nx_rs_cnt;
logic [$clog2(`Num_Edge_PE)-1:0]rs_ptr,nx_rs_ptr;
logic [$clog2(`Max_FV_num)-1:0] num_fv,nx_num_fv;
logic [`Mult_per_PE-1:0][$clog2(`Max_FV_num)-1:0]vertex_fv_idx;
assign Vertex_RS_empty=rs_cnt=='d0;;
always_ff@(posedge clk)begin
    if(reset)begin
        state<=#1 IDLE;
        rs_cnt<=#1 'd0;
        rs_ptr<=#1 'd0;
        num_fv<=#1 'd0;
        RS2Vertex_PE_out<=#1 'd0;
        RS_Node_id<=#1 'd0;
        RS_FV_data<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        rs_cnt<=#1 nx_rs_cnt;
        rs_ptr<=#1 nx_rs_ptr;    
        num_fv<=#1 nx_num_fv;   
        RS2Vertex_PE_out<=#1 nx_RS2Vertex_PE_out;
        RS_Node_id<=#1 nx_RS_Node_id;
        RS_FV_data<=#1 nx_RS_FV_data;
    end
end
// assign RS_available=nx_cnt<`Num_Edge_PE;
always_comb begin
    nx_state=state;
    nx_RS2Vertex_PE_out='d0;
    RS_available='d0;
    nx_rs_cnt=rs_cnt;
    nx_num_fv=num_fv;
    nx_rs_ptr=rs_ptr;
    vertex_fv_idx='d0;
    fire='d0;
    nx_RS_Node_id=RS_Node_id;
    nx_RS_FV_data=RS_FV_data;
    case(state)
        IDLE:   
            begin
                if(Bank2RS_in.sos)begin
                    nx_state=Rex_FV;
                    // nx_rs_cnt=nx_rs_cnt+1'b1;
                    nx_RS_FV_data[nx_rs_ptr][nx_num_fv]=Bank2RS_in.FV_data[0];
                    nx_RS_FV_data[nx_rs_ptr][nx_num_fv+1'b1]=Bank2RS_in.FV_data[1];
                    nx_RS_Node_id[nx_rs_ptr]=Bank2RS_in.Node_id;
                    nx_num_fv=nx_num_fv+'d2;
                    nx_rs_cnt=nx_rs_cnt+1'b1;
                end
                else  begin
                    nx_state=IDLE;
                    RS_available=1'b1;
                end
            end
        
        Rex_FV:
            begin
                nx_RS_FV_data[nx_rs_ptr][nx_num_fv]=Bank2RS_in.FV_data[0];
                nx_RS_FV_data[nx_rs_ptr][nx_num_fv+1'b1]=Bank2RS_in.FV_data[1];
                if(Bank2RS_in.eos)begin
                    nx_num_fv='d0;
                    if(nx_rs_cnt==`Num_Edge_PE)begin
                        nx_state=Wait_vertex;
                        nx_rs_ptr='d0;
                        fire=1'b1;
                    end
                    else begin
                        nx_state=IDLE;
                        nx_rs_ptr=nx_rs_ptr+1'b1;
                    end
                end 
                else begin
                    nx_state=Rex_FV;
                    nx_num_fv=nx_num_fv+'d2;

                end
            end
        Wait_vertex:
            begin

                for(int i=0;i<`Mult_per_PE;i++)begin
                    vertex_fv_idx[i]=start_idx+i;
                end 
                for(int i=0;i<`Num_Edge_PE;i++)begin
                    for(int j=0;j<`Mult_per_PE;j++)begin
                        nx_RS2Vertex_PE_out.FV_data[i][j]=nx_RS_FV_data[i][vertex_fv_idx[j]];
                        nx_RS2Vertex_PE_out.Node_id[i]=nx_RS_Node_id[i];
                    end
                end
                if(complete)begin
                    nx_state=Wait_vertex_buffer;
                end
                else begin
                    nx_state=Wait_vertex;
                end
            end
        Wait_vertex_buffer:
                if(Vertex_buf_idle)begin
                    nx_state=IDLE;
                    nx_RS2Vertex_PE_out='d0;
                    nx_rs_cnt='d0;
                    nx_num_fv='d0;
                    nx_rs_ptr='d0;
                    vertex_fv_idx='d0;
                    fire='d0;
                end
                else begin
                    nx_state=Wait_vertex_buffer;
                end
        default:
            begin
                    nx_state=IDLE;
                    nx_RS2Vertex_PE_out='d0;
                    nx_rs_cnt='d0;
                    nx_num_fv='d0;
                    nx_rs_ptr='d0;
                    vertex_fv_idx='d0;
                    fire='d0;
            end
    endcase
end

endmodule


// endmodule
//     logic [`Num_RS2Vertex_PE-1:0][`Max_FV_num-1:0][`FV_size-1:0] RS_FV_data;
//     logic [`Num_RS2Vertex_PE-1:0][$clog2(`Max_Node_id)-1:0] RS_Node_id;

//     logic [2:0] count;
//     logic counting;

//     logic [$clog2(`Num_RS2Vertex_PE):0] eos_cnt;
//     logic eos_last; 
//     logic [$clog2(`Num_RS2Vertex_PE):0] sos_cnt;
//     logic sos_last; 

//     logic [3:0] boundary;
//     logic RS_ready; // RS is ready to issue, but need Vertex_buf_idle = 1 currently
//     logic fire, fire_last;

//     assign boundary = count << 1;
//     assign RS_empty = complete;

//     always_ff @(posedge clk) begin
//         if (reset) begin
//             count <= #1 0;
//             counting <= #1 0;
//         end else begin
//             if (Bank2RS_in.sos) begin
//                 counting <= #1 1;
//                 count <= #1 count + 1;
//             end
//             if (counting) begin
//                 if (count == 7 || Bank2RS_in.eos) begin
//                     count <= #1 0;
//                     counting <= #1 0;
//                 end else begin
//                     count <= #1 count + 1;
//                 end
//             end
//         end
//     end

// // Counter the number of eos
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             eos_cnt <= #1 0;
//             eos_last <= #1 0;
//         end else begin
//             eos_last <= #1 Bank2RS_in.eos; 
//             if (Bank2RS_in.eos && !eos_last) begin
//                 eos_cnt <= #1 (eos_cnt == `Num_RS2Vertex_PE-1) ? 0 : eos_cnt + 1;
//             end
//         end
//     end

// // Counter the number of sos
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             sos_cnt <= #1 0;
//             sos_last <= #1 0;
//         end else begin
//             sos_last <= #1 Bank2RS_in.sos; 
//             if (Bank2RS_in.sos && !sos_last) begin
//                 sos_cnt <= #1 (sos_cnt == `Num_RS2Vertex_PE-1) ? 0 : sos_cnt + 1'b1;
//             end
//         end
//     end

// // Write data into RS
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             RS_FV_data <= #1 0;
//             RS_Node_id <= #1 0;
//         end
//         else begin
//             if (Bank2RS_in.sos || counting) begin
//                 RS_FV_data[eos_cnt][boundary +: 2] <= #1 Bank2RS_in.FV_data[1:0];
//                 RS_Node_id[eos_cnt] <= #1 Bank2RS_in.Node_id;
//             end
//         end
//     end

// // Inform Edge buffer that RS is unavailable once the last entry of RS is being written
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             unavailable <= #1 0;
//         end
//         else begin
//             if ((sos_cnt == `Num_RS2Vertex_PE-1) && (Bank2RS_in.sos)) begin
//                 unavailable <= #1 1;
//             end
//             else begin
//                 unavailable <= #1 0;
//             end
//         end
//     end

// // Output
//     always_ff @(posedge clk) begin
//         if (reset) begin
//             RS2Vertex_PE_out.FV_data <= #1 0;
//             RS2Vertex_PE_out.Node_id <= #1 0;
//         end
//         else begin
//             for (int i=0; i<`Num_RS2Vertex_PE; i=i+1) begin
//                 RS2Vertex_PE_out.FV_data[i] <= #1 RS_FV_data[i][start_idx +: 2];
//             end
//             RS2Vertex_PE_out.Node_id <= #1 RS_Node_id;
//         end
//     end

// // Determine if RS is ready for fire
//     always @(posedge clk) begin
//         if (reset) begin
//             RS_ready <= #1 0;
//         end
//         else begin
//             if ((eos_cnt == `Num_RS2Vertex_PE-1) && (Bank2RS_in.eos)) begin
//                 RS_ready <= #1 1;
//             end
//             else begin
//                 if (Bank2RS_in.sos)
//                 RS_ready <= #1 0;
//             end
//         end
//     end

// // Fire when both RS_ready and Vertex_buf_idle
//     always @(posedge clk) begin
//         if (reset) begin
//             fire <= #1 0;
//         end
//         else begin
//             if (RS_ready && Vertex_buf_idle) begin
//                 fire <= #1 1;
//             end
//             else begin
//                 fire <= #1 0;
//             end
//         end
//     end

// // Transfer pulse fire to level fire
//     always @(posedge clk) begin
//         if (reset) begin
//             RS2Vertex_PE_out.fire <= #1 0;
//             fire_last <= #1 0;
//         end else begin
//             RS2Vertex_PE_out.fire <= #1 (fire && !fire_last);
//             fire_last <= #1 fire;
//         end
//     end

// endmodule