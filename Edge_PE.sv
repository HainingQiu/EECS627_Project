
module Edge_PE
#(parameter PE_tag = 0)(
input clk,													// global clock
input reset,												// sync active high reset
input DP_task2Edge_PE DP_task2Edge_PE_in,					// dispatch task from command buffer
input FV_SRAM2Edge_PE FV_SRAM2Edge_PE_in,					// feature value from FV SRAM (for current computation)
input Output_SRAM2Edge_PE Output_SRAM2Edge_PE_in,			// feature value from output SRAM (last computation)
input NeighborID_SRAM2Edge_PE NeighborID_SRAM2Edge_PE_in,	// neighbor info from neighbor SRAM
input Grant_Bus_arbiter Grant_Bus_arbiter_in,				// grant request signal
input Grant_output_Bus_arbiter_in,                             // grant output sram req
input [$clog2(`Max_replay_Iter)-1:0] Cur_Replay_Iter,		// replay iteration count
// input [$clog2(`Max_Node_id)-1:0] Last_Node_ID,				// last node ID address
input Grant_WB_Packet,										// write back packet

output Req_Bus_arbiter Req_Bus_arbiter_out,					// request to arbiter
output Edge_PE2DP Edge_PE2DP_out,							// idle flag output to dispatch
output Edge_PE2IMEM_CNTL Edge_PE2IMEM_CNTL_out,				// packet to IMEM
output logic req_WB_Packet,									// request write back packet
output Edge_PE2Bank Edge_PE2Bank_out,						// aggregated output to bank
output Edge_PE2Req_Output_SRAM Req_Output_SRAM_out
);

// FSM State Def
typedef enum reg [$clog2(12)-1:0] {
	IDLE='d0,
	Req_Neighbor_ID='d1,
	Wait_Neighbor_ID='d2,
	Stream_Neighbor_ID='d3,
	Req_Neighbor_FV='d4,
	Wait_Neighbor_FV='d5,
	Stream_Neighbor_FV='d6,
	Req_Pre_ITER_output='d7,
	Wait_Pre_ITER_output='d8,
	Stream_Pre_ITER_output='d9,
	Req_wb_packet='d10,
	Complete='d11
	//Gen_Fence='d12
} state_t;
state_t state, nx_state;


logic [`max_degree_Iter-1:0][$clog2(`Max_Node_id)-1:0] Neighbor_ids, nx_Neighbor_ids;
logic [$clog2(`Max_Node_id)-1:0] Target_node,nx_Target_node;
logic [2:0] DP_Priority,nx_DP_Priority;
logic [3:0] req_neighbor_Iter,nx_req_neighbor_Iter;
// Req_Bus_arbiter nx_Req_Bus_arbiter_out;
Edge_PE2Bank nx_Edge_PE2Bank_out;
Edge_PE2IMEM_CNTL nx_Edge_PE2IMEM_CNTL_out;
// Req_Output_SRAM nx_Req_Output_SRAM_out;

logic [$clog2(`max_degree_Iter)-1:0] cnt_neighbor_info,nx_cnt_neighbor_info;
logic [$clog2(`max_degree_Iter)-1:0] fv_req_ptr,nx_fv_req_ptr;
logic[$clog2(`max_degree_Iter)-1:0] reg_Neighbor_num_Iter,nx_reg_Neighbor_num_Iter;
logic Cal_replay_Iter,NonCal_replay_Iter;
Edge_PE2DP nx_Edge_PE2DP_out;
// logic [$clog2(`Max_replay_Iter)-1:0] fence_nx_Replay_Iter;
always_ff@(posedge clk)begin
    if(reset)begin
        state<=#1 IDLE;
        Neighbor_ids<=#1 'd0;
        Target_node<=#1 'd0;
        DP_Priority<=#1 'd0;
        req_neighbor_Iter<=#1 'd0;
        cnt_neighbor_info<=#1 'd0;
        // Req_Bus_arbiter_out<='d0;
        fv_req_ptr<=#1 'd0;
        reg_Neighbor_num_Iter<=#1 'd0;
        Edge_PE2Bank_out<=#1 'd0;
        Edge_PE2DP_out<=#1 'd0;
        Edge_PE2IMEM_CNTL_out<=#1 'd0;
        // Req_Output_SRAM_out<=#1 'd0;
    end
    else begin
        state<=#1 nx_state;
        Neighbor_ids<=#1 nx_Neighbor_ids;
        Target_node<=#1 nx_Target_node;
        DP_Priority<=#1 nx_DP_Priority;
        req_neighbor_Iter<=#1 nx_req_neighbor_Iter;
        cnt_neighbor_info<=#1 nx_cnt_neighbor_info;
        // Req_Bus_arbiter_out<=#1 nx_Req_Bus_arbiter_out;
        fv_req_ptr<=#1 nx_fv_req_ptr;
        reg_Neighbor_num_Iter<=#1 nx_reg_Neighbor_num_Iter;
        Edge_PE2Bank_out<=#1 nx_Edge_PE2Bank_out;
        Edge_PE2DP_out<=#1 nx_Edge_PE2DP_out;
        Edge_PE2IMEM_CNTL_out<=#1 nx_Edge_PE2IMEM_CNTL_out;
        // Req_Output_SRAM_out<=#1 nx_Req_Output_SRAM_out;
    end
