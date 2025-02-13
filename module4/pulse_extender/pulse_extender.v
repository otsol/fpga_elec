module pulse_extender (
  input wire in_clock,
  input wire in_reset,
  input wire in_set,
  input wire [7:0] in_value,
  output reg out_ack,
  input wire in_signal,
  output reg out_signal
);
  reg [7:0] repetition_memory;
  reg flag;
  reg [7:0] pulse_width;

  always @(posedge in_clock) begin
    // handle the reset
    if (in_reset) begin
      pulse_width <= 1;
      out_ack <= 0;
      flag <=0;
      repetition_memory <= 0;
      out_signal <= 0;
      
    end else begin
      // setting the pulse width in this else block
      if (in_set) begin
        pulse_width <= in_value;
        out_ack <= 1;
      end else begin
        out_ack <= 0;
      end
      
      // pulse extension
      if (in_signal) begin
        // when a signal is detect immediately output a response  

        // case 1: 
        // start the counter if it is NOT running already
        // also set out_signal to 1
        if (repetition_memory == 0) begin 
          repetition_memory <= 1;
          out_signal <= 1;
          // flag <=1;
        // case 2: the counter is running but has not reached the target width
        end else if (repetition_memory < pulse_width) begin
          repetition_memory = repetition_memory + 1;
        // case 3: the pulse width has been reached
        end else begin
          if (!in_signal) begin
            out_signal <= 0;
            repetition_memory <= 0;
          end
        end
      end
      
      // if (flag) begin
      //   // increment the counter until N width has been achieved
        
      // end

    end

  end
endmodule