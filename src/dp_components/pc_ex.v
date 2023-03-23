`include "src/defines.v"

module PCExecute (
    input branch, jal, jalr,
    input [2:0] branch_type,
    input [31:0] rs1_data, imm, pc,
    input zero, less_than,
    output reg pc_src,
    output reg[31:0] new_pc
);

    always @(*) begin
        pc_src = `PC_PLUS4;
        new_pc = 32'b0;
        if(jal) begin
            new_pc = pc + imm;    // JAL and JALr is using current PC/register_data to add immediate number to generate the next pc 
            pc_src = `NEW_PC;
        end
        else if(jalr)begin
            new_pc = rs1_data + imm;
            pc_src = `NEW_PC;
        end
        else if(branch) begin
            case (branch_type)
                `BEQ: begin
                    if(zero) begin
                        pc_src = `NEW_PC;
                        new_pc = pc + imm;
                    end
                end 
                `BNE: begin
                    if(~zero) begin
                        pc_src = `NEW_PC;
                        new_pc = pc + imm;
                    end
                end
                `BGEU, `BGE: begin
                    if(~less_than) begin
                        pc_src = `NEW_PC;
                        new_pc = pc + imm;
                    end
                end
                `BLTU, `BLT: begin
                    if(less_than) begin
                        pc_src = `NEW_PC;
                        new_pc = pc + imm;
                    end
                end
                default: begin
                    pc_src = `NEW_PC;
                    new_pc = 32'h00000000;
                end 
            endcase
        end

        else begin
            pc_src = `PC_PLUS4;
            new_pc = 32'h00000000;
        end

    end
endmodule