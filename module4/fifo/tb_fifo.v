`include "fifo.v"
`default_nettype none

module tb_fifo;
parameter DATA_WIDTH = 8;
parameter FIFO_ASIZE = 4;
reg clk;
reg rst_n;
reg take;
reg put;
wire o_empty;
wire o_full;
wire [DATA_WIDTH-1:0] o_data;
wire [DATA_WIDTH-1:0] i_data;
// wire [FIFO_ASIZE-1:0] o_write_pointer;
// wire [FIFO_ASIZE-1:0] o_read_pointer;

fifo DUT
(
  .in_clock(clk),
  .in_reset(rst_n),
  .in_take(take),
  .in_put(put),
  .out_empty(o_empty),
  .out_full(o_full),
  .out_data(o_data),
  .in_data(i_data)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
  $dumpfile("tb_fifo.vcd");
  $dumpvars(0, tb_fifo);
  $dumpvars(1, tb_fifo.DUT);
end

reg [1:0] input_value = 3;
assign i_data = input_value;
initial begin : SIMULATTION_PROCESS
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

 // =========
  // = Tasks =
  // =========

// task t_INITIALIZATION(// some configure arguments);
// // ... set configuration
// endtask


endmodule
`default_nettype wire