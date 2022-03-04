#! /usr/bin/python
#
# This file is part of the ROLLO hardware, which generates the top level
# of a GF2m[z] multiplier architecture
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
# Function: code generation tool for module gf2mz_top
# Usage: python gen_gf2mz_top.py -SL 'ROLLO-I-128' -d 3 -GF2_MUL_WIDTH 16 > ./verilog/gf2mz_top.v

import argparse
import math

parser = argparse.ArgumentParser(description='Generate gf2mz_top module.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO security level')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='number of GF2m coefficients in each block memory cell')
parser.add_argument('-GF2_MUL_WIDTH, --num', dest='GF2_MUL_WIDTH', type=int, required= True,
          help='digit size of the GF2m multiplier')
args = parser.parse_args()

SL = args.SL
d = args.d
GF2_MUL_WIDTH = args.GF2_MUL_WIDTH


'''parser = argparse.ArgumentParser(description='Generate gf2mz_top module.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-n, --num', dest='n', type=int, required= True,
          help='degree of GF2m[z] polynomial')
parser.add_argument('-m, --num', dest='m', type=int, required= True,
          help='degree of GF2m')
parser.add_argument('-MEM_WIDTH, --num', dest='MEM_WIDTH', type=int, required= True,
          help='data width of memory block')
parser.add_argument('-GF2_MUL_WIDTH, --num', dest='GF2_MUL_WIDTH', type=int, required= True,
          help='digit size of the GF2m multiplier')
args = parser.parse_args()

n = args.n
m = args.m
MEM_WIDTH = args.MEM_WIDTH
GF2_MUL_WIDTH = args.GF2_MUL_WIDTH

#calculate the delay of GF2m multiplier
DELAY = int(math.ceil(1.0*m/GF2_MUL_WIDTH) + 1) 

#calculate each memory cell contains d GF(2m) coefficients
d = MEM_WIDTH/m'''

############################################################################
#
#   initialize the system parameters
#
############################################################################
#ROLLO-I setups
if SL == 'ROLLO-I-128':
  n = 83
  m = 67
  f_coeff_list = [5,2,1]


elif SL == 'ROLLO-I-192':
  n = 97
  m = 79
  f_coeff_list = [9]  

elif SL == 'ROLLO-I-256': 
  n = 113
  m = 97
  f_coeff_list = [6]

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 189
  m = 83
  f_coeff_list = [7,4,2]

elif SL == 'ROLLO-II-192':
  n = 193
  m = 97
  f_coeff_list = [6]

elif SL == 'ROLLO-II-256':
  n = 211
  m = 97
  f_coeff_list = [6]

else:
  print ('Iuput Errors')  
  exit()

#calculate the delay of GF2m multiplier
DELAY = int(math.ceil(1.0*m/GF2_MUL_WIDTH) + 1) 
if len(f_coeff_list) == 1:
	k = f_coeff_list[0]
else:
	k3 = f_coeff_list[0]
	k2 = f_coeff_list[1]
	k1 = f_coeff_list[2]	


print ("""`timescale 1ns / 1ps
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

module gf2mz_top #(parameter n = {n}, m = {m}, d = {d}, FILE_A = "mem_A.txt", FILE_B = "mem_B.txt")(
	input wire 				clk,
	input wire				rst_b,
	input wire 				start,

	output wire				done,
	output wire [m-1:0]		dout
    );

parameter WIDTH = m*d;
parameter DEPTH = (n/d) + ((n%d) != 0); //ceil(n/d)
parameter DELAY = {DELAY}; //set the cycle delay of GF2m multiplier



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
wire mul_start;""".format(n = n, m = m, d = d, DELAY = DELAY))

tmp = "wire "
for i in range(d):
	for j in range(d):
		if i != d-1 or j != d-1:
			tmp += """mul{i}{j}_done, """.format(i = i, j = j)
		else:
			tmp += """mul{i}{j}_done; """.format(i = i, j = j)	
	tmp += "\n"
