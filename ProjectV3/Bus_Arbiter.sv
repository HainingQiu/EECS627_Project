// `include "sys_defs.svh"
module Bus_Arbiter
(
input clk,															// global clock
input reset,														// sync active high reset
// input Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_in,			// input request from PE
//Req_Bus_arbiter_in
input Req_Bus_arbiter_in_0_req,
input [$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_in_0_PE_tag,
input Req_Bus_arbiter_in_0_req_type,
input [$clog2(`Max_Node_id)-1:0]Req_Bus_arbiter_in_0_Node_id,

input Req_Bus_arbiter_in_1_req,
input [$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_in_1_PE_tag,
input Req_Bus_arbiter_in_1_req_type,
input [$clog2(`Max_Node_id)-1:0]Req_Bus_arbiter_in_1_Node_id,

input Req_Bus_arbiter_in_2_req,
input [$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_in_2_PE_tag,
input Req_Bus_arbiter_in_2_req_type,
input [$clog2(`Max_Node_id)-1:0]Req_Bus_arbiter_in_2_Node_id,

input Req_Bus_arbiter_in_3_req,
input [$clog2(`Num_Edge_PE)-1:0] Req_Bus_arbiter_in_3_PE_tag,
input Req_Bus_arbiter_in_3_req_type,
input [$clog2(`Max_Node_id)-1:0]Req_Bus_arbiter_in_3_Node_id,
//Req_Bus_arbiter_in

// output Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out,
output logic Grant_Bus_arbiter_out_0_Grant,
output logic Grant_Bus_arbiter_out_1_Grant,
output logic Grant_Bus_arbiter_out_2_Grant,
output logic Grant_Bus_arbiter_out_3_Grant,
// output BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out,
output logic BUS2FV_info_MEM_CNTL_out_valid,
output logic [$clog2(`Max_Node_id)-1:0] BUS2FV_info_MEM_CNTL_out_Node_id,
output logic [$clog2(`Num_Edge_PE)-1:0] BUS2FV_info_MEM_CNTL_out_PE_tag,

// output BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out
output logic BUS2Neighbor_info_MEM_CNTL_out_valid,
output logic [$clog2(`Max_Node_id)-1:0] BUS2Neighbor_info_MEM_CNTL_out_Node_id,
output logic [$clog2(`Num_Edge_PE)-1:0] BUS2Neighbor_info_MEM_CNTL_out_PE_tag
);
logic [`Num_Edge_PE-1:0] local_req, local_grant;
BUS2FV_info_FIFO nx_BUS2FV_info_MEM_CNTL_out;
// Req_Bus_arbiter granted_Req_Bus_arbiter_in;
Req_Bus_arbiter[`Num_Edge_PE-1:0] reg_Req_Bus_arbiter_in;
BUS2Neighbor_info_MEM_CNTL nx_BUS2Neighbor_info_MEM_CNTL_out;
// BUS2Output_SRAM_MEM_CNTL nx_BUS2Output_SRAM_MEM_CNTL_out;
Req_Bus_arbiter[`Num_Edge_PE-1:0] Req_Bus_arbiter_in;
Grant_Bus_arbiter[`Num_Edge_PE-1:0] Grant_Bus_arbiter_out;
BUS2FV_info_FIFO BUS2FV_info_MEM_CNTL_out;
BUS2Neighbor_info_MEM_CNTL BUS2Neighbor_info_MEM_CNTL_out;

assign Req_Bus_arbiter_in[0].req=Req_Bus_arbiter_in_0_req;
assign Req_Bus_arbiter_in[1].req=Req_Bus_arbiter_in_1_req;
assign Req_Bus_arbiter_in[2].req=Req_Bus_arbiter_in_2_req;
assign Req_Bus_arbiter_in[3].req=Req_Bus_arbiter_in_3_req;

assign Req_Bus_arbiter_in[0].PE_tag=Req_Bus_arbiter_in_0_PE_tag;
assign Req_Bus_arbiter_in[1].PE_tag=Req_Bus_arbiter_in_1_PE_tag;
assign Req_Bus_arbiter_in[2].PE_tag=Req_Bus_arbiter_in_2_PE_tag;
assign Req_Bus_arbiter_in[3].PE_tag=Req_Bus_arbiter_in_3_PE_tag;


assign Req_Bus_arbiter_in[0].req_type=Req_Bus_arbiter_in_0_req_type;
assign Req_Bus_arbiter_in[1].req_type=Req_Bus_arbiter_in_1_req_type;
assign Req_Bus_arbiter_in[2].req_type=Req_Bus_arbiter_in_2_req_type;
assign Req_Bus_arbiter_in[3].req_type=Req_Bus_arbiter_in_3_req_type;


assign Req_Bus_arbiter_in[0].Node_id=Req_Bus_arbiter_in_0_Node_id;
assign Req_Bus_arbiter_in[1].Node_id=Req_Bus_arbiter_in_1_Node_id;
assign Req_Bus_arbiter_in[2].Node_id=Req_Bus_arbiter_in_2_Node_id;
assign Req_Bus_arbiter_in[3].Node_id=Req_Bus_arbiter_in_3_Node_id;

assign Grant_Bus_arbiter_out_0_Grant=Grant_Bus_arbiter_out[0].Grant;
assign Grant_Bus_arbiter_out_1_Grant=Grant_Bus_arbiter_out[1].Grant;
assign Grant_Bus_arbiter_out_2_Grant=Grant_Bus_arbiter_out[2].Grant;
assign Grant_Bus_arbiter_out_3_Grant=Grant_Bus_arbiter_out[3].Grant;

assign BUS2FV_info_MEM_CNTL_out_valid=BUS2FV_info_MEM_CNTL_out.valid;
assign BUS2FV_info_MEM_CNTL_out_Node_id=BUS2FV_info_MEM_CNTL_out.Node_id;
assign BUS2FV_info_MEM_CNTL_out_PE_tag=BUS2FV_info_MEM_CNTL_out.PE_tag;

assign BUS2Neighbor_info_MEM_CNTL_out_valid=BUS2Neighbor_info_MEM_CNTL_out.valid;
assign BUS2Neighbor_info_MEM_CNTL_out_Node_id=BUS2Neighbor_info_MEM_CNTL_out.Node_id;
assign BUS2Neighbor_info_MEM_CNTL_out_PE_tag=BUS2Neighbor_info_MEM_CNTL_out.PE_tag;
always_ff@(posedge clk)begin
    if(reset)begin
        reg_Req_Bus_arbiter_in<=#1 'd0;
        BUS2FV_info_MEM_CNTL_out<=#1 'd0;
        BUS2Neighbor_info_MEM_CNTL_out<=#1 'd0;
        // BUS2Output_SRAM_MEM_CNTL_out<=#1 'd0;
    end
    else begin
        reg_Req_Bus_arbiter_in<=#1 Req_Bus_arbiter_in;
        BUS2FV_info_MEM_CNTL_out<=#1 nx_BUS2FV_info_MEM_CNTL_out;
        BUS2Neighbor_info_MEM_CNTL_out<=#1 nx_BUS2Neighbor_info_MEM_CNTL_out;
        // BUS2Output_SRAM_MEM_CNTL_out<=#1 nx_BUS2Output_SRAM_MEM_CNTL_out;
    end

end
always_comb begin
    nx_BUS2FV_info_MEM_CNTL_out='d0;
    nx_BUS2Neighbor_info_MEM_CNTL_out='d0;
    // nx_BUS2Output_SRAM_MEM_CNTL_out='d0;
    for (int i = 0; i < `Num_Edge_PE; i++) begin
	local_req[i] = Req_Bus_arbiter_in[i].req;
	Grant_Bus_arbiter_out[i].Grant  = local_grant[i];
    end

    
    for(int i=0; i<`Num_Edge_PE;i++)begin
        if(Grant_Bus_arbiter_out[i])begin
            case(reg_Req_Bus_arbiter_in[i].req_type)
                'b0: begin
					nx_BUS2Neighbor_info_MEM_CNTL_out.valid=1'b1;
					//nx_BUS2Neighbor_info_MEM_CNTL_out.rd_wr_en=1'b0;
					nx_BUS2Neighbor_info_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
					nx_BUS2Neighbor_info_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
				end

                'b1: begin
					nx_BUS2FV_info_MEM_CNTL_out.valid=1'b1;
					//nx_BUS2FV_info_MEM_CNTL_out.rd_wr_en=1'b0;
					nx_BUS2FV_info_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
					nx_BUS2FV_info_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
				end 

                // 'b10: begin
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.valid=1'b1;
				// 	//nx_BUS2Output_SRAM_MEM_CNTL_out.rd_wr_en=1'b0;
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.Node_id=reg_Req_Bus_arbiter_in[i].Node_id;
				// 	nx_BUS2Output_SRAM_MEM_CNTL_out.PE_tag=reg_Req_Bus_arbiter_in[i].PE_tag;
                // end
                default: begin
					
				end				
            endcase
        end
    end

end
//may don't need this

// local packed array



rr_arbiter
#(.num_reqs(`Num_Edge_PE))
rr_arbiter_U0(
    .clk(clk),
    .reset(reset),
    .reqs(local_req),//[`Num_Edge_PE-1:0][$bits(Req_Bus_arbiter_in)-1]),
    .grants(local_grant)
);



endmodule