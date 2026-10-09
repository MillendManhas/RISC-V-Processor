
module register_file_tb;

    reg clk;
    reg reg_write;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;

    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Connect the Register File
    register_file uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Generate clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $monitor("time=%0t rs1=%0d data1=%0d rs2=%0d data2=%0d",
                 $time, rs1, read_data1, rs2, read_data2);

        // Initial values
        reg_write = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;

        // Write 100 to x5
        #10;
        reg_write = 1;
        rd = 5;
        write_data = 100;

        #10;
        reg_write = 0;
        rs1 = 5;

        #5;
        if (read_data1 == 100)
            $display("PASS: x5 = 100");
        else
            $display("FAIL: x5 expected 100");

        // Write 200 to x10
        #5;
        reg_write = 1;
        rd = 10;
        write_data = 200;

        #10;
        reg_write = 0;
        rs1 = 10;

        #5;
        if (read_data1 == 200)
            $display("PASS: x10 = 200");
        else
            $display("FAIL: x10 expected 200");

        // Check x0
        rs1 = 0;
        rs2 = 0;

        #5;
        if (read_data1 == 0 && read_data2 == 0)
            $display("PASS: x0 always reads 0");
        else
            $display("FAIL: x0 is not zero");

        $finish;
    end

endmodule
