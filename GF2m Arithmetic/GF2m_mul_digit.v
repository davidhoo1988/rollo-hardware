`timescale 1ns / 1ps

`include "clog2.v" 

module GF2m_mul_digit #(parameter WIDTH = 127, k = 1, d = 64)(
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
wire [WIDTH-1:0] bx, bx0, bx1, bx2, bx3, bx4, bx5, bx6, bx7, bx8, bx9, bx10, bx11, bx12, bx13, bx14, bx15, bx16, bx17, bx18, bx19, bx20, bx21, bx22, bx23, bx24, bx25, bx26, bx27, bx28, bx29, bx30, bx31, bx32, bx33, bx34, bx35, bx36, bx37, bx38, bx39, bx40, bx41, bx42, bx43, bx44, bx45, bx46, bx47, bx48, bx49, bx50, bx51, bx52, bx53, bx54, bx55, bx56, bx57, bx58, bx59, bx60, bx61, bx62, bx63;

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
		.a(a[WIDTH_A-63]),
		.p(b),
		.px(bx1)
		);
defparam shift_1.WIDTH = WIDTH;
defparam shift_1.k = k;
defparam shift_1.i = 1;

	
shift_x_by_i shift_2(
		.a(a[WIDTH_A-62]),
		.p(b),
		.px(bx2)
		);
defparam shift_2.WIDTH = WIDTH;
defparam shift_2.k = k;
defparam shift_2.i = 2;

	
shift_x_by_i shift_3(
		.a(a[WIDTH_A-61]),
		.p(b),
		.px(bx3)
		);
defparam shift_3.WIDTH = WIDTH;
defparam shift_3.k = k;
defparam shift_3.i = 3;

	
shift_x_by_i shift_4(
		.a(a[WIDTH_A-60]),
		.p(b),
		.px(bx4)
		);
defparam shift_4.WIDTH = WIDTH;
defparam shift_4.k = k;
defparam shift_4.i = 4;

	
shift_x_by_i shift_5(
		.a(a[WIDTH_A-59]),
		.p(b),
		.px(bx5)
		);
defparam shift_5.WIDTH = WIDTH;
defparam shift_5.k = k;
defparam shift_5.i = 5;

	
shift_x_by_i shift_6(
		.a(a[WIDTH_A-58]),
		.p(b),
		.px(bx6)
		);
defparam shift_6.WIDTH = WIDTH;
defparam shift_6.k = k;
defparam shift_6.i = 6;

	
shift_x_by_i shift_7(
		.a(a[WIDTH_A-57]),
		.p(b),
		.px(bx7)
		);
defparam shift_7.WIDTH = WIDTH;
defparam shift_7.k = k;
defparam shift_7.i = 7;

	
shift_x_by_i shift_8(
		.a(a[WIDTH_A-56]),
		.p(b),
		.px(bx8)
		);
defparam shift_8.WIDTH = WIDTH;
defparam shift_8.k = k;
defparam shift_8.i = 8;

	
shift_x_by_i shift_9(
		.a(a[WIDTH_A-55]),
		.p(b),
		.px(bx9)
		);
defparam shift_9.WIDTH = WIDTH;
defparam shift_9.k = k;
defparam shift_9.i = 9;

	
shift_x_by_i shift_10(
		.a(a[WIDTH_A-54]),
		.p(b),
		.px(bx10)
		);
defparam shift_10.WIDTH = WIDTH;
defparam shift_10.k = k;
defparam shift_10.i = 10;

	
shift_x_by_i shift_11(
		.a(a[WIDTH_A-53]),
		.p(b),
		.px(bx11)
		);
defparam shift_11.WIDTH = WIDTH;
defparam shift_11.k = k;
defparam shift_11.i = 11;

	
shift_x_by_i shift_12(
		.a(a[WIDTH_A-52]),
		.p(b),
		.px(bx12)
		);
defparam shift_12.WIDTH = WIDTH;
defparam shift_12.k = k;
defparam shift_12.i = 12;

	
shift_x_by_i shift_13(
		.a(a[WIDTH_A-51]),
		.p(b),
		.px(bx13)
		);
defparam shift_13.WIDTH = WIDTH;
defparam shift_13.k = k;
defparam shift_13.i = 13;

	
shift_x_by_i shift_14(
		.a(a[WIDTH_A-50]),
		.p(b),
		.px(bx14)
		);
defparam shift_14.WIDTH = WIDTH;
defparam shift_14.k = k;
defparam shift_14.i = 14;

	
shift_x_by_i shift_15(
		.a(a[WIDTH_A-49]),
		.p(b),
		.px(bx15)
		);
defparam shift_15.WIDTH = WIDTH;
defparam shift_15.k = k;
defparam shift_15.i = 15;

	
shift_x_by_i shift_16(
		.a(a[WIDTH_A-48]),
		.p(b),
		.px(bx16)
		);
