
module decoder(
    input clk,
    input reset,
    input com_packet com2DPpacket,
    input RS_empty,
    input grant, 
    input [`Num_Edge_PE-1:0]bank_busy_in,
    input [`Num_Edge_PE-1:0]PE_IDLE,
    input stream_end,
    input vertex_done,
    output logic cntl_done,
    output logic task_complete,
    output DP_task2RS DP_task2RS_out,
    output logic Req,
    output logic fifo_stall,
    output logic current_replay_iter_flag,
    output logic [$clog2(`Max_replay_Iter)-1:0]  replay_Iter,
    output logic [$clog2(16):0 ]    Num_FV ,
    output logic [$clog2(16)-1:0 ] Weights_boundary,
    output  DP2mem_packet DP2mem_packet_out,
    output logic stream_begin
);
parameter IDLE='d0, wait_grant='d1,wait_replay_iter='d2,wait_stream='d3,wait_task_complete='d4;
logic [2:0]state,nx_state;
logic [$clog2(16)-1:0 ] nx_Weights_boundary,current_Weights_boundary;
logic [$clog2(`Max_replay_Iter)-1:0] nx_replay_Iter ,current_replay_Iter;
logic [`packet_size-1:0] nx_packet ,current_packet;
logic [$clog2(16):0 ] nx_Num_FV,current_Num_FV;
logic nx_Req,current_Req;
logic bank_busy;
logic [3:0] Iter;
logic PE_finish;
logic replay_iter_flag;

logic nx_stream_begin;
assign Iter = com2DPpacket.packet[13:10];
assign PE_finish = (&PE_IDLE);
assign replay_Iter =current_replay_Iter;
assign Num_FV =current_Num_FV;
assign Weights_boundary =current_Weights_boundary;
assign Req =nx_Req;
assign bank_busy=|bank_busy_in;
always_ff @( posedge clk ) begin 
    if(reset)begin
        state <= #1 'd0;
        current_Weights_boundary <= #1 'd0;
        current_replay_Iter <= #1 'd0;
        current_packet <= #1 'd0;
        current_Num_FV <= #1 'd0; 
        current_Req<= #1 'd0;
        stream_begin<= #1 'd0;
        current_replay_iter_flag<= #1 'd0;
    end
    else begin
        state <= #1 nx_state;
        current_Weights_boundary <= #1 nx_Weights_boundary;
        current_replay_Iter <= #1 nx_replay_Iter;
        current_packet <= #1 nx_packet;
        current_Num_FV <= #1 nx_Num_FV; 
        current_Req<= #1 nx_Req;
        stream_begin<= #1 nx_stream_begin;
        current_replay_iter_flag<= #1 replay_iter_flag;
    end
end
always_comb begin
        nx_state = state;
        nx_Weights_boundary = current_Weights_boundary;
        nx_replay_Iter = current_replay_Iter;
        nx_packet = current_packet;
        nx_Num_FV = current_Num_FV;  
        replay_iter_flag =current_replay_iter_flag;
        DP_task2RS_out=0;
        nx_Req =current_Req;
        fifo_stall = 0;
        DP2mem_packet_out =0;
        cntl_done=0;
        task_complete='d0;
        nx_stream_begin=0;
    if(com2DPpacket.valid && !replay_iter_flag) begin 
        case(com2DPpacket.packet[`packet_size-1:`packet_size-2])
            'b00 :   begin 
                        if (Iter[current_replay_Iter]) begin 
                        
                        DP_task2RS_out.packet = com2DPpacket.packet[`packet_size-3:0];
                        DP_task2RS_out.valid  = 'd1;
                        end 
                        // else if(current_replay_Iter=='d3)begin 
                        // DP_task2RS_out.packet = com2DPpacket.packet[`packet_size-3:0];
                        // DP_task2RS_out.valid  = 'd1; 
                        // end
                        else begin
                        nx_Req ='d1;
                        fifo_stall = 'd1;
                        nx_packet = com2DPpacket.packet;
                        nx_state =  wait_grant;

                        end
                    end
            'b01:   begin 
			
                        nx_packet = com2DPpacket.packet;
                        nx_state =  wait_replay_iter;
                        fifo_stall = 'd1;

                    end
            'b10:   begin
                        nx_Num_FV= com2DPpacket.packet[$clog2(16):0 ];
                        nx_stream_begin='d1;
                    end
            'b11:   begin 
                        nx_Weights_boundary = com2DPpacket.packet[$clog2(16)-1:0 ];
			nx_state =  wait_stream;
			fifo_stall = 'd1;
                        
                    end

        endcase
    end

        case(state)
        IDLE :  begin

                    // replay_iter_flag ='d0;
                    // nx_packet = 0 ;
                    
                end
        wait_grant:   begin 
                        if(grant) begin
                            DP2mem_packet_out.packet = current_packet;
                            DP2mem_packet_out.valid='d1;
                            nx_state = IDLE;
                            nx_Req ='d0;
                            fifo_stall = 'd0;
                        end 
                        else begin
                           DP2mem_packet_out = 0;
                           fifo_stall = 'd1;
                           nx_state =wait_grant;
                           nx_Req ='d1;
                        end

                      end
        wait_replay_iter:   begin
                            replay_iter_flag ='d0;
                            if (!bank_busy && RS_empty && PE_finish && replay_Iter=='d3)begin
                                fifo_stall = 'd1;
                                nx_state=wait_task_complete;
                                cntl_done='d1;
                            end
                            else if(!bank_busy && RS_empty && PE_finish ) begin
                            DP2mem_packet_out.packet = current_packet;
                            DP2mem_packet_out.valid='d1;
                                nx_state = wait_stream;
                                nx_replay_Iter = nx_replay_Iter+'d1;
                                replay_iter_flag ='d1;
                                fifo_stall = 'd1;
                            end
                            else begin
                                DP2mem_packet_out = 0;
                                fifo_stall = 'd1;
                                nx_state =wait_replay_iter;
                            end
        end
        wait_stream:     begin
                            if(stream_end)begin
                                nx_state =IDLE;
                                fifo_stall = 'd0;
                                replay_iter_flag ='d0;
                            end
                            else begin
                                fifo_stall = 'd1;
                                nx_state=wait_stream;
                            end
                        end
        wait_task_complete: begin                         
                            if(vertex_done)begin
                                nx_state =wait_task_complete;
                                fifo_stall = 'd1;
                                task_complete='d1;
                                
                            end
                            else begin
                                fifo_stall = 'd1;
                                nx_state=wait_task_complete;
                            end
                        end
         default: begin
             nx_state=IDLE;
             fifo_stall=0;
             nx_Req=0;
         end
    endcase
end


endmodule
