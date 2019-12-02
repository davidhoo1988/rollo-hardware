`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2019 06:30:20 PM
// Design Name: 
// Module Name: GF2m_mul_digit_penta_tb
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


module GF2m_mul_digit_penta_tb;

parameter WIDTH = 83;
parameter k3 = 7, k2 = 4, k1 = 2;
parameter d = 16;

reg clk, rst_b, start;
reg [WIDTH-1:0] op_a, op_b;
wire done;
wire [WIDTH-1:0] op_c;

GF2m_mul_digit_penta DUT(
	.clk(clk),
    .rst_b(rst_b), 
    .start(start),
    .done(done),
    .op_a(op_a),
    .op_b(op_b),
    .op_c(op_c)
  );
defparam DUT.WIDTH = WIDTH;
defparam DUT.k3 = k3;
defparam DUT.k2 = k2;
defparam DUT.k1 = k1;
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
      op_a <= {'b11000001001100111001000000111110110111011110101110110011110010110100110011111000100};
      op_b <= {'b11001011101010011010001100010001011011010001010011011000011000000110110010111110111};
      # 10;
      start <= 1'b0;

      //@(posedge done);
      //$display("\nruntime: %0d cycles\n", ($time - start_time)/10);

      # 1000;
      start <= 1'b1;
      op_a <= {'b10101110010110001000100000110101010110000010010000010010000010101001010110110111001};
      op_b <= {'b10010010110011110110100001101111011111101101000010010100011111101000101111001101111};
      # 10;
      start <= 1'b0;

      # 1000;
      start <= 1'b1;
      op_a <= {'b10111100110100001101101010000111011110011010100110000000101101000110010010011100110};
      op_b <= {'b10101111100010111001010001011010111000011101000011000100111011101100111011111001011};
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
