//Testbench for state_machine
`timescale 1ns / 1ps

module tb_state_machine;

//Inputs
reg clk, rst;
reg [31:0] instruction, data_from_mem;
reg [4:0] FLAGS;

//Outputs
wire PCen, RegOrImm, WE, ALU_MUX_CNTL, LS_CNTL, branch, jump, IEn, flagEn;
wire [3:0] state_counter;
wire [31:0] Ren;

// Parameters --> Cannot be changed
parameter funct7_0 = 7'b0000000;
parameter funct7_1 = 7'b0100000;

parameter reg_to_reg = 7'b0110011;
parameter imm_to_reg = 7'b0010011;
parameter reg_to_mem = 7'b0100011;
parameter mem_to_reg = 7'b0000011;

parameter branch_inst = 7'b1100011;

parameter jal_inst    = 7'b1101111;
parameter jalr_inst   = 7'b1100111;

parameter lui_inst    = 7'b0110111;
parameter auipc_inst  = 7'b0010111;

parameter r_ADD  = 3'b000;
parameter r_SUB  = 3'b000;
parameter r_SLL  = 3'b001;
parameter r_SLT  = 3'b010;
parameter r_SLTU = 3'b011;
parameter r_XOR  = 3'b100;
parameter r_SRL  = 3'b101;
parameter r_SRA  = 3'b101;
parameter r_OR   = 3'b110;
parameter r_AND  = 3'b111;

parameter i_ADD  = 3'b000;
parameter i_SLT  = 3'b010;
parameter i_SLTU = 3'b011;
parameter i_XOR  = 3'b100;
parameter i_OR   = 3'b110;
parameter i_AND  = 3'b111;
parameter i_SLL  = 3'b001;
parameter i_SRL  = 3'b101;
parameter i_SRA  = 3'b101;

parameter s_BYTE = 3'b000;
parameter s_HWORD = 3'b001;
parameter s_WORD  = 3'b010;

parameter l_BYTE = 3'b000;
parameter l_HWORD = 3'b001;
parameter l_WORD = 3'b010;
parameter l_BYTEU = 3'b100;
parameter l_HWORDU = 3'b101;

parameter b_EQ = 3'b000;
parameter b_NE = 3'b001;
parameter b_LT = 3'b100;
parameter b_GE = 3'b101;
parameter b_LTU = 3'b110;
parameter b_GEU = 3'b111;

parameter j_R = 3'b000;

// Changeable Parameters
parameter rs1 = 5'b00001;
parameter rs2 = 5'b00010;
parameter rsd = 5'b00011;

parameter imm_31to12 = 20'd42;

parameter imm_20_10to1_11_19to12 = 20'd0;

parameter imm_11to0 = 12'd42;

parameter imm_12_10to5 = 7'd0;

parameter imm_4to1_11 = 5'd0;

parameter imm_11to5 = 7'd0;

parameter imm_4to0  = 5'd0;


parameter shamt = 5'd2;
//TODO: Add parameters for the various commands to improve readability and allow for quicker changes

	state_machine UUT(
		clk, rst, instruction, data_from_mem, branch, jump, FLAGS, PCen, Ren, RegOrImm, WE, IEn, ALU_MUX_CNTL, LS_CNTL, flagEn, state_counter
	);
	
	initial 
	begin
		clk = 1'b1;
		rst = 1'b0;
		instruction = 32'd0;
		data_from_mem = 32'd0;
		FLAGS = 5'd0;
		
		
		#20;
		
		instruction   = {funct7_0,rs2,rs1,r_ADD,rsd,reg_to_reg}; // ADD R2 + R1 --> R3
		data_from_mem = {funct7_0,rs2,rs1,r_ADD,rsd,reg_to_reg};
		
		#30;
		
		instruction   = {imm_11to0,rs1,i_ADD,rsd,imm_to_reg}; // ADDI 42 + R2 --> R3
		data_from_mem = {imm_11to0,rs1,i_ADD,rsd,imm_to_reg};
		
		#30;
		
		instruction   = {imm_31to12,rsd,lui_inst}; // LUI 42       --> R3
		data_from_mem = {imm_31to12,rsd,lui_inst};
		
		#30;
		
		instruction   = {imm_31to12,rsd,auipc_inst}; // AUIPC 42     --> R3
		data_from_mem = {imm_31to12,rsd,auipc_inst};
		
		#30;
		
		instruction   = {imm_11to0, rs1, i_SLT, rsd, imm_to_reg}; // SLTI 42 compare R2 --> R3
		data_from_mem = {imm_11to0, rs1, i_SLT, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {imm_11to0, rs1, i_SLTU, rsd, imm_to_reg}; // SLTIU 42 compare R2 --> R3
		data_from_mem = {imm_11to0, rs1, i_SLTU, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {imm_11to0, rs1, i_XOR, rsd, imm_to_reg}; // XORI 42 with R2 --> R3
		data_from_mem = {imm_11to0, rs1, i_XOR, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {imm_11to0, rs1, i_OR, rsd, imm_to_reg}; // ORI 42 || R2 --> R3
		data_from_mem = {imm_11to0, rs1, i_OR, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {imm_11to0, rs1, i_AND, rsd, imm_to_reg}; // ANDI 42 * R2 --> R3
		data_from_mem = {imm_11to0, rs1, i_AND, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {funct7_0, shamt, rs1, i_SLL, rsd, imm_to_reg}; // SLLI R2 << 2 --> R3
		data_from_mem = {funct7_0, shamt, rs1, i_SLL, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {funct7_0, shamt, rs1, i_SRL, rsd, imm_to_reg}; // SRLI R2 >> 2 --> R3
		data_from_mem = {funct7_0, shamt, rs1, i_SRL, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {funct7_1, shamt, rs1, i_SRA, rsd, imm_to_reg}; // SRAI R2 >> 10 --> R3
		data_from_mem = {funct7_1, shamt, rs1, i_SRA, rsd, imm_to_reg};
		
		#30;
		
		instruction   = {funct7_1, rs2, rs1, r_SUB, rsd, reg_to_reg}; // SUB R2 - R1 --> R3
		data_from_mem = {funct7_1, rs2, rs1, r_SUB, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_SLL, rsd, reg_to_reg}; // SLL R1 << R2 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_SLL, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_SLT, rsd, reg_to_reg}; // SLT R2 compare R1 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_SLT, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_SLTU, rsd, reg_to_reg}; // SLTU R2 compare R1 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_SLTU, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_XOR, rsd, reg_to_reg}; // XOR R2 with R1 --> R3 
		data_from_mem = {funct7_0, rs2, rs1, r_XOR, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_SRL, rsd, reg_to_reg}; // SRL R1 >> R2 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_SRL, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_1, rs2, rs1, r_SRA, rsd, reg_to_reg}; // SRA R1 >> R2 --> R3
		data_from_mem = {funct7_1, rs2, rs1, r_SRA, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_OR, rsd, reg_to_reg}; // OR R2 || R1 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_OR, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {funct7_0, rs2, rs1, r_AND, rsd, reg_to_reg}; // AND R2 * R1 --> R3
		data_from_mem = {funct7_0, rs2, rs1, r_AND, rsd, reg_to_reg};
		
		#30;
		
		instruction   = {imm_11to0, rs1, l_BYTE, rsd, mem_to_reg}; // LB into R2 immediate = 42
		data_from_mem = {imm_11to0, rs1, l_BYTE, rsd, mem_to_reg};
		
		#40;
		
		instruction   = {imm_11to0, rs1, l_HWORD, rsd, mem_to_reg}; // LH into R2 immediate = 42
		data_from_mem = {imm_11to0, rs1, l_HWORD, rsd, mem_to_reg};
		
		#40;
		
		instruction   = {imm_11to0, rs1, l_WORD, rsd, mem_to_reg}; // LW into R2 immediate = 42
		data_from_mem = {imm_11to0, rs1, l_WORD, rsd, mem_to_reg};
		
		#40;
		
		instruction   = {imm_11to0, rs1, l_BYTEU, rsd, mem_to_reg}; // LBU
		data_from_mem = {imm_11to0, rs1, l_BYTEU, rsd, mem_to_reg};
		
		#40;
		
		instruction   = {imm_11to0, rs1, l_HWORDU, rsd, mem_to_reg}; // LHU
		data_from_mem = {imm_11to0, rs1, l_HWORDU, rsd, mem_to_reg};
		
		#40;
		
		instruction   = {imm_11to5, rs2, rs1, s_BYTE, imm_4to0, reg_to_mem}; // SB imm[4:0] = 3, imm[11:5] = 1 rs2 = 2, rs1 = 1 --> right here
		data_from_mem = {imm_11to5, rs2, rs1, s_BYTE, imm_4to0, reg_to_mem};
		
		#30;
		
		instruction   = {imm_11to5, rs2, rs1, s_HWORD, imm_4to0, reg_to_mem}; // SH
		data_from_mem = {imm_11to5, rs2, rs1, s_HWORD, imm_4to0, reg_to_mem};
		
		#30;
		
		instruction   = {imm_11to5, rs2, rs1, s_WORD, imm_4to0, reg_to_mem}; // SW
		data_from_mem = {imm_11to5, rs2, rs1, s_WORD, imm_4to0, reg_to_mem};
		
		#30;
		
		instruction   = {imm_20_10to1_11_19to12, rsd, jal_inst}; // JAL rd = 3 imm20 = 0 imm10-1 = 21 imm11 = 0 imm19-12 = 0
		data_from_mem = {imm_20_10to1_11_19to12, rsd, jal_inst};
		
		#30;
		
		instruction   = {imm_11to0, rs1, j_R, rsd, jalr_inst}; // JALR imm11-0 = 42 rs1 = 2
		data_from_mem = {imm_11to0, rs1, j_R, rsd, jalr_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_EQ, imm_4to1_11, branch_inst}; // BEQ R2 compare R1 imm12 = 0 imm10-5 = 1 rs2 = 2 rs1 = 1
		data_from_mem = {imm_12_10to5, rs2, rs1, b_EQ, imm_4to1_11, branch_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_NE, imm_4to1_11, branch_inst}; // BNE R2 compare R1 
		data_from_mem = {imm_12_10to5, rs2, rs1, b_NE, imm_4to1_11, branch_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_LT, imm_4to1_11, branch_inst}; // BLT R2 compare R1 
		data_from_mem = {imm_12_10to5, rs2, rs1, b_LT, imm_4to1_11, branch_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_GE, imm_4to1_11, branch_inst}; // BGE R2 compare R1 
		data_from_mem = {imm_12_10to5, rs2, rs1, b_GE, imm_4to1_11, branch_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_LTU, imm_4to1_11, branch_inst}; // BLTU R2 compare R1 
		data_from_mem = {imm_12_10to5, rs2, rs1, b_LTU, imm_4to1_11, branch_inst};
		
		#30;
		
		instruction   = {imm_12_10to5, rs2, rs1, b_GEU, imm_4to1_11, branch_inst}; // BGEU R2 compare R1 
		data_from_mem = {imm_12_10to5, rs2, rs1, b_GEU, imm_4to1_11, branch_inst};
		
		#30;
		
	//	instruction   = 32'b00000010101000010000000110010011; // FENCE
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // FENCE.I
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // ECALL
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // EBREAK
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRW
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRS
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRC
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRWI
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRSI
	//	data_from_mem = 32'b00000010101000010000000110010011;
	//	
	//	#10;
	//	
	//	instruction   = 32'b00000010101000010000000110010011; // CSRRCI
	//	data_from_mem = 32'b00000010101000010000000110010011;
		
		#10;
		
		#100;
	
	end
	
	
	
	
	always
		#5 clk = !clk;
		
		
endmodule 