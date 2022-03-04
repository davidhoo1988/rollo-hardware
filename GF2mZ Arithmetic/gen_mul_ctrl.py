#! /usr/bin/python
#
# This file is part of the ROLLO hardware, which generates the 
# control logic for GF2m[z] multiplier
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
# Function: code generation tool for module mul_ctrl
# Usage: python gen_mul_ctrl.py -SL 'ROLLO-I-128' -d 3 > ./verilog/mul_ctrl.v


import argparse
import math

parser = argparse.ArgumentParser(description='Generate the control logic for gf2mz_top.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO security level')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='number of GF2m coefficients held in block memeory')
args = parser.parse_args()

SL = args.SL
d = args.d


############################################################################
#
#   initialize the system parameters
#
############################################################################
if SL == 'ROLLO-I-128':
  n = 83
  m = 67

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[83] = 1
  P_list[7] = 1
  P_list[4] = 1
  P_list[2] = 1
  P_list[0] = 1
  P_coeff_list = [7,4,2]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[67] = 1
  f_list[5] = 1
  f_list[2] = 1
  f_list[1] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-192':
  n = 97
  m = 79
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[97] = 1
  P_list[6] = 1
  P_list[0] = 1
  P_coeff_list = [6]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[79] = 1
  f_list[9] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-256': 
  n = 113
  m = 97

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[113] = 1
  P_list[9] = 1
  P_list[0] = 1
  P_coeff_list = [9]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 189
  m = 83
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[189] = 1
  P_list[6] = 1
  P_list[5] = 1
  P_list[2] = 1
  P_list[0] = 1
  P_coeff_list = [6,5,2]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[83] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[2] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-192':
  n = 193
  m = 97
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[193] = 1
  P_list[15] = 1
  P_list[0] = 1
  P_coeff_list = [15]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-256':
  n = 211
  m = 97
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[211] = 1
  P_list[11] = 1
  P_list[10] = 1
  P_list[8] = 1
  P_list[0] = 1
  P_coeff_list = [11,10,8]

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1

else:
  print ('Iuput Errors')  
  exit()

if n%d == 0:
  delta = d
else:  
  delta = n%d # the remaining GF(2m) coefficients (1,2,...,d-1,d) in the last memory cell


print("""`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: 
// 
// Create Date: 10/14/2019 12:06:16 PM
// Design Name: 
// Module Name: mul_ctrl
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
`include "define.v"
`include "clog2.v"

module mul_ctrl #(parameter WIDTH = 8, DEPTH = 64, m = 79, d = 3, DELAY = 6)(
	input wire 			clk,
	input wire 			rst_b,
	input wire 			start,
	output reg 			done,

	//A interface
	input wire [WIDTH-1:0]			A_di, //input from A_do of mem_A
	output reg 						A_we,
	output reg [`CLOG2(DEPTH)-1:0]	A_addr,
	output reg [WIDTH-1:0]			A_do, //output to A_di of mem_A

	//B interface
	input wire [WIDTH-1:0]			B_dia,
	output reg 						B_wea,
	output reg [`CLOG2(DEPTH)-1:0]	B_addra,
	output reg [WIDTH-1:0]			B_doa,
	input wire [WIDTH-1:0]			B_dib,
	output reg 						B_web,
	output reg [`CLOG2(DEPTH)-1:0]	B_addrb,
	output reg [WIDTH-1:0]			B_dob,

	//C interface
	input wire [WIDTH-1:0]			C_di,
	output reg 						C_we,
	output reg [`CLOG2(DEPTH)-1:0]	C_addr,
	output reg [WIDTH-1:0]			C_do,

	//GF2m multiplier interface
	output reg 					    mul_start,
    input wire                      mul_done,
""")

tmp = ""
for i in range(d):
	for j in range(d):
		if i != d-1 or j != d-1:
			tmp += """	output wire [m-1:0] 			mul{i}{j}_op_a,
	output wire [m-1:0] 			mul{i}{j}_op_b,
    input wire [m-1:0]              mul{i}{j}_op_c,
""".format(i = i, j = j)
		else:
			tmp += """	output wire [m-1:0] 			mul{i}{j}_op_a,
	output wire [m-1:0] 			mul{i}{j}_op_b,
    input wire [m-1:0]              mul{i}{j}_op_c
	);""".format(i = i, j = j)
