module decoder #(
    parameter NUM_OUTPUT = 4
) (
    input wire [$clog2(NUM_OUTPUT)-1:0] in_address,
    output wire [NUM_OUTPUT-1:0] out_select,
    output wire out_error
);
    //assign out_select = 0;
    wire [NUM_OUTPUT-1:0] tmp = 4'b0001; // muista laittaa leveys eli koko
                                         // 4'b0001 on visualisointia varten
                                         // koko voi olla isompi kuin 4
    assign out_select = tmp << in_address;
    //assign out_select = tmp2;


    // assign tmp[1:0] = in_address & 2'b01;
    // assign tmp[3:2] = in_address & 2'b01;
    
    // assign out_select[1:0] = in_address & 2'b01;
    // assign out_select[3:2] = in_address & 2'b01;
    // assign out_select[1:0] = in_address[1] ? tmp[1:0] & 2'b00 : tmp[1:0] & 2'b11;
    //assign out_select[1:0] = in_address[1] ? 2'b00 : 2'b11;
    // assign out_select[3:2] = in_address[1] ? tmp[1:0] & 2'b11 : tmp[1:0] & 2'b00;
    //in_address[1] ? 2'b11 : 2'b00;
    // assign out_select[1] = in_address[1];
    // assign out_select[3] = in_address[1];
    // assign out_select[0] = 1;
    // assign out_select[2] = 0;
    // assign out_select[1] = 0;
    // assign out_select[3] = 0;

    assign out_error = (in_address >= NUM_OUTPUT) | (in_address < 0);

    
endmodule