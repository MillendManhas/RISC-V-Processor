
`timescale 1ns/1ps

module branch_edge_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        // x1 = 5, x2 = 5, x3 = -1
        dut.imem[0]  = 32'h00500093; // ADDI x1, x0, 5
        dut.imem[1]  = 32'h00500113; // ADDI x2, x0, 5
        dut.imem[2]  = 32'hFFF00193; // ADDI x3, x0, -1

        // BEQ taken: skip instruction at index 4
        dut.imem[3]  = 32'h00208463; // BEQ x1, x2, +8
        dut.imem[4]  = 32'h06300213; // ADDI x4, x0, 99 (must skip)
        dut.imem[5]  = 32'h00700213; // ADDI x4, x0, 7

        // BNE not taken: x1 equals x2
        dut.imem[6]  = 32'h00209463; // BNE x1, x2, +8
        dut.imem[7]  = 32'h00900293; // ADDI x5, x0, 9

        // BLT signed taken: -1 < 5
        dut.imem[8]  = 32'h0021C463; // BLT x3, x2, +8
        dut.imem[9]  = 32'h06300313; // ADDI x6, x0, 99 (must skip)
        dut.imem[10] = 32'h00B00313; // ADDI x6, x0, 11

        // BGE signed not taken: -1 >= 5 is false
        dut.imem[11] = 32'h0021D463; // BGE x3, x2, +8
        dut.imem[12] = 32'h00D00393; // ADDI x7, x0, 13

        // BLTU unsigned not taken: 0xFFFFFFFF < 5 is false
        dut.imem[13] = 32'h0021E463; // BLTU x3, x2, +8
        dut.imem[14] = 32'h00F00413; // ADDI x8, x0, 15

        // BGEU unsigned taken: 0xFFFFFFFF >= 5 is true
        dut.imem[15] = 32'h0021F463; // BGEU x3, x2, +8
        dut.imem[16] = 32'h06300493; // ADDI x9, x0, 99 (must skip)
        dut.imem[17] = 32'h01100493; // ADDI x9, x0, 17

        #12;
        reset = 0;
        #200;

        if (dut.x[4] === 7) begin
            $display("PASS: BEQ taken");
        end else begin
            $display("FAIL: BEQ");
            errors = errors + 1;
        end

        if (dut.x[5] === 9) begin
            $display("PASS: BNE not taken");
        end else begin
            $display("FAIL: BNE");
            errors = errors + 1;
        end

        if (dut.x[6] === 11) begin
            $display("PASS: BLT signed taken");
        end else begin
            $display("FAIL: BLT");
            errors = errors + 1;
        end

        if (dut.x[7] === 13) begin
            $display("PASS: BGE signed not taken");
        end else begin
            $display("FAIL: BGE");
            errors = errors + 1;
        end

        if (dut.x[8] === 15) begin
            $display("PASS: BLTU unsigned not taken");
        end else begin
            $display("FAIL: BLTU");
            errors = errors + 1;
        end

        if (dut.x[9] === 17) begin
            $display("PASS: BGEU unsigned taken");
        end else begin
            $display("FAIL: BGEU");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL BRANCH EDGE TESTS PASSED");
        else
            $display("FAILURES: %0d", errors);

        $finish;
    end

endmodule