print (tmp)

print ("""
reg [`CLOG2(DELAY+18)-1:0] cnt; //log2(DELAY+18)-bit timer
reg flag; //used to handle the exception transition from MUL to POST

wire [WIDTH-1:0] cache; //used for updating B(z) to B(z)z^d in mem_B""")

tmp = "reg [m-1:0] "
for i in range(d):
	if i != d-1:
		tmp += "cache{i}, ".format(i = i)
	else:
		tmp += "cache{i};\n".format(i = i)	
print (tmp)

print ("wire [WIDTH-1:0] mul_r;")

tmp = "wire [m-1:0] "
for i in range(d):
	if i != d-1:
		tmp += "mul_r{i}, ".format(i = i)
	else:
		tmp += "mul_r{i};".format(i = i)	
print (tmp)

print ("""//----------------------------------------------------------
// FSM state signal Declaration
//----------------------------------------------------------		
parameter 		INIT = 3'd0, //do nothing, then get prepared
				PRE = 3'd1, //generate one entry of the dense polynomial g
				MUL = 3'd2, //scalar multiplication phase ai*[b_{j}b_{j+1}b_{j+2}]
                POST = 3'd3;//handle the tailing computation of state MUL

reg 			PRE_done, MUL_done, POST_done;

//----------------------------------------------------------
//1st always block, sequential state transition
//----------------------------------------------------------
reg    [2:0]   state, next_state;

always @ (posedge clk)
      if (!rst_b)            
    		state <= INIT;        
      else                  
    		state <= next_state; 

//----------------------------------------------------------
//2nd always block, combinational condition judgement
//----------------------------------------------------------
always @(*) begin
    case (state)
        INIT: 
            if (start)
                next_state = PRE;
            else
                next_state = INIT;  

        PRE:
            if (PRE_done)
                next_state = MUL;
            else   
                next_state = PRE;  

        MUL:
        	if (MUL_done)
        		next_state = POST;	
        	else 
        		next_state = MUL;  

        POST: 
            if (done)
                next_state = INIT;
            else if (POST_done)
                next_state = MUL;
            else 
                next_state = POST;          			         
   
        default:
            next_state = INIT;        
    endcase
end
""")

tmp = """//----------------------------------------------------------
//3rd sequential block, the sequential FSM output
//----------------------------------------------------------	
always @(posedge clk) begin
    case (state)
        INIT: begin	
        	PRE_done <= 0;
        	MUL_done <= 0;
            POST_done <= 0;
            done <= 0;

            mul_start <= 0;
            cnt <= 0;
            flag <= 0;

"""
for i in range(d):
	tmp += "\t\t\tcache{i} <= 0;\n".format(i = i)

tmp += """
            A_we <= 0;
            A_addr <= 0;
            A_do <= 0;

            B_wea <= 0;
            B_addra <= 0;
            B_doa <= 0;
            B_web <= 0;
            B_addrb <= 0;
            B_dob <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end"""
print (tmp)

tmp = """
        PRE: begin      //takes 3 cycles
        	if (cnt == 2) 
        		cnt <= 0;
        	else 
        		cnt <= cnt + 1'b1;
            flag <= 0;

            if (cnt == 1)
                PRE_done <= 1;
            else 
                PRE_done <= 0;    
            MUL_done <= 0;
            POST_done <= 0;
            done <= 0;
            if (PRE_done)
                mul_start <= 1;
            else 
                mul_start <= 0;

            if (PRE_done) begin
"""
for i in range(d):
	tmp += "\t\t\t\tcache{i} <= B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m];\n".format(i = i, j = i+1)

tmp += """            end
            else begin
"""
for i in range(d):
	tmp += "\t\t\t\tcache{i} <= 0;\n".format(i = i)
tmp += """			end
            

        	B_wea <= 0;
        	B_doa <= 0;
        	if (cnt == 0)
        		B_addra <= DEPTH-2;
        	else if (cnt == 1)
        		B_addra <= DEPTH-1;
            else 
                B_addra <= B_addra;    

        	B_web <= 0;
        	B_dob <= 0;
        	if (cnt == 0)
        		B_addrb <= DEPTH-1;
        	else if (cnt == 1)
        		B_addrb <= 0;	
            else 
                B_addrb <= B_addrb;    

        	A_we <= 0;
        	A_addr <= 0;
        	A_do <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end"""
