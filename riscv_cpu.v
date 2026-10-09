
module riscv_cpu (
    input wire clk,
    input wire reset
);

    reg [31:0] pc;

    // 32 general-purpose registers
    reg [31:0] x [0:31];

    // Instruction memory: 256 instructions
    reg [31:0] imem [0:255];

    // Data memory: 1024 bytes
    reg [7:0] dmem [0:1023];

    wire [31:0] instr = imem[pc[9:2]];

    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    reg [31:0] a, b, imm, result, address;
    reg branch_taken;
    integer i;

    always @(*) begin
        a = x[rs1];
        b = x[rs2];
        imm = {{20{instr[31]}}, instr[31:20]};
        result = 0;
        address = 0;
        branch_taken = 0;

        case (opcode)

        
            // R-type instructions
            7'b0110011: begin
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000)
                            result = a + b; // ADD
                        else if (funct7 == 7'b0100000)
                            result = a - b; // SUB
                        else
                            result = 0;
                    end

                    3'b001:
                        result = (funct7 == 7'b0000000)
                               ? a << b[4:0] : 0; // SLL

                    3'b010:
                        result = (funct7 == 7'b0000000)
                               ? ($signed(a) < $signed(b)) : 0; // SLT

                    3'b011:
                        result = (funct7 == 7'b0000000)
                               ? (a < b) : 0; // SLTU

                    3'b100:
                        result = (funct7 == 7'b0000000)
                               ? (a ^ b) : 0; // XOR

                    3'b101: begin
                        if (funct7 == 7'b0000000)
                            result = a >> b[4:0]; // SRL
                        else if (funct7 == 7'b0100000)
                            result = $signed(a) >>> b[4:0]; // SRA
                        else
                            result = 0;
                    end

                    3'b110:
                        result = (funct7 == 7'b0000000)
                               ? (a | b) : 0; // OR

                    3'b111:
                        result = (funct7 == 7'b0000000)
                               ? (a & b) : 0; // AND

                    default: result = 0;
                endcase
            end


            // I-type arithmetic instructions
            7'b0010011: begin
                case (funct3)
                    3'b000: result = a + imm; // ADDI
                    3'b010: result = ($signed(a) < $signed(imm));
                    3'b011: result = (a < imm);
                    3'b100: result = a ^ imm;
                    3'b110: result = a | imm;
                    3'b111: result = a & imm;
                   
3'b001: begin
    if (instr[31:25] == 7'b0000000)
        result = a << instr[24:20]; // SLLI
    else
        result = 0;
end

3'b101: begin
    if (instr[31:25] == 7'b0000000)
        result = a >> instr[24:20]; // SRLI
    else if (instr[31:25] == 7'b0100000)
        result = $signed(a) >>> instr[24:20]; // SRAI
    else
        result = 0;
end

                endcase
            end

            // LUI
            7'b0110111: result = {instr[31:12], 12'b0};

            // AUIPC
            7'b0010111: result = pc + {instr[31:12], 12'b0};

            // JAL
            7'b1101111: begin
                result = pc + 4;
                imm = {{11{instr[31]}}, instr[31],
                       instr[19:12], instr[20],
                       instr[30:21], 1'b0};
            end

            // JALR
            7'b1100111: begin
                result = pc + 4;
                imm = {{20{instr[31]}}, instr[31:20]};
            end

            // Conditional branches
            7'b1100011: begin
                imm = {{19{instr[31]}}, instr[31],
                       instr[7], instr[30:25],
                       instr[11:8], 1'b0};

                case (funct3)
                    3'b000: branch_taken = (a == b);
                    3'b001: branch_taken = (a != b);
                    3'b100: branch_taken = ($signed(a) < $signed(b));
                    3'b101: branch_taken = ($signed(a) >= $signed(b));
                    3'b110: branch_taken = (a < b);
                    3'b111: branch_taken = (a >= b);
                endcase
            end

            // Loads: LB, LH, LW, LBU, LHU
            7'b0000011: begin
                address = a + imm;
                case (funct3)
                    3'b000: result = {
                        {24{dmem[address[9:0]][7]}},
                        dmem[address[9:0]]
                    };
                    3'b001: result = {
                        {16{dmem[address[9:0] + 10'd1][7]}},
                        dmem[address[9:0] + 10'd1],
                        dmem[address[9:0]]
                    };
                    3'b010: result = {
                        dmem[address[9:0] + 10'd3],
                        dmem[address[9:0] + 10'd2],
                        dmem[address[9:0] + 10'd1],
                        dmem[address[9:0]]
                    };
                    3'b100: result = {
                        24'b0, dmem[address[9:0]]
                    };
                    3'b101: result = {
                        16'b0,
                        dmem[address[9:0] + 10'd1],
                        dmem[address[9:0]]
                    };
                    default: result = 0;
                endcase
            end

            // Stores: SB, SH, SW
            7'b0100011: begin
                imm = {{20{instr[31]}}, instr[31:25],
                       instr[11:7]};
                address = a + imm;
            end

            default: begin
                result = 0;
            end
        endcase
    end

    // Sequential state updates
    always @(posedge clk) begin
        if (reset) begin
            pc <= 0;
            for (i = 0; i < 32; i = i + 1)
                x[i] <= 0;
        end
        else begin
            x[0] <= 0;
            pc <= pc + 4;

            case (opcode)

                // R-type and I-type arithmetic
                7'b0110011, 7'b0010011:
                    if (rd != 0)
                        x[rd] <= result;

                // LUI and AUIPC
                7'b0110111, 7'b0010111:
                    if (rd != 0)
                        x[rd] <= result;

                // Loads
                7'b0000011:
                    if (rd != 0)
                        x[rd] <= result;

                // Stores
                7'b0100011: begin
                    case (funct3)
                        3'b000:
                            dmem[address[9:0]] <= b[7:0];
                        3'b001: begin
                            dmem[address[9:0]] <= b[7:0];
                            dmem[address[9:0] + 10'd1] <= b[15:8];
                        end
                        3'b010: begin
                            dmem[address[9:0]] <= b[7:0];
                            dmem[address[9:0] + 10'd1] <= b[15:8];
                            dmem[address[9:0] + 10'd2] <= b[23:16];
                            dmem[address[9:0] + 10'd3] <= b[31:24];
                        end
                    endcase
                end

                // Branches
                7'b1100011:
                    if (branch_taken)
                        pc <= pc + imm;

                // JAL
                7'b1101111: begin
                    if (rd != 0)
                        x[rd] <= pc + 4;
                    pc <= pc + imm;
                end

                // JALR
                7'b1100111: begin
                    if (rd != 0)
                        x[rd] <= pc + 4;
                    pc <= (a + imm) & 32'hfffffffe;
                end

            endcase
        end
    end

endmodule
