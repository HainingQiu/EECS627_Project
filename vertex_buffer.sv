

module vertex_buffer(
    input clk, reset,
    input Vertex2Accu_Bank [`Num_Vertex_Unit-1:0] vertex_data_pkt, 
    input Weight_Cntl2bank  vertex_cntl_pkt,
    input logic [`Num_Vertex_Unit-1:0] req_grant,

    // output logic busy,
    output logic empty,
    output Bank_Req2Req_Output_SRAM [`Num_Vertex_Unit-1:0] outbuff_pkt
);
logic[`Num_Vertex_Unit-1:0] bank_busy;
    assign busy = |bank_busy;
    assign empty = ~|bank_busy;

    generate
        genvar i;
        for (i = 0; i < `Num_Vertex_Unit; i++) begin:vertex_buffer_one_DUT
            vertex_buffer_one buffer2 (
                .clk(clk),
                .reset(reset),
                .vertex_data_pkt(vertex_data_pkt[i]), 
                .vertex_cntl_pkt(vertex_cntl_pkt),
                .req_grant(req_grant[i]),
               
                .bank_busy(bank_busy[i]),
                .outbuff_pkt(outbuff_pkt[i])
            );
        end 
    endgenerate

endmodule