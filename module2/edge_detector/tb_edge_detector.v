//
// Assuming that this file is saved as "tb_edge_detector.v" and edge_detector is saved in "edge_detector.v".
//
// iverilog -o edge_detector -s tb_edge_detector -Wall -g2005 tb_edge_detector.v edge_detector.v
//
// vvp edge_detector
//
// gtkwave tb_edge_detector.vcd
//

//`timescale 1ns / 1ps // If "edge_detector.v" has timescale, uncomment this line

module tb_edge_detector();
    reg clock = 1;
    reg tb_in_signal;
    wire tb_out_strobe;

    // clock 'loop', T=4
    always #1 clock <= !clock;

    initial begin
        tb_in_signal = 0;

        $monitor("%g\t %b   %b %b", $time, clock,
            tb_in_signal, tb_out_strobe);
        $dumpfile("tb_edge_detector.vcd");
        $dumpvars(0,tb_edge_detector);
        $display("time\t in_clk in_sig out_strobe");

        #2
        tb_in_signal = 1;

        #2
        tb_in_signal = 0;
        #8
        tb_in_signal = 1;
        #4
        tb_in_signal = 0;
        #8
        
        #10
        $finish;
    end

    edge_detector DUT(
    .in_clock(clock),
    .in_signal(tb_in_signal),
    .out_strobe(tb_out_strobe)
        );
endmodule

