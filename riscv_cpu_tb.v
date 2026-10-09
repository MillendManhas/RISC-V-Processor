
module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        dut.imem[0] = 32'h00C00093; // addi x1,x0,12
        dut.imem[1] = 32'h00209113; // slli x2,x1,2 = 48
        dut.imem[2] = 32'h0020D193; // srli x3,x1,2 = 3
        dut.imem[3] = 32'h4020D213; // srai x4,x1,2 = 3

        #12;
        reset = 0;
        #60;

        $display("SLLI x2 = %0d", dut.x[2]);
        $display("SRLI x3 = %0d", dut.x[3]);
        $display("SRAI x4 = %0d", dut.x[4]);

        if (dut.x[2] == 48 &&
            dut.x[3] == 3 &&
            dut.x[4] == 3)
            $display("PASS: I-type shift tests");
        else
            $display("FAIL: I-type shift tests");

        $finish;
    end
endmodule
