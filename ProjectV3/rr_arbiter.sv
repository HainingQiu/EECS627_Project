module rr_arbiter
#(parameter num_reqs=4)
(
input clk,
input reset,
input [num_reqs-1:0] reqs,
output logic [num_reqs-1:0] grants
);

logic [num_reqs-1:0] P;
logic [num_reqs:0] Carry;
// logic Carry_bit_num_req;
logic [num_reqs-1 :0] nx_grants;
    for (genvar i = 1; i < num_reqs+1; i++)begin:Carry_logic
       assign  Carry[i] = ~reqs[i-1] && (P[i-1] || Carry[i-1]);
    end
    assign Carry[0]=Carry[num_reqs];
    for(genvar i = 0; i < num_reqs; i++)begin:nx_grants_logic
        assign nx_grants[i] = reqs[i] && (P[i] || Carry[i]);
    end
// always_comb begin
//     nx_grants = 'd0;
//     // Carry= {{num_reqs-1{1'b0}},Carry_bit_num_req};

//     // Carry[0] = Carry[num_reqs];
//     for(int i = 0; i < num_reqs + 1; i++)begin
//         nx_grants[i] = reqs[i] && (P[i] || Carry[i]);
//     end
// end
always_ff @(posedge clk)begin
    if(reset)begin
        P <= #1 'd1;
        grants <= #1 'd0;
        // Carry_bit_num_req<=#1 'd0;
    end
    else begin
        P <= #1 |nx_grants ? {nx_grants[num_reqs-2:0], nx_grants[num_reqs-1]} : P;
        grants <= #1 nx_grants;
        // Carry_bit_num_req<=#1 Carry[num_reqs];
    end
end
endmodule