print (tmp)

tmp = """
        MUL: begin
            if (cnt == DELAY) //[0,1,...,DELAY,0,1,...,DELAY,...]
                cnt <= 0;
            else 
                cnt <= cnt + 1'b1;
            if (flag == 0 && cnt == DELAY && B_addra == DEPTH-2 && B_addrb == DEPTH-1) 
                flag <= 1;
            else if (flag == 1 && cnt == DELAY && B_addra == DEPTH-1 && B_addrb == 0) 
                flag <= 0;   
            else
                flag <= flag;    
            if (flag && cnt == DELAY && B_addra == DEPTH-1 && B_addrb == 0)
                MUL_done <= 1;
            else 
                MUL_done <= 0;    
            PRE_done <= 0;
            POST_done <= 0;
            done <= 0; 
            if (cnt == DELAY)          
                mul_start <= 1;
            else 
                mul_start <= 0;      

            if (MUL_done && B_addra == DEPTH-1) begin //exceptional process to update cache for B[0]
"""
for i in range(d):
	if i < d - delta:
		tmp += "\t\t\t\tcache{i} <= cache{j};\n".format(i = i, j = delta+i)
	else:
		tmp += "\t\t\t\tcache{i} <= B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m];\n".format(i = i, j = i-(d-delta), k = i-(d-delta)+1)	
tmp += """			end
            else if (cnt == 0 && B_addra != DEPTH-1 && B_addrb != 0) begin //iteratively update cache for {B[1],B[2],...,B[DEPTH-1]}
"""
for i in range(d):      
	tmp +=  "\t\t\t\tcache{i} <= B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m];\n".format(i = i, j = i+1)     
tmp += """			end
            else begin
"""
for i in range(d):
	tmp += "\t\t\t\tcache{i} <= cache{i};\n".format(i = i)

tmp += """            end   

            A_we <= 0;
            A_addr <= A_addr;
            A_do <= 0;

            if (cnt == DELAY - 1) begin //read/write new data from RAM B at cnt == DELAY, it implicitly suggests DELAY >= 2   
                if (flag && B_addrb == DEPTH-1) begin
                    B_wea <= 1;
                    B_doa <= {{cache[WIDTH-1:WIDTH-{delta}*m]""".format(delta = delta)
for i in range(d-delta):
    if i == 0:
        tmp += ", "
    if i != d-delta-1:
        tmp += "{m{1'b0}}, "
    else:
        tmp += "{m{1'b0}}"                    
tmp += "};"                    
tmp += """
                end     
                else if (B_addra != DEPTH-1 && B_addra != DEPTH-2) begin
                    B_wea <= 1;
                    B_doa <= cache;
                end
                else begin
                    B_wea <= 0;  
                    B_doa <= 0;   
                end       
                B_addra <= B_addra != DEPTH-1 ? B_addra + 1'b1 : 0;             
                B_web <= 0;
                B_addrb <= B_addrb != DEPTH-1 ? B_addrb + 1'b1 : 0;
                B_dob <= 0; 
            end
            else begin
                B_wea <= 0;
                B_addra <= B_addra;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= B_addrb;
                B_dob <= 0;
            end


            if (mul_done) begin // mul_done when cnt == DELAY, write mem_C
                C_we <= 1;
                C_do <= C_di ^ mul_r;
            end 
            else begin
                C_we <= 0;    
                C_do <= 0;
            end 
            if (cnt == 0 && B_addra != DEPTH-1 && B_addrb != 0)
                C_addr <= C_addr + 1'b1;
            else 
                C_addr <= C_addr;               
        end"""
print (tmp)


