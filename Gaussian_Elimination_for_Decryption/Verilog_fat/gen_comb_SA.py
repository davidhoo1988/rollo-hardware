'''
   This file is the code generation file for module comb_SA.v (used in ROLLO Decryption)

   Copyright (C) 2020
   Authors: Jingwei Hu <davidhoo471494221@gmail.com>
  
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
  
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
  
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
   
Generate a systolic array for k*l binary matrix as follows:
python2.7 gen_comb_SA.py -SL 'ROLLO-I-128' > comb_SA.v
'''

import argparse

parser = argparse.ArgumentParser(description='Generate Gaussian Elimination Systolic Array module for ROLLO Decryption.',
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-SL, --str', dest='SL', type=str, required= True,
          help='ROLLO security level')
args = parser.parse_args()

SL = args.SL

#ROLLO-I setups
if SL == 'ROLLO-I-128':
  n = 47
  m = 79
  r = 5

elif SL == 'ROLLO-I-192':
  n = 53
  m = 89
  r = 6

elif SL == 'ROLLO-I-256': 
  n = 67
  m = 113
  r = 7
#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 149
  m = 83
  r = 5

elif SL == 'ROLLO-II-192':
  n = 151
  m = 107
  r = 6

elif SL == 'ROLLO-II-256':
  n = 157
  m = 127
  r = 7

elif SL == 'ROLLO-III-128':
  n = 47
  m = 101
  r = 6

elif SL == 'ROLLO-III-192':
  n = 59
  m = 107
  r = 8

elif SL == 'ROLLO-III-256':
  n = 67
  m = 131
  r = 8

else:
  print 'Iuput Errors'  
  exit()

row_num = r
col_num = 2*m


print """module comb_SA #(parameter DAT_W = {0})(
  input wire clk,
  input wire rst_b,
  input wire mode,
  input start,
  input swap,
  input wire [DAT_W-1:0] data,
  output reg finish,
  output wire full_rank,
  output wire [DAT_W-1:0] result
);""".format(col_num)

print ""

print "  reg [{0} : 1] start_tmp;".format(row_num-1)
print "  reg [{0} : 1] start_row;".format(row_num-1)
print ""

print "  reg [{0} : 1] swap_row;".format(row_num-1)
print ""

print "  always @(posedge clk) begin"
for i in range(1,row_num):
   if i == 1:
      print "    start_tmp[{0}] <= start;".format(i, i-1, row_num-1)
      print "    start_row[{0}] <= start_tmp[{0}];".format(i, i-1, row_num-1)
   else:
      print "    start_tmp[{0}] <= start_row[{1}];".format(i, i-1, row_num-1)
      print "    start_row[{0}] <= start_tmp[{0}];".format(i, i-1)
print "  end"

print ""

print "  always @(posedge clk) begin"
for i in range(1,row_num):
   if i == 1:
      print "    swap_row[{0}] <= swap;".format(i, i-1, row_num-1)
   else:
      print "    swap_row[{0}] <= swap_row[{1}];".format(i, i-1)
print "  end"

print ""

print " //input skewed form"
for i in range(0,col_num):
  if i == 0:
    print " wire data_col0;"
  else:
    print " reg [{j}:1] data_col{j};".format(j = i)  

print ""

print " assign data_col0 = data[{0}];".format(col_num-1)
print ""

print "  always @(posedge clk) begin"
for i in range(1,col_num):
  for j in range(1,i+1):
    if j == 1:
      print "   data_col{p}[1] <= data[{r}];".format(p = i, r = col_num-1-i)
    else:
      print "   data_col{p}[{q}] <= data_col{p}[{r}];".format(p = i, q = j, r = j-1)    
  if i == col_num-1:
    print " end\n"
  else:
    print ""  

print " wire [DAT_W-1:0] data_in;"
print " assign data_in = {" + "data_col0, " + ", ".join(["data_col{0}[{0}]".format(i) for i in range(1,col_num)]) + "};"

print ""

