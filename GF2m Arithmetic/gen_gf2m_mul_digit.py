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
# Usage: python gen_gf2m_mul_digit.py -SL 'ROLLO-I-128' -d 16 > ./verilog/gf2m_mul.v

import os
import argparse

parser = argparse.ArgumentParser(description='Generate GF2m_mul_digit module.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO security level category')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='digit size of the multiplier')
args = parser.parse_args()

SL = args.SL
d = args.d


############################################################################
#
#   initialize the system parameters
#
############################################################################
#ROLLO-I setups
if SL == 'ROLLO-I-128':
  n = 47
  m = 79

  f_list = (m+1)*[0] # sparse list for polynomial f(x)
  f_list[79] = 1
  f_list[9] = 1
  f_list[0] = 1
  f_coeff_list = [79,9,0]

elif SL == 'ROLLO-I-192':
  n = 53
  m = 89

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[89] = 1
  f_list[38] = 1
  f_list[0] = 1
  f_coeff_list = [89,38,0]

elif SL == 'ROLLO-I-256': 
  n = 67
  m = 113

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[113] = 1
  f_list[9] = 1
  f_list[0] = 1
  f_coeff_list = [113,9,0]

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 149
  m = 83

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[83] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[2] = 1
  f_list[0] = 1
  f_coeff_list = [83,7,4,2,0]

elif SL == 'ROLLO-II-192':
  n = 151
  m = 107
  
  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[107] = 1
  f_list[9] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[0] = 1
  f_coeff_list = [107,9,7,4,0]

elif SL == 'ROLLO-II-256':
  n = 157
  m = 127
  
  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[127] = 1
  f_list[1] = 1
  f_list[0] = 1
  f_coeff_list = [127,1,0]

elif SL == 'ROLLO-III-128':
  n = 47
  m = 101
  
  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[101] = 1
  f_list[7] = 1
  f_list[6] = 1
  f_list[1] = 1
  f_list[0] = 1
  f_coeff_list = [101,7,6,1,0]

elif SL == 'ROLLO-III-192':
  n = 59
  m = 107
  
  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[107] = 1
  f_list[9] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[0] = 1
  f_coeff_list = [107,9,7,4,0]

elif SL == 'ROLLO-III-256':
  n = 67
  m = 131
  
  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[131] = 1
  f_list[8] = 1
  f_list[3] = 1
  f_list[2] = 1
  f_list[0] = 1
  f_coeff_list = [131,8,3,2,0]

else:
  print 'Iuput Errors'  
  exit()

if len(f_coeff_list) == 3:
	k = f_coeff_list[1]
	os.system("python ../GF2m\ Arithmetic/gen_gf2m_mul_digit_tri.py -WIDTH {m} -k {k} -d {d}".format(m = m, k = k, d = d))

elif len(f_coeff_list) == 5:
	k3 = f_coeff_list[1]
	k2 = f_coeff_list[2]
	k1 = f_coeff_list[3]
	os.system("python ../GF2m\ Arithmetic/gen_gf2m_mul_digit_penta.py -WIDTH {m} -k3 {k3} -k2 {k2} -k1 {k1} -d {d}".format(m = m, k3 = k3, k2 = k2, k1 = k1, d = d))