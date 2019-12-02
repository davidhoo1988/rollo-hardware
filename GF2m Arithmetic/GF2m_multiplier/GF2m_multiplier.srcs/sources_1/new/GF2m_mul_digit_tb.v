`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2019 06:46:08 PM
// Design Name: 
// Module Name: GF2m_mul_digit_tb
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


module GF2m_mul_digit_tb;

parameter WIDTH = 89;
parameter k = 38;
parameter d = 8;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul_digit DUT(
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
defparam DUT.d = d;

initial
    begin
      rst_b = 1'b0;
      start = 1'b0;
      # 50;
      rst_b <= 1'b1;
      # 100;
      start <= 1'b1;
      //start_time <= $time;
      /*op_a <= {'b1001001100111001000000111110110111011110101110110011110010110100110011111000100};
      op_b <= {'b1011101010011010001100010001011011010001010011011000011000000110110010111110111};*/
      op_a <= {'b11011111000001001100111001000000111110110111011110101110110011110010110100110011111000100};
      op_b <= {'b11110010100001001011101010011010001100010001011011010001010011011000011000000110110010111};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      /*op_a <= {'b1001000100000110101010110000010010000010010000010101001010110110111001010000100};
      op_b <= {'b1011010000110111101111110110100001001010001111110100010111100110111110101110010};*/
      op_a <= {'b10111100110111110101110010110001000100000110101010110000010010000010010000010101001010110};
      op_b <= {'b10011001001001110011010010010110011110110100001101111011111101101000010010100011111101000};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      /*op_a <= {'b1101010000111011110011010100110000000101101000110010010011100110100100101100111};
      op_b <= {'b1011010111000011101000011000100111011101100111011111001011110011110011010000110};*/
      op_a <= {'b11101110110011101111100101111001111001101000011011010100001110111100110101001100000001011};
      op_b <= {'b11011111010001010011110000010101010101111100010111001010001011010111000011101000011000100};
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