defparam shift_16.WIDTH = WIDTH;
defparam shift_16.k = k;
defparam shift_16.i = 16;

	
shift_x_by_i shift_17(
		.a(a[WIDTH_A-47]),
		.p(b),
		.px(bx17)
		);
defparam shift_17.WIDTH = WIDTH;
defparam shift_17.k = k;
defparam shift_17.i = 17;

	
shift_x_by_i shift_18(
		.a(a[WIDTH_A-46]),
		.p(b),
		.px(bx18)
		);
defparam shift_18.WIDTH = WIDTH;
defparam shift_18.k = k;
defparam shift_18.i = 18;

	
shift_x_by_i shift_19(
		.a(a[WIDTH_A-45]),
		.p(b),
		.px(bx19)
		);
defparam shift_19.WIDTH = WIDTH;
defparam shift_19.k = k;
defparam shift_19.i = 19;

	
shift_x_by_i shift_20(
		.a(a[WIDTH_A-44]),
		.p(b),
		.px(bx20)
		);
defparam shift_20.WIDTH = WIDTH;
defparam shift_20.k = k;
defparam shift_20.i = 20;

	
shift_x_by_i shift_21(
		.a(a[WIDTH_A-43]),
		.p(b),
		.px(bx21)
		);
defparam shift_21.WIDTH = WIDTH;
defparam shift_21.k = k;
defparam shift_21.i = 21;

	
shift_x_by_i shift_22(
		.a(a[WIDTH_A-42]),
		.p(b),
		.px(bx22)
		);
defparam shift_22.WIDTH = WIDTH;
defparam shift_22.k = k;
defparam shift_22.i = 22;

	
shift_x_by_i shift_23(
		.a(a[WIDTH_A-41]),
		.p(b),
		.px(bx23)
		);
defparam shift_23.WIDTH = WIDTH;
defparam shift_23.k = k;
defparam shift_23.i = 23;

	
shift_x_by_i shift_24(
		.a(a[WIDTH_A-40]),
		.p(b),
		.px(bx24)
		);
defparam shift_24.WIDTH = WIDTH;
defparam shift_24.k = k;
defparam shift_24.i = 24;

	
shift_x_by_i shift_25(
		.a(a[WIDTH_A-39]),
		.p(b),
		.px(bx25)
		);
defparam shift_25.WIDTH = WIDTH;
defparam shift_25.k = k;
defparam shift_25.i = 25;

	
shift_x_by_i shift_26(
		.a(a[WIDTH_A-38]),
		.p(b),
		.px(bx26)
		);
defparam shift_26.WIDTH = WIDTH;
defparam shift_26.k = k;
defparam shift_26.i = 26;

	
shift_x_by_i shift_27(
		.a(a[WIDTH_A-37]),
		.p(b),
		.px(bx27)
		);
defparam shift_27.WIDTH = WIDTH;
defparam shift_27.k = k;
defparam shift_27.i = 27;

	
shift_x_by_i shift_28(
		.a(a[WIDTH_A-36]),
		.p(b),
		.px(bx28)
		);
defparam shift_28.WIDTH = WIDTH;
defparam shift_28.k = k;
defparam shift_28.i = 28;

	
shift_x_by_i shift_29(
		.a(a[WIDTH_A-35]),
		.p(b),
		.px(bx29)
		);
defparam shift_29.WIDTH = WIDTH;
defparam shift_29.k = k;
defparam shift_29.i = 29;

	
shift_x_by_i shift_30(
		.a(a[WIDTH_A-34]),
		.p(b),
		.px(bx30)
		);
defparam shift_30.WIDTH = WIDTH;
defparam shift_30.k = k;
defparam shift_30.i = 30;

	
shift_x_by_i shift_31(
		.a(a[WIDTH_A-33]),
		.p(b),
		.px(bx31)
		);
defparam shift_31.WIDTH = WIDTH;
defparam shift_31.k = k;
defparam shift_31.i = 31;

	
shift_x_by_i shift_32(
		.a(a[WIDTH_A-32]),
		.p(b),
		.px(bx32)
		);
defparam shift_32.WIDTH = WIDTH;
defparam shift_32.k = k;
defparam shift_32.i = 32;

	
shift_x_by_i shift_33(
		.a(a[WIDTH_A-31]),
		.p(b),
		.px(bx33)
		);
defparam shift_33.WIDTH = WIDTH;
defparam shift_33.k = k;
defparam shift_33.i = 33;

	
shift_x_by_i shift_34(
		.a(a[WIDTH_A-30]),
		.p(b),
		.px(bx34)
		);
