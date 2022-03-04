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
#usage: sage rollo_rng_collector.sage -SL 'ROLLO-I-128' -d 3 (it generates the small dimension vector space E as one memory files 'mem_E.txt', 
# d GF(2m) elements reside in each memory cell)
import sys
import argparse


parser = argparse.ArgumentParser(description='Generate one memory files for the small dimension vector space E.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO Security Level')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='number of GF(2m) elements stored in each cell of the memory')
args = parser.parse_args()

SL = args.SL # security parameters derived from the NIST recommended categorization
digit = args.d # number of GF(2m) elements stored in each cell of the memory


#SL = 'ROLLO-I-128'
#digit = 3
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
  r = 5
  d = 6

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
  r = 6
  d = 7
  
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
  r = 7
  d = 8

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
  r = 5
  d = 8
  
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
  r = 6
  d = 8
  
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
  r = 7 
  d = 8
  
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
  w = 5
  wr = 6
  
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
  w = 6
  wr = 8
  
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
  w = 7
  wr = 8
  
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

if SL.find("ROLLO-I-") != -1 or SL.find("ROLLO-II-") != -1:
  depth = ceil(r/digit) # memory depth
  width = m*digit # memory width (bit-level)

if m*digit > 576: # ensure m*d <= 576
	raise RuntimeError('bit-length overflow in memory cell')	

#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
ffi_elt = GF(2^m, 'x', modulus = f_list)
PR_F_2m.<z> = PolynomialRing(ffi_elt)

#construct the polynomial ring over GF(2m)[z] based on the ring polynomial P
nonzero_idx = [i for i, e in enumerate(P_list) if e != 0]
P = 0
for i in nonzero_idx:
  P += z^i
ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(P))

f = P # keep consistency in rollo_basic.sage

# main function
load("rollo_basic.sage")
load("keccak.py") #self-made python file

keccak.prng_seed( 0xffffffff )
#keccak.prng_seed( randint(0, 0xffffffff) )


if SL.find("ROLLO-I-") != -1:
  for i in range(5):
    rng = keccak.prng() 
    rng_hex = hex( int(rng[0:], 2) )
    print "bin: " + rng
    print "hex: " + rng_hex
    print 

elif SL.find("ROLLO-II-") != -1:
  [pk, sk] = ROLLO_II_keygen()
  [c, cipher] = ROLLO_II_encap('hello world!', pk)
  msg = ROLLO_II_decap([c, cipher], sk)
  if 'hello world!' in msg:
    print "ROLLO-II OK"
  else:
    print "ROLLO-II not OK"  

elif SL.find("ROLLO-III-") != -1:
  [pk, sk] = ROLLO_III_keygen()
  [sr, se, E1] = ROLLO_III_encap(pk)
  E2 = ROLLO_III_decap([sr, se], sk)
  if E1 == E2:
    print "ROLLO-III OK"
  else:
    print "ROLLO-III not OK"



