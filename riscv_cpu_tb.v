
module riscv_cpu_tb;

    reg clk;
    reg reset;

    riscv_cpu dut (
        .clk(clk),
        .reset(reset)
    );

    // Generate clock: one transition every 5 time units
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Program loaded into instruction memory
        dut.imem[0] = 32'h00500093; // addi x1, x0, 5
        dut.imem[1] = 32'h00700113; // addi x2, x0, 7
        dut.imem[2] = 32'h002081B3; // add x3, x1, x2
        dut.imem[3] = 32'h40110233; // sub x4, x2, x1

        // Reset the processor
        #12;
        reset = 0;

        // Wait for the four instructions to execute
        #40;

        $display("x1 = %0d", dut.x[1]);
        $display("x2 = %0d", dut.x[2]);
        $display("x3 = %0d", dut.x[3]);
        $display("x4 = %0d", dut.x[4]);

        if (dut.x[1] == 5 &&
            dut.x[2] == 7 &&
            dut.x[3] == 12 &&
            dut.x[4] == 2)
            $display("PASS: Basic arithmetic test");
        else
            $display("FAIL: Basic arithmetic test");

        $finish;
    end

endmodule
