SIM=iverilog

.PHONY: all sim clean

all: sim

sim:
\t./sim/run_sim.sh

verilate:
\t# optional: if you want to use Verilator, implement commands here
\t@echo "Verilate target (optional)"

clean:
\trm -rf sim/*.vcd sim/vvp
