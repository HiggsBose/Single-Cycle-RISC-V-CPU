`include "src/defines.v"
module ALU (
    input [3:0] alu_type,
    input [31:0] op1, op2,
    output reg [31:0] alu_result,
    output reg zero, less_than
);
    always @(*) begin
        case (alu_type)
            `ADD : begin
                alu_result = op1 + op2;
                zero = 1'b0;
                less_than = 1'b0;
            end

            `SUB : begin
                alu_result = $signed(op1) - $signed(op2);
                zero = (alu_result == 0) ? 1 : 0;
                less_than = 1'b0;
            end

            `SLL : begin
                alu_result = op1 << op2;
                zero = 1'b0;
                less_than = 1'b0;
            end
            
            `SLT : begin
                alu_result = $signed(op1) < $signed (op2);
                zero = 1'b0;
                less_than = alu_result ? 1'b1 : 1'b0;
            end 
            
            `SLTU : begin
                alu_result = op1 < op2;
                zero = 1'b0;
                less_than = (alu_result) ? 1'b1 : 1'b0;
            end
            
            `XOR : begin
                alu_result = op1 ^ op2;
                zero = 1'b0;
                less_than = 1'b0;
            end
            
            `SRL : begin
                alu_result = op1 >> op2;
                zero = 1'b0;
                less_than = 1'b0;
            end
            
            `OR : begin
                alu_result = op1 | op2;
                zero = 1'b0;
                less_than = 1'b0;
            end
            
            `AND : begin
                alu_result = op1 & op2;
                zero = 1'b0;
                less_than = 1'b0;
            end
            
             `SRA : begin
                alu_result = $signed(op1) >>> op2;
                zero = 1'b0;
                less_than = 1'b0;
             end
             
            
            default: begin
                alu_result = 32'b0;
                zero = 1'b0;
                less_than = 1'b0;
            end
        endcase
    end
endmodule