if len(P_coeff_list) == 1:
    k = P_coeff_list[0]
    tmp = """
        POST: begin //in total DELAY+2 cycles (starting from cnt=1 to cnt=DELAY+2); load [b_45,b_46] to compute a1*b45 and [a2*b45,a2*b46]
            if (cnt == DELAY + 2) 
                cnt <= 0;
            else 
                cnt <= cnt + 1'b1;
            flag <= 0;
            if (cnt == DELAY + 1)
                POST_done <= 1;
            else 
                POST_done <= 0;  
            PRE_done <= 0;  
            MUL_done <= 0;
            if (cnt == DELAY + 1 && A_addr == DEPTH - 1)
                done <= 1;
            else 
                done <= 0;    

            if (cnt == DELAY+2) begin
"""
    for i in range(d):
        tmp +=  "\t\t\t\tcache{i} <= B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m];\n".format(i = i, j = i+1)  

    tmp +=  """            end
            else begin
"""

    for i in range(d):
        tmp +=  "\t\t\t\tcache{i} <= cache{i};\n".format(i = i)  

    print (tmp)   

    tmp = """			end



           
            if (cnt == DELAY + 2)
                mul_start <= 1;
            else 
                mul_start <= 0;     

            //mem_A controller
            A_we <= 0;
            if (cnt == DELAY + 1) //ensure to get the mem_A data at the beginning cycle of state MUL
                A_addr <= A_addr != DEPTH-1 ? A_addr + 1'b1 : 0;
            else 
                A_addr <= A_addr;    

            A_do <= 0; 

            //mem_B controller
            if (cnt == 1) begin //finally update B[0], B_addrb = 0 here
                B_wea <= 0;
                B_addra <= B_addra;
                B_doa <= 0;
                B_web <= 1;
                B_addrb <= B_addrb;
                B_dob <= cache;
            end
            else if (cnt == 2) begin //read B[{i}],B[{j}]
                B_wea <= 0;
                B_addra <= {i};
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= {j};
                B_dob <= 0; 
            end
""".format(i = k/d, j = k/d+1)

    tmp += """			else if (cnt == 4) begin //write B[{i}],B[{j}] as: [b2 b3 b4] <- [b2 b3 b4] + [b44 b45 b46]
                    B_wea <= 1;
                    B_addra <= {i};\n""".format(i = k/d, j = k/d+1)
    tmp += "\t\t\t\tB_doa <= {"
    for i in range(d):
    	if i < k%d:
    		tmp += "B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
    	elif i != d-1:
    		tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = i-k%d, j = i, k = i+1)
    	else:
    		tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m]}}; ".format(i = i-k%d, j = i, k = i+1)	
    tmp += """
                    B_web <= 1;
                    B_addrb <= {j};
""".format(j = k/d+1)
    tmp += """				B_dob <= {"""
    for i in range(d):
    	if i < k%d:
    		tmp += "cache{i}^B_dib[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = d-k%d+i, j = i, k = i+1)
    	elif i != d-1:
    		tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
    	else:
    		tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m]}}; ".format(i = i, j = i+1)	
    print (tmp)
