module wishbone_register #(
    parameter INITIAL_VALUE = 0,
    parameter READ_ONLY_BITS = 0,
    parameter LIVE_BITS = 0
  ) (
    input wire in_clock,
    input wire in_reset,
    input wire in_wb_cyc,
    input wire in_wb_stb,
    input wire in_wb_we,
    input wire [3:0] in_wb_sel,
    input wire [31:0] in_wb_dat,
    output reg out_wb_ack,
    output reg [31:0] out_wb_dat,
    output reg [31:0] out_contents,
    input wire [31:0] in_live_value
  );

  localparam
    s_IDLE = 0,
    s_ACK = 1,
    s_ACK_OFF = 2,
    s_READ1 = 3,
    s_READ2 = 4;

  //internal state
  reg [2:0] state, next_state;

  reg [31:0] in_data_selected;
  integer i;
  always @(*)
  begin
    in_data_selected = 0; // Start with 0
    for (i = 0; i < 4; i = i + 1)
    begin
      if (in_wb_sel[i])
      begin
        in_data_selected[i*8 +: 8] = in_wb_dat[i*8 +: 8]; // Select byte using indexed part-select
      end
    end
  end
  //
  reg [31:0] store;
  reg [31:0] store2;
  reg [31:0] store3;
  always @(*)
  begin
    if (!in_wb_cyc)
      out_wb_dat = 0;
    else
      out_wb_dat = ~READ_ONLY_BITS & store;

    case (state)
      s_IDLE:
        if (in_wb_cyc && in_wb_stb && in_wb_we)
          next_state = s_ACK;
        else if (in_wb_cyc && in_wb_stb && !in_wb_we)
          next_state = s_READ1;
        else
          next_state = s_IDLE;
      s_ACK:
        next_state = s_ACK_OFF;
      s_ACK_OFF:
        next_state = s_IDLE;
      s_READ1:
        next_state = s_READ2;
      s_READ2:
        next_state = s_IDLE;
      default:
        next_state = s_IDLE;
    endcase
  end

  always @(posedge in_clock)
  begin
    if (in_reset)
    begin
      out_wb_ack <= 0;
      out_contents <= INITIAL_VALUE;
      state <= s_IDLE;
      store3 <= READ_ONLY_BITS;
    end
    else
    begin
      state <= next_state;
      case (next_state)
        s_ACK:
        begin
          out_wb_ack <= 1;
          //store3 <= READ_ONLY_BITS;
          out_contents <= (~READ_ONLY_BITS & in_data_selected) | (READ_ONLY_BITS & INITIAL_VALUE);
          //out_contents <= (~READ_ONLY_BITS & in_data_selected) | (store3 & INITIAL_VALUE);

        end
        s_ACK_OFF:
          out_wb_ack <= 0;
        s_READ1:
        begin
          out_wb_ack <= 1;
          //out_wb_dat <= (in_live_value & LIVE_BITS) & out_contents;
          store2 <= in_live_value & LIVE_BITS;
          store <= (in_live_value & LIVE_BITS) | (~LIVE_BITS & out_contents);
        end
        s_READ2:
        begin
          // change the value of out_wb_dat with this
          out_wb_ack <= 0;
          store <= 0;
        end
      endcase
    end
  end

endmodule