defparam shift_34.WIDTH = WIDTH;
defparam shift_34.k = k;
defparam shift_34.i = 34;

	
shift_x_by_i shift_35(
		.a(a[WIDTH_A-29]),
		.p(b),
		.px(bx35)
		);
defparam shift_35.WIDTH = WIDTH;
defparam shift_35.k = k;
defparam shift_35.i = 35;

	
shift_x_by_i shift_36(
		.a(a[WIDTH_A-28]),
		.p(b),
		.px(bx36)
		);
defparam shift_36.WIDTH = WIDTH;
defparam shift_36.k = k;
defparam shift_36.i = 36;

	
shift_x_by_i shift_37(
		.a(a[WIDTH_A-27]),
		.p(b),
		.px(bx37)
		);
defparam shift_37.WIDTH = WIDTH;
defparam shift_37.k = k;
defparam shift_37.i = 37;

	
shift_x_by_i shift_38(
		.a(a[WIDTH_A-26]),
		.p(b),
		.px(bx38)
		);
defparam shift_38.WIDTH = WIDTH;
defparam shift_38.k = k;
defparam shift_38.i = 38;

	
shift_x_by_i shift_39(
		.a(a[WIDTH_A-25]),
		.p(b),
		.px(bx39)
		);
defparam shift_39.WIDTH = WIDTH;
defparam shift_39.k = k;
defparam shift_39.i = 39;

	
shift_x_by_i shift_40(
		.a(a[WIDTH_A-24]),
		.p(b),
		.px(bx40)
		);
defparam shift_40.WIDTH = WIDTH;
defparam shift_40.k = k;
defparam shift_40.i = 40;

	
shift_x_by_i shift_41(
		.a(a[WIDTH_A-23]),
		.p(b),
		.px(bx41)
		);
defparam shift_41.WIDTH = WIDTH;
defparam shift_41.k = k;
defparam shift_41.i = 41;

	
shift_x_by_i shift_42(
		.a(a[WIDTH_A-22]),
		.p(b),
		.px(bx42)
		);
defparam shift_42.WIDTH = WIDTH;
defparam shift_42.k = k;
defparam shift_42.i = 42;

	
shift_x_by_i shift_43(
		.a(a[WIDTH_A-21]),
		.p(b),
		.px(bx43)
		);
defparam shift_43.WIDTH = WIDTH;
defparam shift_43.k = k;
defparam shift_43.i = 43;

	
shift_x_by_i shift_44(
		.a(a[WIDTH_A-20]),
		.p(b),
		.px(bx44)
		);
defparam shift_44.WIDTH = WIDTH;
defparam shift_44.k = k;
defparam shift_44.i = 44;

	
shift_x_by_i shift_45(
		.a(a[WIDTH_A-19]),
		.p(b),
		.px(bx45)
		);
defparam shift_45.WIDTH = WIDTH;
defparam shift_45.k = k;
defparam shift_45.i = 45;

	
shift_x_by_i shift_46(
		.a(a[WIDTH_A-18]),
		.p(b),
		.px(bx46)
		);
defparam shift_46.WIDTH = WIDTH;
defparam shift_46.k = k;
defparam shift_46.i = 46;

	
shift_x_by_i shift_47(
		.a(a[WIDTH_A-17]),
		.p(b),
		.px(bx47)
		);
defparam shift_47.WIDTH = WIDTH;
defparam shift_47.k = k;
defparam shift_47.i = 47;

	
shift_x_by_i shift_48(
		.a(a[WIDTH_A-16]),
		.p(b),
		.px(bx48)
		);
defparam shift_48.WIDTH = WIDTH;
defparam shift_48.k = k;
defparam shift_48.i = 48;

	
shift_x_by_i shift_49(
		.a(a[WIDTH_A-15]),
		.p(b),
		.px(bx49)
		);
defparam shift_49.WIDTH = WIDTH;
defparam shift_49.k = k;
defparam shift_49.i = 49;

	
shift_x_by_i shift_50(
		.a(a[WIDTH_A-14]),
		.p(b),
		.px(bx50)
		);
defparam shift_50.WIDTH = WIDTH;
defparam shift_50.k = k;
defparam shift_50.i = 50;

	
shift_x_by_i shift_51(
		.a(a[WIDTH_A-13]),
		.p(b),
		.px(bx51)
		);
defparam shift_51.WIDTH = WIDTH;
defparam shift_51.k = k;
defparam shift_51.i = 51;

	
shift_x_by_i shift_52(
		.a(a[WIDTH_A-12]),
		.p(b),
		.px(bx52)
		);
defparam shift_52.WIDTH = WIDTH;
defparam shift_52.k = k;
defparam shift_52.i = 52;

	
shift_x_by_i shift_53(
		.a(a[WIDTH_A-11]),
		.p(b),
		.px(bx53)
		);
