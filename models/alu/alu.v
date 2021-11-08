
`timescale 1ns / 10ps

module alu(
    input  [31:0] op1,
    input  [31:0] op2,
    input  [3 :0] alu_op,
    
    output [31:0] alu_out,
	 output branch
);
    
    reg [31:0] result;
    assign alu_out = result;
	 reg branch_out;
	 assign branch = branch_out;
    always@(alu_op, op1, op2)
        begin
            case(alu_op)
                0: begin result = op1 + op2;  branch_out = 1'b0; end
                1: begin result = op1 - op2;  branch_out = 1'b0; end
                2: begin result = op1 & op2;  branch_out = 1'b0; end
                3: begin result = op1 | op2;  branch_out = 1'b0; end
                4: begin result = op1 ^ op2;  branch_out = 1'b0; end
                5: begin result = op1 > op2;  branch_out = op1 > op2; end
                6: begin result = op1 < op2;  branch_out = op1 < op2; end
                7: begin result = op1 >> op2; branch_out = 1'b0; end
                8: begin result = op1 << op2; branch_out = 1'b0; end
					 default: begin result = op1 & 0; branch_out = 1'b0; end
                
            endcase
        end
endmodule
