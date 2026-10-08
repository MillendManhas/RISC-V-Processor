module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_ctrl;

    wire [31:0] result;

    alu uut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result)
    );

    initial begin

        $monitor("a=%d b=%d ctrl=%b result=%d",
                 a, b, alu_ctrl, result);

        // ADD
        a = 10;
        b = 5;
        alu_ctrl = 4'b0000;
        #10;

        // SUB
        a = 10;
        b = 5;
        alu_ctrl = 4'b0001;
        #10;

        // AND
        a = 10;
        b = 5;
        alu_ctrl = 4'b0010;
        #10;

        // OR
        a = 10;
        b = 5;
        alu_ctrl = 4'b0011;
        #10;

        // XOR
        a = 10;
        b = 5;
        alu_ctrl = 4'b0100;
        #10;

        // SLL
        a = 8;
        b = 2;
        alu_ctrl = 4'b0101;
        #10;

        // SRL
        a = 8;
        b = 2;
        alu_ctrl = 4'b0110;
        #10;

        // SRA
        a = 8;
        b = 2;
        alu_ctrl = 4'b0111;
        #10;

        // SLT
        a = 10;
        b = 20;
        alu_ctrl = 4'b1000;
        #10;

        // SLTU
        a = 10;
        b = 20;
        alu_ctrl = 4'b1001;
        #10;

        $finish;

    end

endmodule