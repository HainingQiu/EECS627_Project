
module Neighbor_BUS(
    input clk,
    input reset,
    input Neighbor_bank_CNTL2Edge_PE[`Num_Banks_Neighbor-1:0] Neighbor_bank_CNTL2Edge_PE_in,
    output NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] NeighborID_SRAM2Edge_PE_out
);
NeighborID_SRAM2Edge_PE[`Num_Edge_PE-1:0] nx_NeighborID_SRAM2Edge_PE_out;

always_ff@(posedge clk)begin
    if(reset)begin
        NeighborID_SRAM2Edge_PE_out<=#1 'd0;
    end
    else begin
        NeighborID_SRAM2Edge_PE_out<=#1 nx_NeighborID_SRAM2Edge_PE_out;
    end
end
always_comb begin
    nx_NeighborID_SRAM2Edge_PE_out='d0;
    for (int i=0;i<`Num_Banks_FV;i++)begin

            nx_NeighborID_SRAM2Edge_PE_out[Neighbor_bank_CNTL2Edge_PE_in[i].PE_tag].sos=Neighbor_bank_CNTL2Edge_PE_in[i].sos;
            nx_NeighborID_SRAM2Edge_PE_out[Neighbor_bank_CNTL2Edge_PE_in[i].PE_tag].eos=Neighbor_bank_CNTL2Edge_PE_in[i].eos;
            nx_NeighborID_SRAM2Edge_PE_out[Neighbor_bank_CNTL2Edge_PE_in[i].PE_tag].Neighbor_ids=Neighbor_bank_CNTL2Edge_PE_in[i].data;
            nx_NeighborID_SRAM2Edge_PE_out[Neighbor_bank_CNTL2Edge_PE_in[i].PE_tag].Neighbor_num_Iter=Neighbor_bank_CNTL2Edge_PE_in[i].data;

    end
end

endmodule