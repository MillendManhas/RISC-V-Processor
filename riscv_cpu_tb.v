
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

        // x1 = 64: base address
        dut.imem[0] = 32'h04000093; // addi x1, x0, 64

        // x2 = 291 = 0x123
        dut.imem[1] = 32'h12300113; // addi x2, x0, 291

        // Store a word at address 64
        dut.imem[2] = 32'h0020A023; // sw x2, 0(x1)

        // Load byte, halfword and word
        dut.imem[3] = 32'h00008183; // lb  x3, 0(x1)
        dut.imem[4] = 32'h0000C203; // lbu x4, 0(x1)
        dut.imem[5] = 32'h00009283; // lh  x5, 0(x1)
        dut.imem[6] = 32'h0000D303; // lhu x6, 0(x1)
        dut.imem[7] = 32'h0000A383; // lw  x7, 0(x1)

        // Store a byte at address 68
        dut.imem[8] = 32'h00208223; // sb x2, 4(x1)
        dut.imem[9] = 32'h0040C403; // lbu x8, 4(x1)

        // Store a halfword at address 70
        dut.imem[10] = 32'h00209323; // sh x2, 6(x1)
        dut.imem[11] = 32'h0060D483; // lhu x9, 6(x1)

        #12;
        reset = 0;

        // Wait for the instructions to execute
        #120;

        $display("LB  x3 = %0d", dut.x[3]);
        $display("LBU x4 = %0d", dut.x[4]);
        $display("LH  x5 = %0d", dut.x[5]);
        $display("LHU x6 = %0d", dut.x[6]);
        $display("LW  x7 = %0d", dut.x[7]);
        $display("LBU x8 = %0d", dut.x[8]);
        $display("LHU x9 = %0d", dut.x[9]);

        if (dut.x[3] == 35 &&
            dut.x[4] == 35 &&
            dut.x[5] == 291 &&
            dut.x[6] == 291 &&
            dut.x[7] == 291 &&
            dut.x[8] == 35 &&
            dut.x[9] == 291)
            $display("PASS: Load and store tests");
        else
            $display("FAIL: Load and store tests");

        $finish;
    end

endmodule
