`include "picobus_wishbone_bridge.v"
`timescale 1ns/1ps

module tb_picobus_wishbone_bridge;
  reg in_clock;
  reg in_reset;
  reg in_pico_valid;
  reg [31:0] in_pico_address;
  reg [3:0] in_pico_wstrobe;
  reg [31:0] in_pico_wdata;
  wire out_pico_ready;
  wire out_pico_error;
  wire [31:0] out_pico_rdata;
  wire out_wb_cyc;
  wire out_wb_stb;
  wire out_wb_we;
  wire [21:0] out_wb_adr;
  wire [3:0] out_wb_sel;
  wire [31:0] out_wb_wdat;
  reg in_wb_ack;
  reg in_wb_err;
  reg [31:0] in_wb_rdat;

  picobus_wishbone_bridge DUT (
                            .in_clock(in_clock),
                            .in_reset(in_reset),
                            .in_pico_valid(in_pico_valid),
                            .in_pico_address(in_pico_address),
                            .in_pico_wstrobe(in_pico_wstrobe),
                            .in_pico_wdata(in_pico_wdata),
                            .out_pico_ready(out_pico_ready),
                            .out_pico_error(out_pico_error),
                            .out_pico_rdata(out_pico_rdata),
                            .out_wb_cyc(out_wb_cyc),
                            .out_wb_stb(out_wb_stb),
                            .out_wb_we(out_wb_we),
                            .out_wb_adr(out_wb_adr),
                            .out_wb_sel(out_wb_sel),
                            .out_wb_wdat(out_wb_wdat),
                            .in_wb_ack(in_wb_ack),
                            .in_wb_err(in_wb_err),
                            .in_wb_rdat(in_wb_rdat)
                          );

  // Clock generation
  localparam CLK_P = 10;
  always #(CLK_P/2) in_clock = ~in_clock;

  initial
  begin
    in_clock = 0;
    in_reset = 1;


    repeat (2) @(posedge in_clock);
    in_reset = 0;
    in_pico_valid = 0;
    repeat (2) @(posedge in_clock);
    in_pico_valid = 1;
    in_pico_address = 32'h45000024;
    in_pico_wstrobe = 4'b0;

    repeat (2) @(posedge in_clock);
    in_wb_err = 1;
    repeat (1) @(posedge in_clock);
    in_wb_err = 0;
    repeat (1) @(posedge in_clock);
    in_pico_valid = 0;
    repeat (1) @(posedge in_clock);
    in_pico_valid = 1;
    in_pico_address = 32'h45AA0024;
    in_pico_wstrobe = 4'b0;

    repeat (3) @(posedge in_clock);
    in_wb_ack = 1;
    in_wb_rdat = 32'hDAFA;
    repeat (1) @(posedge in_clock);
    in_wb_ack = 0;
    repeat (1) @(posedge in_clock);
    in_pico_valid = 0;
    repeat (1) @(posedge in_clock);


    // WRITE TEST
    repeat (1) @(posedge in_clock);
    in_pico_valid = 1;
    in_pico_address = 32'h45000024;
    in_pico_wstrobe = 4'b1111;
    in_pico_wdata = 32'hDAFA;

    repeat (2) @(posedge in_clock);
    in_wb_err = 1;
    repeat (1) @(posedge in_clock);
    in_wb_err = 0;
    
    repeat (1) @(posedge in_clock);
    in_pico_valid = 0;
    repeat (1) @(posedge in_clock);
    in_pico_valid = 1;
    in_pico_address = 32'h45AA0024;
    in_pico_wstrobe = 4'b0011;

    repeat (3) @(posedge in_clock);
    in_wb_ack = 1;
    in_wb_rdat = 32'hDAFA;
    repeat (1) @(posedge in_clock);
    in_wb_ack = 0;
    repeat (1) @(posedge in_clock);
    in_pico_valid = 0;
    repeat (1) @(posedge in_clock);





    // End simulation
    $finish;
  end

  initial
  begin
    $dumpfile("tb_picobus_wishbone_bridge.vcd");
    $dumpvars(0, tb_picobus_wishbone_bridge);
  end

endmodule
