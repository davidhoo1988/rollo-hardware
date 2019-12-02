#!/usr/bin/sage

#
# This file is part of the testbench, which generates a random input GF(2m)[z] 
# polynomial which fits the block RAM data format.
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
#usage: sage gen_test.sage -SL 'ROLLO-I-128' -d 3 (it generates two memory files as 'mem_A.txt' and 'mem_B.txt')

import sys
import argparse

parser = argparse.ArgumentParser(description='Generate two memory files for GF2m[z] polynomials.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO Security Level')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='number of GF(2m) elements stored in each cell of the memory')
args = parser.parse_args()

SL = args.SL # security parameters derived from the NIST recommended categorization
d = args.d # number of GF(2m) elements stored in each cell of the memory


#SL = 'ROLLO-I-128'
#d = 3

#set_random_seed(12345)

#determine the security parameters used according to the SL option
############################################################################
#
# initialize the system parameters
#
############################################################################
#ROLLO-I setups
if SL == 'ROLLO-I-128':
  n = 47
  m = 79

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[47] = 1
  P_list[5] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[79] = 1
  f_list[9] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-192':
  n = 53
  m = 89
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[53] = 1
  P_list[6] = 1
  P_list[2] = 1
  P_list[1] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[89] = 1
  f_list[38] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-256': 
  n = 67
  m = 113

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[67] = 1
  P_list[5] = 1
  P_list[2] = 1
  P_list[1] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[113] = 1
  f_list[9] = 1
  f_list[0] = 1

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 149
  m = 83
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[149] = 1
  P_list[10] = 1
  P_list[9] = 1
  P_list[7] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[83] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[2] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-192':
  n = 151
  m = 107
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[151] = 1
  P_list[3] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[107] = 1
  f_list[9] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-256':
  n = 157
  m = 127
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[157] = 1
  P_list[6] = 1
  P_list[5] = 1
  P_list[2] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[127] = 1
  f_list[1] = 1
  f_list[0] = 1

elif SL == 'ROLLO-III-128':
  n = 47
  m = 101
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[47] = 1
  P_list[5] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[101] = 1
  f_list[7] = 1
  f_list[6] = 1
  f_list[1] = 1
  f_list[0] = 1

elif SL == 'ROLLO-III-192':
  n = 59
  m = 107
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[59] = 1
  P_list[7] = 1
  P_list[4] = 1
  P_list[2] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[107] = 1
  f_list[9] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[0] = 1

elif SL == 'ROLLO-III-256':
  n = 67
  m = 131
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[67] = 1
  P_list[5] = 1
  P_list[2] = 1
  P_list[1] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[131] = 1
  f_list[8] = 1
  f_list[3] = 1
  f_list[2] = 1
  f_list[0] = 1

else:
  print 'Iuput Errors'  
  exit()

depth = ceil(n/d) # memory depth
width = m*d # memory width (bit-level)


#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
ffi_elt = GF(2^m, 'x', modulus = f_list)
PR_F_2m.<z> = PolynomialRing(ffi_elt)

#construct the polynomial ring over GF(2m)[z] based on the ring polynomial P
nonzero_idx = [i for i, e in enumerate(P_list) if e != 0]
P = 0
for i in nonzero_idx:
  P += z^i

ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(P))


A = ffi_vec.random_element()
B = ffi_vec.random_element()

#output polynomials A/B to file (depth addresses, each address has m*d bits data (i.e., d GF2m elements, each of which is represented in MSB first mode))
fo = open("./verilog/mem_A.txt", "w+")
for i in range(depth):
  if (i < depth-1) or (i == depth-1 and n%d == 0):
    for j in range(d):
        #output each GF(2m) coefficient of A[i] in BIN form bin(ffi_elt.integer_representation())[2:]]
        string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
        fo.write(string.format(A[i*d+j].integer_representation()))
    fo.write("\n")
  else:
    r = n%d
    for j in range(r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(A[i*d+j].integer_representation())) 
    for j in range(d-r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(0))   
         
fo.close()

fo = open("./verilog/mem_B.txt", "w+")
for i in range(depth):
  if (i < depth-1) or (i == depth-1 and n%d == 0):
    for j in range(d):
        #output each GF(2m) coefficient of B[i] in BIN form bin(ffi_elt.integer_representation())[2:]]
        string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
        fo.write(string.format(B[i*d+j].integer_representation()))
    fo.write("\n")
  else:
    r = n%d
    for j in range(r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(B[i*d+j].integer_representation()))       
    for j in range(d-r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(0))   
fo.close()

'''
#output polynomial A*B to file
C = A*B
fo = open("mem_C.txt", "w+")
for i in range(depth):
  if (i < depth-1) or (i == depth-1 and n%d == 0):
    for j in range(d):
        #output each GF(2m) coefficient of B[i] in BIN form bin(ffi_elt.integer_representation())[2:]]
        string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
        fo.write(string.format(C[i*d+j].integer_representation()))
    fo.write("\n")
  else:
    r = n%d
    for j in range(r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(C[i*d+j].integer_representation()))       
    for j in range(d-r):
      string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
      fo.write(string.format(0))   
fo.close()
'''