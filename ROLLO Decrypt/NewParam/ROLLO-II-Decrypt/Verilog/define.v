`define ROLLO_II_128 1
`define READ_FIRST 1

`ifdef TEST
    `define N 3
    `define M 2
    `define D 2
`elsif ROLLO_I_128
    `define N 83
    `define M 67
    `define R 7
    `define D 8
`elsif ROLLO_I_192
    `define N 97
    `define M 79
    `define R 8
    `define D 8
`elsif ROLLO_I_256
    `define N 113
    `define M 97
    `define R 9
    `define D 9
`elsif ROLLO_II_128
    `define N 189
    `define M 83
    `define R 7
    `define D 8
`elsif ROLLO_II_192
    `define N 193
    `define M 97
    `define R 8
    `define D 8
`elsif ROLLO_II_256
    `define N 211
    `define M 97
    `define R 8
    `define D 9
`endif

`define x 16 //define the row number of systolic array


`define  k (2*`N)
`define  l (2*`M)
`define  d 5 //define GF2mz multiplier digit width
