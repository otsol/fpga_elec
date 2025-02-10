`include "fifo_controller.v"

module fifo #(
  parameter DATA_WIDTH = 8,
  parameter FIFO_ASIZE = 4
) (
  input wire in_clock,
  input wire in_reset,
  input wire in_take,
  input wire in_put,
  output wire out_empty,
  output wire out_full,
  output wire [DATA_WIDTH-1:0] out_data,
  input wire [DATA_WIDTH-1:0] in_data
);
// initialize the fifo_controller
wire [FIFO_ASIZE-1:0] out_write_pointer;
wire [FIFO_ASIZE-1:0] out_read_pointer;

fifo_controller #(
 .FIFO_ASIZE(FIFO_ASIZE)
) fifo_c (
  .in_clock(in_clock),
  .in_reset(in_reset),
  .in_take(in_take),
  .in_put(in_put),
  .out_empty(out_empty),
  .out_full(out_full),
  .out_write_pointer(out_write_pointer),
  .out_read_pointer(out_read_pointer)
);

// initialize the memory logic, must use combinatorial logic for speed
reg [DATA_WIDTH-1:0] memory [0:(1 << FIFO_ASIZE)-1];
assign out_data = memory[out_read_pointer];

always @(*) begin
  memory[out_write_pointer] = in_data;
end

endmodule