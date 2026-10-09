
`timescale 1ns/1ps

module compare_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        dut.imem[0] = 32'hFFF00093; // ADDI x1, x0, -1
        dut.imem[1] = 32'h00100113; // ADDI x2, x0, 1
        dut.imem[2] = 32'h0020A1B3; // SLT x3, x1, x2
        dut.imem[3] = 32'h0020B233; // SLTU x4, x1, x2

        #12;
        reset = 0;
        #50;

        $display("SLT  result = %h", dut.x[3]);
        $display("SLTU result = %h", dut.x[4]);

        if (dut.x[3] === 32'd1)
            $display("PASS: SLT signed comparison");
        else begin
            $display("FAIL: SLT");
            errors = errors + 1;
        end

        if (dut.x[4] === 32'd0)
            $display("PASS: SLTU unsigned comparison");
        else begin
            $display("FAIL: SLTU");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL COMPARISON TESTS PASSED");
        else
            $display("FAILURES: %0d", errors);

        $finish;
    end

endmodule