for row in range(row_num):
   print "  /////////////////////////////////////"
   print "  // row {0}".format(row)

   for col in range(col_num):
      print "  // row {0}, col {1}".format(row, col)

      print ""
      
      if row == 0 and col == 0:
         print """     wire start_in_{row}_{col};
     wire start_out_{row}_{col};

     wire swap_in_{row}_{col};
     wire swap_out_{row}_{col};

     wire [1:0] op_in_{row}_{col};
     wire [1:0] op_out_{row}_{col};

     wire r_{row}_{col};

     wire data_in_{row}_{col};
     wire data_out_{row}_{col};

     wire pivot_in_{row}_{col};
     wire pivot_out_{row}_{col};""".format(row = row, col = col)

         print ""

         print """     assign data_in_{row}_{col} = data_in[DAT_W-1];
     assign op_in_{row}_{col} = 2'b00;
     assign pivot_in_0_0 = 0;

     assign start_in_{row}_{col} = start;
     assign swap_in_{row}_{col} = swap;""".format(row = row, col = col)

         print """
     processor_AB AB_{row}_{col} (
       .clk        (clk),
       .rst_b      (rst_b),
       .mode       (mode),
       .data_in    (data_in_{row}_{col}),
       .start_in   (start_in_{row}_{col}),
       .swap_in    (swap_in_{row}_{col}),
       .op_in      (op_in_{row}_{col}),
       .pivot_in   (pivot_in_{row}_{col}),
       .start_out  (start_out_{row}_{col}),
       .swap_out   (swap_out_{row}_{col}),
       .data_out   (data_out_{row}_{col}),
       .op_out     (op_out_{row}_{col}),
       .pivot_out  (pivot_out_{row}_{col}),
       .r          (r_{row}_{col})
     );""".format(row = row, col = col)

      elif row == 0 and row != col:
         print """     reg start_in_{row}_{col};
     wire start_out_{row}_{col};

     reg swap_in_{row}_{col};
     wire swap_out_{row}_{col};

     reg [1:0] op_in_{row}_{col};
     wire [1:0] op_out_{row}_{col};

     wire r_{row}_{col};

     wire data_in_{row}_{col};
     wire data_out_{row}_{col};

     reg pivot_in_{row}_{col};
     wire pivot_out_{row}_{col};""".format(row = row, col = col)

         print ""

         print """     assign data_in_{row}_{col} = data_in[DAT_W-{i}];

     always @(posedge clk) begin
        op_in_{row}_{col} <= op_out_{row}_{j};
        pivot_in_{row}_{col} <= pivot_out_{row}_{j};
        start_in_{row}_{col} <= start_out_{row}_{j};
        swap_in_{row}_{col} <= swap_out_{row}_{j};
     end""".format(row = row, col = col, i = 1+col, j = col-1)

         print """  
     processor_AB AB_{row}_{col} (
       .clk        (clk),
       .rst_b      (rst_b),
       .mode       (mode),
       .data_in    (data_in_{row}_{col}),
       .start_in   (start_in_{row}_{col}),
       .swap_in    (swap_in_{row}_{col}),
       .op_in      (op_in_{row}_{col}),
       .pivot_in   (pivot_in_{row}_{col}),
       .start_out  (start_out_{row}_{col}),
       .swap_out   (swap_out_{row}_{col}),
       .data_out   (data_out_{row}_{col}),
       .op_out     (op_out_{row}_{col}),
       .pivot_out  (pivot_out_{row}_{col}),
       .r          (r_{row}_{col})
     );""".format(row = row, col = col)

      elif row != 0 and col == 0:
         print """     wire start_in_{row}_{col};
     wire start_out_{row}_{col};

     wire swap_in_{row}_{col};
     wire swap_out_{row}_{col};

     wire [1:0] op_in_{row}_{col};
     wire [1:0] op_out_{row}_{col};

     wire r_{row}_{col};

     reg data_in_{row}_{col};
     wire data_out_{row}_{col};

     wire pivot_in_{row}_{col};
     wire pivout_out_{row}_{col};""".format(row = row, col = col)

         print ""

         print """     assign op_in_{row}_{col} = 2'b00;
     assign pivot_in_{row}_{col} = 0;

     assign start_in_{row}_{col} = start_row[{row}]; 
     assign swap_in_{row}_{col} = mode ? swap : swap_row[{row}]; 

     always @(posedge clk) begin
         data_in_{row}_{col} <= data_out_{i}_{col};
     end""".format(row = row, col = col, i = row-1)

         print """
     processor_AB AB_{row}_{col} (
       .clk        (clk),
       .rst_b      (rst_b),
       .mode       (mode),
       .data_in    (data_in_{row}_{col}),
       .start_in   (start_in_{row}_{col}),
       .swap_in   (swap_in_{row}_{col}),
       .op_in      (op_in_{row}_{col}),
       .pivot_in   (pivot_in_{row}_{col}),
       .start_out  (start_out_{row}_{col}),
       .swap_out   (swap_out_{row}_{col}),
       .data_out   (data_out_{row}_{col}),
       .op_out     (op_out_{row}_{col}),
       .pivot_out  (pivot_out_{row}_{col}),
       .r          (r_{row}_{col})
     );""".format(row = row, col = col)     


      else: # row != 0 and col != 0
         print """     reg start_in_{row}_{col};
     wire start_out_{row}_{col};

     reg swap_in_{row}_{col};
     wire swap_out_{row}_{col};

     reg [1:0] op_in_{row}_{col};
     wire [1:0] op_out_{row}_{col};

     wire r_{row}_{col};

     reg data_in_{row}_{col};
     wire data_out_{row}_{col};

     reg pivot_in_{row}_{col};
     wire pivot_out_{row}_{col};""".format(row = row, col = col)

         print ""

         print """     always @(posedge clk) begin
         op_in_{row}_{col} <= op_out_{row}_{j};
         pivot_in_{row}_{col} <= pivot_out_{row}_{j};
         start_in_{row}_{col} <= start_out_{row}_{j};
         swap_in_{row}_{col} <= swap_out_{row}_{j};
     end""".format(row = row, col = col, i = row-1, j = col-1)

         print ""

         print """     always @(posedge clk) begin
         data_in_{row}_{col} <= data_out_{i}_{col};
     end""".format(row = row, col = col, i = row-1, j = col-1)

         print """  
     processor_AB AB_{row}_{col} (
       .clk        (clk),
       .rst_b      (rst_b),
       .mode       (mode),
       .data_in    (data_in_{row}_{col}),
       .start_in   (start_in_{row}_{col}),
       .swap_in   (swap_in_{row}_{col}),
       .op_in      (op_in_{row}_{col}),
       .pivot_in   (pivot_in_{row}_{col}),
       .start_out  (start_out_{row}_{col}),
       .swap_out   (swap_out_{row}_{col}),
       .data_out   (data_out_{row}_{col}),
       .op_out     (op_out_{row}_{col}),
       .pivot_out  (pivot_out_{row}_{col}),
       .r          (r_{row}_{col})
     );""".format(row = row, col = col)


      print ""

