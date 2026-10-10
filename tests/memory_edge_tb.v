
`timescale 1ns/1ps

module memory_edge_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        // Base address = 128
        dut.imem[0] = 32'h08000093; // ADDI x1, x0, 128

        // Construct the word 0x12345678
        dut.imem[1] = 32'h12345137; // LUI x2, 0x12345
        dut.imem[2] = 32'h67810113; // ADDI x2, x2, 0x678

        // Store word in little-endian format
        dut.imem[3] = 32'h0020A023; // SW x2, 0(x1)

        // Load bytes from offsets 0 and 3
        dut.imem[4] = 32'h00008183; // LB x3, 0(x1)
        dut.imem[5] = 32'h0030C203; // LBU x4, 3(x1)

        // Load halfwords from offsets 0 and 2
        dut.imem[6] = 32'h00009283; // LH x5, 0(x1)
        dut.imem[7] = 32'h0020D303; // LHU x6, 2(x1)

        // Load the complete word
        dut.imem[8] = 32'h0000A383; // LW x7, 0(x1)

        #12;
        reset = 0;
        #110;

        $display("LB  offset 0 = %h", dut.x[3]);
        $display("LBU offset 3 = %h", dut.x[4]);
        $display("LH  offset 0 = %h", dut.x[5]);
        $display("LHU offset 2 = %h", dut.x[6]);
        $display("LW  offset 0 = %h", dut.x[7]);

        if (dut.x[3] === 32'h00000078)
            $display("PASS: LB at offset 0");
        else begin
            $display("FAIL: LB at offset 0");
            errors = errors + 1;
        end

        if (dut.x[4] === 32'h00000012)
            $display("PASS: LBU at offset 3");
        else begin
            $display("FAIL: LBU at offset 3");
            errors = errors + 1;
        end

        if (dut.x[5] === 32'h00005678)
            $display("PASS: LH at offset 0");
        else begin
            $display("FAIL: LH at offset 0");
            errors = errors + 1;
        end

        if (dut.x[6] === 32'h00001234)
            $display("PASS: LHU at offset 2");
        else begin
            $display("FAIL: LHU at offset 2");
            errors = errors + 1;
        end

        if (dut.x[7] === 32'h12345678)
            $display("PASS: LW at offset 0");
        else begin
            $display("FAIL: LW at offset 0");
            errors = errors + 1;
        end

        // Verify individual bytes in memory
        if (dut.dmem[128] === 8'h78 &&
            dut.dmem[129] === 8'h56 &&
            dut.dmem[130] === 8'h34 &&
            dut.dmem[131] === 8'h12)
            $display("PASS: Little-endian byte ordering");
        else begin
            $display("FAIL: Little-endian byte ordering");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL MEMORY EDGE TESTS PASSED");
        else
            $display("FAILURES: %0d", errors);

        $finish;
    end

endmodule