end

always_comb begin
    Req_Bus_arbiter_out='d0;
	nx_state = state; // default state to avoid latch
    req_WB_Packet='d0;
    nx_cnt_neighbor_info=cnt_neighbor_info;
    nx_fv_req_ptr=fv_req_ptr;
    nx_Neighbor_ids=Neighbor_ids;
    nx_reg_Neighbor_num_Iter=reg_Neighbor_num_Iter;
    nx_Target_node=Target_node;
    nx_DP_Priority=DP_Priority;
    nx_req_neighbor_Iter=req_neighbor_Iter;
    // nx_cnt_neighbor_info=cnt_neighbor_info;
    nx_Edge_PE2DP_out='d0;
    // nx_Req_Output_SRAM_out='d0;
    Req_Output_SRAM_out='d0;
    nx_Edge_PE2IMEM_CNTL_out='d0;
    nx_Edge_PE2Bank_out='d0;
    case(Cur_Replay_Iter)
        'b00:Cal_replay_Iter='d0;
        'b01:Cal_replay_Iter=nx_req_neighbor_Iter[0];
        'b10:Cal_replay_Iter=nx_req_neighbor_Iter[1]||nx_req_neighbor_Iter[0];
        'b11:Cal_replay_Iter=nx_req_neighbor_Iter[2]||nx_req_neighbor_Iter[1]||nx_req_neighbor_Iter[0];
    endcase
    case(Cur_Replay_Iter)
        'b00:NonCal_replay_Iter=(nx_req_neighbor_Iter[1]||nx_req_neighbor_Iter[2]||nx_req_neighbor_Iter[3]);
        'b01:NonCal_replay_Iter=(nx_req_neighbor_Iter[2]||nx_req_neighbor_Iter[3]);
        'b10:NonCal_replay_Iter=(nx_req_neighbor_Iter[3]);
        'b11:NonCal_replay_Iter='d0;
    endcase
    case(state)
        IDLE: 
            if(DP_task2Edge_PE_in.valid)begin
                nx_state=Req_Neighbor_ID;
                {nx_req_neighbor_Iter,nx_DP_Priority,nx_Target_node}=DP_task2Edge_PE_in.packet[13:0];
            end
            else begin
                nx_state=IDLE;
                nx_Edge_PE2DP_out.IDLE_flag=1'b1;
            end
        Req_Neighbor_ID:
            if(Grant_Bus_arbiter_in.Grant)begin
                nx_state=Wait_Neighbor_ID;
            end
            else begin
                nx_state=Req_Neighbor_ID;
                Req_Bus_arbiter_out.req=1'b1;
                Req_Bus_arbiter_out.PE_tag=PE_tag;
                Req_Bus_arbiter_out.req_type='d0;
                Req_Bus_arbiter_out.Node_id=nx_Target_node;
            end
        Wait_Neighbor_ID:
             if(NeighborID_SRAM2Edge_PE_in.eos)begin
                nx_reg_Neighbor_num_Iter=NeighborID_SRAM2Edge_PE_in.Neighbor_num_Iter;
  
                nx_state=Req_Neighbor_FV;
                nx_Neighbor_ids[nx_cnt_neighbor_info]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[6:0];
                nx_Neighbor_ids[nx_cnt_neighbor_info+'d1]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[13:7];
                nx_cnt_neighbor_info='d0;
            end
            else if(NeighborID_SRAM2Edge_PE_in.sos)begin
                nx_state=Stream_Neighbor_ID;
                nx_reg_Neighbor_num_Iter=NeighborID_SRAM2Edge_PE_in.Neighbor_num_Iter;
                nx_Neighbor_ids[nx_cnt_neighbor_info]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[6:0];
                nx_Neighbor_ids[nx_cnt_neighbor_info+'d1]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[13:7];
                nx_cnt_neighbor_info=nx_cnt_neighbor_info+'d2;
            end
            else begin
                nx_state=Wait_Neighbor_ID;
            end
        Stream_Neighbor_ID:
            if(NeighborID_SRAM2Edge_PE_in.eos)begin
                nx_state=Req_Neighbor_FV;
                nx_Neighbor_ids[nx_cnt_neighbor_info]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[6:0];
                nx_Neighbor_ids[nx_cnt_neighbor_info+1'b1]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[13:7];
                nx_cnt_neighbor_info='d0;
                
            end
            else begin
                nx_state=Stream_Neighbor_ID;
                nx_Neighbor_ids[nx_cnt_neighbor_info]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[6:0];
                nx_Neighbor_ids[nx_cnt_neighbor_info+1'b1]=NeighborID_SRAM2Edge_PE_in.Neighbor_ids[13:7];
                nx_cnt_neighbor_info=nx_cnt_neighbor_info+'d2;
            end
        Req_Neighbor_FV:
                if(Grant_Bus_arbiter_in.Grant)begin
                    nx_state=Wait_Neighbor_FV;
                    nx_fv_req_ptr=nx_fv_req_ptr+1'b1;
                end
                else begin
                        nx_state=Req_Neighbor_FV;
                        Req_Bus_arbiter_out.req=1'b1;
                        Req_Bus_arbiter_out.PE_tag=PE_tag;
                        Req_Bus_arbiter_out.req_type='d1;
                        Req_Bus_arbiter_out.Node_id=nx_Neighbor_ids[nx_fv_req_ptr];
                        
                end
          

        Wait_Neighbor_FV:
            if(FV_SRAM2Edge_PE_in.eos)begin
                if(fv_req_ptr==nx_reg_Neighbor_num_Iter&& (!Cal_replay_Iter))begin//
                    nx_state=Complete;
                    nx_fv_req_ptr='d0;
                end
                else if(nx_fv_req_ptr==nx_reg_Neighbor_num_Iter)begin
                    nx_state=Req_Pre_ITER_output;
                end
                else begin
                    nx_state=Req_Neighbor_FV;
                end     
                nx_Edge_PE2Bank_out.sos=1'b1;
                nx_Edge_PE2Bank_out.eos=1'b1;
                nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                nx_Edge_PE2Bank_out.WB_en=1'b0;
                nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
            end
            else if(FV_SRAM2Edge_PE_in.sos)begin
                nx_state=Stream_Neighbor_FV;
                nx_Edge_PE2Bank_out.sos=1'b1;
                nx_Edge_PE2Bank_out.eos=1'b0;
                nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                nx_Edge_PE2Bank_out.WB_en=1'b0;
                nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
            end
            else begin
                nx_state=Wait_Neighbor_FV;
            end
        Stream_Neighbor_FV:
            if(FV_SRAM2Edge_PE_in.eos)begin
                if(fv_req_ptr==nx_reg_Neighbor_num_Iter&& (!Cal_replay_Iter))begin//
                    nx_state=Complete;
                    nx_fv_req_ptr='d0;
                end
                else if(nx_fv_req_ptr==nx_reg_Neighbor_num_Iter)begin
                    nx_state=Req_Pre_ITER_output;
                    nx_fv_req_ptr='d0;
                end
                else begin
                    nx_state=Req_Neighbor_FV;
                end     
                nx_Edge_PE2Bank_out.sos=1'b0;
                nx_Edge_PE2Bank_out.eos=1'b1;
                nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                nx_Edge_PE2Bank_out.WB_en=1'b0;
                nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
            end
            else begin
                nx_Edge_PE2Bank_out.sos=1'b0;
                nx_Edge_PE2Bank_out.eos=1'b0;
                nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                nx_Edge_PE2Bank_out.WB_en=1'b0;
                nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                nx_state=Stream_Neighbor_FV;
            end
        Req_Pre_ITER_output:
                if(Grant_output_Bus_arbiter_in)begin
                    nx_state=Wait_Pre_ITER_output;
                end
                else begin
                    nx_state=Req_Pre_ITER_output;
                    // nx_Req_Bus_arbiter_out.req=1'b1;
                    // nx_Req_Bus_arbiter_out.PE_tag=PE_tag;
                    // nx_Req_Bus_arbiter_out.req_type='d2;
                    // nx_Req_Bus_arbiter_out.Node_id=nx_Target_node;
                    Req_Output_SRAM_out.req=1'b1;
                    Req_Output_SRAM_out.PE_tag=PE_tag;
                    Req_Output_SRAM_out.Node_id=nx_Target_node;
                    Req_Output_SRAM_out.Grant_valid=1'b0;

                end
        Wait_Pre_ITER_output:
            begin
            Req_Output_SRAM_out.req=1'b0;
            Req_Output_SRAM_out.PE_tag=PE_tag;
            Req_Output_SRAM_out.Node_id=nx_Target_node;
            Req_Output_SRAM_out.Grant_valid=1'b1;
                if(Output_SRAM2Edge_PE_in.eos)begin
                    nx_state=Complete;
                    nx_Edge_PE2Bank_out.sos=1'b1;
                    nx_Edge_PE2Bank_out.eos=1'b1;
                    nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                    nx_Edge_PE2Bank_out.WB_en=1'b0;
                    nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                    nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                    nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                end
                else if(FV_SRAM2Edge_PE_in.sos)begin
                    nx_state=Stream_Pre_ITER_output;
                    nx_Edge_PE2Bank_out.sos=1'b1;
                    nx_Edge_PE2Bank_out.eos=1'b0;
                    nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                    nx_Edge_PE2Bank_out.WB_en=1'b0;
                    nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                    nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                    nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                end
                else begin
                    nx_state=Wait_Pre_ITER_output;
                end
            end
        Stream_Pre_ITER_output: 
            begin
                Req_Output_SRAM_out.req=1'b0;
                Req_Output_SRAM_out.PE_tag=PE_tag;
                Req_Output_SRAM_out.Node_id=nx_Target_node;
                Req_Output_SRAM_out.Grant_valid=1'b1;
                if(FV_SRAM2Edge_PE_in.eos)begin
                    nx_state=Complete;
                    nx_Edge_PE2Bank_out.sos=1'b0;
                    nx_Edge_PE2Bank_out.eos=1'b1;
                    nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                    nx_Edge_PE2Bank_out.WB_en=1'b0;
                    nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                    nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                    nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                end
                else begin
                    nx_Edge_PE2Bank_out.sos=1'b0;
                    nx_Edge_PE2Bank_out.eos=1'b0;
                    nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                    nx_Edge_PE2Bank_out.WB_en=1'b0;
                    nx_Edge_PE2Bank_out.FV_data[0]=FV_SRAM2Edge_PE_in.FV_data[7:0];
                    nx_Edge_PE2Bank_out.FV_data[1]=FV_SRAM2Edge_PE_in.FV_data[15:8];
                    nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                    nx_state=Stream_Pre_ITER_output;
                end
            end
        Complete:
            if(Grant_WB_Packet)begin
                nx_state=IDLE;
            end
            else if(NonCal_replay_Iter)begin
                nx_state=Complete;
                req_WB_Packet=1'b1;
                nx_Edge_PE2IMEM_CNTL_out.packet={2'b00,nx_req_neighbor_Iter,nx_DP_Priority,nx_Target_node};
                nx_Edge_PE2IMEM_CNTL_out.valid=1'b1;
                nx_Edge_PE2Bank_out.Done_aggr=1'b0;
                nx_Edge_PE2Bank_out.WB_en=1'b1;
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
            end
            else begin
                nx_Edge_PE2Bank_out.Done_aggr=1'b1;
                nx_Edge_PE2Bank_out.WB_en=1'b0;
                nx_Edge_PE2Bank_out.Node_id=nx_Target_node;
                nx_state=IDLE;
            end
        default: begin
            nx_state=IDLE;
            Req_Bus_arbiter_out='d0;
            nx_Edge_PE2DP_out='d0;
            nx_Edge_PE2Bank_out='d0;
      
            nx_fv_req_ptr='d0;
            Req_Output_SRAM_out='d0;
            nx_Neighbor_ids='d0;
            nx_Target_node='d0;
            nx_DP_Priority='d0;
            nx_req_neighbor_Iter='d0;
            nx_cnt_neighbor_info='d0;
            Req_Bus_arbiter_out='d0;
            nx_reg_Neighbor_num_Iter='d0;
            nx_Edge_PE2Bank_out='d0;
            nx_Edge_PE2DP_out='d0;
            nx_Edge_PE2IMEM_CNTL_out='d0;
        end
    endcase
end


endmodule