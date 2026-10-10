
module mux_tb;

    reg a;
    reg b;
    reg sel;
    wire y;

    integer passed = 0;
    integer failed = 0;

    mux uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task check_result;
        input expected;
        input [8*20-1:0] test_name;
        begin
            if (y === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%b Actual=%b",
                         test_name, expected, y);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        // sel=0 selects a
        a = 0; b = 1; sel = 0;
        #10;
        check_result(0, "Select a when a=0");

        // sel=1 selects b
        sel = 1;
        #10;
        check_result(1, "Select b when b=1");

        // sel=0 selects a
        a = 1; b = 0; sel = 0;
        #10;
        check_result(1, "Select a when a=1");

        // sel=1 selects b
        sel = 1;
        #10;
        check_result(0, "Select b when b=0");

        $display("");
        $display("==============================");
        $display("Multiplexer Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("==============================");

        if (failed == 0)
            $display("ALL MUX TESTS PASSED");
        else
            $display("SOME MUX TESTS FAILED");

        $finish;
    end

endmodule
