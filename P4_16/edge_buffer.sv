`define NUM_PE 4
`define BIT_WIDTH $clog2(`NUM_PE)


module edge_buffer(
    input clk, reset,
    input [`Num_Edge_PE-1:0] edge_pkt_sos,
    input [`Num_Edge_PE-1:0] edge_pkt_eos,
    input [`FV_size-1:0] edge_pkt_FV_data_0_0,
    input [`FV_size-1:0] edge_pkt_FV_data_0_1,
    input [`FV_size-1:0] edge_pkt_FV_data_1_0,
    input [`FV_size-1:0] edge_pkt_FV_data_1_1,
    input [`FV_size-1:0] edge_pkt_FV_data_2_0,
    input [`FV_size-1:0] edge_pkt_FV_data_2_1,
    input [`FV_size-1:0] edge_pkt_FV_data_3_0,
    input [`FV_size-1:0] edge_pkt_FV_data_3_1,
    input [`Num_Edge_PE-1:0] edge_pkt_Done_aggr,
    input [`Num_Edge_PE-1:0] edge_pkt_WB_en,
    input [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_0,
    input [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_1,
    input [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_2,
    input [$clog2(`Max_Node_id)-1:0] edge_pkt_Node_id_3,

    input [`Num_Edge_PE-1:0] req_grant,
    input RS_available, // 1 is available , 0 is not available

    output logic RS_pkt_out_sos,
    output logic RS_pkt_out_eos,
    output logic [`FV_size-1:0] RS_pkt_out_FV_data_0,
    output logic [`FV_size-1:0] RS_pkt_out_FV_data_1,
    output logic [$clog2(`Max_Node_id)-1:0] RS_pkt_out_Node_id,

    output logic [`Num_Edge_PE-1:0] bank_busy,
    
    output logic [`Num_Edge_PE-1:0] outbuff_pkt_Grant_valid,
    output logic [`Num_Edge_PE-1:0] outbuff_pkt_sos,
    output logic [`Num_Edge_PE-1:0] outbuff_pkt_eos,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_data_0,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_data_1,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_data_2,
    output logic [`FV_bandwidth-1:0] outbuff_pkt_data_3,
    output logic [`Num_Edge_PE-1:0] outbuff_pkt_req,
    output logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_0,
    output logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_1,
    output logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_2,
    output logic [$clog2(`Max_Node_id)-1:0] outbuff_pkt_Node_id_3
);
    
Edge_PE2Bank [`Num_Edge_PE-1:0] edge_pkt;
Bank2RS RS_pkt_out;
Bank_Req2Req_Output_SRAM [`Num_Edge_PE-1:0] outbuff_pkt;

assign edge_pkt[0].sos = edge_pkt_sos[0];
assign edge_pkt[1].sos = edge_pkt_sos[1];
assign edge_pkt[2].sos = edge_pkt_sos[2];
assign edge_pkt[3].sos = edge_pkt_sos[3];
assign edge_pkt[0].eos = edge_pkt_eos[0];
assign edge_pkt[1].eos = edge_pkt_eos[1];
assign edge_pkt[2].eos = edge_pkt_eos[2];
assign edge_pkt[3].eos = edge_pkt_eos[3];
assign edge_pkt[0].FV_data[0] = edge_pkt_FV_data_0_0;
assign edge_pkt[0].FV_data[1] = edge_pkt_FV_data_0_1;

assign edge_pkt[1].FV_data[0] = edge_pkt_FV_data_1_0;
assign edge_pkt[1].FV_data[1] = edge_pkt_FV_data_1_1;

assign edge_pkt[2].FV_data[0] = edge_pkt_FV_data_2_0;
assign edge_pkt[2].FV_data[1] = edge_pkt_FV_data_2_1;

assign edge_pkt[3].FV_data[0] = edge_pkt_FV_data_3_0;
assign edge_pkt[3].FV_data[1] = edge_pkt_FV_data_3_1;

assign edge_pkt[0].Done_aggr = edge_pkt_Done_aggr[0];
assign edge_pkt[1].Done_aggr = edge_pkt_Done_aggr[1];
assign edge_pkt[2].Done_aggr = edge_pkt_Done_aggr[2];
assign edge_pkt[3].Done_aggr = edge_pkt_Done_aggr[3];
assign edge_pkt[0].WB_en = edge_pkt_WB_en[0];
assign edge_pkt[1].WB_en = edge_pkt_WB_en[1];
assign edge_pkt[2].WB_en = edge_pkt_WB_en[2];
assign edge_pkt[3].WB_en = edge_pkt_WB_en[3];
assign edge_pkt[0].Node_id = edge_pkt_Node_id_0;
assign edge_pkt[1].Node_id = edge_pkt_Node_id_1;
assign edge_pkt[2].Node_id = edge_pkt_Node_id_2;
assign edge_pkt[3].Node_id = edge_pkt_Node_id_3;

assign RS_pkt_out_sos = RS_pkt_out.sos;
assign RS_pkt_out_eos = RS_pkt_out.eos;
assign RS_pkt_out_FV_data_0 = RS_pkt_out.FV_data[0];
assign RS_pkt_out_FV_data_1 = RS_pkt_out.FV_data[1];
// assign RS_pkt_out_FV_data_2 = RS_pkt_out.FV_data[2];
// assign RS_pkt_out_FV_data_3 = RS_pkt_out.FV_data[3];
assign RS_pkt_out_Node_id = RS_pkt_out.Node_id;

assign outbuff_pkt_Grant_valid[0] = outbuff_pkt[0].Grant_valid;
assign outbuff_pkt_Grant_valid[1] = outbuff_pkt[1].Grant_valid;
assign outbuff_pkt_Grant_valid[2] = outbuff_pkt[2].Grant_valid;
assign outbuff_pkt_Grant_valid[3] = outbuff_pkt[3].Grant_valid;
assign outbuff_pkt_sos[0] = outbuff_pkt[0].sos;
assign outbuff_pkt_sos[1] = outbuff_pkt[1].sos;
assign outbuff_pkt_sos[2] = outbuff_pkt[2].sos;
assign outbuff_pkt_sos[3] = outbuff_pkt[3].sos;
assign outbuff_pkt_eos[0] = outbuff_pkt[0].eos;
assign outbuff_pkt_eos[1] = outbuff_pkt[1].eos;
assign outbuff_pkt_eos[2] = outbuff_pkt[2].eos;
assign outbuff_pkt_eos[3] = outbuff_pkt[3].eos;
assign outbuff_pkt_data_0 = outbuff_pkt[0].data;
assign outbuff_pkt_data_1 = outbuff_pkt[1].data;
assign outbuff_pkt_data_2 = outbuff_pkt[2].data;
assign outbuff_pkt_data_3 = outbuff_pkt[3].data;
assign outbuff_pkt_req[0] = outbuff_pkt[0].req;
assign outbuff_pkt_req[1] = outbuff_pkt[1].req;
assign outbuff_pkt_req[2] = outbuff_pkt[2].req;
assign outbuff_pkt_req[3] = outbuff_pkt[3].req;
assign outbuff_pkt_Node_id_0 = outbuff_pkt[0].Node_id;
assign outbuff_pkt_Node_id_1 = outbuff_pkt[1].Node_id;
assign outbuff_pkt_Node_id_2 = outbuff_pkt[2].Node_id;
assign outbuff_pkt_Node_id_3 = outbuff_pkt[3].Node_id;

    logic [`Num_Edge_PE-1:0]  rs_req, masked_rs_req, rs_req_grant, rs_req_grant_last;
    Bank2RS[`Num_Edge_PE-1:0] rs_pkt;
    
    // assign busy = bank_busy;

    typedef enum logic [1:0] {
        IDLE = 'd0,
        BLOCKED = 'd1
    } state_t;

    state_t state, nx_state;

    logic or_result;

    always_comb begin
        or_result = 0; // Initialize to 0
        foreach (rs_pkt[i]) begin
            or_result |= rs_pkt[i].eos;
        end
    end


    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= #1 IDLE;
            rs_req_grant_last <= 'd0;
        end else begin
            if (state == IDLE && |rs_req_grant) begin
                state <= #1 BLOCKED;
                rs_req_grant_last <= rs_req_grant;
            end else if (state == BLOCKED && or_result)begin
                state <= #1 IDLE;
            end
        end
    end

    // always_comb begin
    //     masked_rs_req = rs_req;

    //     if (|rs_req_grant) begin
    //         masked_rs_req = {`Num_Edge_PE{1'b0}};
    //     end

    //     if ((state == BLOCKED) && (!or_result)) begin
    //         masked_rs_req = {`Num_Edge_PE{1'b0}};
    //     end
    
    // end

    assign masked_rs_req = (|rs_req_grant || ((state == BLOCKED) && (!or_result)) || (!RS_available)) ? {`Num_Edge_PE{1'b0}} : rs_req; // TODO


    generate
        genvar i;
        for (i = 0; i < `Num_Edge_PE; i++) begin:edge_buffer_one_DUT
            edge_buffer_one buffer1 (
                .clk(clk),
                .reset(reset),
                .edge_pkt(edge_pkt[i]),
                .req_grant(req_grant[i]),
                .rs_req_grant(rs_req_grant[i]),
                // .RS_busy(RS_busy),

                .rs_req(rs_req[i]),
                .rs_pkt(rs_pkt[i]),
                .bank_busy(bank_busy[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate


    rr_arbiter
    #(.num_reqs(`Num_Edge_PE))
    rr_arbiter_U0(
        .clk(clk),
        .reset(reset),
        .reqs(masked_rs_req),
        .grants(rs_req_grant)
    );

    // round_robin_arbiter rr_arb_u (
    //     .clk(clk),
    //     .reset(reset),
    //     .req(rs_req),
    //     .rs_busy(busy),

    //     .grant(rs_req_grant)
    // );

    always_comb begin
       case (rs_req_grant_last)
            4'b0001: RS_pkt_out = rs_pkt[0];
            4'b0010: RS_pkt_out = rs_pkt[1];
            4'b0100: RS_pkt_out = rs_pkt[2];
            4'b1000: RS_pkt_out = rs_pkt[3];
            default: RS_pkt_out = '0; // Default to zero packet
        endcase
    end

endmodule



// module round_robin_arbiter (
//     input		reset,
//     input		clk,
//     input	[3:0]	req,
//     input   rs_busy,
//     output	logic[3:0]	grant
// );

// logic	[3:0]	rotate_ptr;
// logic	[3:0]	mask_req;
// logic	[3:0]	mask_grant;
// logic	[3:0]	grant_comb;

// logic	[3:0]	no_mask_req;
// // logic	[3:0]	nomask_grant;
// logic   [3:0]   no_mask_grant;
// always @ (posedge clk or negedge reset)
// begin
// 	if (reset)begin
// 		rotate_ptr[3:0] <= 4'b1111;
//         grant[3:0] <= 4'b0;
//     end
// 	else begin
//         grant[3:0] <= grant_comb[3:0] & (~{4{rs_busy}});
// 		case (1'b1) // synthesis parallel_case
// 			grant_comb[0]: rotate_ptr[3:0] <= 4'b1111;
// 			grant_comb[1]: rotate_ptr[3:0] <= 4'b0111;
// 			grant_comb[2]: rotate_ptr[3:0] <= 4'b0011;
// 			grant_comb[3]: rotate_ptr[3:0] <= 4'b0001;
// 		endcase
//     end
// end

// assign mask_req[3:0] = req[3:0] & rotate_ptr[3:0];

// // simple priority arbiter for mask req
// always_comb begin
//     casez (mask_req)
//         4'b1???: mask_grant = 4'b1000;
//         4'b01??: mask_grant = 4'b0100;
//         4'b001?: mask_grant = 4'b0010;
//         4'b0001: mask_grant = 4'b0001;
//         default: mask_grant = 4'b0;
//     endcase
// end

// // simple priority arbiter for no mask req
// always_comb begin
//     casez (no_mask_req)
//         4'b1???: no_mask_grant = 4'b1000;
//         4'b01??: no_mask_grant = 4'b0100;
//         4'b001?: no_mask_grant = 4'b0010;
//         4'b0001: no_mask_grant = 4'b0001;
//         default: no_mask_grant = 4'b0;
//     endcase
// end

// // not or
// assign no_mask_req = ~|mask_req[3:0];
// assign grant_comb[3:0] = (no_mask_grant[3:0] & {4{no_mask_req}}) | mask_grant[3:0];



// endmodule