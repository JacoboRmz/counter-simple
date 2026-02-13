SIM=iverilog

.PHONY: all sim clean

all: sim

sim:
	./sim/run_sim.sh

clean:
	rm -rf sim/*.vcd sim/vvp

