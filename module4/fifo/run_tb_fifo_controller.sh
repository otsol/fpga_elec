#!/usr/bin/env bash
source /Users/otsol/d/fpga_elec-e7555/oss-cad-suite/environment
iverilog -o fifo_controller -s tb_fifo_controller -Wall -g2005 tb_fifo_controller.v
vvp fifo_controller
gtkwave tb_fifo_controller.vcd