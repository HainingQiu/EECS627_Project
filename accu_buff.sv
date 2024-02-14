`define NUM_PE 4
`define BIT_WIDTH $clog2(`NUM_PE)

typedef struct packed {
    logic sos; // start of streaming
    logic eos;//  end of streaming
    logic [1:0][`FV_size-1:0] FV_data;
    logic Done_aggr;
    logic WB_en;
} Edge_PE2Bank;

typedef struct packed {
    logic sos;
    logic eos;
    logic [1:0][`FV_size-1:0] FV_data;
} out_buff2Bank;


module acc_buffer(
    input clk, reset,
    input Edge_PE2Bank [`Num_Edge_PE-1:0] edge_pkt,
    input logic [`Num_Edge_PE-1:0] req_grant,

    output Bank2RS [`Num_Edge_PE-1:0] RS_pkt, // TODO: might need to chagne the parameter here
    output Bank_Req2Req_Output_SRAM [`Num_Edge_PE-1:0] outbuff_pkt
);

    generate
        for (int i = 0; i < `Num_Edge_PE; i++) begin
            buffer_one buffer1 (
                .clk(clk),
                .reset(reset),
                .edge_pkt(edge_PE_pkt[i]),
                .req_grant(req_grant[i]),

                .rs_pkt(rs_pkt[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate

endmodule