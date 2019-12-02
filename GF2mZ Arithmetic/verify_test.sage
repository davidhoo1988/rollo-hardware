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

#usage: sage verify_test.sage 'ROLLO-I-128' '3' 'mem_A.txt' 'mem_B.txt' 'mem_C.txt' (it extracts two memory files as 'mem_A.txt' and 'mem_B.txt' and compare the result with that of 'mem_C.txt')

import sys


SL = str(sys.argv[1])
d = int(sys.argv[2])
mem_A = str(sys.argv[3])
mem_B = str(sys.argv[4])
mem_C = str(sys.argv[5])

#set_random_seed(12345)

############################################################################
#
#	initialize the system parameters
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
  print 'Input Errors'  
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


A1 = ffi_vec.random_element()
B1 = ffi_vec.random_element()
############################################################################
#
#	extract the data from the input memory files and then verify the correctness
#
############################################################################

# read mem_A file - line wise, 4 GF(2m) coefficients in each line, every coefficient is MSB first
rows = []
with open(mem_A, "r") as f:
	for line in f:
		if line.startswith("//"): #strip off the comment lines
			continue

		line = line.replace('\r', '') #handle the ending symbol '\r\n' in MS-Windows format
		for i in range(d):
			row = []
			coeff = line[i*m:i*m+m]
			for c in coeff:
				row = [int(c)] + row
			rows.append(row)
A = ffi_vec(rows)

# read mem_B file
rows = []
with open(mem_B, "r") as f:
	for line in f:
		if line.startswith("//"): #strip off the comment lines
			continue

		line = line.replace('\r', '') #handle the ending symbol '\r\n' in MS-Windows format
		for i in range(d):
			row = []
			coeff = line[i*m:i*m+m]
			for c in coeff:
				row = [int(c)] + row
			rows.append(row)
B = ffi_vec(rows)

# read mem_C file
rows = []
with open(mem_C, "r") as f:
	for line in f:
		if line.startswith("//"): #strip off the comment lines
			continue

		line = line.replace('\r', '') #handle the ending symbol '\r\n' in MS-Windows format
		for i in range(d):
			row = []
			coeff = line[i*m:i*m+m]
			for c in coeff:
				row = [int(c)] + row
			rows.append(row)
C = ffi_vec(rows)

if C == A*B:
	print "OK"
else: 
	print "ERROR"
	exit(-1)
