# counter-simple

Proyecto didáctico: **contador parametrizable** en Verilog.

## Qué incluye
- rtl/counter.v  — contador simple
- tb/tb_counter.v — testbench (iverilog)
- sim/run_sim.sh — script para simular
- Makefile — targets: sim, clean

## Cómo simular localmente (WSL)
1. Instalar iverilog: sudo apt update && sudo apt install -y iverilog
2. Ejecutar: make sim
3. Resultado: sim/waveform.vcd (abrir con GTKWave o descargar como artifact en CI)

## Siguientes pasos sugeridos
- Añadir assertions / cobertura
- Integrarlo en OpenLane (openlane/ config.tcl) para llevar el bloque a PnR
- Documentar y publicar en GitHub

