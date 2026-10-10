
module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_ctrl;

    wire [31:0] result;

    integer passed = 0;
    integer failed = 0;

    alu uut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result)
    );

    task check_result;
        input [31:0] expected;
        input [160*8-1:0] test_name;
        begin
            if (result === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, result);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        // ADD: 10 + 5 = 15
        a = 10; b = 5; alu_ctrl = 4'b0000;
        #10;
        check_result(32'd15, "ADD");

        // SUB: 10 - 5 = 5
        a = 10; b = 5; alu_ctrl = 4'b0001;
        #10;
        check_result(32'd5, "SUB");

        // AND: 1010 & 0101 = 0000
        a = 10; b = 5; alu_ctrl = 4'b0010;
        #10;
        check_result(32'd0, "AND");

        // OR: 1010 | 0101 = 1111
        a = 10; b = 5; alu_ctrl = 4'b0011;
        #10;
        check_result(32'd15, "OR");

        // XOR: 1010 ^ 0101 = 1111
        a = 10; b = 5; alu_ctrl = 4'b0100;
        #10;
        check_result(32'd15, "XOR");

        // SLL: 8 << 2 = 32
        a = 8; b = 2; alu_ctrl = 4'b0101;
        #10;
        check_result(32'd32, "SLL");

        // SRL: 8 >> 2 = 2
        a = 8; b = 2; alu_ctrl = 4'b0110;
        #10;
        check_result(32'd2, "SRL");

        // SRA: arithmetic right shift of positive 8
        a = 8; b = 2; alu_ctrl = 4'b0111;
        #10;
        check_result(32'd2, "SRA");

        // SLT: 10 < 20 is true
        a = 10; b = 20; alu_ctrl = 4'b1000;
        #10;
        check_result(32'd1, "SLT");

        // SLTU: 10 < 20 is true (unsigned)
        a = 10; b = 20; alu_ctrl = 4'b1001;
        #10;
        check_result(32'd1, "SLTU");

        $display("");
        $display("==============================");
        $display("ALU Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("==============================");

        if (failed == 0)
            $display("ALL ALU TESTS PASSED");
        else
            $display("SOME ALU TESTS FAILED");

        $finish;
    end

endmodule
