module picobus_wishbone_bridge (
    input wire in_clock,
    input wire in_reset,
    input wire in_pico_valid,
    input wire [31:0] in_pico_address,
    input wire [3:0] in_pico_wstrobe,
    input wire [31:0] in_pico_wdata,
    output reg out_pico_ready,
    output reg out_pico_error,
    output reg [31:0] out_pico_rdata,
    output reg out_wb_cyc,
    output reg out_wb_stb,
    output reg out_wb_we,
    output reg [21:0] out_wb_adr,
    output reg [3:0] out_wb_sel,
    output reg [31:0] out_wb_wdat,
    input wire in_wb_ack,
    input wire in_wb_err,
    input wire [31:0] in_wb_rdat
  );


  localparam
    s_IDLE = 0,
    s_READ = 1,
    s_READY = 2,
    s_ERROR = 3,
    s_WRITE = 4;

  reg [3:0] state, next_state;

  always @(*)
  begin
    case (state)
      s_IDLE:
        if (in_pico_wstrobe == 4'b0000 && in_pico_valid == 1'b1 && in_pico_address[31:24] == 8'b01000101)
          next_state = s_READ;
        else if (in_pico_wstrobe != 4'b0000 && in_pico_valid == 1'b1 && in_pico_address[31:24] == 8'b01000101)
          next_state = s_WRITE;
        else
          next_state = s_IDLE;
      s_READ:
        if (in_wb_ack)
          next_state = s_READY;
        else if (in_wb_err)
          next_state = s_ERROR;
        else
          next_state = s_READ;
      s_WRITE:
        if (in_wb_ack)
          next_state = s_READY;
        else if (in_wb_err)
          next_state = s_ERROR;
        else
          next_state = s_WRITE;
      s_READY:
        next_state = s_IDLE;
      s_ERROR:
        next_state = s_IDLE;
      default:
        next_state = s_IDLE;
    endcase
  end

  always @(posedge in_clock)
  begin
    if (in_reset)
    begin
      out_wb_cyc <= 0;
      out_wb_stb <= 0;
      out_pico_ready <= 0;
      state <= s_IDLE;
      out_pico_error <= 0;
    end
    else
    begin
      state <= next_state;
      case (next_state)
        s_IDLE:
        begin
          out_pico_ready <= 0;
          out_pico_error <= 0;
          out_wb_cyc <= 0;
        end
        s_READ:
        begin
          out_wb_cyc <= 1;
          out_wb_stb <= 1;
          out_wb_we <= 0;
          out_wb_adr <= in_pico_address[23:2];
          out_wb_sel <= 4'b1111;
        end
        s_WRITE:
          begin
            out_wb_cyc <= 1;
            out_wb_stb <= 1;
            out_wb_we <= 1;
            out_wb_adr <= in_pico_address[23:2];
            out_wb_sel <= in_pico_wstrobe;
            out_wb_wdat <= in_pico_wdata;
          end
        s_READY:
        begin
          out_wb_cyc <= 0;
          out_wb_stb <= 0;
          out_pico_ready <= 1;
          out_pico_error <= 0;
          out_pico_rdata <= in_wb_rdat;
        end
        s_ERROR:
        begin
          out_wb_cyc <= 0;
          out_wb_stb <= 0;
          out_pico_ready <= 1;
          out_pico_error <= 1;
        end
        default:
          ;
      endcase
    end
  end

endmodule
