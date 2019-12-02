#! /usr/bin/python

#
# This file is part of the ROLLO hardware, which generates a digit-level
# GF(2m) multiplier
# 
# Copyright (C) 2019
# Authors: David Jingwei Hu <davidhu@ntu.edu.sg>
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Function: code generation tool for module GF2m_mul_digit
# Usage: python gen_gf2m_mul_digit_tri.py -WIDTH 79 -k 9 -d 16 > ./verilog/gf2m_mul.v

import argparse

parser = argparse.ArgumentParser(description='Generate GF2m_mul_digit module.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-WIDTH, --num', dest='WIDTH', type=int, required= True,
          help='size of the finite field')
parser.add_argument('-k, --num', dest='k', type=int, required= True,
          help='coeff k of the irreducible trinomial')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='digit size of the multiplier')
args = parser.parse_args()

WIDTH = args.WIDTH
k = args.k
d = args.d

print "`timescale 1ns / 1ps"
print ""
print """`include "clog2.v" """ + "\n"

print """module gf2m_mul #(parameter WIDTH = {0}, k = {1}, d = {2})(
	input wire clk,
	input wire rst_b,
	input wire start,
	input wire [WIDTH-1:0] op_a,
	input wire [WIDTH-1:0] op_b,

	output reg done,
	output wire [WIDTH-1:0] op_c
    );""".format(WIDTH, k, d)

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
defparam shift_{0}.k = k;
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
defparam shift_{0}.k = k;
defparam shift_{0}.i = {0};


assign op_c = c;


endmodule


""".format(d)

#create module shift_x_by_i
print """module shift_x_by_i #(parameter WIDTH = {0}, k = {1}, i = {2})(
	input wire a,
	input wire [WIDTH-1:0] p, //polynomial p(x), represented in big-endian notation
	output wire [WIDTH-1:0] px //output a * p(x)x^i mod f(x)
	);""".format(WIDTH, k, d)
print ""

print "wire [WIDTH-1:0] px1;"
print ""

print "assign px1 = {p[WIDTH-i-1:0], p[WIDTH-1:WIDTH-i]};"
print "assign px = a ? {px1[WIDTH-1:k+i], {px1[k+i-1:k]^p[WIDTH-1:WIDTH-i]}, px1[k-1:0]}: {WIDTH{1'b0}};"
print ""

print "endmodule"





