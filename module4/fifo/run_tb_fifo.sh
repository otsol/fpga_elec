#!/usr/bin/env bash
source /Users/otsol/d/fpga_elec-e7555/oss-cad-suite/environment
iverilog -o fifo -s tb_fifo -Wall -g2005 tb_fifo.v
vvp fifo
gtkwave tb_fifo.vcd