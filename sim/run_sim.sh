#!/bin/bash
set -e
mkdir -p sim
iverilog -g2012 -o sim/vvp rtl/counter.v tb/tb_counter.v
vvp sim/vvp
echo "Simulation finished. Waveform at sim/waveform.vcd"
