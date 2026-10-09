
module immediate_gen_tb;

    reg [31:0] instruction;
    reg [2:0] imm_type;
    wire [31:0] immediate;

    immediate_gen uut (
        .instruction(instruction),
        .imm_type(imm_type),
        .immediate(immediate)
    );

    initial begin

        // I-type: immediate = 10
        instruction = 32'h00A00093;
        imm_type = 3'b000;
        #10;
        $display("I-type: immediate = %0d", $signed(immediate));

        // S-type: immediate = 8
        instruction = 32'h00502423;
        imm_type = 3'b001;
        #10;
        $display("S-type: immediate = %0d", $signed(immediate));

        // B-type: branch offset = 16
        instruction = 32'h00208863;
        imm_type = 3'b010;
        #10;
        $display("B-type: immediate = %0d", $signed(immediate));

        // U-type: upper immediate
        instruction = 32'h123450B7;
        imm_type = 3'b011;
        #10;
        $display("U-type: immediate = %h", immediate);

        // J-type: jump offset = 8
        instruction = 32'h008000EF;
        imm_type = 3'b100;
        #10;
        $display("J-type: immediate = %0d", $signed(immediate));

        $finish;
    end

endmodule
