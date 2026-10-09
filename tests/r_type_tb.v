

module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        dut.imem[0] = 32'h00C00093; // addi x1,x0,12
        dut.imem[1] = 32'h00300113; // addi x2,x0,3

        dut.imem[2] = 32'h002081B3; // add  x3,x1,x2 = 15
        dut.imem[3] = 32'h40208233; // sub  x4,x1,x2 = 9
        dut.imem[4] = 32'h002092B3; // sll  x5,x1,x2 = 96
        dut.imem[5] = 32'h0020A333; // slt  x6,x1,x2 = 0
        dut.imem[6] = 32'h0020B3B3; // sltu x7,x1,x2 = 0
        dut.imem[7] = 32'h0020C433; // xor  x8,x1,x2 = 15
        dut.imem[8] = 32'h0020D4B3; // srl  x9,x1,x2 = 1
        dut.imem[9] = 32'h4020D533; // sra  x10,x1,x2 = 1
        dut.imem[10] = 32'h0020E5B3; // or   x11,x1,x2 = 15
        dut.imem[11] = 32'h0020F633; // and  x12,x1,x2 = 0

        #12;
        reset = 0;
        #120;

        $display("ADD  x3  = %0d", dut.x[3]);
        $display("SUB  x4  = %0d", dut.x[4]);
        $display("SLL  x5  = %0d", dut.x[5]);
        $display("SLT  x6  = %0d", dut.x[6]);
        $display("SLTU x7  = %0d", dut.x[7]);
        $display("XOR  x8  = %0d", dut.x[8]);
        $display("SRL  x9  = %0d", dut.x[9]);
        $display("SRA  x10 = %0d", dut.x[10]);
        $display("OR   x11 = %0d", dut.x[11]);
        $display("AND  x12 = %0d", dut.x[12]);

        if (dut.x[3] == 15 && dut.x[4] == 9 &&
            dut.x[5] == 96 && dut.x[6] == 0 &&
            dut.x[7] == 0 && dut.x[8] == 15 &&
            dut.x[9] == 1 && dut.x[10] == 1 &&
            dut.x[11] == 15 && dut.x[12] == 0)
            $display("PASS: R-type instruction tests");
        else
            $display("FAIL: R-type instruction tests");

        $finish;
    end
endmodule
