module wishbone_peripheral_from_axi #(
  parameter DATA_WIDTH = 8
) (

input wire in_clock,
input wire in_reset,
input wire in_wb_cyc,
input wire in_wb_stb,
input wire in_wb_we,
input wire [((DATA_WIDTH/8)-1):0] in_wb_sel,
output reg out_wb_ack,
output reg out_wb_err,
output reg [DATA_WIDTH-1:0] out_wb_dat,
input wire in_sink_valid,
output reg out_sink_ready,
input wire [DATA_WIDTH-1:0] in_sink_data
);

  // check that the parameter DATA_WIDTH is a multiple of 8. If it is not,
  // the simulation / synthesis fill fail.
  initial if ((DATA_WIDTH % 8) != 0) begin 
    $error("[ERROR] DATA_WIDTH is invalid length!"); $finish; end

  // internal states
  localparam
    s_IDLE = 0,
    s_ERROR = 1,
    s_ERROR2 = 2,
    s_SINK = 3,
    s_READ = 4,
    s_READ2 = 5;

   // internal state
  reg [4:0] state = s_IDLE, next_state;


  // all bits are ones - check
  wire all_ones;
  assign all_ones = &in_wb_sel;

  reg [DATA_WIDTH-1:0] save_last_in_sink_data;

  always @(*) begin
    case (state)
      s_IDLE:   if(in_wb_cyc && in_wb_stb && in_wb_we) next_state = s_ERROR; // trying to write -> error
                // command is read AND all bits in in_wb_sel are 1s
                else if (in_wb_cyc && in_wb_stb && !in_wb_we && all_ones) next_state = s_SINK;
                // command is read and some bits are 0s -> results in error
                else if (in_wb_cyc && in_wb_stb && !in_wb_we && !all_ones) next_state = s_ERROR;
                else next_state = s_IDLE;
      s_ERROR:  next_state = s_ERROR2;
      s_ERROR2: next_state = s_IDLE;
      s_SINK:   if (in_sink_valid) next_state <= s_READ;
                else next_state <= s_SINK;
      s_READ:   begin 
                  next_state = s_READ2;
                  out_wb_dat = save_last_in_sink_data;
                  // out_wb_dat = in_sink_data;

      end
      s_READ2:  next_state = s_IDLE;
      default:  next_state = s_IDLE;
    endcase 
    // set out_wb_dat to zero when deasserted
    if (!in_wb_cyc) out_wb_dat = 0;
  end

always @(posedge in_clock) begin
  save_last_in_sink_data <= in_sink_data;
  if (in_reset) begin
    out_wb_ack <= 1'b0;
    out_wb_err <= 1'b0;
    out_sink_ready <= 1'b0;
    state <= s_IDLE;
  end else begin
    state <= next_state;
    case (next_state)
      s_ERROR:  out_wb_err <= 1'b1;
      s_ERROR2: out_wb_err <= 1'b0;
      s_SINK:   begin
        out_sink_ready <= 1'b1;
      end
      s_READ:   begin
        out_sink_ready <= 1'b0;
        out_wb_ack <= 1'b1;
      end
      s_READ2:  out_wb_ack <= 1'b0;
    endcase
  end
end

endmodule