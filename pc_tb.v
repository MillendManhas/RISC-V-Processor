
module pc_tb;

    reg clk;
    reg reset;
    reg [31:0] next_pc;
    wire [31:0] current_pc;

    integer passed = 0;
    integer failed = 0;

    pc uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    always #5 clk = ~clk;

    task check_pc;
        input [31:0] expected;
        input [8*30-1:0] test_name;
        begin
            if (current_pc === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, current_pc);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        next_pc = 0;

        // Reset should set PC to zero at a rising clock edge.
        @(posedge clk);
        #1;
        check_pc(32'd0, "Reset sets PC to zero");

        // Update PC to 4.
        reset = 0;
        next_pc = 4;
        @(posedge clk);
        #1;
        check_pc(32'd4, "PC updates to 4");

        // Update PC to 8.
        next_pc = 8;
        @(posedge clk);
        #1;
        check_pc(32'd8, "PC updates to 8");

        // Test a non-sequential target address.
        next_pc = 32'h00000100;
        @(posedge clk);
        #1;
        check_pc(32'h00000100, "PC accepts jump target");

        $display("");
        $display("==============================");
        $display("Program Counter Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("==============================");

        if (failed == 0)
            $display("ALL PC TESTS PASSED");
        else
            $display("SOME PC TESTS FAILED");

        $finish;
    end

endmodule
