module register_file (
    input wire clk,
    input wire reg_write,

    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,

    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    // 32 registers, each 32 bits
    reg [31:0] registers [0:31];

    // Read ports
    assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];

    assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

    // Write port
    always @(posedge clk) begin

        if (reg_write && rd != 5'b00000)
            registers[rd] <= write_data;

    end

endmodule