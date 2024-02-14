`define NUM_PE 4
`define BIT_WIDTH $clog2(`NUM_PE)

// typedef struct packed {
//     logic sos; // start of streaming
//     logic eos;//  end of streaming
//     logic [1:0][`FV_size-1:0] FV_data;
//     logic Done_aggr;
//     logic WB_en;
// } Edge_PE2Bank;

// typedef struct packed {
//     logic sos;
//     logic eos;
//     logic [1:0][`FV_size-1:0] FV_data;
// } out_buff2Bank;


module edge_buffer(
    input clk, reset,
    input Edge_PE2Bank [`Num_Edge_PE-1:0] edge_pkt,
    input [`Num_Edge_PE-1:0] req_grant,
    input RS_busy,

    output Bank2RS RS_pkt_out,
    output logic busy,
    output Bank2out_buff [`Num_Edge_PE-1:0] outbuff_pkt
);

    assign busy = |bank_busy;
    generate
        for (int i = 0; i < `Num_Edge_PE; i++) begin
            edge_buffer_one buffer1 (
                .clk(clk),
                .reset(reset),
                .edge_pkt(edge_PE_pkt[i]),
                .req_grant(req_grant[i]),
                .rs_req_grant(rs_req_grant[i]),

                .rs_req(rs_req[i]),
                .rs_pkt(rs_pkt[i]),
                .bank_busy(bank_busy[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate

    round_robin_arbiter rr_arb_u (
        .clk(clk),
        .reset(reset),
        .req(rs_req),
        .rs_busy(busy),

        .grant(rs_req_grant)
    );


    always_comb begin
       case (rs_req_grant)
        4'b0001: RS_pkt_out = rs_pkt[0];
        4'b0010: RS_pkt_out = rs_pkt[1];
        4'b0100: RS_pkt_out = rs_pkt[2];
        4'b1000: RS_pkt_out = rs_pkt[3];
        default: RS_pkt_out = '0; // Default to zero packet
    endcase
    
    end

endmodule



module round_robin_arbiter (
    input		reset,
    input		clk,
    input	[3:0]	req,
    output	[3:0]	grant
);

logic	[3:0]	rotate_ptr;
logic	[3:0]	mask_req;
logic	[3:0]	mask_grant;
logic	[3:0]	grant_comb;

logic	[3:0]	no_mask_req;
logic	[3:0]	nomask_grant;

always @ (posedge clk or negedge reset)
begin
	if (!reset)
		rotate_ptr[3:0] <= 4'b1111;
        grant[3:0] <= 4'b0;
	else
        grant[3:0] <= grant_comb[3:0] & (~{4{rs_busy}});
		case (1'b1) // synthesis parallel_case
			grant_comb[0]: rotate_ptr[3:0] <= 4'b1111;
			grant_comb[1]: rotate_ptr[3:0] <= 4'b0111;
			grant_comb[2]: rotate_ptr[3:0] <= 4'b0011;
			grant_comb[3]: rotate_ptr[3:0] <= 4'b0001;
		endcase
end

assign mask_req[3:0] = req[3:0] & rotate_ptr[3:0];

// simple priority arbiter for mask req
always_comb begin
    casez (mask_req)
        4'b1???: mask_grant = 4'b1000;
        4'b01??: mask_grant = 4'b0100;
        4'b001?: mask_grant = 4'b0010;
        4'b0001: mask_grant = 4'b0001;
        default: mask_grant = 4'b0;
    endcase
end

// simple priority arbiter for no mask req
always_comb begin
    casez (no_mask_req)
        4'b1???: no_mask_grant = 4'b1000;
        4'b01??: no_mask_grant = 4'b0100;
        4'b001?: no_mask_grant = 4'b0010;
        4'b0001: no_mask_grant = 4'b0001;
        default: no_mask_grant = 4'b0;
    endcase
end

// not or
assign no_mask_req = ~|mask_req[3:0];
assign grant_comb[3:0] = (nomask_grant[3:0] & {4{no_mask_req}}) | mask_grant[3:0];



endmodule