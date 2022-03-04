`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2019 06:26:30 PM
// Design Name: 
// Module Name: GF2m_mul_penta
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "clog2.v"

module GF2m_mul_penta #(parameter WIDTH = 67, k3 = 5, k2 = 2, k1 = 1)(
	input wire clk,
	input wire rst_b,
	input wire start,
	input wire [WIDTH-1:0] op_a,
	input wire [WIDTH-1:0] op_b,

	output reg done,
	output wire [WIDTH-1:0] op_c

    );

wire [WIDTH-1:0] cx1, cx;

reg [WIDTH-1:0] a; //shift register to load/shift a(x)
reg [WIDTH-1:0] b; // keep b(x)
reg [WIDTH-1:0] c; //result register for a(x)*b(x), big endian notation


reg start_en;
reg [`CLOG2(WIDTH)-1:0] cnt;

//control signal
always @(posedge clk) begin
	if (!rst_b)
		start_en <= 1'b0;
	else if (start)
		start_en <= 1'b1;
	else if (cnt == WIDTH-1)
		start_en <= 1'b0;	
	else 
		start_en <= start_en;		
end

always @(posedge clk) begin
	if (!rst_b) 
		// reset
		cnt <= 0;
	else if (cnt == WIDTH-1)
		cnt <= 0;
	else if (start_en) 
		cnt <= cnt + 1'b1;
	else 
		cnt <= cnt;	
end

always @(posedge clk) begin
	if (!rst_b)
		done <= 1'b0;
	else if (cnt == WIDTH-1)
		done <= 1'b1;
	else
		done <= 1'b0;		
end


//arithmetic 
always @(posedge clk) begin
	if (!rst_b) 
		// reset
		a <= {WIDTH{1'b0}};
	else if (start) 
		a <= op_a;
	else if (start_en)
		a <= {a[WIDTH-2:0],1'b0};
	else 
		a <= 0;	
end

always @(posedge clk) begin
	if (!rst_b) 
		// reset
		b <= {WIDTH{1'b0}};
	else if (start) 
		b <= op_b;
	else 
		b <= b;	
end


always @(posedge clk) begin
	if (!rst_b) 
		// reset
		c <= {WIDTH{1'b0}};
	else if (start)
		c <= {WIDTH{1'b0}};	
	else if (start_en) 
		c <= cx ^ (a[WIDTH-1] ? b : {WIDTH{1'b0}});
	else 
		c <= c;	
end


assign cx1 = {c[WIDTH-2:0],c[WIDTH-1]};
assign cx = {cx1[WIDTH-1:k3+1], {cx1[k3]^c[WIDTH-1]}, cx1[k3-1:k2+1], {cx1[k2]^c[WIDTH-1]},cx1[k2-1:k1+1], {cx1[k1]^c[WIDTH-1]}, cx1[k1-1:0]};

assign op_c = c;

endmodule