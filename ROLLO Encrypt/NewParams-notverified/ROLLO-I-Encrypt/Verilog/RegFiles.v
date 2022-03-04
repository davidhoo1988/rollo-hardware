`include "clog2.v" 
`include "define.v"

module RegFiles #(parameter n = `N, m = `M, r = `R) (
	input clk,
	input rst_b,

	input rw,
	input [r:0] ctrl_w, //control word:  1-bit ctrl + (r)-bit rand
	input [`CLOG2(r)-1:0] addr,
	input [m-1:0] data_in,

	output reg [m-1:0] data_out
	);

(* srl_style = "register" *) 
reg [m-1:0] files [0:r-1];

wire [m-1:0] acc [0:r-1];

assign acc[0] = ctrl_w[r-1] ? files[0] : 0;
assign acc[1] = ctrl_w[r-2] ? files[1]^acc[0] : acc[0];
assign acc[2] = ctrl_w[r-3] ? files[2]^acc[1] : acc[1];
assign acc[3] = ctrl_w[r-4] ? files[3]^acc[2] : acc[2];
assign acc[4] = ctrl_w[r-5] ? files[4]^acc[3] : acc[3];
assign acc[5] = ctrl_w[r-6] ? files[5]^acc[4] : acc[4];
assign acc[6] = ctrl_w[r-7] ? files[6]^acc[5] : acc[5];

//storage function
always @(posedge clk or negedge rst_b) begin
	if (~rst_b) begin
		// reset
		files[0] <= 0;
		files[1] <= 0;
		files[2] <= 0;
		files[3] <= 0;
		files[4] <= 0;
		files[5] <= 0;
		files[6] <= 0;
		data_out <= 0;
	end
	//trigger random linear combination of files[0],...,files[r-1]
	else if (ctrl_w[r] != 0) begin
		data_out <= acc[6];
	end
	//trigger normal write regs
	else if (rw == 1) begin
		files[addr] <= data_in;
	end
	//trigger normal read regs
	else begin
		data_out <= files[addr];
	end
end




	
endmodule