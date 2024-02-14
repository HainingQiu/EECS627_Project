

module vertex_buffer(
    input clk, reset,
    input Vertex_PE2Bank [`Num_Edge_PE-1:0] vertex_data_pkt, 
    input Weight_Cntl2bank [`Num_Edge_PE-1:0] vertex_cntl_pkt,
    input logic [`Num_Edge_PE-1:0] req_grant,

    output logic busy,
    output logic empty,
    output Bank2out_buff [`Num_Edge_PE-1:0] outbuff_pkt
);

    assign busy = |bank_busy;
    assign empty = ~|bank_busy;

    generate
        for (int i = 0; i < `Num_Edge_PE; i++) begin
            vertex_buffer_one buffer2 (
                .clk(clk),
                .reset(reset),
                .vertex_data_pkt(vertex_data_pkt[i]), 
                .vertex_cntl_pkt(vertex_cntl_pkt[i]),
                .req_grant(req_grant[i]),
               
                .bank_busy(bank_busy[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate

endmodule