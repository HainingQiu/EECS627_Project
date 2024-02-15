# make           <- runs simv (after compiling simv if needed)
# make simv      <- compile simv if needed (but do not run)
# make verdi     <- runs GUI debugger (after compiling it if needed)
# make verdi_cov <- runs Verdi in coverage mode
# make syn       <- runs syn_simv (after synthesizing if needed then 
#                                 compiling synsimv if needed)
# make clean     <- remove files created during compilations (but not synthesis)
# make nuke      <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
#

VCS = SW_VCS=2020.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 -kdb -lca -debug_access+all+reverse -cm line+cond+fsm+tgl+branch+assert

all:    simv
	./simv | tee program.out

##### 
# Modify starting here
#####

TESTBENCH = S_FV_SRAM_Integration_tb.sv
SIMFILES = BIG_FV_SRAM.v Output_BUS.sv PACKET_CNTL.sv PACKET_SRAM_integration.sv Top.sv Vertex_RS.sv vertex_buffer_one.sv edge_buffer.sv vertex_buffer.sv edge_buffer_one.sv  buffer_one.sv decoder.sv Command_FIFO.sv Big_FV_wrapper_1.sv BIg_FV_BankCntl_1.sv Big_FV_wrapper_0.sv BIg_FV_BankCntl_0.sv accu_buff.sv Weight_CNTL.sv rr_arbiter.sv Output_Bus_arbiter.sv Edge_PE.sv S_FV_SRAM_Integration.sv SMALL_FV_SRAM.v FV_MEMcntl.sv FV_BUS.sv FV_Bank_MEMCntl.sv FV_Sync_FIFO.sv  FV_Info_Integration.sv FV_info_MEMcntl.sv FV_Info_Sync_FIFO.sv FV_info_SRAM.v Neighbor_Bank_MEMCntl.sv Neighbor_BUS.sv Neighbor_Info_CNTL.sv Neighbor_Info_Integration.sv Neighbor_Info_Sync_FIFO.sv Neighbor_MEM_CNTL.sv Neighbor_Sync_FIFO.sv S_Neighbor_SRAM_Integration.sv Neighbor_Info_SRAM.v Neighbor_SRAM.v

SYNFILES = my_waveform_gen.vg  my_controller.vg DFS.vg
LIB = /afs/umich.edu/class/eecs470/lib/verilog/lec25dscc25.v


my_waveform_gen.vg:	my_waveform_gen.v my_waveform_gen.tcl 
	dc_shell-t -f my_waveform_gen.tcl | tee synth.out

my_controller.vg:	my_controller.v my_controller.tcl 
	dc_shell-t -f my_controller.tcl | tee synth.out
DFS.vg:	DFS.v DFS.tcl 
	dc_shell-t -f DFS.tcl | tee synth.out




#####
# Should be no need to modify after here
#####

simv:	$(SIMFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SIMFILES)	-o simv

novas.rc: initialnovas.rc
	sed s/UNIQNAME/$$USER/ initialnovas.rc > novas.rc

verdi:	simv novas.rc
	if [[ ! -d /tmp/$${USER}470 ]] ; then mkdir /tmp/$${USER}470 ; fi
	./simv -gui=verdi

verdi_cov:	simv
	./simv -cm line+cond+fsm+tgl+branch+assert
	./simv -gui=verdi -cov -covdir simv.vdb

syn_simv:	$(SYNFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SYNFILES) $(LIB) -o syn_simv

syn:	syn_simv
	./syn_simv | tee syn_program.out

clean:
	rm -rvf simv* *.daidir csrc vcs.key program.out \
	  syn_simv syn_simv.daidir syn_program.out \
          dve *.vpd *.vcd *.dump ucli.key \
	          DVEfiles/ vdCovLog/ verdi* novas* *fsdb*

nuke:	clean
	rm -rvf *.vg *.rep *.db *.chk *.log *.out
