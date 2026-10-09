
module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        dut.imem[0]  = 32'h00C00093; // ADDI x1, x0, 12
        dut.imem[1]  = 32'h00300113; // ADDI x2, x0, 3
        dut.imem[2]  = 32'h00508193; // ADDI x3, x1, 5 = 17
        dut.imem[3]  = 32'h00512213; // SLTI x4, x2, 5 = 1
        dut.imem[4]  = 32'h00213293; // SLTIU x5, x2, 2 = 0
        dut.imem[5]  = 32'h0050C313; // XORI x6, x1, 5 = 9
        dut.imem[6]  = 32'h0030E393; // ORI x7, x1, 3 = 15
        dut.imem[7]  = 32'h00A0F413; // ANDI x8, x1, 10 = 8
        dut.imem[8]  = 32'h00211493; // SLLI x9, x2, 2 = 12
        dut.imem[9]  = 32'h0020D513; // SRLI x10, x1, 2 = 3
        dut.imem[10] = 32'h4020D593; // SRAI x11, x1, 2 = 3

        #12;
        reset = 0;
        #110;

        $display("ADDI x3  = %0d", dut.x[3]);
        $display("SLTI x4  = %0d", dut.x[4]);
        $display("SLTIU x5 = %0d", dut.x[5]);
        $display("XORI x6  = %0d", dut.x[6]);
        $display("ORI x7   = %0d", dut.x[7]);
        $display("ANDI x8  = %0d", dut.x[8]);
        $display("SLLI x9  = %0d", dut.x[9]);
        $display("SRLI x10 = %0d", dut.x[10]);
        $display("SRAI x11 = %0d", dut.x[11]);

        if (dut.x[3]  == 17 &&
            dut.x[4]  == 1  &&
            dut.x[5]  == 0  &&
            dut.x[6]  == 9  &&
            dut.x[7]  == 15 &&
            dut.x[8]  == 8  &&
            dut.x[9]  == 12 &&
            dut.x[10] == 3  &&
            dut.x[11] == 3)
            $display("PASS: I-type instruction tests");
        else
            $display("FAIL: I-type instruction tests");

        $finish;
    end
endmodule
