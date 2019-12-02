`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2019 19:16:01
// Design Name: 
// Module Name: GF2m_mul_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GF2m_mul_tb;

parameter WIDTH = 89;
parameter k = 38;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul DUT(
	.clk(clk),
    .rst_b(rst_b), 
    .start(start),
    .done(done),
    .op_a(op_a),
    .op_b(op_b),
    .op_c(op_c)
  );
defparam DUT.WIDTH = WIDTH;
defparam DUT.k = k;

initial
    begin
      rst_b = 1'b0;
      start = 1'b0;
      # 50;
      rst_b <= 1'b1;
      # 100;
      start <= 1'b1;
      //start_time <= $time;
      op_a <= {'b11110100000010000101010101111010100001010010010101100000101011010000001100001100100110101};
      op_b <= {'b11000111011100110000110001101011011110110101100101111100010100111000010110010000100010100};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      op_a <= {'b1001000100000110101010110000010010000010010000010101001010110110111001010000100};
      op_b <= {'b1011010000110111101111110110100001001010001111110100010111100110111110101110010};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      op_a <= {'b1101010000111011110011010100110000000101101000110010010011100110100100101100111};
      op_b <= {'b1011010111000011101000011000100111011101100111011111001011110011110011010000110};
      # 10;
      start <= 1'b0;

      # 1000;

      $finish;
    end

always
	begin
	  clk = 1'b1;
	  #5;
	  clk = 1'b0;
	  #5;
	end

endmodule
