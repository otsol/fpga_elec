module edge_detector (
    input wire in_clock,
    input wire in_signal,
    output reg out_strobe
);
    // reg last_signal;
    reg last_strobe = 1;
    reg tmp;
    always @(*) begin
        // tmp = in_signal & ~last_signal & ~last_strobe;
        tmp = in_signal & ~last_strobe;
        last_strobe = 0;
    end
    always @(posedge in_clock) begin
        out_strobe <= tmp;
        last_strobe <= 1;
        // last_signal <= in_signal;
    end
endmodule