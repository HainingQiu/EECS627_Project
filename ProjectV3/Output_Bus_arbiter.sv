module Output_Bus_arbiter(
    input clk,
    input reset,

    // input Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in,
    input Edge_PE2Req_Output_SRAM_in_Grant_valid_0,
    input [$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_0,
    input Edge_PE2Req_Output_SRAM_in_req_0,
    input [$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_0,

    input Edge_PE2Req_Output_SRAM_in_Grant_valid_1,
    input [$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_1,
    input Edge_PE2Req_Output_SRAM_in_req_1,
    input [$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_1,

    input Edge_PE2Req_Output_SRAM_in_Grant_valid_2,
    input [$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_2,
    input Edge_PE2Req_Output_SRAM_in_req_2,
    input [$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_2,

    input Edge_PE2Req_Output_SRAM_in_Grant_valid_3,
    input [$clog2(`Num_Edge_PE)-1:0] Edge_PE2Req_Output_SRAM_in_PE_tag_3,
    input Edge_PE2Req_Output_SRAM_in_req_3,
    input [$clog2(`Max_Node_id)-1:0] Edge_PE2Req_Output_SRAM_in_Node_id_3,
    // input Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in_,
    input Edge_Bank2Req_Output_SRAM_in_Grant_valid_0,
    input Edge_Bank2Req_Output_SRAM_in_sos_0,
    input Edge_Bank2Req_Output_SRAM_in_eos_0,
    input [`FV_bandwidth-1:0] Edge_Bank2Req_Output_SRAM_in_data_0,
    input Edge_Bank2Req_Output_SRAM_in_req_0,
    input Edge_Bank2Req_Output_SRAM_in_Node_id_0,

    input Edge_Bank2Req_Output_SRAM_in_Grant_valid_1,
    input Edge_Bank2Req_Output_SRAM_in_sos_1,
    input Edge_Bank2Req_Output_SRAM_in_eos_1,
    input [`FV_bandwidth-1:0] Edge_Bank2Req_Output_SRAM_in_data_1,
    input Edge_Bank2Req_Output_SRAM_in_req_1,
    input Edge_Bank2Req_Output_SRAM_in_Node_id_1,

    input Edge_Bank2Req_Output_SRAM_in_Grant_valid_2,
    input Edge_Bank2Req_Output_SRAM_in_sos_2,
    input Edge_Bank2Req_Output_SRAM_in_eos_2,
    input [`FV_bandwidth-1:0] Edge_Bank2Req_Output_SRAM_in_data_2,
    input Edge_Bank2Req_Output_SRAM_in_req_2,
    input Edge_Bank2Req_Output_SRAM_in_Node_id_2,

    input Edge_Bank2Req_Output_SRAM_in_Grant_valid_3,
    input Edge_Bank2Req_Output_SRAM_in_sos_3,
    input Edge_Bank2Req_Output_SRAM_in_eos_3,
    input [`FV_bandwidth-1:0] Edge_Bank2Req_Output_SRAM_in_data_3,
    input Edge_Bank2Req_Output_SRAM_in_req_3,
    input Edge_Bank2Req_Output_SRAM_in_Node_id_3,
    // input Bank_Req2Req_Output_SRAM[`Num_Vertex_Unit-1:0] Vertex_Bank2Req_Output_SRAM_in,
    input Vertex_Bank2Req_Output_SRAM_in_Grant_valid_0,
    input Vertex_Bank2Req_Output_SRAM_in_sos_0,
    input Vertex_Bank2Req_Output_SRAM_in_eos_0,
    input [`FV_bandwidth-1:0] Vertex_Bank2Req_Output_SRAM_in_data_0,
    input Vertex_Bank2Req_Output_SRAM_in_req_0,
    input Vertex_Bank2Req_Output_SRAM_in_Node_id_0,

    input Vertex_Bank2Req_Output_SRAM_in_Grant_valid_1,
    input Vertex_Bank2Req_Output_SRAM_in_sos_1,
    input Vertex_Bank2Req_Output_SRAM_in_eos_1,
    input [`FV_bandwidth-1:0] Vertex_Bank2Req_Output_SRAM_in_data_1,
    input Vertex_Bank2Req_Output_SRAM_in_req_1,
    input Vertex_Bank2Req_Output_SRAM_in_Node_id_1,

    input Vertex_Bank2Req_Output_SRAM_in_Grant_valid_2,
    input Vertex_Bank2Req_Output_SRAM_in_sos_2,
    input Vertex_Bank2Req_Output_SRAM_in_eos_2,
    input [`FV_bandwidth-1:0] Vertex_Bank2Req_Output_SRAM_in_data_2,
    input Vertex_Bank2Req_Output_SRAM_in_req_2,
    input Vertex_Bank2Req_Output_SRAM_in_Node_id_2,

    input Vertex_Bank2Req_Output_SRAM_in_Grant_valid_3,
    input Vertex_Bank2Req_Output_SRAM_in_sos_3,
    input Vertex_Bank2Req_Output_SRAM_in_eos_3,
    input [`FV_bandwidth-1:0] Vertex_Bank2Req_Output_SRAM_in_data_3,
    input Vertex_Bank2Req_Output_SRAM_in_req_3,
    // input Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter,
    input [`Num_Banks_FV-1:0] Output_Sram2Arbiter_eos,
    // output Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out,
    output logic Req2Output_SRAM_Bank_out_valid_0,
    output logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_0,
    output logic Req2Output_SRAM_Bank_out_rd_wr_0,
    output logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_0,
    output logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_0,
    output logic Req2Output_SRAM_Bank_out_wr_sos_0,
    output logic Req2Output_SRAM_Bank_out_wr_eos_0,

    output logic Req2Output_SRAM_Bank_out_valid_1,
    output logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_1,
    output logic Req2Output_SRAM_Bank_out_rd_wr_1,
    output logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_1,
    output logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_1,
    output logic Req2Output_SRAM_Bank_out_wr_sos_1,
    output logic Req2Output_SRAM_Bank_out_wr_eos_1,

    output logic Req2Output_SRAM_Bank_out_valid_2,
    output logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_2,
    output logic Req2Output_SRAM_Bank_out_rd_wr_2,
    output logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_2,
    output logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_2,
    output logic Req2Output_SRAM_Bank_out_wr_sos_2,
    output logic Req2Output_SRAM_Bank_out_wr_eos_2,

    output logic Req2Output_SRAM_Bank_out_valid_3,
    output logic [$clog2(`Num_Edge_PE)-1:0]Req2Output_SRAM_Bank_out_PE_tag_3,
    output logic Req2Output_SRAM_Bank_out_rd_wr_3,
    output logic [$clog2(`Max_Node_id)-1:0]Req2Output_SRAM_Bank_out_Node_id_3,
    output logic [`FV_bandwidth-1:0] Req2Output_SRAM_Bank_out_data_3,
    output logic Req2Output_SRAM_Bank_out_wr_sos_3,
    output logic Req2Output_SRAM_Bank_out_wr_eos_3,

    output logic[`Num_Total_reqs2Output-1:0] Ouput_SRAM_Grants
);

Edge_PE2Req_Output_SRAM[`Num_Edge_PE-1:0]  Edge_PE2Req_Output_SRAM_in;
Bank_Req2Req_Output_SRAM[`Num_Edge_PE-1:0] Edge_Bank2Req_Output_SRAM_in;
Bank_Req2Req_Output_SRAM[`Num_Vertex_Unit-1:0] Vertex_Bank2Req_Output_SRAM_in;
Output_Sram2Arbiter[`Num_Banks_FV-1:0] Output_Sram2Arbiter;
Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] Req2Output_SRAM_Bank_out;


assign Edge_PE2Req_Output_SRAM_in[0].Grant_valid=Edge_PE2Req_Output_SRAM_in_Grant_valid_0;
assign Edge_PE2Req_Output_SRAM_in[0].PE_tag=Edge_PE2Req_Output_SRAM_in_PE_tag_0;
assign Edge_PE2Req_Output_SRAM_in[0].req=Edge_PE2Req_Output_SRAM_in_req_0;
assign Edge_PE2Req_Output_SRAM_in[0].Node_id=Edge_PE2Req_Output_SRAM_in_Node_id_0;

assign Edge_PE2Req_Output_SRAM_in[1].Grant_valid=Edge_PE2Req_Output_SRAM_in_Grant_valid_1;
assign Edge_PE2Req_Output_SRAM_in[1].PE_tag=Edge_PE2Req_Output_SRAM_in_PE_tag_1;
assign Edge_PE2Req_Output_SRAM_in[1].req=Edge_PE2Req_Output_SRAM_in_req_1;
assign Edge_PE2Req_Output_SRAM_in[1].Node_id=Edge_PE2Req_Output_SRAM_in_Node_id_1;

assign Edge_PE2Req_Output_SRAM_in[2].Grant_valid=Edge_PE2Req_Output_SRAM_in_Grant_valid_2;
assign Edge_PE2Req_Output_SRAM_in[2].PE_tag=Edge_PE2Req_Output_SRAM_in_PE_tag_2;
assign Edge_PE2Req_Output_SRAM_in[2].req=Edge_PE2Req_Output_SRAM_in_req_2;
assign Edge_PE2Req_Output_SRAM_in[2].Node_id=Edge_PE2Req_Output_SRAM_in_Node_id_2;

assign Edge_PE2Req_Output_SRAM_in[3].Grant_valid=Edge_PE2Req_Output_SRAM_in_Grant_valid_3;
assign Edge_PE2Req_Output_SRAM_in[3].PE_tag=Edge_PE2Req_Output_SRAM_in_PE_tag_3;
assign Edge_PE2Req_Output_SRAM_in[3].req=Edge_PE2Req_Output_SRAM_in_req_3;
assign Edge_PE2Req_Output_SRAM_in[3].Node_id=Edge_PE2Req_Output_SRAM_in_Node_id_3;


assign Edge_Bank2Req_Output_SRAM_in[0].Grant_valid=Edge_Bank2Req_Output_SRAM_in_Grant_valid_0;
assign Edge_Bank2Req_Output_SRAM_in[0].sos=Edge_Bank2Req_Output_SRAM_in_sos_0;
assign Edge_Bank2Req_Output_SRAM_in[0].eos=Edge_Bank2Req_Output_SRAM_in_eos_0;
assign Edge_Bank2Req_Output_SRAM_in[0].data=Edge_Bank2Req_Output_SRAM_in_data_0;
assign Edge_Bank2Req_Output_SRAM_in[0].req=Edge_Bank2Req_Output_SRAM_in_req_0;
assign Edge_Bank2Req_Output_SRAM_in[0].Node_id=Edge_Bank2Req_Output_SRAM_in_Node_id_0;

assign Edge_Bank2Req_Output_SRAM_in[1].Grant_valid=Edge_Bank2Req_Output_SRAM_in_Grant_valid_1;
assign Edge_Bank2Req_Output_SRAM_in[1].sos=Edge_Bank2Req_Output_SRAM_in_sos_1;
assign Edge_Bank2Req_Output_SRAM_in[1].eos=Edge_Bank2Req_Output_SRAM_in_eos_1;
assign Edge_Bank2Req_Output_SRAM_in[1].data=Edge_Bank2Req_Output_SRAM_in_data_1;
assign Edge_Bank2Req_Output_SRAM_in[1].req=Edge_Bank2Req_Output_SRAM_in_req_1;
assign Edge_Bank2Req_Output_SRAM_in[1].Node_id=Edge_Bank2Req_Output_SRAM_in_Node_id_1;

assign Edge_Bank2Req_Output_SRAM_in[2].Grant_valid=Edge_Bank2Req_Output_SRAM_in_Grant_valid_2;
assign Edge_Bank2Req_Output_SRAM_in[2].sos=Edge_Bank2Req_Output_SRAM_in_sos_2;
assign Edge_Bank2Req_Output_SRAM_in[2].eos=Edge_Bank2Req_Output_SRAM_in_eos_2;
assign Edge_Bank2Req_Output_SRAM_in[2].data=Edge_Bank2Req_Output_SRAM_in_data_2;
assign Edge_Bank2Req_Output_SRAM_in[2].req=Edge_Bank2Req_Output_SRAM_in_req_2;
assign Edge_Bank2Req_Output_SRAM_in[2].Node_id=Edge_Bank2Req_Output_SRAM_in_Node_id_2;

assign Edge_Bank2Req_Output_SRAM_in[3].Grant_valid=Edge_Bank2Req_Output_SRAM_in_Grant_valid_3;
assign Edge_Bank2Req_Output_SRAM_in[3].sos=Edge_Bank2Req_Output_SRAM_in_sos_3;
assign Edge_Bank2Req_Output_SRAM_in[3].eos=Edge_Bank2Req_Output_SRAM_in_eos_3;
assign Edge_Bank2Req_Output_SRAM_in[3].data=Edge_Bank2Req_Output_SRAM_in_data_3;
assign Edge_Bank2Req_Output_SRAM_in[3].req=Edge_Bank2Req_Output_SRAM_in_req_3;
assign Edge_Bank2Req_Output_SRAM_in[3].Node_id=Edge_Bank2Req_Output_SRAM_in_Node_id_3;


assign Vertex_Bank2Req_Output_SRAM_in[0].Grant_valid=Vertex_Bank2Req_Output_SRAM_in_Grant_valid_0;
assign Vertex_Bank2Req_Output_SRAM_in[0].sos=Vertex_Bank2Req_Output_SRAM_in_sos_0;
assign Vertex_Bank2Req_Output_SRAM_in[0].eos=Vertex_Bank2Req_Output_SRAM_in_eos_0;
assign Vertex_Bank2Req_Output_SRAM_in[0].data=Vertex_Bank2Req_Output_SRAM_in_data_0;
assign Vertex_Bank2Req_Output_SRAM_in[0].req=Vertex_Bank2Req_Output_SRAM_in_req_0;
assign Vertex_Bank2Req_Output_SRAM_in[0].Node_id=Vertex_Bank2Req_Output_SRAM_in_Node_id_0;

assign Vertex_Bank2Req_Output_SRAM_in[1].Grant_valid=Vertex_Bank2Req_Output_SRAM_in_Grant_valid_1;
assign Vertex_Bank2Req_Output_SRAM_in[1].sos=Vertex_Bank2Req_Output_SRAM_in_sos_1;
assign Vertex_Bank2Req_Output_SRAM_in[1].eos=Vertex_Bank2Req_Output_SRAM_in_eos_1;
assign Vertex_Bank2Req_Output_SRAM_in[1].data=Vertex_Bank2Req_Output_SRAM_in_data_1;
assign Vertex_Bank2Req_Output_SRAM_in[1].req=Vertex_Bank2Req_Output_SRAM_in_req_1;
assign Vertex_Bank2Req_Output_SRAM_in[1].Node_id=Vertex_Bank2Req_Output_SRAM_in_Node_id_1;

assign Vertex_Bank2Req_Output_SRAM_in[2].Grant_valid=Vertex_Bank2Req_Output_SRAM_in_Grant_valid_2;
assign Vertex_Bank2Req_Output_SRAM_in[2].sos=Vertex_Bank2Req_Output_SRAM_in_sos_2;
assign Vertex_Bank2Req_Output_SRAM_in[2].eos=Vertex_Bank2Req_Output_SRAM_in_eos_2;
assign Vertex_Bank2Req_Output_SRAM_in[2].data=Vertex_Bank2Req_Output_SRAM_in_data_2;
assign Vertex_Bank2Req_Output_SRAM_in[2].req=Vertex_Bank2Req_Output_SRAM_in_req_2;
assign Vertex_Bank2Req_Output_SRAM_in[2].Node_id=Vertex_Bank2Req_Output_SRAM_in_Node_id_2;

assign Vertex_Bank2Req_Output_SRAM_in[3].Grant_valid=Vertex_Bank2Req_Output_SRAM_in_Grant_valid_3;
assign Vertex_Bank2Req_Output_SRAM_in[3].sos=Vertex_Bank2Req_Output_SRAM_in_sos_3;
assign Vertex_Bank2Req_Output_SRAM_in[3].eos=Vertex_Bank2Req_Output_SRAM_in_eos_3;
assign Vertex_Bank2Req_Output_SRAM_in[3].data=Vertex_Bank2Req_Output_SRAM_in_data_3;
assign Vertex_Bank2Req_Output_SRAM_in[3].req=Vertex_Bank2Req_Output_SRAM_in_req_3;
assign Vertex_Bank2Req_Output_SRAM_in[3].Node_id=Vertex_Bank2Req_Output_SRAM_in_Node_id_3;



assign Output_Sram2Arbiter[0].eos=Output_Sram2Arbiter_eos[0];
assign Output_Sram2Arbiter[1].eos=Output_Sram2Arbiter_eos[1];
assign Output_Sram2Arbiter[2].eos=Output_Sram2Arbiter_eos[2];
assign Output_Sram2Arbiter[3].eos=Output_Sram2Arbiter_eos[3];


assign Req2Output_SRAM_Bank_out[0].valid=Req2Output_SRAM_Bank_out_valid_0;
assign Req2Output_SRAM_Bank_out[0].PE_tag=Req2Output_SRAM_Bank_out_PE_tag_0;
assign Req2Output_SRAM_Bank_out[0].rd_wr=Req2Output_SRAM_Bank_out_rd_wr_0;
assign Req2Output_SRAM_Bank_out[0].Node_id=Req2Output_SRAM_Bank_out_Node_id_0;
assign Req2Output_SRAM_Bank_out[0].data=Req2Output_SRAM_Bank_out_data_0;
assign Req2Output_SRAM_Bank_out[0].wr_sos=Req2Output_SRAM_Bank_out_wr_sos_0;
assign Req2Output_SRAM_Bank_out[0].wr_eos=Req2Output_SRAM_Bank_out_wr_eos_0;

assign Req2Output_SRAM_Bank_out[1].valid=Req2Output_SRAM_Bank_out_valid_1;
assign Req2Output_SRAM_Bank_out[1].PE_tag=Req2Output_SRAM_Bank_out_PE_tag_1;
assign Req2Output_SRAM_Bank_out[1].rd_wr=Req2Output_SRAM_Bank_out_rd_wr_1;
assign Req2Output_SRAM_Bank_out[1].Node_id=Req2Output_SRAM_Bank_out_Node_id_1;
assign Req2Output_SRAM_Bank_out[1].data=Req2Output_SRAM_Bank_out_data_1;
assign Req2Output_SRAM_Bank_out[1].wr_sos=Req2Output_SRAM_Bank_out_wr_sos_1;
assign Req2Output_SRAM_Bank_out[1].wr_eos=Req2Output_SRAM_Bank_out_wr_eos_1;

assign Req2Output_SRAM_Bank_out[2].valid=Req2Output_SRAM_Bank_out_valid_2;
assign Req2Output_SRAM_Bank_out[2].PE_tag=Req2Output_SRAM_Bank_out_PE_tag_2;
assign Req2Output_SRAM_Bank_out[2].rd_wr=Req2Output_SRAM_Bank_out_rd_wr_2;
assign Req2Output_SRAM_Bank_out[2].Node_id=Req2Output_SRAM_Bank_out_Node_id_2;
assign Req2Output_SRAM_Bank_out[2].data=Req2Output_SRAM_Bank_out_data_2;
assign Req2Output_SRAM_Bank_out[2].wr_sos=Req2Output_SRAM_Bank_out_wr_sos_2;
assign Req2Output_SRAM_Bank_out[2].wr_eos=Req2Output_SRAM_Bank_out_wr_eos_2;

assign Req2Output_SRAM_Bank_out[3].valid=Req2Output_SRAM_Bank_out_valid_3;
assign Req2Output_SRAM_Bank_out[3].PE_tag=Req2Output_SRAM_Bank_out_PE_tag_3;
assign Req2Output_SRAM_Bank_out[3].rd_wr=Req2Output_SRAM_Bank_out_rd_wr_3;
assign Req2Output_SRAM_Bank_out[3].Node_id=Req2Output_SRAM_Bank_out_Node_id_3;
assign Req2Output_SRAM_Bank_out[3].data=Req2Output_SRAM_Bank_out_data_3;
assign Req2Output_SRAM_Bank_out[3].wr_sos=Req2Output_SRAM_Bank_out_wr_sos_3;
assign Req2Output_SRAM_Bank_out[3].wr_eos=Req2Output_SRAM_Bank_out_wr_eos_3;




logic[`Num_Total_reqs2Output-1:0] masked_reqs;
logic [`Num_Banks_FV-1:0] Bank_Busy,nx_Bank_Busy;
// logic [`Num_Total_reqs2Output-1:0] all_eos;
logic [`Num_Total_reqs2Output-1:0][$clog2(`Num_Banks_FV)-1:0] target_bank,nx_target_bank;//
Req2Output_SRAM_Bank[`Num_Banks_FV-1:0] nx_Req2Output_SRAM_Bank_out;
always_comb begin
    masked_reqs='d0;
    // all_eos='d0;
    nx_Bank_Busy=Bank_Busy;
    nx_Req2Output_SRAM_Bank_out='d0;
    nx_target_bank=target_bank;
//granted req;
    for(int i=0;i<`Num_Edge_PE;i++)begin
        if(Edge_PE2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag=Edge_PE2Req_Output_SRAM_in[i].PE_tag;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Edge_PE2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos='d0;
        end
    end
    for(int i=0;i<`Num_Edge_PE;i++)begin
        if(Edge_Bank2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag='d0;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b1;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Edge_Bank2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data=Edge_Bank2Req_Output_SRAM_in[i].data;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos=Edge_Bank2Req_Output_SRAM_in[i].sos;
            nx_Req2Output_SRAM_Bank_out[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos=Edge_Bank2Req_Output_SRAM_in[i].eos;
        end
    end
    for (int i=0;i<`Num_Vertex_Unit;i++)begin
        if(Vertex_Bank2Req_Output_SRAM_in[i].Grant_valid)begin
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].valid=1'b1;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].PE_tag='d0;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].rd_wr=1'b1;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].Node_id=Vertex_Bank2Req_Output_SRAM_in[i].Node_id;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].data=Vertex_Bank2Req_Output_SRAM_in[i].data;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_sos=Vertex_Bank2Req_Output_SRAM_in[i].sos;
            nx_Req2Output_SRAM_Bank_out[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]].wr_eos=Vertex_Bank2Req_Output_SRAM_in[i].eos;
        end
    end
    for(int i=0;i<`Num_Total_reqs2Output;i++)begin
        if(Ouput_SRAM_Grants[i])begin
            nx_Bank_Busy[target_bank[i]]=1'b1;
        end
    end
    for(int i=0;i<`Num_Edge_PE;i++)begin
        nx_target_bank[i]=Edge_PE2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Edge_PE2Req_Output_SRAM_in[i].req & (~nx_Bank_Busy[nx_target_bank[i]]);
    end
    for (int i=`Num_Edge_PE;i<`Num_Edge_PE+`Num_Edge_PE;i++)begin
        nx_target_bank[i]=Edge_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Edge_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE].req & (~nx_Bank_Busy[nx_target_bank[i]]); 
    end
    for (int i=`Num_Edge_PE+`Num_Edge_PE;i<`Num_Total_reqs2Output;i++)begin
        nx_target_bank[i]=Vertex_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE-`Num_Edge_PE].Node_id[$clog2(`Num_Banks_FV)-1:0];
        masked_reqs[i]=Vertex_Bank2Req_Output_SRAM_in[i-`Num_Edge_PE-`Num_Edge_PE].req & (~nx_Bank_Busy[nx_target_bank[i]]); 
    end
    for(int i=0;i<`Num_Banks_FV;i++)begin
        nx_Bank_Busy[i]=Output_Sram2Arbiter[i].eos?1'b0:nx_Bank_Busy[i];
    end
    for (int i=0;i<`Num_Edge_PE;i++)begin
        if(Edge_Bank2Req_Output_SRAM_in[i].eos)begin
            nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=1'b0;
        end
        else begin
            nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=nx_Bank_Busy[Edge_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]];
        end
    end
    for (int i=0;i<`Num_Vertex_Unit;i++)begin
        if(Vertex_Bank2Req_Output_SRAM_in[i].eos)begin
            nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=1'b0;
        end
        else begin
            nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]]=nx_Bank_Busy[Vertex_Bank2Req_Output_SRAM_in[i].Node_id[$clog2(`Num_Banks_FV)-1:0]];
        end
    end
end
always_ff@(posedge clk)begin
    if(reset)begin
        Bank_Busy<=#1 'd0;
        Req2Output_SRAM_Bank_out<=#1 'd0;
        target_bank<=#1 'd0;
    end
    else begin
        Bank_Busy<=#1 nx_Bank_Busy;
        Req2Output_SRAM_Bank_out<=#1 nx_Req2Output_SRAM_Bank_out;
        target_bank<=#1 nx_target_bank;
    end
end

rr_arbiter
#(.num_reqs(`Num_Total_reqs2Output))
rr_arbiter_U0(
    .clk(clk),
    .reset(reset),
    .reqs(masked_reqs),
    .grants(Ouput_SRAM_Grants)
);

endmodule