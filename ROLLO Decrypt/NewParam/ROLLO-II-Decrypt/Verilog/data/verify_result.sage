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

# read data_in file - row wise
A_rows = []

# open the reference intersection results
with open("mem_E.txt", "r") as f:
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


A = matrix(GF(2), A_rows)

print ("Input matrix 'as is':")
print (A)
print ("")

A_rref = A # choose to use A.rref() or not
A_intersect = A_rref

if A_rref == A:
  print ("Intersetion of input matrix: ")
  print (A_intersect)


# read data_out file from hardware- row wise
B_rows = []

with open("mem_S1S2.txt", "r") as f:
  for line in f:
    if line.startswith("//"):
      continue

    line = line.replace('\r', '')
    line = line.replace('\n', '')
    row = []
    for c in line[::-1]:
      row = [int(c)] + row

    B_rows.append(row)


B = matrix(GF(2), B_rows[0:A_intersect.nrows()]) # extract the first few rows of B and ONLY compare them

print ("Output matrix 'as is':")
print (B)
print ("")

if B[:, B.ncols()/2:B.ncols()].echelon_form() == A_intersect:
  print ("verified")
else:
  print ("not verified")  


