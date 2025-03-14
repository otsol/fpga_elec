module axi_stream_pwm (
  input wire in_clock,
  input wire in_reset,
  input wire in_valid,
  input wire [4:0] in_data,
  output reg out_ready,
  output reg out_data
);
  // memory for asserting out_data for N cycles
  reg [4:0] counter1;
  // memory for counting 32 cycles
  reg [4:0] counter31;
  always @(posedge in_clock) begin
    if (in_reset) begin
      out_ready <= 1;
      out_data <= 0;
    end else begin
      if (in_valid && out_ready) begin
        out_ready <= 0;
        counter1 <= in_data;
        counter31 <= 31;
        if (in_data != 0)
          out_data <= 1;
      end else if (counter31 > 0) begin
        counter31 <= counter31 - 1;
        counter1 <= counter1 - 1;
        // deassert out_data after N cycles, then repeat 0 until
        // 32 cycles have been reached
        if (counter1 == 1) begin
          out_data <= 0;
        end
        if (counter31 == 1) begin
          out_data <= 0;
          out_ready <= 1;
          
        end

      end
    end
      
  end
endmodule