module mux32 (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sel,
    output wire [31:0] y
);

    assign y = sel ? b : a;

endmodule