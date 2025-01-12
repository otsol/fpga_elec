//
// Assuming that this file is saved as "tb_decoder.v" and decoder is saved in "decoder.v".
//
// iverilog -o decoder -s tb_decoder -Wall -g2005 tb_decoder.v decoder.v
//
// vvp decoder
//
// gtkwave tb_decoder.vcd
//

//`timescale 1ns / 1ps // If "decoder.v" has timescale, uncomment this line

module tb_decoder();
    parameter NUM_OUTPUT = 4;
    reg [$clog2(NUM_OUTPUT)-1:0] tb_in0;
    wire [NUM_OUTPUT-1:0] tb_out0;
    wire tb_out1;

    initial begin
        tb_in0 = 2'b01;

        $monitor("%g\t %b   %b %b", $time, tb_in0,
            tb_out0, tb_out1);
        $dumpfile("tb_decoder.vcd");
        $dumpvars(0,tb_decoder);
        $display("time\t in0 out0 out_error");

        #2
        tb_in0 = 2'b10;

        #2
        tb_in0 = 2'b11;

        #2
        tb_in0 = 1'b0;

        #2
        tb_in0 = 1'b0;

        #10 $finish;
    end

    decoder DUT(
    .in_address(tb_in0),
    .out_select(tb_out0),
    .out_error(tb_out1)
        );
endmodule