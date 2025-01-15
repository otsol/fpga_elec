// iverilog -o edge_detector -s tb_edge_detector -Wall -g2005 tb_edge_detector.v edge_detector.v

module tb_edge_detector;

    // Testbench signals
    reg in_clock;
    reg in_signal;
    wire out_strobe;

    // Instantiate the edge_detector module
    edge_detector uut (
        .in_clock(in_clock),
        .in_signal(in_signal),
        .out_strobe(out_strobe)
    );

    // Clock generation: toggles every 5 time units (period = 10)
    always begin
        #5 in_clock = ~in_clock;
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        in_clock = 0;    // Start with clock low
        in_signal = 0;   // Start with signal low

        // Wait for a few clock cycles and apply stimulus
        #10;             // Wait for 10 time units
        in_signal = 1;   // Trigger a rising edge on in_signal
        #10;             // Wait for another clock cycle
        in_signal = 0;   // Trigger a falling edge on in_signal
        #10;             // Wait for another clock cycle
        in_signal = 1;   // Trigger another rising edge on in_signal
        #10;             // Wait for another clock cycle

        // End simulation
        #20;
        $finish;
    end

    // Monitor the signals for debugging
    initial begin
        $monitor("Time: %0t | Clock: %b | Signal: %b | Out Strobe: %b", 
                 $time, in_clock, in_signal, out_strobe);
        $dumpfile("tb_edge_detector.vcd");
        $dumpvars(0,tb_edge_detector);
    end
endmodule