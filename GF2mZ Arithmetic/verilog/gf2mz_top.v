`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2019 09:50:38 AM
// Design Name: 
// Module Name: gf2mz_top
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
// n: degree of GF(2m)[z] polynomial  m: degree of GF(2m)  
// d: number of GF(2m) elements in each memory cell
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"
`include "clog2.v"

module gf2mz_top #(parameter n = 47, m = 79, d = 3, FILE_A = "mem_A.txt", FILE_B = "mem_B.txt")(
	input wire 				clk,
	input wire				rst_b,
	input wire 				start,

	output wire				done,
	output wire [m-1:0]		dout
    );

parameter WIDTH = m*d;
parameter DEPTH = (n/d) + ((n%d) != 0); //ceil(n/d)
parameter DELAY = 6; //set the cycle delay of GF2m multiplier



//for synthesis
/*parameter FILE_A = "mem_A.txt";
parameter FILE_B = "mem_B.txt";*/

//declare signals
wire [WIDTH-1:0] A_di, A_do;
wire [`CLOG2(DEPTH)-1:0] A_addr;
wire A_we;

wire [WIDTH-1:0] B_dia, B_doa, B_dib, B_dob;
wire [`CLOG2(DEPTH)-1:0] B_addra, B_addrb;
wire B_wea, B_web;

