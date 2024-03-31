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
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoom -win $_nWave3 0.000000 131808065.607318
wvZoom -win $_nWave3 0.000000 70775788.822000
wvZoom -win $_nWave3 0.000000 40547115.156751
debExit