else:
    #print "pentanomial"  
    k3 = P_coeff_list[0]
    k2 = P_coeff_list[1]
    k1 = P_coeff_list[2]

    tmp = """
        POST: begin //in total DELAY+18 cycles (starting from cnt=1 to cnt=DELAY+18); handling the 'tail' of GF2m[z] arithmetic
            if (cnt == DELAY + 18) 
                cnt <= 0;
            else 
                cnt <= cnt + 1'b1;
            flag <= 0;
            if (cnt == DELAY + 17)
                POST_done <= 1;
            else 
                POST_done <= 0;  
            PRE_done <= 0;  
            MUL_done <= 0;
            if (cnt == DELAY + 17 && A_addr == DEPTH - 1)
                done <= 1;
            else 
                done <= 0;    

            if (cnt == DELAY+18) begin
"""
    for i in range(d):
        tmp +=  "\t\t\t\tcache{i} <= B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m];\n".format(i = i, j = i+1)  

    tmp +=  """            end
            else begin
"""
    for i in range(d):
        tmp +=  "\t\t\t\tcache{i} <= cache{i};\n".format(i = i)  
    print (tmp)   

    tmp = """           end



           
            if (cnt == DELAY + 18)
                mul_start <= 1;
            else 
                mul_start <= 0;     

            //mem_A controller
            A_we <= 0;
            if (cnt == DELAY + 17) //ensure to get the mem_A data at the beginning cycle of state MUL
                A_addr <= A_addr != DEPTH-1 ? A_addr + 1'b1 : 0;
            else 
                A_addr <= A_addr;    

            A_do <= 0; 

            //mem_B controller
            if (cnt == 1) begin //finally update B[0], B_addrb = 0 here
                B_wea <= 0;
                B_addra <= B_addra;
                B_doa <= 0;
                B_web <= 1;
                B_addrb <= B_addrb;
                B_dob <= cache;
            end
            else if (cnt == 2) begin //read B[{i}],B[{j}]
                B_wea <= 0;
                B_addra <= {i};
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= {j};
                B_dob <= 0; 
            end
""".format(i = k1/d, j = k1/d+1)  
    
    #handle case k1
    tmp += """            else if (cnt == 4) begin //write B[{i}],B[{j}] for k1
                B_wea <= 1;
                B_addra <= {i};\n""".format(i = k1/d, j = k1/d+1)
    tmp += "\t\t\t\tB_doa <= {"
    for i in range(d):
        if i < k1%d:
            tmp += "B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        elif i != d-1:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = i-k1%d, j = i, k = i+1)
        else:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m]}}; ".format(i = i-k1%d, j = i, k = i+1)    
    tmp += """
                B_web <= 1;
                B_addrb <= {j};
""".format(j = k1/d+1)
    tmp += """                B_dob <= {"""
    for i in range(d):
        if i < k1%d:
            tmp += "cache{i}^B_dib[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = d-k1%d+i, j = i, k = i+1)
        elif i != d-1:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        else:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m]}}; ".format(i = i, j = i+1)    
    print (tmp + "\n\t\t\tend")

    #handle case k2
    tmp = """            else if (cnt == DELAY+10) begin //read B[{i}],B[{j}]
                B_wea <= 0;
                B_addra <= {i};
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= {j};
                B_dob <= 0; 
            end
""".format(i = k2/d, j = k2/d+1)  
    tmp += """            else if (cnt == DELAY+12) begin //write B[{i}],B[{j}] for k2
                B_wea <= 1;
                B_addra <= {i};\n""".format(i = k2/d, j = k2/d+1)
    tmp += "\t\t\t\tB_doa <= {"
    for i in range(d):
        if i < k2%d:
            tmp += "B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        elif i != d-1:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = i-k2%d, j = i, k = i+1)
        else:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m]}}; ".format(i = i-k2%d, j = i, k = i+1)    
    tmp += """
                B_web <= 1;
                B_addrb <= {j};
""".format(j = k2/d+1)
    tmp += """                B_dob <= {"""
    for i in range(d):
        if i < k2%d:
            tmp += "cache{i}^B_dib[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = d-k2%d+i, j = i, k = i+1)
        elif i != d-1:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        else:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m]}}; ".format(i = i, j = i+1)    
    print (tmp + "\n\t\t\tend")

    #handle case k3
    tmp = """            else if (cnt == DELAY+13) begin //read B[{i}],B[{j}]
                B_wea <= 0;
                B_addra <= {i};
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= {j};
                B_dob <= 0; 
            end
""".format(i = k3/d, j = k3/d+1)  
    tmp += """            else if (cnt == DELAY+15) begin //write B[{i}],B[{j}] for k3
                B_wea <= 1;
                B_addra <= {i};\n""".format(i = k3/d, j = k3/d+1)
    tmp += "\t\t\t\tB_doa <= {"
    for i in range(d):
        if i < k3%d:
            tmp += "B_dia[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        elif i != d-1:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = i-k3%d, j = i, k = i+1)
        else:
            tmp += "cache{i}^B_dia[WIDTH-{j}*m-1:WIDTH-{k}*m]}}; ".format(i = i-k3%d, j = i, k = i+1)    
    tmp += """
                B_web <= 1;
                B_addrb <= {j};
""".format(j = k3/d+1)
    tmp += """                B_dob <= {"""
    for i in range(d):
        if i < k3%d:
            tmp += "cache{i}^B_dib[WIDTH-{j}*m-1:WIDTH-{k}*m], ".format(i = d-k3%d+i, j = i, k = i+1)
        elif i != d-1:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m], ".format(i = i, j = i+1)
        else:
            tmp += "B_dib[WIDTH-{i}*m-1:WIDTH-{j}*m]}}; ".format(i = i, j = i+1)    
    print (tmp)

