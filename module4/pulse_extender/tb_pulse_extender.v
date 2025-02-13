`include "pulse_extender.v"
`default_nettype none
module tb_pulse_extender (
);
reg clock;
reg reset;
reg set;
reg [7:0] value;
wire ack;
reg i_signal;
wire o_signal;

pulse_extender DUT (
  .in_clock(clock),
  .in_reset(reset),
  .in_set(set),
  .in_value(value),
  .out_ack(ack),
  .in_signal(i_signal),
  .out_signal(o_signal)
);

localparam CLOCK_PERIOD = 10;
always #(CLOCK_PERIOD/2) clock = ~clock;

initial begin
  $monitor("Time: %0t | Clock: %b | Reset: %b | Set: %b | Out Signal: %d", 
           $time, clock, reset, set, o_signal);
  $dumpfile("tb_pulse_extender.vcd");
  $dumpvars(0, tb_pulse_extender);
  $dumpvars(1, tb_pulse_extender.DUT);
end

initial begin : SIMULATION_PROCESS
  
  #1 clock <= 0;
  // Wait for a few clock cycles
  repeat(1) @(posedge clock);
  #(CLOCK_PERIOD*3) reset <= 1;  // Assert reset
  repeat(1) @(posedge clock);
  #(CLOCK_PERIOD*3) reset <= 0;
  repeat(5) @(posedge clock);

  // test in_signal with default pulse width (1)
  repeat(1) begin
    @(posedge clock) i_signal <=1;  // Assert put on clock edge
  end
  repeat(5) begin
    @(posedge clock) i_signal <=0;  // Assert put on clock edge
  end
  // Perform write operations


  // Wait for a few clock cycles
  repeat(5) @(posedge clock);
  // End simulation
  $finish;
end

endmodule
`default_nettype wire