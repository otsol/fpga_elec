`include "fifo_controller.v"
`default_nettype none

module tb_fifo_controller;
  parameter FIFO_ASIZE = 4;
  reg clk;
  reg rst_n;
  reg take;
  reg put;
  wire o_empty;
  wire o_full;
  wire [FIFO_ASIZE-1:0] o_write_pointer;
  wire [FIFO_ASIZE-1:0] o_read_pointer;

  fifo_controller DUT (
    .in_clock(clk),
    .in_reset(rst_n),
    .in_take(take),
    .in_put(put),
    .out_empty(o_empty),
    .out_full(o_full),
    .out_write_pointer(o_write_pointer),
    .out_read_pointer(o_read_pointer)
  );

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;

  initial begin
    $monitor("Time: %0t | Clock: %b | Reset: %b | Full: %b | Empty: %d", 
             $time, clk, rst_n, o_full, o_empty);
    $dumpfile("tb_fifo_controller.vcd");
    $dumpvars(0, tb_fifo_controller);
    $dumpvars(1, tb_fifo_controller.DUT);
  end

  initial begin : SIMULATION_PROCESS
    // Initialize inputs
    #1 rst_n <= 1'bx; clk <= 1'bx;
    take <= 0;
    put <= 0;

    // Apply reset
    #(CLK_PERIOD*3) rst_n <= 1;  // Assert reset
    #(CLK_PERIOD*3) rst_n <= 0;  // Deassert reset
    clk <= 0;

    // Wait for a few clock cycles
    repeat(1) @(posedge clk);
    #(CLK_PERIOD*3) rst_n <= 1;  // Assert reset
    repeat(1) @(posedge clk);
    #(CLK_PERIOD*3) rst_n <= 0;
    repeat(5) @(posedge clk);
    // Perform write operations
    repeat(5) begin
      @(posedge clk) put <= 1;  // Assert put on clock edge
      @(posedge clk) put <= 0;  // Deassert put on next clock edge
    end

    // Wait for a few clock cycles
    repeat(5) @(posedge clk);

    // Perform read operations
    repeat(2) begin
      @(posedge clk) take <= 1;  // Assert take on clock edge
      @(posedge clk) take <= 0;  // Deassert take on next clock edge
    end
    repeat(20) begin
      @(posedge clk) put <= 1;  // Assert put on clock edge
      // @(posedge clk) put <= 0;  // Deassert put on next clock edge
    end

    // Wait for a few clock cycles
    repeat(5) @(posedge clk);

    // End simulation
    $finish;
  end
endmodule
`default_nettype wire