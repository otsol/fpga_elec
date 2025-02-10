module fifo_controller #(
  parameter FIFO_ASIZE = 4
) (
  input wire in_clock,
  input wire in_reset,
  input wire in_take,
  input wire in_put,
  output reg out_empty,
  output reg out_full,
  output reg [FIFO_ASIZE-1:0] out_write_pointer,
  output reg [FIFO_ASIZE-1:0] out_read_pointer
);
  // size of out_write pointer + 1
  reg [FIFO_ASIZE:0] read_counter, write_counter;
  always @(*) begin
    out_full = (out_write_pointer === out_read_pointer) && !out_empty;
    out_write_pointer = write_counter[FIFO_ASIZE-1:0];
    out_read_pointer = read_counter[FIFO_ASIZE-1:0];
  end
  
  always @(posedge in_clock) begin
    if (in_reset) begin
      // check reset
      // set pointers to the same location
      read_counter <= 0;
      write_counter <= 0;
      
      out_empty <= 1;
      out_full <= 0;
    end else begin
      
      if (in_put) begin
        // check if full
        if (!out_full) begin
          // out_write_pointer <= out_write_pointer + 1;
          write_counter <= write_counter + 1;
          out_empty <= 0;
        end
        
      end
  
      if (in_take) begin
        if (!out_empty) begin
          // out_read_pointer <= out_read_pointer + 1;
          read_counter <= read_counter + 1;
        end
      end
    end
    

  end
endmodule