if len(P_coeff_list) == 1:
  i = 0
else:
  i = 16  
print("""			end
            else if (cnt == DELAY+{i}) begin // read B[-2] at cnt = DELAY+{i}
                B_wea <= 0;
                B_addra <= DEPTH-2;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= 0;
                B_dob <= 0;
            end
            else begin // read B[-1] at cnt = DELAY+{j}
                B_wea <= 0;
                B_addra <= DEPTH-1;
                B_doa <= 0;
                B_web <= 0;
                B_addrb <= 0;
                B_dob <= 0;
            end
""".format(i = i, j = i+1))

# hard part to handle mem_C
tmp = """            //mem_C controller  
            if (cnt == DELAY) begin
                C_we <= 1;
                C_do <= C_di ^ {"""

if len(P_coeff_list) == 1:
    k = P_coeff_list[0]
    for i in range(d):
        if i < k%d:
            tmp += "{m{1'b0}}, "
        else:
            if k%d != 0:
                for j in range(i-k%d+1, d):
                    if j != d-1:
                        tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k%d)
                    else:
                        if i != d-1:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k%d) 
                        else:    
                            tmp += "mul{p}{q}_op_c}};".format(p = j, q = i-k%d)  
            else:
                if i != d-1:
                    for j in range(i-k%d+1, d):
                        if j != d-1:
                            tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k%d)
                        else:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k%d) 
                else:
                    tmp += "{m{1'b0}}};"           


    tmp += """
            end
            else if (cnt == DELAY + 1) begin
                C_we <= 1;
                C_do <= C_di ^ {"""

    for i in range(d):
        if i < k%d-1: 
            for j in range(d-k%d+1+i, d):
                if j != d-1:
                    tmp += "mul{p}{q}_op_c^".format(p = j, q = d-k%d+i)
                else:
                    tmp += "mul{p}{q}_op_c, ".format(p = j, q = d-k%d+i) 

        else:
            if i != d-1:
                tmp += "{m{1'b0}}, "
            else:
                tmp += "{m{1'b0}}};"   

               
    tmp += "\n\t\t\tend" 
    print (tmp)

    print ("""            else begin
                C_we <= 0;
                C_do <= 0;
            end 
            if (cnt == DELAY-2 || cnt == DELAY)
                C_addr <= {i};
            else if (cnt == DELAY-1 || cnt == DELAY+1)
                C_addr <= {j};
            else 
                C_addr <= 0;                             
        end""".format(i = k/d, j = k/d+1))

