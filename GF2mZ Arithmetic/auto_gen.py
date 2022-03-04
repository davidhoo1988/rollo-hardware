#! /usr/bin/python

#
# This file is part of the ROLLO hardware, which generates a digit-level
# GF(2m)[Z] multiplier
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
# Function: code generation tool for all frequently changed files
# Usage: python auto_gen.py -SL 'ROLLO-I-128' -d 4 -GF2_MUL_WIDTH 16

import os
import argparse

parser = argparse.ArgumentParser(description='Wrapper for generating all hdl files.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO security level category')
parser.add_argument('-d, --num', dest='d', type=int, required= True,
          help='number of GF2m coefficients in each memory cell')
parser.add_argument('-GF2_MUL_WIDTH, --num', dest='GF2_MUL_WIDTH', type=int, required= True,
          help='digit size of the multiplier')

args = parser.parse_args()

SL = args.SL
d = args.d
GF2_MUL_WIDTH = args.GF2_MUL_WIDTH


#generate memory files: mem_A.txt mem_B.txt
os.system("sage gen_test.sage -SL {SL} -d {d}".format(SL = SL, d = d))
print ("mem_A.txt mem_B.txt are generated.")

#generate gf2mz_top.v
os.system("python gen_gf2mz_top.py -SL {SL} -d {d} -GF2_MUL_WIDTH {GF2_MUL_WIDTH} > ./verilog/gf2mz_top.v".format(SL = SL, d = d, GF2_MUL_WIDTH = GF2_MUL_WIDTH))
print ("gf2mz_top.v is generated.")

#generate mul_ctrl.v
os.system("python gen_mul_ctrl.py -SL {SL} -d {d} > ./verilog/mul_ctrl.v".format(SL = SL, d = d))
print ("mul_ctrl.v is generated.")

#generate gf2m_mul.v
os.system("python ../GF2m\ Arithmetic/gen_gf2m_mul_digit.py -SL {SL} -d {d} >./verilog/gf2m_mul.v".format(SL = SL, d = GF2_MUL_WIDTH))
print ("gf2m_mul.v is generated.")
