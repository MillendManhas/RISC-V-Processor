
module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // x1 = 5
        dut.imem[0] = 32'h00500093; // addi x1,x0,5

        // JAL: jump from PC=4 to PC=12
        // Save PC+4 (=8) in x5
        dut.imem[1] = 32'h008002EF; // jal x5,+8

        // This instruction should be skipped
        dut.imem[2] = 32'h06300113; // addi x2,x0,99

        // Target at PC=12
        dut.imem[3] = 32'h00B00113; // addi x2,x0,11

        // Prepare JALR target: x1=32
        dut.imem[4] = 32'h02000093; // addi x1,x0,32

        // JALR: jump to (x1+0)&~1 = 32
        // Save PC+4 (=20) in x6
        dut.imem[5] = 32'h00008367; // jalr x6,0(x1)

        // These instructions should be skipped
        dut.imem[6] = 32'h06300193; // addi x3,x0,99
        dut.imem[7] = 32'h06300213; // addi x4,x0,99

        // JALR target at PC=32 (instruction index 8)
        dut.imem[8] = 32'h00D00193; // addi x3,x0,13

        #12;
        reset = 0;
        #120;

        $display("x2 (JAL target) = %0d", dut.x[2]);
        $display("x3 (JALR target) = %0d", dut.x[3]);
        $display("x4 (should stay 0) = %0d", dut.x[4]);
        $display("x5 (JAL link) = %0d", dut.x[5]);
        $display("x6 (JALR link) = %0d", dut.x[6]);

        if (dut.x[2] == 11 &&
            dut.x[3] == 13 &&
            dut.x[4] == 0 &&
            dut.x[5] == 8 &&
            dut.x[6] == 24)
            $display("PASS: JAL and JALR tests");
        else
            $display("FAIL: JAL and JALR tests");

        $finish;
    end
endmodule
