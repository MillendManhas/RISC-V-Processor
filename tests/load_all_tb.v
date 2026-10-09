
`timescale 1ns/1ps

module load_all_tb;

    reg clk, reset;
    integer errors;

    riscv_cpu dut (.clk(clk), .reset(reset));
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;

        // Base address x1 = 128
        dut.imem[0] = 32'h08000093; // ADDI x1, x0, 128

        // x2 = 0x800000FF
        dut.imem[1] = 32'h80000137; // LUI x2, 0x80000
        dut.imem[2] = 32'h0FF10113; // ADDI x2, x2, 255

        // Store word 0x800000FF at address 128
        dut.imem[3] = 32'h0020A023; // SW x2, 0(x1)

        // Load signed and unsigned byte at address 131
dut.imem[4] = 32'h00308183; // LB x3, 3(x1)
dut.imem[5] = 32'h0030C203; // LBU x4, 3(x1)

// Load signed and unsigned halfword at address 130
dut.imem[6] = 32'h00209303; // LH x6, 2(x1)
dut.imem[7] = 32'h0020D383; // LHU x7, 2(x1)

// Load full word at address 128
dut.imem[8] = 32'h0000A283; // LW x5, 0(x1)

        #12;
        reset = 0;
        #100;

$display("LB  result = %h", dut.x[3]);
$display("LBU result = %h", dut.x[4]);
$display("LH  result = %h", dut.x[6]);
$display("LHU result = %h", dut.x[7]);
$display("LW  result = %h", dut.x[5]);

if (dut.x[3] !== 32'hFFFFFF80) begin
    $display("FAIL: LB");
    errors = errors + 1;
end else $display("PASS: LB");

if (dut.x[4] !== 32'h00000080) begin
    $display("FAIL: LBU");
    errors = errors + 1;
end else $display("PASS: LBU");

if (dut.x[6] !== 32'hFFFF8000) begin
    $display("FAIL: LH");
    errors = errors + 1;
end else $display("PASS: LH");

if (dut.x[7] !== 32'h00008000) begin
    $display("FAIL: LHU");
    errors = errors + 1;
end else $display("PASS: LHU");

if (dut.x[5] !== 32'h800000FF) begin
    $display("FAIL: LW");
    errors = errors + 1;
end else $display("PASS: LW");

if (errors == 0)
    $display("ALL FIVE LOAD INSTRUCTIONS PASSED");
else
    $display("FAILURES: %0d", errors);

$finish;
    end

endmodule
