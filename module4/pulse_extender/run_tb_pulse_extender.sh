#!/usr/bin/env bash
source /Users/otsol/d/fpga_elec-e7555/oss-cad-suite/environment
iverilog -o pulse_extender -s tb_pulse_extender -Wall -g2005 tb_pulse_extender.v
vvp pulse_extender
gtkwave tb_pulse_extender.vcd