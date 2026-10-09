
`timescale 1ns/1ps

module riscv_cpu_tb;
    reg clk, reset;
    integer passed, failed;
    integer j;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

task clear_imem;
    begin
        for (j = 0; j < 256; j = j + 1)
            dut.imem[j] = 32'h00000013; // ADDI x0,x0,0 (NOP)
    end
endtask

    // Reset PC and registers before each independent test group.
    task reset_cpu;
        begin
            reset = 1;
            #12;
            reset = 0;
        end
    endtask

    task check;
        input condition;
        input [8*50-1:0] test_name;
        begin
            if (condition) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s", test_name);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        passed = 0;
        failed = 0;

        // =========================================
        // 1. R-TYPE: all 10 instructions
        // =========================================
        clear_imem;
        dut.imem[0]  = 32'h00C00093;
        dut.imem[1]  = 32'h00300113;
        dut.imem[2]  = 32'h002081B3;
        dut.imem[3]  = 32'h40208233;
        dut.imem[4]  = 32'h002092B3;
        dut.imem[5]  = 32'h0020A333;
        dut.imem[6]  = 32'h0020B3B3;
        dut.imem[7]  = 32'h0020C433;
        dut.imem[8]  = 32'h0020D4B3;
        dut.imem[9]  = 32'h4020D533;
        dut.imem[10] = 32'h0020E5B3;
        dut.imem[11] = 32'h0020F633;

        reset_cpu;
        #120;
        check(dut.x[3] == 15 && dut.x[4] == 9 &&
              dut.x[5] == 96 && dut.x[6] == 0 &&
              dut.x[7] == 0 && dut.x[8] == 15 &&
              dut.x[9] == 1 && dut.x[10] == 1 &&
              dut.x[11] == 15 && dut.x[12] == 0,
              "R-type instructions");

        // =========================================
        // 2. I-TYPE: arithmetic and shifts
        // =========================================
        clear_imem;
        dut.imem[0]  = 32'h00C00093;
        dut.imem[1]  = 32'h00300113;
        dut.imem[2]  = 32'h00508193;
        dut.imem[3]  = 32'h00512213;
        dut.imem[4]  = 32'h00213293;
        dut.imem[5]  = 32'h0050C313;
        dut.imem[6]  = 32'h0030E393;
        dut.imem[7]  = 32'h00A0F413;
        dut.imem[8]  = 32'h00211493;
        dut.imem[9]  = 32'h0020D513;
        dut.imem[10] = 32'h4020D593;

        reset_cpu;
        #110;
        check(dut.x[3] == 17 && dut.x[4] == 1 &&
              dut.x[5] == 0 && dut.x[6] == 9 &&
              dut.x[7] == 15 && dut.x[8] == 8 &&
              dut.x[9] == 12 && dut.x[10] == 3 &&
              dut.x[11] == 3,
              "I-type arithmetic and shifts");

        // =========================================
        // 3. U-TYPE: LUI and AUIPC
        // =========================================
        clear_imem;
        dut.imem[0] = 32'h12345137; // LUI x2, 0x12345
        dut.imem[1] = 32'h00001697; // AUIPC x13, 0x1

        reset_cpu;
        #30;
        check(dut.x[2] == 32'h12345000 &&
              dut.x[13] == 32'h00001004,
              "LUI and AUIPC");

        // =========================================
        // 4. BRANCHES: all six conditions
        // =========================================
        clear_imem;
        dut.imem[0]  = 32'h00500093;
        dut.imem[1]  = 32'h00500113;
        dut.imem[2]  = 32'h00300193;
        dut.imem[3]  = 32'h00208463;
        dut.imem[4]  = 32'h06300213;
        dut.imem[5]  = 32'h00700213;
        dut.imem[6]  = 32'h00309463;
        dut.imem[7]  = 32'h06300293;
        dut.imem[8]  = 32'h00900293;
        dut.imem[9]  = 32'h0011C463;
        dut.imem[10] = 32'h06300313;
        dut.imem[11] = 32'h00B00313;
        dut.imem[12] = 32'h0030D463;
        dut.imem[13] = 32'h06300393;
        dut.imem[14] = 32'h00D00393;
        dut.imem[15] = 32'h0021E463;
        dut.imem[16] = 32'h06300413;
        dut.imem[17] = 32'h00F00413;
        dut.imem[18] = 32'h00317463;
        dut.imem[19] = 32'h06300493;
        dut.imem[20] = 32'h01100493;

        reset_cpu;
        #220;
        check(dut.x[4] == 7 && dut.x[5] == 9 &&
              dut.x[6] == 11 && dut.x[7] == 13 &&
              dut.x[8] == 15 && dut.x[9] == 17,
              "All six branch instructions");

        // =========================================
        // 5. JUMPS: JAL and JALR
        // =========================================
        clear_imem;
        dut.imem[0] = 32'h00500093;
        dut.imem[1] = 32'h008002EF;
        dut.imem[2] = 32'h06300113;
        dut.imem[3] = 32'h00B00113;
        dut.imem[4] = 32'h02000093;
        dut.imem[5] = 32'h00008367;
        dut.imem[6] = 32'h06300193;
        dut.imem[7] = 32'h06300213;
        dut.imem[8] = 32'h00D00193;

        reset_cpu;
        #120;
        check(dut.x[2] == 11 && dut.x[3] == 13 &&
              dut.x[4] == 0 && dut.x[5] == 8 &&
              dut.x[6] == 24,
              "JAL and JALR");

        // =========================================
        // 6. STORES: SB, SH and SW
        // =========================================
        clear_imem;
        dut.dmem[128] = 0;
        dut.dmem[129] = 0;
        dut.dmem[130] = 0;
        dut.dmem[131] = 0;
        dut.dmem[132] = 0;
        dut.dmem[133] = 0;
        dut.dmem[134] = 0;
        dut.dmem[135] = 0;

        dut.imem[0] = 32'h08000093;
        dut.imem[1] = 32'h12300113;
        dut.imem[2] = 32'h00208023;
        dut.imem[3] = 32'h00209123;
        dut.imem[4] = 32'h0020A223;

        reset_cpu;
        #60;
        check(dut.dmem[128] == 8'h23 &&
              dut.dmem[130] == 8'h23 &&
              dut.dmem[131] == 8'h01 &&
              dut.dmem[132] == 8'h23 &&
              dut.dmem[133] == 8'h01 &&
              dut.dmem[134] == 8'h00 &&
              dut.dmem[135] == 8'h00,
              "SB, SH and SW");

        // =========================================
        // 7. LOADS: signed/unsigned byte and halfword
        // =========================================
        clear_imem;
        dut.dmem[64] = 0;
        dut.dmem[65] = 0;
        dut.dmem[66] = 0;
        dut.dmem[67] = 0;

        dut.imem[0]  = 32'h04000293; // ADDI x5,x0,64
        dut.imem[1]  = 32'h0FF00313; // ADDI x6,x0,255
        dut.imem[2]  = 32'h00628023; // SB x6,0(x5)
        dut.imem[3]  = 32'h00028383; // LB x7,0(x5)
        dut.imem[4]  = 32'h0002C403; // LBU x8,0(x5)
        dut.imem[5]  = 32'h0FF00313; // ADDI x6,x0,255
        dut.imem[6]  = 32'h00629123; // SH x6,2(x5)
        dut.imem[7]  = 32'h00229503; // LH x10,2(x5)
        dut.imem[8]  = 32'h0022D583; // LHU x11,2(x5)

        reset_cpu;
        #100;
        check(dut.x[7] == 32'hFFFFFFFF &&
              dut.x[8] == 255 &&
              dut.x[10] == 255 && dut.x[11] == 255,
              "Byte and halfword loads");

        // =========================================
        // FINAL SUMMARY
        // =========================================
        $display("");
        $display("================================");
        $display("Combined RISC-V CPU Test Results");
        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);
        $display("================================");

        if (failed == 0)
            $display("ALL TEST GROUPS PASSED");
        else
            $display("SOME TEST GROUPS FAILED");

        $finish;
    end
endmodule
