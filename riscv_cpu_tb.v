
`timescale 1ns/1ps

module riscv_cpu_tb;

    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        dut.imem[0] = 32'h08000093; // ADDI x1, x0, 128
        dut.imem[1] = 32'h80000137; // LUI x2, 0x80000
        dut.imem[2] = 32'h0020A023; // SW x2, 0(x1)

        dut.imem[3] = 32'h00209183; // LH  x3, 2(x1)
        dut.imem[4] = 32'h0020D203; // LHU x4, 2(x1)

        #12;
        reset = 0;
        #60;

        $display("Memory[130] = %h", dut.dmem[130]);
        $display("Memory[131] = %h", dut.dmem[131]);
        $display("LH  x3 = %0d", $signed(dut.x[3]));
        $display("LHU x4 = %0d", dut.x[4]);

        if (dut.x[3] == 32'hFFFF8000 &&
            dut.x[4] == 32'h00008000)
            $display("PASS: Signed and unsigned halfword tests");
        else
            $display("FAIL: Signed and unsigned halfword tests");

        $finish;
    end
endmodule