else: #print "pentanomial" 
    k3 = P_coeff_list[0]
    k2 = P_coeff_list[1]
    k1 = P_coeff_list[2]
    # handle case of k1
    for i in range(d):
        if i < k1%d:
            tmp += "{m{1'b0}}, "
        else:
            if k1%d != 0:
                for j in range(i-k1%d+1, d):
                    if j != d-1:
                        tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k1%d)
                    else:
                        if i != d-1:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k1%d) 
                        else:    
                            tmp += "mul{p}{q}_op_c}};".format(p = j, q = i-k1%d)  
            else:
                if i != d-1:
                    for j in range(i-k1%d+1, d):
                        if j != d-1:
                            tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k1%d)
                        else:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k1%d) 
                else:
                    tmp += "{m{1'b0}}};" 
    tmp += """
            end
            else if (cnt == DELAY + 1) begin
                C_we <= 1;
                C_do <= C_di ^ {"""

    for i in range(d):
        if i < k1%d-1: 
            for j in range(d-k1%d+1+i, d):
                if j != d-1:
                    tmp += "mul{p}{q}_op_c^".format(p = j, q = d-k1%d+i)
                else:
                    tmp += "mul{p}{q}_op_c, ".format(p = j, q = d-k1%d+i) 

        else:
            if i != d-1:
                tmp += "{m{1'b0}}, "
            else:
                tmp += "{m{1'b0}}};"   

               
    tmp += "\n\t\t\tend" 
    print (tmp) 

    #handle case of k2  
    tmp = """            //handle case of k2  
            else if (cnt == DELAY+4) begin
                C_we <= 1;
                C_do <= C_di ^ {"""               

    for i in range(d):
        if i < k2%d:
            tmp += "{m{1'b0}}, "
        else:
            if k2%d != 0:
                for j in range(i-k2%d+1, d):
                    if j != d-1:
                        tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k2%d)
                    else:
                        if i != d-1:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k2%d) 
                        else:    
                            tmp += "mul{p}{q}_op_c}};".format(p = j, q = i-k2%d)  
            else:
                if i != d-1:
                    for j in range(i-k2%d+1, d):
                        if j != d-1:
                            tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k2%d)
                        else:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k2%d) 
                else:
                    tmp += "{m{1'b0}}};" 
    tmp += """
            end
            else if (cnt == DELAY+5) begin
                C_we <= 1;
                C_do <= C_di ^ {"""

    for i in range(d):
        if i < k2%d-1: 
            for j in range(d-k2%d+1+i, d):
                if j != d-1:
                    tmp += "mul{p}{q}_op_c^".format(p = j, q = d-k2%d+i)
                else:
                    tmp += "mul{p}{q}_op_c, ".format(p = j, q = d-k2%d+i) 

        else:
            if i != d-1:
                tmp += "{m{1'b0}}, "
            else:
                tmp += "{m{1'b0}}};"   

               
    tmp += "\n\t\t\tend" 
    print (tmp) 

    # handle case of k3
    tmp = """            //handle case of k3 
            else if (cnt == DELAY+8) begin
                C_we <= 1;
                C_do <= C_di ^ {""" 

    for i in range(d):
        if i < k3%d:
            tmp += "{m{1'b0}}, "
        else:
            if k3%d != 0:
                for j in range(i-k3%d+1, d):
                    if j != d-1:
                        tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k3%d)
                    else:
                        if i != d-1:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k3%d) 
                        else:    
                            tmp += "mul{p}{q}_op_c}};".format(p = j, q = i-k3%d)  
            else:
                if i != d-1:
                    for j in range(i-k3%d+1, d):
                        if j != d-1:
                            tmp += "mul{p}{q}_op_c^".format(p = j, q = i-k3%d)
                        else:
                            tmp += "mul{p}{q}_op_c, ".format(p = j, q = i-k3%d) 
                else:
                    tmp += "{m{1'b0}}};" 
    tmp += """
            end
            else if (cnt == DELAY+9) begin
                C_we <= 1;
                C_do <= C_di ^ {"""

    for i in range(d):
        if i < k3%d-1: 
            for j in range(d-k3%d+1+i, d):
                if j != d-1:
                    tmp += "mul{p}{q}_op_c^".format(p = j, q = d-k3%d+i)
                else:
                    tmp += "mul{p}{q}_op_c, ".format(p = j, q = d-k3%d+i) 

        else:
            if i != d-1:
                tmp += "{m{1'b0}}, "
            else:
                tmp += "{m{1'b0}}};"   

               
    tmp += "\n\t\t\tend" 
    print (tmp) 

    print ("""            else begin
                C_we <= 0;
                C_do <= 0;
            end 
            if (cnt == DELAY-2 || cnt == DELAY)
                C_addr <= {i1};
            else if (cnt == DELAY-1 || cnt == DELAY+1)
                C_addr <= {j1};
            else if (cnt == DELAY+2 || cnt == DELAY+4)
                C_addr <= {i2};
            else if (cnt == DELAY+3 || cnt == DELAY+5)
                C_addr <= {j2};
            else if (cnt == DELAY+6 || cnt == DELAY+8)
                C_addr <= {i3};
            else if (cnt == DELAY+7 || cnt == DELAY+9)
                C_addr <= {j3};            
            else 
                C_addr <= 0;                             
        end""".format(i1 = k1/d, j1 = k1/d+1, i2 = k2/d, j2 = k2/d+1, i3 = k3/d, j3 = k3/d+1))    



print ("""        
		default: begin
        	PRE_done <= 0;
        	MUL_done <= 0;
            POST_done <= 0;
            done <= 0;
            mul_start <= 0;
            cnt <= 0;
            flag <= 0;""")
for i in range(d):
    print ("\t\t\tcache{i} <= 0;".format(i = i))