print (tmp)

tmp = "wire [m-1:0]	"
for i in range(d):
	for j in range(d):
		if i != d-1 or j != d-1:
			tmp += "mul{i}{j}_op_a, mul{i}{j}_op_b, mul{i}{j}_op_c,".format(i = i, j = j)
		else:
			tmp += "mul{i}{j}_op_a, mul{i}{j}_op_b, mul{i}{j}_op_c; ".format(i = i, j = j)	
		tmp += "\n"
print (tmp)


print ("""
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
""".format(n = n, m = m, d = d, DELAY = DELAY))

print ("""//GF(2m) multiplier instances, d*d arrays""")
tmp = ""
if len(f_coeff_list) == 1:
	for i in range(d):
		for j in range(d):
			tmp += """gf2m_mul mul{i}{j} (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul{i}{j}_op_a),
	.op_b (mul{i}{j}_op_b),

	.done (mul{i}{j}_done),
	.op_c (mul{i}{j}_op_c)
	);

defparam mul{i}{j}.WIDTH = {m};
defparam mul{i}{j}.k = {k};
defparam mul{i}{j}.d = {GF2_MUL_WIDTH};

""".format(i = i, j = j, m = m, k = k, GF2_MUL_WIDTH = GF2_MUL_WIDTH)

elif len(f_coeff_list) == 3:
	for i in range(d):
		for j in range(d):
			tmp += """gf2m_mul mul{i}{j} (
	.clk (clk),
	.rst_b (rst_b),
	.start (mul_start),
	.op_a (mul{i}{j}_op_a),
	.op_b (mul{i}{j}_op_b),

	.done (mul{i}{j}_done),
	.op_c (mul{i}{j}_op_c)
	);

defparam mul{i}{j}.WIDTH = {m};
defparam mul{i}{j}.k3 = {k3};
defparam mul{i}{j}.k2 = {k2};
defparam mul{i}{j}.k1 = {k1};
defparam mul{i}{j}.d = {GF2_MUL_WIDTH};

""".format(i = i, j = j, m = m, k3 = k3, k2 = k2, k1 = k1, GF2_MUL_WIDTH = GF2_MUL_WIDTH)

print (tmp)


print ("""//control logic for the multiplication of C(z) = A(z)*B(z)
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
""")

tmp = """	//GF2m multiplier interface
	.mul_start(mul_start),
	.mul_done("""
for i in range(d):
	for j in range(d):
			if i != d-1 or j != d-1:
				tmp += """mul{i}{j}_done & """.format(i = i, j = j)
			else:
				tmp += """mul{i}{j}_done),\n\n""".format(i = i, j = j)	

for i in range(d):
	for j in range(d):
		if i != d-1 or j != d-1:
			tmp += """	.mul{i}{j}_op_a(mul{i}{j}_op_a),
	.mul{i}{j}_op_b(mul{i}{j}_op_b),
	.mul{i}{j}_op_c(mul{i}{j}_op_c),
""".format(i = i, j = j)
		else:
			tmp += """	.mul{i}{j}_op_a(mul{i}{j}_op_a),
	.mul{i}{j}_op_b(mul{i}{j}_op_b),
	.mul{i}{j}_op_c(mul{i}{j}_op_c)
);""".format(i = i, j = j)
	tmp += "\n"
print (tmp)


print ("""defparam ctrl.WIDTH = WIDTH;
defparam ctrl.DEPTH = DEPTH;
defparam ctrl.m = m;
defparam ctrl.d = d;
defparam ctrl.DELAY = DELAY;


assign ctrl_start = start;
assign done = ctrl_done;
assign dout = {{C_di[WIDTH-1:WIDTH-m] ^ C_di[WIDTH-m-1:WIDTH-2*m] ^ C_di[WIDTH-2*m-1:WIDTH-3*m]}};

endmodule""".format())
