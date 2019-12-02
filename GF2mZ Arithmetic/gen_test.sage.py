
# This file was *autogenerated* from the file gen_test.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_7 = Integer(7); _sage_const_6 = Integer(6); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_9 = Integer(9); _sage_const_8 = Integer(8); _sage_const_67 = Integer(67); _sage_const_131 = Integer(131); _sage_const_89 = Integer(89); _sage_const_47 = Integer(47); _sage_const_113 = Integer(113); _sage_const_83 = Integer(83); _sage_const_157 = Integer(157); _sage_const_151 = Integer(151); _sage_const_38 = Integer(38); _sage_const_10 = Integer(10); _sage_const_59 = Integer(59); _sage_const_53 = Integer(53); _sage_const_127 = Integer(127); _sage_const_101 = Integer(101); _sage_const_79 = Integer(79); _sage_const_107 = Integer(107); _sage_const_149 = Integer(149)#!/usr/bin/sage

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
  n = _sage_const_47 
  m = _sage_const_79 

  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_47 ] = _sage_const_1 
  P_list[_sage_const_5 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_79 ] = _sage_const_1 
  f_list[_sage_const_9 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-I-192':
  n = _sage_const_53 
  m = _sage_const_89 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_53 ] = _sage_const_1 
  P_list[_sage_const_6 ] = _sage_const_1 
  P_list[_sage_const_2 ] = _sage_const_1 
  P_list[_sage_const_1 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_89 ] = _sage_const_1 
  f_list[_sage_const_38 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-I-256': 
  n = _sage_const_67 
  m = _sage_const_113 

  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_67 ] = _sage_const_1 
  P_list[_sage_const_5 ] = _sage_const_1 
  P_list[_sage_const_2 ] = _sage_const_1 
  P_list[_sage_const_1 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_113 ] = _sage_const_1 
  f_list[_sage_const_9 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = _sage_const_149 
  m = _sage_const_83 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_149 ] = _sage_const_1 
  P_list[_sage_const_10 ] = _sage_const_1 
  P_list[_sage_const_9 ] = _sage_const_1 
  P_list[_sage_const_7 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_83 ] = _sage_const_1 
  f_list[_sage_const_7 ] = _sage_const_1 
  f_list[_sage_const_4 ] = _sage_const_1 
  f_list[_sage_const_2 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-II-192':
  n = _sage_const_151 
  m = _sage_const_107 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_151 ] = _sage_const_1 
  P_list[_sage_const_3 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_107 ] = _sage_const_1 
  f_list[_sage_const_9 ] = _sage_const_1 
  f_list[_sage_const_7 ] = _sage_const_1 
  f_list[_sage_const_4 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-II-256':
  n = _sage_const_157 
  m = _sage_const_127 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_157 ] = _sage_const_1 
  P_list[_sage_const_6 ] = _sage_const_1 
  P_list[_sage_const_5 ] = _sage_const_1 
  P_list[_sage_const_2 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_127 ] = _sage_const_1 
  f_list[_sage_const_1 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-III-128':
  n = _sage_const_47 
  m = _sage_const_101 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_47 ] = _sage_const_1 
  P_list[_sage_const_5 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_101 ] = _sage_const_1 
  f_list[_sage_const_7 ] = _sage_const_1 
  f_list[_sage_const_6 ] = _sage_const_1 
  f_list[_sage_const_1 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-III-192':
  n = _sage_const_59 
  m = _sage_const_107 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_59 ] = _sage_const_1 
  P_list[_sage_const_7 ] = _sage_const_1 
  P_list[_sage_const_4 ] = _sage_const_1 
  P_list[_sage_const_2 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_107 ] = _sage_const_1 
  f_list[_sage_const_9 ] = _sage_const_1 
  f_list[_sage_const_7 ] = _sage_const_1 
  f_list[_sage_const_4 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

elif SL == 'ROLLO-III-256':
  n = _sage_const_67 
  m = _sage_const_131 
  
  P_list = (n+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial P
  P_list[_sage_const_67 ] = _sage_const_1 
  P_list[_sage_const_5 ] = _sage_const_1 
  P_list[_sage_const_2 ] = _sage_const_1 
  P_list[_sage_const_1 ] = _sage_const_1 
  P_list[_sage_const_0 ] = _sage_const_1 

  f_list = (m+_sage_const_1 )*[_sage_const_0 ] # sparse list for polynomial f
  f_list[_sage_const_131 ] = _sage_const_1 
  f_list[_sage_const_8 ] = _sage_const_1 
  f_list[_sage_const_3 ] = _sage_const_1 
  f_list[_sage_const_2 ] = _sage_const_1 
  f_list[_sage_const_0 ] = _sage_const_1 

else:
  print 'Iuput Errors'  
  exit()

depth = ceil(n/d) # memory depth
width = m*d # memory width (bit-level)


#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
ffi_elt = GF(_sage_const_2 **m, 'x', modulus = f_list)
PR_F_2m = PolynomialRing(ffi_elt, names=('z',)); (z,) = PR_F_2m._first_ngens(1)

#construct the polynomial ring over GF(2m)[z] based on the ring polynomial P
nonzero_idx = [i for i, e in enumerate(P_list) if e != _sage_const_0 ]
P = _sage_const_0 
for i in nonzero_idx:
  P += z**i

ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(P))


A = ffi_vec.random_element()
B = ffi_vec.random_element()

#output polynomials A/B to file (depth addresses, each address has m*d bits data (i.e., d GF2m elements, each of which is represented in MSB first mode))
fo = open("./verilog/mem_A.txt", "w+")
for i in range(depth):
  if (i < depth-_sage_const_1 ) or (i == depth-_sage_const_1  and n%d == _sage_const_0 ):
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
      fo.write(string.format(_sage_const_0 ))   
         
fo.close()

fo = open("./verilog/mem_B.txt", "w+")
for i in range(depth):
  if (i < depth-_sage_const_1 ) or (i == depth-_sage_const_1  and n%d == _sage_const_0 ):
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
      fo.write(string.format(_sage_const_0 ))   
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
