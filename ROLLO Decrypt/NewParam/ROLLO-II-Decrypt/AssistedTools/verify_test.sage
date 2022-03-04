#!/usr/bin/sage

#
# This file is part of the testbench, which verifies the result by comparing
# with the theoretical sage result.
#
# Copyright (C) 2016
# Authors: Wen Wang <wen.wang.ww349@yale.edu>
#          Ruben Niederhagen <ruben@polycephaly.org>
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
# example: sage verify_test.sage


SL = 'ROLLO-I-128'

############################################################################
#
#   initialize the system parameters
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

k = 2*n
l = 2*m
r = 5
d = 6

k1 = ceil(1.0*k/d)*d

MS = MatrixSpace(GF(2), k1, l)


#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
ffi_elt = GF(2^m, 'x', modulus = f_list)

# read S file and finv file - row wise
S_rows = []

with open("mem_S.txt", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    row = []
    for c in line[::-1]:
      row = [int(c)] + row
    for i in range(5): # a single line to 5 lines
      S_rows.append(row[i*m:i*m+m])


S = matrix(GF(2), S_rows)

print "Input matrix S 'as is':"
print S
print ""

finv_rows = []

with open("mem_finv.txt", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    row = []
    for c in line[::-1]:
      row = [int(c)] + row
    finv_rows.append(row)


finv = matrix(GF(2), finv_rows)

print "Input matrix finv 'as is':"
print finv
print ""

# compute S1S2 from S and f
S1 = matrix(GF(2),n,m)
for i in range(n):
    tmp = ( ffi_elt(S[i].list())*ffi_elt(finv[0].list()) ).polynomial().list()
    for j in range(len(tmp)):
        S1[i,j] = tmp[j]   

S2 = matrix(GF(2),n,m)
for i in range(n):
    tmp = ( ffi_elt(S[i].list())*ffi_elt(finv[1].list()) ).polynomial().list()
    for j in range(len(tmp)):
        S2[i,j] = tmp[j]  

# formulate the target 2n*2m matrix S1S2 from S1 and S2        
S1S2_cpt = block_matrix([ [S1, S1], [S2, 0] ])
ZERO = zero_matrix(GF(2), k1-k, l)
# S1S2_cpt = block_matrix([ [S1S2_cpt], [ZERO] ]) # pad S1S2_cpt with 0's



# read S1S2 file - row wise
S1S2_rows = []

with open("mem_S1S2.txt", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    row = []
    for c in line[::-1]:
      row = [int(c)] + row
    S1S2_rows.append(row)


S1S2 = matrix(GF(2), S1S2_rows) # S1S2 may not padded 0's, you need to check this.


if S1S2_cpt == S1S2:
  print "verified"
else:
  print "not verified"  