print "  /////////////////////////////////////"
print "  // outputs \n"
print "  wire [{0}:0] pivot_found;".format(row_num-1);

print "  wire [{0}:0] ".format(col_num-1) + ", ".join([ "row{0}".format(i) for i in range(row_num) ]) + ";"

print ""

print "  assign pivot_found = {" + ", ".join([ " | ".join(["r_{i}_{j}".format(i = i, j = j) for j in range(col_num)]) for i in range(row_num) ]) + "};"
print "  assign full_rank =  pivot_found == {0}'b".format(row_num) + '1'*row_num + " ? 1'b1 : 1'b0;"

print ""

for i in range(row_num):
  print "  assign row{0} = {{".format(i) + ", ".join(["r_{row}_{col}".format(row = i, col = j) for j in range(col_num)]) + "};"

print ""

print """  always @(posedge clk) begin
      finish <= ~mode ? start_out_{row}_{col}: start_out_{row2}_{col2};
  end""".format(row = row_num-1, col = col_num-1, row2 = 0, col2 = col_num-2)

print ""

print "   //output regular form from skewed form via pipelining"
for i in range(0,col_num):
    print " reg [{j}:1] result_col{k};".format(j = col_num-i, k = i)  

print ""

print "  always @(posedge clk) begin"
for i in range(0,col_num):
  for j in range(1,col_num+1-i):
    if j == 1:
      print "   result_col{i}[1] <= data_out_{row}_{col};".format(i = i, row = row_num-1, col = i)
    else:
      print "   result_col{i}[{q}] <= result_col{i}[{r}];".format(i = i, q = j, r = j-1)    
  if i == col_num-1:
    print " end\n"
  else:
    print ""  

print " assign result = {" + ", ".join(["result_col{i}[{j}]".format(i = i, j = col_num-i) for i in range(0,col_num-1)]) + ", result_col{0}[1]".format(col_num-1) + "};"

print ""

print "endmodule\n"








      