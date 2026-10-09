module register_file (
    input wire clk,              // Clock
    input wire reg_write,        // Enable writing

    input wire [4:0] rs1,        // First source register
    input wire [4:0] rs2,        // Second source register
    input wire [4:0] rd,         // Destination register

    input wire [31:0] write_data, // Data to write

    output wire [31:0] read_data1, // Value from rs1
    output wire [31:0] read_data2  // Value from rs2
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Read port 1
    // x0 always reads as 0
    assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];

    // Read port 2
    // x0 always reads as 0
    assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

    // Write port
    // Writing happens on rising clock edge
    always @(posedge clk) begin

        // Don't allow writing to x0
        if (reg_write && rd != 5'b00000)
            registers[rd] <= write_data;

    end

endmodule