
module register_file_tb;

    reg clk;
    reg reg_write;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;

    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    integer passed = 0;
    integer failed = 0;

    register_file uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task check_result;
        input condition;
        input [8*35-1:0] test_name;
        begin
            if (condition === 1'b1) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s", test_name);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        reg_write = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;

        // Write 100 to x5.
        @(negedge clk);
        reg_write = 1;
        rd = 5;
        write_data = 100;

        @(negedge clk);
        reg_write = 0;
        rs1 = 5;
        #1;
        check_result(read_data1 === 32'd100,
                     "Read back 100 from x5");

        // Write 200 to x10.
        @(negedge clk);
        reg_write = 1;
        rd = 10;
        write_data = 200;

        @(negedge clk);
        reg_write = 0;
        rs1 = 10;
        #1;
        check_result(read_data1 === 32'd200,
                     "Read back 200 from x10");

        // Verify two registers retain separate values.
        rs1 = 5;
        rs2 = 10;
        #1;
        check_result(read_data1 === 32'd100 &&
                     read_data2 === 32'd200,
                     "Read x5 and x10 independently");

        // Attempt to write 999 to x0.
        @(negedge clk);
        reg_write = 1;
        rd = 0;
        write_data = 999;

        @(negedge clk);
        reg_write = 0;
        rs1 = 0;
        rs2 = 0;
        #1;
        check_result(read_data1 === 32'd0 &&
                     read_data2 === 32'd0,
                     "x0 remains zero after write attempt");

        $display("");
        $display("==============================");
        $display("Register File Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("==============================");

        if (failed == 0)
            $display("ALL REGISTER FILE TESTS PASSED");
        else
            $display("SOME REGISTER FILE TESTS FAILED");

        $finish;
    end

endmodule
