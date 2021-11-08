
//******************************************************//
//                                                      //
//  Project: ECE 6710 RISC-V                            //
//  Module : 32x32 regiter file testbench               //
//  Author : Allen Boston                               //
//  Date   : 10-15-2021                                 //                 
//                                                      //
//                                                      //
//******************************************************//



`timescale  1ns / 10ps


module regfile_tb;

    reg clk = 1'b0;

    localparam period       = 20;
    localparam halfperiod   = 10;


    reg reg_write = 1'b0;
    reg reset     = 1'b1;

    reg [4:0]  addr_a      = 0;
    reg [4:0]  addr_b      = 0;
    reg [4:0]  addr_write  = 5'b0;
    
    reg [31:0] data_write  = 32'b0;
    


    regfile uut 
    (
    .clk(clk),
    .reg_write(reg_write),
    .reset(reset),
    .addr_a(addr_a),
    .addr_b(addr_b),
    .addr_write(addr_write),

    .data_write(data_write),
    .data_a(data_a),
    .data_b(data_b) 
    );


    initial
    begin
        clk = 1'b0;
        forever
        #halfperiod clk = ~clk;
    end


    initial 
    begin
        data_write <= 32'd45;
        addr_write <= 5'd4;
        #period;
        reg_write  <= 1'b1;
        #period
        reg_write  <= 1'b0;

        data_write <= 32'd64;
        addr_write <= 5'd5;        
        #period;
        reg_write  <= 1'b1;
        #period
        reg_write  <= 1'b0;

        data_write <= 32'd256;
        addr_write <= 5'd0;
        #period
        reg_write  <= 1'b1;
        #period
        reg_write  <= 1'b0;

        
        addr_a    <= 5'd5;
        addr_b    <= 5'd4;
        
        #period;
        #period;
        $stop;
    end 
    
endmodule    
