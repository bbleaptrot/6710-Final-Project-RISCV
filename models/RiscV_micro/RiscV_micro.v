module RiscV_micro(clk, rst);

//inputs
input clk, rst;

//wires--ALU
wire [31:0] op1, op2, alu_out;

//wires--control
wire [31:0] instruction;
wire [3:0] alu_op_code;
wire reg_or_imm_mux, data_read, data_write, alu_data_mux, pc_mux, reg_write, pc_en;

//wires--instruction memory
wire [11:0] program_counter, pc_increment, pc_augment;
wire [31:0] instruction_out;

//wires--data memory
wire [31:0] data_from_mem;

//wires--registers
//wire [31:0] rs1, rs2;

//wires --mux outs
wire [31:0] reg_or_imm_out, alu_data_out, pc_out;

wire branch;

wire temp;
assign temp = pc_mux & branch;


//parameters

	alu logic_unit(
	.op1(op1),
	.op2(reg_or_imm_out),
	.alu_op(alu_op_code),
	.alu_out(alu_out),
	.branch(branch)
	);
	
	regfile regi(
	.clk(clk),
	.reset(rst),
	.reg_write(reg_write),
	.addr_write(instruction_out[11:7]),
	.addr_a(instruction_out[19:15]),
	.addr_b(instruction_out[24:20]),
	.data_write(alu_data_out),
	.data_a(op1),
	.data_b(op2)
	);
	
	control control_unit(
	.clk(clk),
	.rst(rst),
	.instruction(instruction_out),
	.alu_op_code(alu_op_code),
	.reg_or_imm_mux(reg_or_imm_mux),
	.data_read(data_read),
	.data_write(data_write),
	.alu_data_mux(alu_data_mux),
	.pc_mux(pc_mux),
	.reg_write(reg_write),
	.pc_en(pc_en)
	);
	
	instruction_memory inst_mem(
	.program_counter(program_counter),
	.clk(clk),
	.q_a(instruction_out)
	);
	
	data_memory data_mem(
	.data_a(op2),
	.addr_a(alu_out),
	.we_a(data_write),
	.re_a(data_read),
	.clk(clk),
	.q_a(data_from_mem)
	);
	
	
	mux_32_2_to_1 alu_or_data(
	.in_a(alu_out),
	.in_b(data_from_mem),
	.cntl(alu_data_mux),
	.mux_out(alu_data_out)
	);
	
	mux_32_2_to_1 reg_or_imm(
	.in_a(op2),
	.in_b(instruction_out),
	.cntl(reg_or_imm_mux),
	.mux_out(reg_or_imm_out)
	);
	
	mux_12_2_to_1 inc_or_aug(
	.in_a(pc_increment),
	.in_b(pc_augment),
	.cntl(temp),
	.mux_out(pc_out)
	);
	
	pc_incrementor pc_adder(
	.input_1(program_counter),
	.output_add(pc_increment)
	);	
	
	pc_augmentor pc_augger(
	.input_1(program_counter),
	.input_2({instruction_out[31], instruction_out[7], instruction[30:25], instruction[11:8]}),
	.output_augment(pc_augment)
	);
	
	program_counter the_count(
	.clk(clk),
	.rst(rst),
	.next_position(pc_out),
	.current_position(program_counter),
	.pc_en(pc_en)
	);
	
	
endmodule 

module mux_32_2_to_1(in_a, in_b, cntl, mux_out);

input [31:0] in_a, in_b;
input cntl;

output reg[31:0] mux_out;

always@(*)
	begin
	case(cntl)
		0: mux_out = in_a;
		1: mux_out = in_b;
	endcase
	end
endmodule 

module mux_12_2_to_1(in_a, in_b, cntl, mux_out);

input [11:0] in_a, in_b;
input cntl;

output reg[11:0] mux_out;

always@(*)
	begin
	case(cntl)
		0: mux_out = in_a;
		1: mux_out = in_b;
	endcase
	end
endmodule 

module pc_incrementor(input_1, output_add);

input [11:0] input_1;
output reg [11:0] output_add;

initial
begin
	output_add <= 12'd0;
end
always@(*)
	begin
	output_add <= input_1 + 12'd1;
	end
endmodule


module pc_augmentor(input_1, input_2, output_augment);

input [11:0] input_1, input_2;
output reg [11:0] output_augment;

initial
begin
	output_augment <= 12'd0;
end

always@(*)
	begin
	output_augment <= input_1 + input_2;
	end
endmodule

module program_counter(clk, rst, pc_en, next_position, current_position);
input clk, rst, pc_en;
input [11:0] next_position;
output[11:0] current_position;

reg [11:0] current;
initial
begin
current = 12'd0;
end
assign current_position = current;
always@(posedge clk) 
begin

	if(rst == 0) current <= 12'b0;
	else if(pc_en == 0) current <= current;
	else current <= next_position;
end   

endmodule
	

