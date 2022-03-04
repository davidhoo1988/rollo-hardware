`define ROLLO_II_128 1
`define D 7

`define READ_FIRST 1

`ifdef Obselete_Param
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
`else
	`ifdef ROLLO_I_128
		`define N 83
		`define M 67
	`elsif ROLLO_I_192
		`define N 97
		`define M 79
	`elsif ROLLO_I_256
		`define N 113
		`define M 97

	`elsif ROLLO_II_128
		`define N 189
		`define M 83
	`elsif ROLLO_II_192
		`define N 193
		`define M 97
	`elsif ROLLO_II_256
		`define N 211
		`define M 97
	`endif
`endif