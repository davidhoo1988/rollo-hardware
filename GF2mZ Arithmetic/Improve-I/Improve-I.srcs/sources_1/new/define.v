`define ROLLO_I_128 1
`define D 1

`define READ_FIRST 1

`ifdef ROLLO_I_128
	`define N 47
	`define M 79
`elsif ROLLO_I_192
	`define N 53
	`define M 89
`elsif ROLLO_I_256
	`define N 67
	`define M 113

`elsif ROLLO_II_128
	`define N 149
	`define M 83
`elsif ROLLO_II_192
	`define N 151
	`define M 107
`elsif ROLLO_II_256
	`define N 157
	`define M 127

`elsif ROLLO_III_128
	`define N 47
	`define M 101
`elsif ROLLO_III_192
	`define N 59
	`define M 107
`elsif ROLLO_III_256
	`define N 67
	`define M 131
`endif