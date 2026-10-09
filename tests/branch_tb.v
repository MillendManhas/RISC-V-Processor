

module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // x1=5, x2=5, x3=3
        dut.imem[0] = 32'h00500093; // addi x1,x0,5
        dut.imem[1] = 32'h00500113; // addi x2,x0,5
        dut.imem[2] = 32'h00300193; // addi x3,x0,3

        // BEQ: x1 == x2, skip x4=99
        dut.imem[3] = 32'h00208463; // beq x1,x2,+8
        dut.imem[4] = 32'h06300213; // addi x4,x0,99
        dut.imem[5] = 32'h00700213; // addi x4,x0,7

        // BNE: x1 != x3, skip x5=99
        dut.imem[6] = 32'h00309463; // bne x1,x3,+8
        dut.imem[7] = 32'h06300293; // addi x5,x0,99
        dut.imem[8] = 32'h00900293; // addi x5,x0,9

        // BLT: x3 < x1, skip x6=99
        dut.imem[9]  = 32'h0011C463; // blt x3,x1,+8
        dut.imem[10] = 32'h06300313; // addi x6,x0,99
        dut.imem[11] = 32'h00B00313; // addi x6,x0,11

        // BGE: x1 >= x3, skip x7=99
        dut.imem[12] = 32'h0030D463; // bge x1,x3,+8
        dut.imem[13] = 32'h06300393; // addi x7,x0,99
        dut.imem[14] = 32'h00D00393; // addi x7,x0,13

        // BLTU: unsigned x3 < x2, skip x8=99
        dut.imem[15] = 32'h0021E463; // bltu x3,x2,+8
        dut.imem[16] = 32'h06300413; // addi x8,x0,99
        dut.imem[17] = 32'h00F00413; // addi x8,x0,15

        // BGEU: unsigned x2 >= x3, skip x9=99
        dut.imem[18] = 32'h00317463; // bgeu x2,x3,+8
        dut.imem[19] = 32'h06300493; // addi x9,x0,99
        dut.imem[20] = 32'h01100493; // addi x9,x0,17

        #12;
        reset = 0;
        #220;

        $display("x4 = %0d", dut.x[4]);
        $display("x5 = %0d", dut.x[5]);
        $display("x6 = %0d", dut.x[6]);
        $display("x7 = %0d", dut.x[7]);
        $display("x8 = %0d", dut.x[8]);
        $display("x9 = %0d", dut.x[9]);

        if (dut.x[4] == 7 && dut.x[5] == 9 &&
            dut.x[6] == 11 && dut.x[7] == 13 &&
            dut.x[8] == 15 && dut.x[9] == 17)
            $display("PASS: Branch tests");
        else
            $display("FAIL: Branch tests");

        $finish;
    end
endmodule
