
`timescale 1ns/1ps

module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // x1 = 128 (base address)
        dut.imem[0] = 32'h08000093; // ADDI x1, x0, 128

        // x2 = 291 (0x123)
        dut.imem[1] = 32'h12300113; // ADDI x2, x0, 291

        // SB x2, 0(x1)
        dut.imem[2] = 32'h00208023;

        // SH x2, 2(x1)
        dut.imem[3] = 32'h00209123;

        // SW x2, 4(x1)
        dut.imem[4] = 32'h0020A223;

        #12;
        reset = 0;
        #60;

        $display("SB byte = %h", dut.dmem[128]);
        $display("SH bytes = %h %h",
                 dut.dmem[131], dut.dmem[130]);
        $display("SW bytes = %h %h %h %h",
                 dut.dmem[135], dut.dmem[134],
                 dut.dmem[133], dut.dmem[132]);

        if (dut.dmem[128] == 8'h23 &&
            dut.dmem[130] == 8'h23 &&
            dut.dmem[131] == 8'h01 &&
            dut.dmem[132] == 8'h23 &&
            dut.dmem[133] == 8'h01 &&
            dut.dmem[134] == 8'h00 &&
            dut.dmem[135] == 8'h00)
            $display("PASS: SB, SH, SW tests");
        else
            $display("FAIL: SB, SH, SW tests");

        $finish;
    end
endmodule
