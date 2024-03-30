simSetSimulator "-vcssv" -exec "./simv" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
srcDeselectAll -win $_nTrace1
wvCreateWindow
wvDrop -win $_nWave3
wvRestoreSignal -win $_nWave3 "/home/zzyyds/EECS627_Project/P5_SPI/signal.rc" \
           -overWriteAutoAlias on -appendSignals on
srcTBRunSim
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvScrollUp -win $_nWave3 9
wvScrollUp -win $_nWave3 9
wvScrollUp -win $_nWave3 63
wvScrollDown -win $_nWave3 13
wvSelectSignal -win $_nWave3 {( "PACKET_SRAM_integration_U" 28 )} 
debExit
