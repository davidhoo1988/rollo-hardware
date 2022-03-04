
# This file was *autogenerated* from the file verify_test.sage
from sage.all_cmdline import *   # import sage library

_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0)#!/usr/bin/sage

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

# read data_in file - row wise
A_rows = []

with open("data.in", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    print (line)
    row = []
    for c in line:
      row = row + [int(c)]
    A_rows.append(row)


A = matrix(GF(_sage_const_2 ), A_rows)

print ("Input matrix 'as is':")
print (A)
print ("")

A_rref = A.echelon_form()
tmp = []
for r in A_rref.rows():
  if r[_sage_const_0 :A_rref.ncols()/_sage_const_2 ] == zero_vector(GF(_sage_const_2 ),A_rref.ncols()/_sage_const_2 ) and r[A_rref.ncols()/_sage_const_2 :A_rref.ncols()] != zero_vector(GF(_sage_const_2 ),A_rref.ncols()/_sage_const_2 ):
    tmp.append(list(r[A_rref.ncols()/_sage_const_2 :A_rref.ncols()]))
A_intersect = matrix(tmp)

print ("Intersetion of input matrix: ")
print (A_intersect)


# read data_out file - row wise
B_rows = []

with open("data.out", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    row = []
    for c in line[::-_sage_const_1 ]:
      row = [int(c)] + row

    B_rows.append(row)


B = matrix(GF(_sage_const_2 ), B_rows[_sage_const_0 :A_intersect.nrows()]) # extract the first few rows of B and ONLY compare them

print ("Output matrix 'as is':")
print (B)
print ("")

if B[:, B.ncols()/_sage_const_2 :B.ncols()].echelon_form() == A_intersect:
  print ("verified")
else:
  print ("not verified")  



