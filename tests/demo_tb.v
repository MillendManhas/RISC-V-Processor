
`timescale 1ns/1ps

module demo_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        // 1. Load values into registers
        dut.imem[0] = 32'h00500093; // ADDI x1, x0, 5
        dut.imem[1] = 32'h00700113; // ADDI x2, x0, 7

        // 2. Arithmetic: x3 = x1 + x2 = 12
        dut.imem[2] = 32'h002081B3; // ADD x3, x1, x2

        // 3. Store x3 to memory and load it back
        dut.imem[3] = 32'h00302023; // SW x3, 0(x0)
        dut.imem[4] = 32'h00002203; // LW x4, 0(x0)

        // 4. Branch if x3 == x4
        dut.imem[5] = 32'h00418463; // BEQ x3, x4, +8

        // This instruction should be skipped
        dut.imem[6] = 32'h06300293; // ADDI x5, x0, 99

        // Branch target: x5 should become 42
        dut.imem[7] = 32'h02A00293; // ADDI x5, x0, 42

        #12;
        reset = 0;

        // Allow the program to execute
        #100;

        $display("");
        $display("=== RISC-V CPU DEMONSTRATION ===");
        $display("x1 = %0d (expected 5)", dut.x[1]);
        $display("x2 = %0d (expected 7)", dut.x[2]);
        $display("x3 = %0d (expected 12)", dut.x[3]);
        $display("x4 = %0d (expected 12)", dut.x[4]);
        $display("x5 = %0d (expected 42)", dut.x[5]);
        $display("Memory word = %h", {
            dut.dmem[3], dut.dmem[2],
            dut.dmem[1], dut.dmem[0]
        });

        if (dut.x[1] === 32'd5 &&
            dut.x[2] === 32'd7 &&
            dut.x[3] === 32'd12 &&
            dut.x[4] === 32'd12 &&
            dut.x[5] === 32'd42 &&
            dut.dmem[0] === 8'd12)
            $display("SUCCESS: DEMONSTRATION PASSED");
        else begin
            $display("FAIL: CHECK THE REGISTER AND MEMORY RESULTS");
            errors = errors + 1;
        end

        $display("Errors = %0d", errors);
        $finish;
    end

endmodule
