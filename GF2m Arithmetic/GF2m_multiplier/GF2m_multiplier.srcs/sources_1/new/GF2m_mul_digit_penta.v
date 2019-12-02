`timescale 1ns / 1ps

`include "clog2.v" 

module GF2m_mul_digit_penta #(parameter WIDTH = 131, k3 = 8, k2 = 3, k1 = 2, d = 32)(
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
wire [WIDTH-1:0] bx, bx0, bx1, bx2, bx3, bx4, bx5, bx6, bx7, bx8, bx9, bx10, bx11, bx12, bx13, bx14, bx15, bx16, bx17, bx18, bx19, bx20, bx21, bx22, bx23, bx24, bx25, bx26, bx27, bx28, bx29, bx30, bx31;

reg [WIDTH_A-1:0] a; //shift register to load/shift a(x)
reg [WIDTH-1:0] b; // keep b(x)
reg [WIDTH-1:0] c; //result register for a(x)*b(x)

reg start_en;
reg [`CLOG2(DIGIT_N)-1:0] cnt;

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
		a <= op_a;
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
		b <= op_b;
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
		.a(a[WIDTH_A-31]),
		.p(b),
		.px(bx1)
		);
defparam shift_1.WIDTH = WIDTH;
defparam shift_1.k3 = k3;
defparam shift_1.k2 = k2;
defparam shift_1.k1 = k1;
defparam shift_1.i = 1;

	
shift_x_by_i shift_2(
		.a(a[WIDTH_A-30]),
		.p(b),
		.px(bx2)
		);
defparam shift_2.WIDTH = WIDTH;
defparam shift_2.k3 = k3;
defparam shift_2.k2 = k2;
defparam shift_2.k1 = k1;
defparam shift_2.i = 2;

	
shift_x_by_i shift_3(
		.a(a[WIDTH_A-29]),
		.p(b),
		.px(bx3)
		);
defparam shift_3.WIDTH = WIDTH;
defparam shift_3.k3 = k3;
defparam shift_3.k2 = k2;
defparam shift_3.k1 = k1;
defparam shift_3.i = 3;

	
shift_x_by_i shift_4(
		.a(a[WIDTH_A-28]),
		.p(b),
		.px(bx4)
		);
defparam shift_4.WIDTH = WIDTH;
defparam shift_4.k3 = k3;
defparam shift_4.k2 = k2;
defparam shift_4.k1 = k1;
defparam shift_4.i = 4;

	
shift_x_by_i shift_5(
		.a(a[WIDTH_A-27]),
		.p(b),
		.px(bx5)
		);
defparam shift_5.WIDTH = WIDTH;
defparam shift_5.k3 = k3;
defparam shift_5.k2 = k2;
defparam shift_5.k1 = k1;
defparam shift_5.i = 5;

	
shift_x_by_i shift_6(
		.a(a[WIDTH_A-26]),
		.p(b),
		.px(bx6)
		);
defparam shift_6.WIDTH = WIDTH;
defparam shift_6.k3 = k3;
defparam shift_6.k2 = k2;
defparam shift_6.k1 = k1;
defparam shift_6.i = 6;

	
shift_x_by_i shift_7(
		.a(a[WIDTH_A-25]),
		.p(b),
		.px(bx7)
		);
defparam shift_7.WIDTH = WIDTH;
defparam shift_7.k3 = k3;
defparam shift_7.k2 = k2;
defparam shift_7.k1 = k1;
defparam shift_7.i = 7;

	
shift_x_by_i shift_8(
		.a(a[WIDTH_A-24]),
		.p(b),
		.px(bx8)
		);
defparam shift_8.WIDTH = WIDTH;
defparam shift_8.k3 = k3;
defparam shift_8.k2 = k2;
defparam shift_8.k1 = k1;
defparam shift_8.i = 8;

	
shift_x_by_i shift_9(
		.a(a[WIDTH_A-23]),
		.p(b),
		.px(bx9)
		);
defparam shift_9.WIDTH = WIDTH;
defparam shift_9.k3 = k3;
defparam shift_9.k2 = k2;
defparam shift_9.k1 = k1;
defparam shift_9.i = 9;

	
shift_x_by_i shift_10(
		.a(a[WIDTH_A-22]),
		.p(b),
		.px(bx10)
		);
defparam shift_10.WIDTH = WIDTH;
defparam shift_10.k3 = k3;
defparam shift_10.k2 = k2;
defparam shift_10.k1 = k1;
defparam shift_10.i = 10;

	
shift_x_by_i shift_11(
		.a(a[WIDTH_A-21]),
		.p(b),
		.px(bx11)
		);
defparam shift_11.WIDTH = WIDTH;
defparam shift_11.k3 = k3;
defparam shift_11.k2 = k2;
defparam shift_11.k1 = k1;
defparam shift_11.i = 11;

	
shift_x_by_i shift_12(
		.a(a[WIDTH_A-20]),
		.p(b),
		.px(bx12)
		);
defparam shift_12.WIDTH = WIDTH;
defparam shift_12.k3 = k3;
defparam shift_12.k2 = k2;
defparam shift_12.k1 = k1;
defparam shift_12.i = 12;

	
shift_x_by_i shift_13(
		.a(a[WIDTH_A-19]),
		.p(b),
		.px(bx13)
		);
defparam shift_13.WIDTH = WIDTH;
defparam shift_13.k3 = k3;
defparam shift_13.k2 = k2;
defparam shift_13.k1 = k1;
defparam shift_13.i = 13;

	
shift_x_by_i shift_14(
		.a(a[WIDTH_A-18]),
		.p(b),
		.px(bx14)
		);
defparam shift_14.WIDTH = WIDTH;
defparam shift_14.k3 = k3;
defparam shift_14.k2 = k2;
defparam shift_14.k1 = k1;
defparam shift_14.i = 14;

	
shift_x_by_i shift_15(
		.a(a[WIDTH_A-17]),
		.p(b),
		.px(bx15)
		);
defparam shift_15.WIDTH = WIDTH;
defparam shift_15.k3 = k3;
defparam shift_15.k2 = k2;
defparam shift_15.k1 = k1;
defparam shift_15.i = 15;

	
shift_x_by_i shift_16(
		.a(a[WIDTH_A-16]),
		.p(b),
		.px(bx16)
		);
defparam shift_16.WIDTH = WIDTH;
defparam shift_16.k3 = k3;
defparam shift_16.k2 = k2;
defparam shift_16.k1 = k1;
defparam shift_16.i = 16;

	
shift_x_by_i shift_17(
		.a(a[WIDTH_A-15]),
		.p(b),
		.px(bx17)
		);
defparam shift_17.WIDTH = WIDTH;
defparam shift_17.k3 = k3;
defparam shift_17.k2 = k2;
defparam shift_17.k1 = k1;
defparam shift_17.i = 17;

	
shift_x_by_i shift_18(
		.a(a[WIDTH_A-14]),
		.p(b),
		.px(bx18)
		);
defparam shift_18.WIDTH = WIDTH;
defparam shift_18.k3 = k3;
defparam shift_18.k2 = k2;
defparam shift_18.k1 = k1;
defparam shift_18.i = 18;

	
shift_x_by_i shift_19(
		.a(a[WIDTH_A-13]),
		.p(b),
		.px(bx19)
		);
defparam shift_19.WIDTH = WIDTH;
defparam shift_19.k3 = k3;
defparam shift_19.k2 = k2;
defparam shift_19.k1 = k1;
defparam shift_19.i = 19;

	
shift_x_by_i shift_20(
		.a(a[WIDTH_A-12]),
		.p(b),
		.px(bx20)
		);
defparam shift_20.WIDTH = WIDTH;
defparam shift_20.k3 = k3;
defparam shift_20.k2 = k2;
defparam shift_20.k1 = k1;
defparam shift_20.i = 20;

	
shift_x_by_i shift_21(
		.a(a[WIDTH_A-11]),
		.p(b),
		.px(bx21)
		);
defparam shift_21.WIDTH = WIDTH;
defparam shift_21.k3 = k3;
defparam shift_21.k2 = k2;
defparam shift_21.k1 = k1;
defparam shift_21.i = 21;

	
shift_x_by_i shift_22(
		.a(a[WIDTH_A-10]),
		.p(b),
		.px(bx22)
		);
defparam shift_22.WIDTH = WIDTH;
defparam shift_22.k3 = k3;
defparam shift_22.k2 = k2;
defparam shift_22.k1 = k1;
defparam shift_22.i = 22;

	
shift_x_by_i shift_23(
		.a(a[WIDTH_A-9]),
		.p(b),
		.px(bx23)
		);
defparam shift_23.WIDTH = WIDTH;
defparam shift_23.k3 = k3;
defparam shift_23.k2 = k2;
defparam shift_23.k1 = k1;
defparam shift_23.i = 23;

	
shift_x_by_i shift_24(
		.a(a[WIDTH_A-8]),
		.p(b),
		.px(bx24)
		);
defparam shift_24.WIDTH = WIDTH;
defparam shift_24.k3 = k3;
defparam shift_24.k2 = k2;
defparam shift_24.k1 = k1;
defparam shift_24.i = 24;

	
shift_x_by_i shift_25(
		.a(a[WIDTH_A-7]),
		.p(b),
		.px(bx25)
		);
defparam shift_25.WIDTH = WIDTH;
defparam shift_25.k3 = k3;
defparam shift_25.k2 = k2;
defparam shift_25.k1 = k1;
defparam shift_25.i = 25;

	
shift_x_by_i shift_26(
		.a(a[WIDTH_A-6]),
		.p(b),
		.px(bx26)
		);
defparam shift_26.WIDTH = WIDTH;
defparam shift_26.k3 = k3;
defparam shift_26.k2 = k2;
defparam shift_26.k1 = k1;
defparam shift_26.i = 26;

	
shift_x_by_i shift_27(
		.a(a[WIDTH_A-5]),
		.p(b),
		.px(bx27)
		);
defparam shift_27.WIDTH = WIDTH;
defparam shift_27.k3 = k3;
defparam shift_27.k2 = k2;
defparam shift_27.k1 = k1;
defparam shift_27.i = 27;

	
shift_x_by_i shift_28(
		.a(a[WIDTH_A-4]),
		.p(b),
		.px(bx28)
		);
defparam shift_28.WIDTH = WIDTH;
defparam shift_28.k3 = k3;
defparam shift_28.k2 = k2;
defparam shift_28.k1 = k1;
defparam shift_28.i = 28;

	
shift_x_by_i shift_29(
		.a(a[WIDTH_A-3]),
		.p(b),
		.px(bx29)
		);
defparam shift_29.WIDTH = WIDTH;
defparam shift_29.k3 = k3;
defparam shift_29.k2 = k2;
defparam shift_29.k1 = k1;
defparam shift_29.i = 29;

	
shift_x_by_i shift_30(
		.a(a[WIDTH_A-2]),
		.p(b),
		.px(bx30)
		);
defparam shift_30.WIDTH = WIDTH;
defparam shift_30.k3 = k3;
defparam shift_30.k2 = k2;
defparam shift_30.k1 = k1;
defparam shift_30.i = 30;

	
shift_x_by_i shift_31(
		.a(a[WIDTH_A-1]),
		.p(b),
		.px(bx31)
		);
defparam shift_31.WIDTH = WIDTH;
defparam shift_31.k3 = k3;
defparam shift_31.k2 = k2;
defparam shift_31.k1 = k1;
defparam shift_31.i = 31;

	
assign bx0 = a[WIDTH_A-32] ? b : {WIDTH{1'b0}};
assign bx = bx0 ^ bx1 ^ bx2 ^ bx3 ^ bx4 ^ bx5 ^ bx6 ^ bx7 ^ bx8 ^ bx9 ^ bx10 ^ bx11 ^ bx12 ^ bx13 ^ bx14 ^ bx15 ^ bx16 ^ bx17 ^ bx18 ^ bx19 ^ bx20 ^ bx21 ^ bx22 ^ bx23 ^ bx24 ^ bx25 ^ bx26 ^ bx27 ^ bx28 ^ bx29 ^ bx30 ^ bx31;
//c(x)x^d mod f(x)
shift_x_by_i shift_32(
	.a(1'b1),
	.p(c),
	.px(cx)
	);
defparam shift_32.WIDTH = WIDTH;
defparam shift_32.k3 = k3;
defparam shift_32.k2 = k2;
defparam shift_32.k1 = k1;
defparam shift_32.i = 32;


assign op_c = c;


endmodule



module shift_x_by_i #(parameter WIDTH = 131, k3 = 8, k2 = 3, k1 = 2, i = 32)(
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
