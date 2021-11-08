module control(clk, rst, instruction, reg_en, reg_or_imm_mux, data_read, data_write, alu_op_code, alu_data_mux, pc_mux, reg_write/* state_counter*/);

input clk, rst;
input [31:0] instruction;

output reg [4:0] reg_en;
output reg [3:0] alu_op_code;
output reg reg_or_imm_mux, data_read, data_write, alu_data_mux, pc_mux, reg_write;

reg [3:0] state_counter = 4'b0000;


	//OpCode Parameters
	
	//R & I Type 
	parameter REG_TO_REG   = 7'b0110011;
	parameter IMM_TO_REG   = 7'b0010011;
	parameter LUI_TO_REG   = 7'b0110111;
	parameter AUIPC_TO_REG = 7'b0010111; // Adds 20 immediate bits to upper portion of program counter
	
	//Jump 
	parameter JAL_INSTR    = 7'b1101111;
	parameter JALR_INSTR   = 7'b1100111;
	
	//Branch
	parameter BRANCH_INSTR = 7'b1100011;
	
	//Load word, half-word, and byte from memory into RD
	parameter LOAD_WORD_RD = 7'b0000011;
	
	//Store word, half-word, and byte from R2 into memory
	parameter STORE_WORD_R2 = 7'b0100011;
	
	//FENCE and FENCE.I
	//parameter FENCE_INSTR  = 7'b0001111;
	
	//The rest of the instructions
	//parameter ADD_INSTRS   = 7'b1110011;
	
	// Next state logic
always @(posedge clk)
 begin
	if(rst == 0) state_counter <= 4'b0000;
	// Else, check if the state counter is at the end and if not increment it to the next state.
	else
	begin
		case(state_counter)
			0: state_counter <= 1;
			1: begin
					if(instruction[6:0] == REG_TO_REG  || 
						instruction[6:0] == IMM_TO_REG  || 
						instruction[6:0] == LUI_TO_REG  ||
						instruction[6:0] == AUIPC_TO_REG)       state_counter <= 4'b0010; // R or I type instruction
					else if(instruction[6:0] == STORE_WORD_R2) state_counter <= 4'b0011; // Store instruction
					else if(instruction[6:0] == LOAD_WORD_RD)  state_counter <= 4'b0100; // Load instruction
					else if(instruction[6:0] == BRANCH_INSTR)  state_counter <= 4'b0101; // Branch instruction
					else if(instruction[6:0] == JAL_INSTR ||
							  instruction[6:0] == JALR_INSTR)    state_counter <= 4'b0110; // Jump instruction
					else state_counter <= 4'b0010;// Everything else right now
				end
			2: state_counter <= 4'b0000;
			3: state_counter <= 4'b0000;
			4: state_counter <= 4'b0000;
			5: state_counter <= 4'b0000;
			6: state_counter <= 4'b0000;
			//7: state_counter <= 4'b0000;
			default: state_counter <= 0;
		endcase
	end
 end
 
 // Output logic
 always @(state_counter)
 begin
	case(state_counter)
		0: begin // Fetch stage
				reg_en        = 5'h0; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000;
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0;
				reg_write     = 1'b0;
				
			end
		1: begin // Decode Stage
				reg_en        = 5'h0; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000;
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0; 
				reg_write     = 1'b0;
				
			end
		2: begin // R-Type
				reg_en        = instruction[11:7]; 
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				reg_write     = 1'b1;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0;
				if(instruction[6:0] == IMM_TO_REG ||
					instruction[6:0] == LUI_TO_REG ||
					instruction[6:0] == AUIPC_TO_REG) 
					begin
						reg_or_imm_mux = 1'b1;
						alu_op_code = {instruction[30], instruction[14:12]};
					end
				else 
				begin
					reg_or_imm_mux = 1'b0;
					alu_op_code ={instruction[30], instruction[14:12]};
				end
				
			end
		3: begin // Store into memory
				reg_en        = 5'b0; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000; // Need to find out what no op or push Rs1 through
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b1;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0;
				reg_write     = 1'b0;
				
			end
		4: begin // Load
				reg_en        = instruction[11:7]; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000;
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b1;
				data_write    = 1'b0;
				alu_data_mux  = 1'b1;
				pc_mux        = 1'b0;
				reg_write     = 1'b1;
			end
		5: begin // Branch
				reg_en        = 5'h0; // Data isn't getting written back in this stage
				alu_op_code   = {1'b0, instruction[14:12]};
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b1;
				reg_write     = 1'b0;
				
			end
		6: begin // Jump
				reg_en        = 5'h0; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000;
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0;
				reg_write     = 1'b1;
				
			end
		default: begin
				reg_en        = 5'h0; // Data isn't getting written back in this stage
				alu_op_code   = 4'b0000;
				reg_or_imm_mux= 1'b0;
				data_read     = 1'b0;
				data_write    = 1'b0;
				alu_data_mux  = 1'b0;
				pc_mux        = 1'b0;
			end
	endcase
 end
 
endmodule
