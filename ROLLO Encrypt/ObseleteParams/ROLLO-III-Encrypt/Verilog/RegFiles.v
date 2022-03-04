//`include "clog2.v" 
//`include "define.v"

module RegFiles #(parameter n = `N, m = `M, wr = `Wr) (
	input clk,
	input rst_b,

	input rw,
	input [wr:0] ctrl_w, //control word:  1-bit ctrl + (wr)-bit rand
	input [`CLOG2(wr)-1:0] addr,
	input [m-1:0] data_in,

	output reg [m-1:0] data_out
	);

(* srl_style = "register" *) 
reg [m-1:0] files [0:wr-1];

wire [m-1:0] acc [0:wr-1];

assign acc[0] = ctrl_w[wr-1] ? files[0] : 0;
assign acc[1] = ctrl_w[wr-2] ? files[1]^acc[0] : acc[0];
assign acc[2] = ctrl_w[wr-3] ? files[2]^acc[1] : acc[1];
assign acc[3] = ctrl_w[wr-4] ? files[3]^acc[2] : acc[2];
assign acc[4] = ctrl_w[wr-5] ? files[4]^acc[3] : acc[3];
assign acc[5] = ctrl_w[wr-6] ? files[5]^acc[4] : acc[4];

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
		data_out <= 0;
	end
	else if (ctrl_w[wr] != 0) begin
		data_out <= acc[5];
	end
	else if (rw == 1) begin
		files[addr] <= data_in;
	end
	else begin
		data_out <= files[addr];
	end
end




	
endmodule