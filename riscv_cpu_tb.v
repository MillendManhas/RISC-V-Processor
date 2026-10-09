

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

        // Setup
        dut.imem[0]  = 32'h00C00093; // addi x1, x0, 12
        dut.imem[1]  = 32'h00300113; // addi x2, x0, 3

        // Immediate arithmetic and logical instructions
        dut.imem[2]  = 32'h00508193; // addi  x3, x1, 5
        dut.imem[3]  = 32'h00512213; // slti  x4, x2, 5
        dut.imem[4]  = 32'h00213293; // sltiu x5, x2, 2
        dut.imem[5]  = 32'h0050C313; // xori  x6, x1, 5
        dut.imem[6]  = 32'h0030E393; // ori   x7, x1, 3
        dut.imem[7]  = 32'h00A0F413; // andi  x8, x1, 10

        // Immediate shifts
        dut.imem[8]  = 32'h00211493; // slli x9,  x2, 2
        dut.imem[9]  = 32'h0020D513; // srli x10, x1, 2
        dut.imem[10] = 32'h4020D593; // srai x11, x1, 2

        // Upper-immediate instructions
        dut.imem[11] = 32'h12345637; // lui   x12, 0x12345
        dut.imem[12] = 32'h00001697; // auipc x13, 0x1

        #12;
        reset = 0;

        // Allow all 13 instructions to execute
        #130;

        $display("x3  ADDI  = %0d", dut.x[3]);
        $display("x4  SLTI  = %0d", dut.x[4]);
        $display("x5  SLTIU = %0d", dut.x[5]);
        $display("x6  XORI  = %0d", dut.x[6]);
        $display("x7  ORI   = %0d", dut.x[7]);
        $display("x8  ANDI  = %0d", dut.x[8]);
        $display("x9  SLLI  = %0d", dut.x[9]);
        $display("x10 SRLI  = %0d", dut.x[10]);
        $display("x11 SRAI  = %0d", dut.x[11]);
        $display("x12 LUI   = %h", dut.x[12]);
        $display("x13 AUIPC = %0d", dut.x[13]);

        if (dut.x[3] == 17 &&
            dut.x[4] == 1 &&
            dut.x[5] == 0 &&
            dut.x[6] == 9 &&
            dut.x[7] == 15 &&
            dut.x[8] == 8 &&
            dut.x[9] == 12 &&
            dut.x[10] == 3 &&
            dut.x[11] == 3 &&
            dut.x[12] == 32'h12345000 &&
            dut.x[13] == 4144)
            $display("PASS: Immediate and upper-immediate tests");
        else
            $display("FAIL: Immediate and upper-immediate tests");

        $finish;
    end

endmodule
