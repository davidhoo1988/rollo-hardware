`timescale 1ns / 1ps

`include "clog2.v" 

module GF2m_mul_digit_penta #(parameter WIDTH = 67, k3 = 5, k2 = 2, k1 = 1, d = 16)(
	input wire clk,
	input wire rst_b,
	input wire start,
	input wire [WIDTH-1:0] op_a,
	input wire [WIDTH-1:0] op_b,

	output reg done,
	output wire [WIDTH-1:0] op_c
    );
parameter DIGIT_N = WIDTH/d + 1;
parameter WIDTH_A = d*(WIDTH/d)+d;

wire [WIDTH-1:0] cx1, cx;
wire [WIDTH-1:0] bx, bx0, bx1, bx2, bx3, bx4, bx5, bx6, bx7, bx8, bx9, bx10, bx11, bx12, bx13, bx14, bx15;

reg [WIDTH_A-1:0] a; //shift register to load/shift a(x)
reg [WIDTH-1:0] b; // keep b(x)
reg [WIDTH-1:0] c; //result register for a(x)*b(x)

reg start_en;
reg [`CLOG2(DIGIT_N)-1:0] cnt;

wire [WIDTH-1:0] op_a_BigEndian, op_b_BigEndian, op_c_BigEndian;
genvar w;
/* reorder byte ~ ~ */
generate
  for(w=0; w<WIDTH; w=w+1)
    begin : L0
          assign op_a_BigEndian[WIDTH-1-w] = op_a[w];
          assign op_b_BigEndian[WIDTH-1-w] = op_b[w];
          assign op_c[WIDTH-1-w] = op_c_BigEndian[w];
    end
endgenerate

//control signal
always @(posedge clk) begin
	if (!rst_b)
		start_en <= 1'b0;
	else if (start)
		start_en <= 1'b1;
	else if (cnt == DIGIT_N-1)
		start_en <= 1'b0;	
	else 
		start_en <= start_en;		
end

always @(posedge clk) begin
	if (!rst_b) 
		// reset
		cnt <= 0;
	else if (cnt == DIGIT_N-1)
		cnt <= 0;
	else if (start_en) 
		cnt <= cnt + 1'b1;
	else 
		cnt <= cnt;	
end

always @(posedge clk) begin
	if (!rst_b)
		done <= 1'b0;
	else if (cnt == DIGIT_N-1)
		done <= 1'b1;
	else
		done <= 1'b0;		
end



//arithmetic 
always @(posedge clk) begin
	if (!rst_b) 
		// reset
		a <= {WIDTH_A{1'b0}};
	else if (start) 
		a <= op_a_BigEndian;
	else if (start_en) //shift by digit
		a <= {a[WIDTH_A-d-1:0],{d{1'b0}}};
	else 
		a <= 0;	
end

always @(posedge clk) begin
	if (!rst_b) 
		// reset
		b <= {WIDTH{1'b0}};
	else if (start) 
		b <= op_b_BigEndian;
	else 
		b <= b;	
end

always @(posedge clk) begin
	if (!rst_b) 
		// reset
		c <= {WIDTH{1'b0}};
	else if (start)
		c <= {WIDTH{1'b0}};	
	else if (start_en) 
		c <= cx ^ bx;
	else 
		c <= c;	
end



//fraction(a(x))*b(x) mod f(x)
shift_x_by_i shift_1(
		.a(a[WIDTH_A-15]),
		.p(b),
		.px(bx1)
		);
defparam shift_1.WIDTH = WIDTH;
defparam shift_1.k3 = k3;
defparam shift_1.k2 = k2;
defparam shift_1.k1 = k1;
defparam shift_1.i = 1;

	
shift_x_by_i shift_2(
		.a(a[WIDTH_A-14]),
		.p(b),
		.px(bx2)
		);
defparam shift_2.WIDTH = WIDTH;
defparam shift_2.k3 = k3;
defparam shift_2.k2 = k2;
defparam shift_2.k1 = k1;
defparam shift_2.i = 2;

	
shift_x_by_i shift_3(
		.a(a[WIDTH_A-13]),
		.p(b),
		.px(bx3)
		);
defparam shift_3.WIDTH = WIDTH;
defparam shift_3.k3 = k3;
defparam shift_3.k2 = k2;
defparam shift_3.k1 = k1;
defparam shift_3.i = 3;

	
shift_x_by_i shift_4(
		.a(a[WIDTH_A-12]),
		.p(b),
		.px(bx4)
		);
defparam shift_4.WIDTH = WIDTH;
defparam shift_4.k3 = k3;
defparam shift_4.k2 = k2;
defparam shift_4.k1 = k1;
defparam shift_4.i = 4;

	
shift_x_by_i shift_5(
		.a(a[WIDTH_A-11]),
		.p(b),
		.px(bx5)
		);
defparam shift_5.WIDTH = WIDTH;
defparam shift_5.k3 = k3;
defparam shift_5.k2 = k2;
defparam shift_5.k1 = k1;
defparam shift_5.i = 5;

	
shift_x_by_i shift_6(
		.a(a[WIDTH_A-10]),
		.p(b),
		.px(bx6)
		);
defparam shift_6.WIDTH = WIDTH;
defparam shift_6.k3 = k3;
defparam shift_6.k2 = k2;
defparam shift_6.k1 = k1;
defparam shift_6.i = 6;

	
shift_x_by_i shift_7(
		.a(a[WIDTH_A-9]),
		.p(b),
		.px(bx7)
		);
defparam shift_7.WIDTH = WIDTH;
defparam shift_7.k3 = k3;
defparam shift_7.k2 = k2;
defparam shift_7.k1 = k1;
defparam shift_7.i = 7;

	
shift_x_by_i shift_8(
		.a(a[WIDTH_A-8]),
		.p(b),
		.px(bx8)
		);
defparam shift_8.WIDTH = WIDTH;
defparam shift_8.k3 = k3;
defparam shift_8.k2 = k2;
defparam shift_8.k1 = k1;
defparam shift_8.i = 8;

	
shift_x_by_i shift_9(
		.a(a[WIDTH_A-7]),
		.p(b),
		.px(bx9)
		);
defparam shift_9.WIDTH = WIDTH;
defparam shift_9.k3 = k3;
defparam shift_9.k2 = k2;
defparam shift_9.k1 = k1;
defparam shift_9.i = 9;

	
shift_x_by_i shift_10(
		.a(a[WIDTH_A-6]),
		.p(b),
		.px(bx10)
		);
defparam shift_10.WIDTH = WIDTH;
defparam shift_10.k3 = k3;
defparam shift_10.k2 = k2;
defparam shift_10.k1 = k1;
defparam shift_10.i = 10;

	
shift_x_by_i shift_11(
		.a(a[WIDTH_A-5]),
		.p(b),
		.px(bx11)
		);
defparam shift_11.WIDTH = WIDTH;
defparam shift_11.k3 = k3;
defparam shift_11.k2 = k2;
defparam shift_11.k1 = k1;
defparam shift_11.i = 11;

	
shift_x_by_i shift_12(
		.a(a[WIDTH_A-4]),
		.p(b),
		.px(bx12)
		);
defparam shift_12.WIDTH = WIDTH;
defparam shift_12.k3 = k3;
defparam shift_12.k2 = k2;
defparam shift_12.k1 = k1;
defparam shift_12.i = 12;

	
shift_x_by_i shift_13(
		.a(a[WIDTH_A-3]),
		.p(b),
		.px(bx13)
		);
defparam shift_13.WIDTH = WIDTH;
defparam shift_13.k3 = k3;
defparam shift_13.k2 = k2;
defparam shift_13.k1 = k1;
defparam shift_13.i = 13;

	
shift_x_by_i shift_14(
		.a(a[WIDTH_A-2]),
		.p(b),
		.px(bx14)
		);
defparam shift_14.WIDTH = WIDTH;
defparam shift_14.k3 = k3;
defparam shift_14.k2 = k2;
defparam shift_14.k1 = k1;
defparam shift_14.i = 14;

	
shift_x_by_i shift_15(
		.a(a[WIDTH_A-1]),
		.p(b),
		.px(bx15)
		);
defparam shift_15.WIDTH = WIDTH;
defparam shift_15.k3 = k3;
defparam shift_15.k2 = k2;
defparam shift_15.k1 = k1;
defparam shift_15.i = 15;

	
assign bx0 = a[WIDTH_A-16] ? b : {WIDTH{1'b0}};
assign bx = bx0 ^ bx1 ^ bx2 ^ bx3 ^ bx4 ^ bx5 ^ bx6 ^ bx7 ^ bx8 ^ bx9 ^ bx10 ^ bx11 ^ bx12 ^ bx13 ^ bx14 ^ bx15;
//c(x)x^d mod f(x)
shift_x_by_i shift_16(
	.a(1'b1),
	.p(c),
	.px(cx)
	);
defparam shift_16.WIDTH = WIDTH;
defparam shift_16.k3 = k3;
defparam shift_16.k2 = k2;
defparam shift_16.k1 = k1;
defparam shift_16.i = 16;


assign op_c_BigEndian = c;


endmodule



module shift_x_by_i #(parameter WIDTH = 67, k3 = 5, k2 = 2, k1 = 1, i = 16)(
	input wire a,
	input wire [WIDTH-1:0] p, //polynomial p(x), represented in big-endian notation
	output wire [WIDTH-1:0] px //output a * p(x)x^i mod f(x)
	);

wire [WIDTH-1:0] px1, px_k1, px_k2, px_k3;

assign px1 = {p[WIDTH-i-1:0], p[WIDTH-1:WIDTH-i]};
assign px_k1 = {px1[WIDTH-1:k1+i], {px1[k1+i-1:k1]^p[WIDTH-1:WIDTH-i]}, px1[k1-1:0]}; //add k1 terms
assign px_k2 = {px_k1[WIDTH-1:k2+i], {px_k1[k2+i-1:k2]^p[WIDTH-1:WIDTH-i]}, px_k1[k2-1:0]}; //add k2 terms
assign px_k3 = {px_k2[WIDTH-1:k3+i], {px_k2[k3+i-1:k3]^p[WIDTH-1:WIDTH-i]}, px_k2[k3-1:0]}; //add k3 terms

assign px = a ? px_k3 : {WIDTH{1'b0}};

endmodule