wire [WIDTH-1:0] C_di, C_do;
wire [`CLOG2(DEPTH)-1:0] C_addr;
wire C_we;

wire ctrl_start, ctrl_done;
wire mul_start;
wire mul00_done, mul01_done, mul02_done, 
mul10_done, mul11_done, mul12_done, 
mul20_done, mul21_done, mul22_done; 

wire [m-1:0]	mul00_op_a, mul00_op_b, mul00_op_c,
mul01_op_a, mul01_op_b, mul01_op_c,
mul02_op_a, mul02_op_b, mul02_op_c,
mul10_op_a, mul10_op_b, mul10_op_c,
mul11_op_a, mul11_op_b, mul11_op_c,
mul12_op_a, mul12_op_b, mul12_op_c,
mul20_op_a, mul20_op_b, mul20_op_c,
mul21_op_a, mul21_op_b, mul21_op_c,
mul22_op_a, mul22_op_b, mul22_op_c; 


//block RAM for A(z)
mem_sp mem_A(
	//input
	.clk (clk),
	.di (A_di),
	.addr (A_addr),
	.en (1'b1),
	.we (A_we),
 	//output
	.do (A_do)
);

defparam mem_A.WIDTH = WIDTH;
defparam mem_A.DEPTH = DEPTH;
defparam mem_A.FILE = FILE_A;

//block RAM for B(z)
mem_dp mem_B(
  //input
  .clka (clk),
  .wea (B_wea),
  .ena (1'b1),
  .dia (B_dia),
  .addra (B_addra),
  //output
  .doa (B_doa), 

  //input
  .clkb (clk),
  .web (B_web),
  .enb (1'b1),
  .dib (B_dib),
  .addrb (B_addrb),
  //output
  .dob (B_dob) 
);

defparam mem_B.WIDTH = WIDTH;
defparam mem_B.DEPTH = DEPTH;
defparam mem_B.FILE = FILE_B;

//block RAM for C(z): result of A(z)*B(z)
mem_sp mem_C(
	//input
	.clk (clk),
	.di (C_di),
	.addr (C_addr),
	.en (1'b1),
	.we (C_we),
 	//output
	.do (C_do)
);

defparam mem_C.WIDTH = WIDTH;
defparam mem_C.DEPTH = DEPTH;
defparam mem_C.FILE = "";

//GF(2m) multiplier instances, d*d arrays
gf2m_mul mul00 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul00_op_a),
	.op_b (mul00_op_b),

	.done (mul00_done),
	.op_c (mul00_op_c)
	);

defparam mul00.WIDTH = 79;
defparam mul00.k = 9;
defparam mul00.d = 16;

gf2m_mul mul01 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul01_op_a),
	.op_b (mul01_op_b),

	.done (mul01_done),
	.op_c (mul01_op_c)
	);

defparam mul01.WIDTH = 79;
defparam mul01.k = 9;
defparam mul01.d = 16;

gf2m_mul mul02 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul02_op_a),
	.op_b (mul02_op_b),

	.done (mul02_done),
	.op_c (mul02_op_c)
	);

defparam mul02.WIDTH = 79;
defparam mul02.k = 9;
defparam mul02.d = 16;

gf2m_mul mul10 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul10_op_a),
	.op_b (mul10_op_b),

	.done (mul10_done),
	.op_c (mul10_op_c)
	);

defparam mul10.WIDTH = 79;
defparam mul10.k = 9;
defparam mul10.d = 16;

gf2m_mul mul11 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul11_op_a),
	.op_b (mul11_op_b),

	.done (mul11_done),
	.op_c (mul11_op_c)
	);

defparam mul11.WIDTH = 79;
defparam mul11.k = 9;
defparam mul11.d = 16;

gf2m_mul mul12 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul12_op_a),
	.op_b (mul12_op_b),

	.done (mul12_done),
	.op_c (mul12_op_c)
	);

defparam mul12.WIDTH = 79;
defparam mul12.k = 9;
defparam mul12.d = 16;

gf2m_mul mul20 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul20_op_a),
	.op_b (mul20_op_b),

	.done (mul20_done),
	.op_c (mul20_op_c)
	);

defparam mul20.WIDTH = 79;
defparam mul20.k = 9;
defparam mul20.d = 16;

gf2m_mul mul21 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul21_op_a),
	.op_b (mul21_op_b),

	.done (mul21_done),
	.op_c (mul21_op_c)
	);

defparam mul21.WIDTH = 79;
defparam mul21.k = 9;
defparam mul21.d = 16;

gf2m_mul mul22 (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul22_op_a),
	.op_b (mul22_op_b),

	.done (mul22_done),
	.op_c (mul22_op_c)
	);

defparam mul22.WIDTH = 79;
defparam mul22.k = 9;
defparam mul22.d = 16;


//control logic for the multiplication of C(z) = A(z)*B(z)
mul_ctrl ctrl(
	.clk (clk),
	.rst_b (rst_b),
	.start(ctrl_start),
	.done(ctrl_done),

	//A interface
	.A_di (A_do), //input from A_do of mem_A
	.A_we (A_we),
	.A_addr (A_addr),
	.A_do (A_di), //output to A_di of mem_A

	//B interface
	.B_dia (B_doa),
	.B_wea (B_wea),
	.B_addra (B_addra),
	.B_doa (B_dia),
	.B_dib (B_dob),
	.B_web (B_web),
	.B_addrb (B_addrb),
	.B_dob (B_dib),

	//C interface
	.C_di (C_do),
	.C_we (C_we),
	.C_addr (C_addr),
	.C_do (C_di),

	//GF2m multiplier interface
	.mul_start(mul_start),
	.mul_done(mul00_done & mul01_done & mul02_done & mul10_done & mul11_done & mul12_done & mul20_done & mul21_done & mul22_done),

	.mul00_op_a(mul00_op_a),
	.mul00_op_b(mul00_op_b),
	.mul00_op_c(mul00_op_c),
	.mul01_op_a(mul01_op_a),
	.mul01_op_b(mul01_op_b),
	.mul01_op_c(mul01_op_c),
	.mul02_op_a(mul02_op_a),
	.mul02_op_b(mul02_op_b),
	.mul02_op_c(mul02_op_c),

	.mul10_op_a(mul10_op_a),
	.mul10_op_b(mul10_op_b),
	.mul10_op_c(mul10_op_c),
	.mul11_op_a(mul11_op_a),
	.mul11_op_b(mul11_op_b),
	.mul11_op_c(mul11_op_c),
	.mul12_op_a(mul12_op_a),
	.mul12_op_b(mul12_op_b),
	.mul12_op_c(mul12_op_c),

	.mul20_op_a(mul20_op_a),
	.mul20_op_b(mul20_op_b),
	.mul20_op_c(mul20_op_c),
	.mul21_op_a(mul21_op_a),
	.mul21_op_b(mul21_op_b),
	.mul21_op_c(mul21_op_c),
	.mul22_op_a(mul22_op_a),
	.mul22_op_b(mul22_op_b),
	.mul22_op_c(mul22_op_c)
);

defparam ctrl.WIDTH = WIDTH;
defparam ctrl.DEPTH = DEPTH;
defparam ctrl.m = m;
defparam ctrl.d = d;
defparam ctrl.DELAY = DELAY;


assign ctrl_start = start;
assign done = ctrl_done;
assign dout = {C_di[WIDTH-1:WIDTH-m] ^ C_di[WIDTH-m-1:WIDTH-2*m] ^ C_di[WIDTH-2*m-1:WIDTH-3*m]};

endmodule
