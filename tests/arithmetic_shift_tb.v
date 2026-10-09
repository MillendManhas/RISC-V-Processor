
`timescale 1ns/1ps

module arithmetic_shift_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        // x1 = -8, x2 = 2
        dut.imem[0] = 32'hFF800093; // ADDI x1, x0, -8
        dut.imem[1] = 32'h00200113; // ADDI x2, x0, 2

        dut.imem[2] = 32'h002081B3; // ADD x3, x1, x2 = -6
        dut.imem[3] = 32'h40208233; // SUB x4, x1, x2 = -10

        // Right shifts of -8 by 2 bits
        dut.imem[4] = 32'h0020D293; // SRLI x5, x1, 2
        dut.imem[5] = 32'h4020D313; // SRAI x6, x1, 2

        #12;
        reset = 0;
        #70;

        $display("ADD  = %h", dut.x[3]);
        $display("SUB  = %h", dut.x[4]);
        $display("SRLI = %h", dut.x[5]);
        $display("SRAI = %h", dut.x[6]);

        if (dut.x[3] === 32'hFFFFFFFA)
            $display("PASS: ADD");
        else begin
            $display("FAIL: ADD");
            errors = errors + 1;
        end

        if (dut.x[4] === 32'hFFFFFFF6)
            $display("PASS: SUB");
        else begin
            $display("FAIL: SUB");
            errors = errors + 1;
        end

        if (dut.x[5] === 32'h3FFFFFFE)
            $display("PASS: SRLI");
        else begin
            $display("FAIL: SRLI");
            errors = errors + 1;
        end

        if (dut.x[6] === 32'hFFFFFFFE)
            $display("PASS: SRAI");
        else begin
            $display("FAIL: SRAI");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL ARITHMETIC AND SHIFT TESTS PASSED");
        else
            $display("FAILURES: %0d", errors);

        $finish;
    end

endmodule
