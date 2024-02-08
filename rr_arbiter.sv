module rr_arbiter
#(parameter num_reqs=5)
(
input clk,
input reset,
input [num_reqs-1:0] reqs,
output logic [num_reqs-1:0] grants
);

logic [num_reqs-1:0] P;
logic [num_reqs:0] Carry;
logic [num_reqs-1 :0] nx_grants;
always_comb begin
    nx_grants <= 'd0;
    for (int i = 1; i < num_reqs + 1; i++)begin
        Carry[i] <= ~reqs[i-1] && (P[i-1] || Carry[i-1]);
    end
    Carry[0] <= Carry[num_reqs];
    for(int i = 0; i < num_reqs + 1; i++)begin
        nx_grants[i] <= reqs[i] && (P[i] || Carry[i]);
    end
end
always_ff @(posedge clk)begin
    if(reset)begin
        P <= #1 'd1;
        grants <= #1 'd0;
    end
    else begin
        P <= #1 |nx_grants ? {nx_grants[num_reqs-2:0], nx_grants[num_reqs-1]} : P;
        grants <= #1 nx_grants;
    end
end
endmodule