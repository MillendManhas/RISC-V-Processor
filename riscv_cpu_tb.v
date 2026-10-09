
module riscv_cpu_tb;

    reg clk;
    reg reset;

    riscv_cpu dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Prepare x1 = 12 and x2 = 3
        dut.imem[0] = 32'h00C00093; // addi x1, x0, 12
        dut.imem[1] = 32'h00300113; // addi x2, x0, 3

        // Logical, shift and comparison instructions
        dut.imem[2] = 32'h002091B3; // sll  x3, x1, x2
        dut.imem[3] = 32'h00112233; // slt  x4, x2, x1
        dut.imem[4] = 32'h0020B2B3; // sltu x5, x1, x2
        dut.imem[5] = 32'h0020C333; // xor  x6, x1, x2
        dut.imem[6] = 32'h0020D3B3; // srl  x7, x1, x2
        dut.imem[7] = 32'h0020E433; // or   x8, x1, x2
        dut.imem[8] = 32'h0020F4B3; // and  x9, x1, x2
        dut.imem[9] = 32'h4020D533; // sra  x10, x1, x2

        #12;
        reset = 0;

        // Ten instructions, including the two setup instructions
        #100;

        $display("x3  SLL  = %0d", dut.x[3]);
        $display("x4  SLT  = %0d", dut.x[4]);
        $display("x5  SLTU = %0d", dut.x[5]);
        $display("x6  XOR  = %0d", dut.x[6]);
        $display("x7  SRL  = %0d", dut.x[7]);
        $display("x8  OR   = %0d", dut.x[8]);
        $display("x9  AND  = %0d", dut.x[9]);
        $display("x10 SRA  = %0d", dut.x[10]);

        if (dut.x[3] == 96 &&
            dut.x[4] == 1 &&
            dut.x[5] == 0 &&
            dut.x[6] == 15 &&
            dut.x[7] == 1 &&
            dut.x[8] == 15 &&
            dut.x[9] == 0 &&
            dut.x[10] == 1)
            $display("PASS: Logical, shift and comparison tests");
        else
            $display("FAIL: Logical, shift and comparison tests");

        $finish;
    end

endmodule

