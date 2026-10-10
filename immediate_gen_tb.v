
module immediate_gen_tb;

    reg [31:0] instruction;
    reg [2:0] imm_type;
    wire [31:0] immediate;

    integer passed = 0;
    integer failed = 0;

    immediate_gen uut (
        .instruction(instruction),
        .imm_type(imm_type),
        .immediate(immediate)
    );

    task check_result;
        input [31:0] expected;
        input [8*20-1:0] test_name;
        begin
            if (immediate === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, immediate);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        // I-type: immediate = 10
        instruction = 32'h00A00093;
        imm_type = 3'b000;
        #10;
        check_result(32'd10, "I-type");

        // S-type: immediate = 8
        instruction = 32'h00502423;
        imm_type = 3'b001;
        #10;
        check_result(32'd8, "S-type");

        // B-type: branch offset = 16
        instruction = 32'h00208863;
        imm_type = 3'b010;
        #10;
        check_result(32'd16, "B-type");

        // U-type: upper immediate
        instruction = 32'h123450B7;
        imm_type = 3'b011;
        #10;
        check_result(32'h12345000, "U-type");

        // J-type: jump offset = 8
        instruction = 32'h008000EF;
        imm_type = 3'b100;
        #10;
        check_result(32'd8, "J-type");

        $display("");
        $display("==============================");
        $display("Immediate Generator Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("==============================");

        if (failed == 0)
            $display("ALL IMMEDIATE TESTS PASSED");
        else
            $display("SOME IMMEDIATE TESTS FAILED");

        $finish;
    end

endmodule
