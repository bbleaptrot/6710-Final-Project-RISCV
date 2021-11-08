//******************************************************//
//                                                      //
//  Project: ECE 6710 RISC-V                            //
//  Module : 32x32 regiter file                         //
//  Author : Allen Boston                               //
//  Date   : 10-15-2021                                 //                 
//                                                      //
//                                                      //
//******************************************************//



`timescale 1ns / 10ps

module regfile(
    input clk,
    input reg_write,
    input reset,
    
    input  [4:0]  addr_a,
    input  [4:0]  addr_b,
    input  [4:0]  addr_write,
    
    input  [31:0] data_write,
    output [31:0] data_a,
    output [31:0] data_b);

    

// initialize registers
reg [31:0]  register[31:0];

reg [31:0] data_out_a, data_out_b;

assign data_a = data_out_a;
assign data_b = data_out_b;
    

//initialize all registers to zero with reset pin
always@(posedge clk, negedge reset)
    begin
        if(reset == 1'b0)
        begin
            register[0]  <= 32'b0;
            register[1]  <= 32'b0;
            register[2]  <= 32'b0;
            register[3]  <= 32'b0;
            register[4]  <= 32'b0;
            register[5]  <= 32'b0;
            register[6]  <= 32'b0;
            register[7]  <= 32'b0;
            register[8]  <= 32'b0;
            register[9]  <= 32'b0;
            register[10] <= 32'b0;
            register[11] <= 32'b0;
            register[12] <= 32'b0;
            register[13] <= 32'b0;
            register[14] <= 32'b0;   
            register[15] <= 32'b0;
            register[16] <= 32'b0;
            register[17] <= 32'b0;
            register[18] <= 32'b0;
            register[19] <= 32'b0;
            register[20] <= 32'b0;
            register[21] <= 32'b0;
            register[22] <= 32'b0;
            register[23] <= 32'b0;
            register[24] <= 32'b0;
            register[25] <= 32'b0;
            register[26] <= 32'b0;
            register[27] <= 32'b0;
            register[28] <= 32'b0;
            register[29] <= 32'b0;
            register[30] <= 32'b0;
            register[31] <= 32'b0;
        end
		  else if(reg_write == 1'b1)
        begin
            register[addr_write] <= data_write;
            register[0] <= 32'b0;
        end
        
        else 
        begin
            data_out_a <= register[addr_a];
            data_out_b <= register[addr_b];
        end
    end

/*always@(posedge clk)
    begin
        if(reg_write == 1'b1)
        begin
            register[addr_write] = data_write;
            register[0] = 32'b0;
        end
        
        else 
        begin
            data_out_a = register[addr_a];
            data_out_b = register[addr_b];
        end
    end
   
endmodule
*/

endmodule 