defparam shift_53.WIDTH = WIDTH;
defparam shift_53.k = k;
defparam shift_53.i = 53;

	
shift_x_by_i shift_54(
		.a(a[WIDTH_A-10]),
		.p(b),
		.px(bx54)
		);
defparam shift_54.WIDTH = WIDTH;
defparam shift_54.k = k;
defparam shift_54.i = 54;

	
shift_x_by_i shift_55(
		.a(a[WIDTH_A-9]),
		.p(b),
		.px(bx55)
		);
defparam shift_55.WIDTH = WIDTH;
defparam shift_55.k = k;
defparam shift_55.i = 55;

	
shift_x_by_i shift_56(
		.a(a[WIDTH_A-8]),
		.p(b),
		.px(bx56)
		);
defparam shift_56.WIDTH = WIDTH;
defparam shift_56.k = k;
defparam shift_56.i = 56;

	
shift_x_by_i shift_57(
		.a(a[WIDTH_A-7]),
		.p(b),
		.px(bx57)
		);
defparam shift_57.WIDTH = WIDTH;
defparam shift_57.k = k;
defparam shift_57.i = 57;

	
shift_x_by_i shift_58(
		.a(a[WIDTH_A-6]),
		.p(b),
		.px(bx58)
		);
defparam shift_58.WIDTH = WIDTH;
defparam shift_58.k = k;
defparam shift_58.i = 58;

	
shift_x_by_i shift_59(
		.a(a[WIDTH_A-5]),
		.p(b),
		.px(bx59)
		);
defparam shift_59.WIDTH = WIDTH;
defparam shift_59.k = k;
defparam shift_59.i = 59;

	
shift_x_by_i shift_60(
		.a(a[WIDTH_A-4]),
		.p(b),
		.px(bx60)
		);
defparam shift_60.WIDTH = WIDTH;
defparam shift_60.k = k;
defparam shift_60.i = 60;

	
shift_x_by_i shift_61(
		.a(a[WIDTH_A-3]),
		.p(b),
		.px(bx61)
		);
defparam shift_61.WIDTH = WIDTH;
defparam shift_61.k = k;
defparam shift_61.i = 61;

	
shift_x_by_i shift_62(
		.a(a[WIDTH_A-2]),
		.p(b),
		.px(bx62)
		);
defparam shift_62.WIDTH = WIDTH;
defparam shift_62.k = k;
defparam shift_62.i = 62;

	
shift_x_by_i shift_63(
		.a(a[WIDTH_A-1]),
		.p(b),
		.px(bx63)
		);
defparam shift_63.WIDTH = WIDTH;
defparam shift_63.k = k;
defparam shift_63.i = 63;

	
assign bx0 = a[WIDTH_A-64] ? b : {WIDTH{1'b0}};
assign bx = bx0 ^ bx1 ^ bx2 ^ bx3 ^ bx4 ^ bx5 ^ bx6 ^ bx7 ^ bx8 ^ bx9 ^ bx10 ^ bx11 ^ bx12 ^ bx13 ^ bx14 ^ bx15 ^ bx16 ^ bx17 ^ bx18 ^ bx19 ^ bx20 ^ bx21 ^ bx22 ^ bx23 ^ bx24 ^ bx25 ^ bx26 ^ bx27 ^ bx28 ^ bx29 ^ bx30 ^ bx31 ^ bx32 ^ bx33 ^ bx34 ^ bx35 ^ bx36 ^ bx37 ^ bx38 ^ bx39 ^ bx40 ^ bx41 ^ bx42 ^ bx43 ^ bx44 ^ bx45 ^ bx46 ^ bx47 ^ bx48 ^ bx49 ^ bx50 ^ bx51 ^ bx52 ^ bx53 ^ bx54 ^ bx55 ^ bx56 ^ bx57 ^ bx58 ^ bx59 ^ bx60 ^ bx61 ^ bx62 ^ bx63;
//c(x)x^d mod f(x)
shift_x_by_i shift_64(
	.a(1'b1),
	.p(c),
	.px(cx)
	);
defparam shift_64.WIDTH = WIDTH;
defparam shift_64.k = k;
defparam shift_64.i = 64;


assign op_c = c;


endmodule



module shift_x_by_i #(parameter WIDTH = 127, k = 1, i = 64)(
	input wire a,
	input wire [WIDTH-1:0] p, //polynomial p(x), represented in big-endian notation
	output wire [WIDTH-1:0] px //output a * p(x)x^i mod f(x)
	);

wire [WIDTH-1:0] px1;

assign px1 = {p[WIDTH-i-1:0], p[WIDTH-1:WIDTH-i]};
assign px = a ? {px1[WIDTH-1:k+i], {px1[k+i-1:k]^p[WIDTH-1:WIDTH-i]}, px1[k-1:0]}: {WIDTH{1'b0}};

endmodule