print ("""
            A_we <= 0;
            A_addr <= 0;
            A_do <= 0;

            B_wea <= 0;
            B_addra <= 0;
            B_doa <= 0;
            B_web <= 0;
            B_addrb <= 0;
            B_dob <= 0;

            C_we <= 0;
            C_addr <= 0;
            C_do <= 0;
        end
    endcase
end
""")

tmp = ""
for i in range(d):
	for j in range(d):
		tmp += """assign mul{i}{j}_op_a = A_di[WIDTH-{i}*m-1:WIDTH-{k}*m];\n""".format(i = i, j = j, k = i+1)
	tmp += "\n"
print (tmp)

#hard part, handling mul_op_b
tmp = ""
if delta == d: # delta = d
  for i in range(d):
    for j in range(d):
      if i > j:
        tmp += """assign mul{i}{j}_op_b = B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(i = i, j = j, p = d-i+j, q = d-i+j+1)
      else:
        tmp += """assign mul{i}{j}_op_b = B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(i = i, j = j, p = j-i, q = j-i+1)          
    tmp += "\n" 

elif delta == d-1: # delta = d-1
	for i in range(d):
		for j in range(d):
			if i > j:
				tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = delta-i+j, q = delta-i+j+1)

				if i < delta:
					tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = d-i+j, q = d-i+j+1)
				else:
					if j < delta:
						tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = d-i+j, q = d-i+j+1)	
					else:	
						tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""

				tmp += """					B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(p = d-i+j, q = d-i+j+1)
			else:
				tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = j-i, q = j-i+1)
				if i < delta:
					if j < delta:
						tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = j-i, q = j-i+1)
					else:
						tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""		
				else:
					tmp += """					B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""
						
				tmp += """					B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(p = j-i, q = j-i+1)
		tmp += "\n"	

else: # delta != d-1
    for i in range(d):
        for j in range(d):
            if i > j:
                #handle case of B_addra == DEPTH-1 && B_addrb == 0
                if i < delta or i == delta:
                    tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = delta-i+j, q = delta-i+j+1) 
                else:
                    if j < i - delta:
                        tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? cache[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = d+delta-i+j, q = d+delta-i+j+1)
                    else:
                        tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = delta-i+j, q = delta-i+j+1)
                #handle case of B_addra == DEPTH-2 && B_addrb == DEPTH-1
                if i < delta:
                    tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = d-i+j, q = d-i+j+1)
                else:
                    if j < delta:
                        tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = d-i+j, q = d-i+j+1)   
                    else:   
                        tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""
                #handle the normal case
                tmp += """                  B_dia[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(p = d-i+j, q = d-i+j+1)


            else:
                #handle case of B_addra == DEPTH-1 && B_addrb == 0
                tmp += """assign mul{i}{j}_op_b = B_addra == DEPTH-1 && B_addrb == 0 ? B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(i = i, j = j, p = j-i, q = j-i+1) 
                #handle case of B_addra == DEPTH-2 && B_addrb == DEPTH-1   
                if i < delta:
                    if j < delta:
                        tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m] :\n""".format(p = j-i, q = j-i+1)
                    else:
                        tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""     
                else:
                    tmp += """                  B_addra == DEPTH-2 && B_addrb == DEPTH-1 ? {m{1'b0}} :\n"""  
                #handle the normal case    
                tmp += """                  B_dib[WIDTH-{p}*m-1:WIDTH-{q}*m];\n""".format(p = j-i, q = j-i+1)
        tmp += "\n"



print (tmp)
            

for i in range(d):
	tmp = "assign mul_r{i} = ".format(i = i, j = j)
	for j in range(d):
		if j != d-1:
			tmp += "mul{j}{i}_op_c ^ ".format(i = i, j = j)
		else:
			tmp += "mul{j}{i}_op_c;".format(i = i, j = j)	
	print (tmp)

tmp = "assign mul_r = {"
for i in range(d):
	if i != d-1:
		tmp += "mul_r{i}, ".format(i = i)
	else:
		tmp += "mul_r{i}}};\n".format(i = i)	
print (tmp)

tmp = "assign cache = {"
for i in range(d):
	if i != d-1:
		tmp += "cache{i}, ".format(i = i)
	else:
		tmp += "cache{i}}};\n\nendmodule".format(i = i)	
print (tmp)


