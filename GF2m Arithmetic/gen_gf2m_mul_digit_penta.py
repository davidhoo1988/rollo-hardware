#! /usr/bin/python

# Function: code generation tool for module GF2m_mul_digit_penta

import argparse

parser = argparse.ArgumentParser(description='Generate GF2m_mul_digit_penta module.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-WIDTH, --num', dest='WIDTH', type=int, required= True,
          help='size of the finite field')
parser.add_argument('-k3, --num', dest='k3', type=int, required= True,
          help='coeff k3 of the irreducible trinomial')
parser.add_argument('-k2, --num', dest='k2', type=int, required= True,
          help='coeff k2 of the irreducible trinomial')
parser.add_argument('-k1, --num', dest='k1', type=int, required= True,
          help='coeff k1 of the irreducible trinomial')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='digit size of the multiplier')
args = parser.parse_args()

WIDTH = args.WIDTH
k3 = args.k3
k2 = args.k2
k1 = args.k1
d = args.d

print "`timescale 1ns / 1ps"
print ""
print """`include "clog2.v" """ + "\n"

print """module gf2m_mul #(parameter WIDTH = {0}, k3 = {1}, k2 = {2}, k1 = {3}, d = {4})(
	input wire clk,
	input wire rst_b,
	input wire start,
	input wire [WIDTH-1:0] op_a,
	input wire [WIDTH-1:0] op_b,

	output reg done,
	output wire [WIDTH-1:0] op_c
    );""".format(WIDTH, k3, k2, k1, d)

print "parameter DIGIT_N = WIDTH/d + 1;"
print "parameter WIDTH_A = d*(WIDTH/d)+d;"

print ""

print "wire [WIDTH-1:0] cx1, cx;"
tmp = "wire [WIDTH-1:0] bx, "
for i in range(d):
	if i != d-1:
		tmp += "bx{0}, ".format(i)
	else:
		tmp += "bx{0};".format(i)	
print tmp; # wire [WIDTH-1:0] bx, bx0, bx1, bx2, bx3, bx4, bx5, bx6, bx7;

print ""

print "reg [WIDTH_A-1:0] a; //shift register to load/shift a(x)"
print "reg [WIDTH-1:0] b; // keep b(x)"
print "reg [WIDTH-1:0] c; //result register for a(x)*b(x)"

print ""


print "reg start_en;"
print "reg [`CLOG2(DIGIT_N)-1:0] cnt;"

print ""

print """//control signal
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


"""

print """//arithmetic 
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


"""

print "//fraction(a(x))*b(x) mod f(x)"
for i in range(1,d):
	print """shift_x_by_i shift_{0}(
		.a(a[WIDTH_A-{1}]),
		.p(b),
		.px(bx{0})
		);
defparam shift_{0}.WIDTH = WIDTH;
defparam shift_{0}.k3 = k3;
defparam shift_{0}.k2 = k2;
defparam shift_{0}.k1 = k1;
defparam shift_{0}.i = {0};

	""".format(i,d-i)
print "assign bx0 = a[WIDTH_A-{0}] ? b : {{WIDTH{{1'b0}}}};".format(d)
tmp = "assign bx = "
for i in range(d):
	if i != d-1:
		tmp += "bx{0} ^ ".format(i)
	else:
		tmp += "bx{0};".format(d-1)
print tmp

print """//c(x)x^d mod f(x)
shift_x_by_i shift_{0}(
	.a(1'b1),
	.p(c),
	.px(cx)
	);
defparam shift_{0}.WIDTH = WIDTH;
defparam shift_{0}.k3 = k3;
defparam shift_{0}.k2 = k2;
defparam shift_{0}.k1 = k1;
defparam shift_{0}.i = {0};


assign op_c = c;


endmodule


""".format(d)

#create module shift_x_by_i
print """module shift_x_by_i #(parameter WIDTH = {0}, k3 = {1}, k2 = {2}, k1 = {3}, i = {4})(
	input wire a,
	input wire [WIDTH-1:0] p, //polynomial p(x), represented in big-endian notation
	output wire [WIDTH-1:0] px //output a * p(x)x^i mod f(x)
	);""".format(WIDTH, k3, k2, k1, d)
print ""

print "wire [WIDTH-1:0] px1, px_k1, px_k2, px_k3;"
print ""

print "assign px1 = {p[WIDTH-i-1:0], p[WIDTH-1:WIDTH-i]};"
print "assign px_k1 = {px1[WIDTH-1:k1+i], {px1[k1+i-1:k1]^p[WIDTH-1:WIDTH-i]}, px1[k1-1:0]}; //add k1 terms"
print "assign px_k2 = {px_k1[WIDTH-1:k2+i], {px_k1[k2+i-1:k2]^p[WIDTH-1:WIDTH-i]}, px_k1[k2-1:0]}; //add k2 terms"
print "assign px_k3 = {px_k2[WIDTH-1:k3+i], {px_k2[k3+i-1:k3]^p[WIDTH-1:WIDTH-i]}, px_k2[k3-1:0]}; //add k3 terms"
print ""
print "assign px = a ? px_k3 : {WIDTH{1'b0}};"

print ""

print "endmodule"





