

module riscv_cpu_tb;
    reg clk, reset;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Negative immediate: -1
        dut.imem[0] = 32'hFFF00093; // addi x1,x0,-1

        // Negative immediate: -5
        dut.imem[1] = 32'hFFB00113; // addi x2,x0,-5

        // Signed comparison: -5 < -1
        dut.imem[2] = 32'h0020A1B3; // slt x3,x1,x2 (x1 < x2? false)
        dut.imem[3] = 32'h0020A233; // slt x4,x1,x2 (same comparison)

        // Base address 64; value 127
        dut.imem[4] = 32'h04000293; // addi x5,x0,64
        dut.imem[5] = 32'h0FF00313; // addi x6,x0,255
        dut.imem[6] = 32'h00628023; // sb x6,0(x5)

        // Signed and unsigned byte loads
        dut.imem[7] = 32'h00028383; // lb x7,0(x5)
        dut.imem[8] = 32'h0002C403; // lbu x8,0(x5)

        // Store 255 in the low halfword at address 66
dut.imem[9]  = 32'h0FF00313; // addi x6,x0,255
dut.imem[10] = 32'h00629123; // sh x6,2(x5)
dut.imem[11] = 32'h00229503; // lh x10,2(x5)
dut.imem[12] = 32'h0022D583; // lhu x11,2(x5)

        #12;
        reset = 0;
        #160;

        $display("x1 = %0d", $signed(dut.x[1]));
        $display("x2 = %0d", $signed(dut.x[2]));
        $display("x7 (LB) = %0d", $signed(dut.x[7]));
        $display("x8 (LBU) = %0d", dut.x[8]);

        if (dut.x[1] == 32'hFFFFFFFF &&
    dut.x[2] == 32'hFFFFFFFB &&
    dut.x[7] == 32'hFFFFFFFF &&
    dut.x[8] == 255)
    $display("PASS: Signed and unsigned byte load test");
else
    $display("FAIL: Signed and unsigned byte load test");

    $display("x10 (LH) = %0d", $signed(dut.x[10]));
$display("x11 (LHU) = %0d", dut.x[11]);

if (dut.x[10] == 255 && dut.x[11] == 255)
    $display("PASS: Halfword load test");
else
    $display("FAIL: Halfword load test");
        $finish;
    end
endmodule
