
module pc_tb;

    reg clk;
    reg reset;
    reg [31:0] next_pc;
    wire [31:0] current_pc;

    pc uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        next_pc = 0;

        #10;
        if (current_pc == 0)
            $display("PASS: Reset sets PC to 0");
        else
            $display("FAIL: Reset");

        reset = 0;
        next_pc = 4;
        #10;
        if (current_pc == 4)
            $display("PASS: PC updates to 4");
        else
            $display("FAIL: PC update to 4");

        next_pc = 8;
        #10;
        if (current_pc == 8)
            $display("PASS: PC updates to 8");
        else
            $display("FAIL: PC update to 8");

        $finish;
    end

endmodule
