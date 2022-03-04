// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Fri Mar 13 10:50:18 2020
// Host        : David-NTU-Desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file {C:/Users/David/Dropbox/LRPC
//               Code/hardware/Gaussian_Elimination/Gaussian_Elimination.sim/sim_1/synth/timing/modelsim/comb_SA_tb_time_synth.v}
// Design      : comb_SA
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a15tcsg325-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* DAT_W = "4" *) 
(* NotValidForBitStream *)
module comb_SA
   (clk,
    rst_b,
    start,
    data,
    finish,
    r_A_and);
  input clk;
  input rst_b;
  input start;
  input [3:0]data;
  output finish;
  output r_A_and;

  wire A_1_1_n_1;
  wire A_1_1_n_2;
  wire B_1_2_n_0;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [3:0]data;
  wire [3:1]data_IBUF;
  wire data_in_1_1;
  wire data_in_1_2;
  wire data_in_2_2;
  wire data_out_0_1;
  wire data_out_0_2;
  wire data_out_1_2;
  wire finish;
  wire finish_OBUF;
  wire r0;
  wire r_0_0;
  wire r_1_1;
  wire r_2_2;
  wire r_A_and;
  wire r_A_and_OBUF;
  wire rst_b;
  wire rst_b_IBUF;
  wire start;
  wire start_IBUF;
  wire start_in_2_2;
  wire start_out_1_1;
  wire [2:1]start_tmp;

initial begin
 $sdf_annotate("comb_SA_tb_time_synth.sdf",,,,"tool_control");
end
  processor_A A_0_0
       (.CLK(clk_IBUF_BUFG),
        .data_IBUF(data_IBUF[3]),
        .r0(r0),
        .r_0_0(r_0_0),
        .r_1_1(r_1_1),
        .r_2_2(r_2_2),
        .r_A_and_OBUF(r_A_and_OBUF),
        .rst_b(A_1_1_n_1),
        .start_IBUF(start_IBUF));
  processor_A_0 A_1_1
       (.CLK(clk_IBUF_BUFG),
        .Q(start_out_1_1),
        .data_in_1_1(data_in_1_1),
        .data_in_1_2(data_in_1_2),
        .r_1_1(r_1_1),
        .r_reg_0(A_1_1_n_1),
        .r_reg_1(A_1_1_n_2),
        .r_reg_2(B_1_2_n_0),
        .rst_b_IBUF(rst_b_IBUF));
  processor_A_1 A_2_2
       (.CLK(clk_IBUF_BUFG),
        .Q(start_in_2_2),
        .data_in_2_2(data_in_2_2),
        .r_2_2(r_2_2),
        .rst_b(A_1_1_n_1));
  processor_B B_0_1
       (.CLK(clk_IBUF_BUFG),
        .data_IBUF(data_IBUF[3:2]),
        .data_out_0_1(data_out_0_1),
        .r0(r0),
        .r_0_0(r_0_0),
        .rst_b(A_1_1_n_1),
        .start_IBUF(start_IBUF));
  processor_B_2 B_0_2
       (.CLK(clk_IBUF_BUFG),
        .data_IBUF({data_IBUF[3],data_IBUF[1]}),
        .data_out_0_2(data_out_0_2),
        .r0(r0),
        .r_0_0(r_0_0),
        .rst_b(A_1_1_n_1),
        .start_IBUF(start_IBUF));
  processor_B_3 B_1_2
       (.CLK(clk_IBUF_BUFG),
        .Q(start_out_1_1),
        .data_in_1_1(data_in_1_1),
        .data_in_1_2(data_in_1_2),
        .data_in_1_2_reg(A_1_1_n_2),
        .data_in_2_2_reg(B_1_2_n_0),
        .data_out_1_2(data_out_1_2),
        .r_1_1(r_1_1),
        .rst_b(A_1_1_n_1));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF \data_IBUF[1]_inst 
       (.I(data[1]),
        .O(data_IBUF[1]));
  IBUF \data_IBUF[2]_inst 
       (.I(data[2]),
        .O(data_IBUF[2]));
  IBUF \data_IBUF[3]_inst 
       (.I(data[3]),
        .O(data_IBUF[3]));
  FDRE #(
    .INIT(1'b0)) 
    data_in_1_1_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(data_out_0_1),
        .Q(data_in_1_1),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    data_in_1_2_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(data_out_0_2),
        .Q(data_in_1_2),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    data_in_2_2_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(data_out_1_2),
        .Q(data_in_2_2),
        .R(1'b0));
  OBUF finish_OBUF_inst
       (.I(finish_OBUF),
        .O(finish));
  FDRE #(
    .INIT(1'b0)) 
    finish_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(start_in_2_2),
        .Q(finish_OBUF),
        .R(1'b0));
  OBUF r_A_and_OBUF_inst
       (.I(r_A_and_OBUF),
        .O(r_A_and));
  IBUF rst_b_IBUF_inst
       (.I(rst_b),
        .O(rst_b_IBUF));
  IBUF start_IBUF_inst
       (.I(start),
        .O(start_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \start_row_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(start_tmp[1]),
        .Q(start_out_1_1),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \start_row_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(start_tmp[2]),
        .Q(start_in_2_2),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \start_tmp_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(start_IBUF),
        .Q(start_tmp[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \start_tmp_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(start_out_1_1),
        .Q(start_tmp[2]),
        .R(1'b0));
endmodule

module processor_A
   (r_0_0,
    r_A_and_OBUF,
    r0,
    rst_b,
    CLK,
    start_IBUF,
    data_IBUF,
    r_1_1,
    r_2_2);
  output r_0_0;
  output r_A_and_OBUF;
  output r0;
  input rst_b;
  input CLK;
  input start_IBUF;
  input [0:0]data_IBUF;
  input r_1_1;
  input r_2_2;

  wire CLK;
  wire [0:0]data_IBUF;
  wire r0;
  wire r_0_0;
  wire r_1_1;
  wire r_2_2;
  wire r_A_and_OBUF;
  wire r_i_1__0_n_0;
  wire rst_b;
  wire start_IBUF;

  LUT3 #(
    .INIT(8'h80)) 
    r_A_and_OBUF_inst_i_1
       (.I0(r_0_0),
        .I1(r_1_1),
        .I2(r_2_2),
        .O(r_A_and_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hDC)) 
    r_i_1__0
       (.I0(start_IBUF),
        .I1(data_IBUF),
        .I2(r_0_0),
        .O(r_i_1__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hAE)) 
    r_i_2
       (.I0(start_IBUF),
        .I1(data_IBUF),
        .I2(r_0_0),
        .O(r0));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(1'b1),
        .D(r_i_1__0_n_0),
        .Q(r_0_0),
        .R(rst_b));
endmodule

(* ORIG_REF_NAME = "processor_A" *) 
module processor_A_0
   (r_1_1,
    r_reg_0,
    r_reg_1,
    CLK,
    rst_b_IBUF,
    Q,
    data_in_1_1,
    data_in_1_2,
    r_reg_2);
  output r_1_1;
  output r_reg_0;
  output r_reg_1;
  input CLK;
  input rst_b_IBUF;
  input [0:0]Q;
  input data_in_1_1;
  input data_in_1_2;
  input r_reg_2;

  wire CLK;
  wire [0:0]Q;
  wire data_in_1_1;
  wire data_in_1_2;
  wire r_1_1;
  wire r_i_1__1_n_0;
  wire r_reg_0;
  wire r_reg_1;
  wire r_reg_2;
  wire rst_b_IBUF;

  LUT1 #(
    .INIT(2'h1)) 
    r_i_1
       (.I0(rst_b_IBUF),
        .O(r_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hDC)) 
    r_i_1__1
       (.I0(Q),
        .I1(data_in_1_1),
        .I2(r_1_1),
        .O(r_i_1__1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hBBAB88A8)) 
    r_i_1__2
       (.I0(data_in_1_2),
        .I1(Q),
        .I2(data_in_1_1),
        .I3(r_1_1),
        .I4(r_reg_2),
        .O(r_reg_1));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(1'b1),
        .D(r_i_1__1_n_0),
        .Q(r_1_1),
        .R(r_reg_0));
endmodule

(* ORIG_REF_NAME = "processor_A" *) 
module processor_A_1
   (r_2_2,
    rst_b,
    CLK,
    Q,
    data_in_2_2);
  output r_2_2;
  input rst_b;
  input CLK;
  input [0:0]Q;
  input data_in_2_2;

  wire CLK;
  wire [0:0]Q;
  wire data_in_2_2;
  wire r_2_2;
  wire r_i_1__3_n_0;
  wire rst_b;

  LUT3 #(
    .INIT(8'hDC)) 
    r_i_1__3
       (.I0(Q),
        .I1(data_in_2_2),
        .I2(r_2_2),
        .O(r_i_1__3_n_0));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(1'b1),
        .D(r_i_1__3_n_0),
        .Q(r_2_2),
        .R(rst_b));
endmodule

module processor_B
   (data_out_0_1,
    rst_b,
    r0,
    data_IBUF,
    CLK,
    r_0_0,
    start_IBUF);
  output data_out_0_1;
  input rst_b;
  input r0;
  input [1:0]data_IBUF;
  input CLK;
  input r_0_0;
  input start_IBUF;

  wire CLK;
  wire [1:0]data_IBUF;
  wire data_out_0_1;
  wire r0;
  wire r_0_0;
  wire r_reg_n_0;
  wire rst_b;
  wire start_IBUF;

  LUT5 #(
    .INIT(32'h00006FA0)) 
    data_in_1_1_i_1
       (.I0(r_reg_n_0),
        .I1(r_0_0),
        .I2(data_IBUF[1]),
        .I3(data_IBUF[0]),
        .I4(start_IBUF),
        .O(data_out_0_1));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(r0),
        .D(data_IBUF[0]),
        .Q(r_reg_n_0),
        .R(rst_b));
endmodule

(* ORIG_REF_NAME = "processor_B" *) 
module processor_B_2
   (data_out_0_2,
    rst_b,
    r0,
    data_IBUF,
    CLK,
    r_0_0,
    start_IBUF);
  output data_out_0_2;
  input rst_b;
  input r0;
  input [1:0]data_IBUF;
  input CLK;
  input r_0_0;
  input start_IBUF;

  wire CLK;
  wire [1:0]data_IBUF;
  wire data_out_0_2;
  wire r0;
  wire r_0_0;
  wire r_reg_n_0;
  wire rst_b;
  wire start_IBUF;

  LUT5 #(
    .INIT(32'h00006FA0)) 
    data_in_1_2_i_1
       (.I0(r_reg_n_0),
        .I1(r_0_0),
        .I2(data_IBUF[1]),
        .I3(data_IBUF[0]),
        .I4(start_IBUF),
        .O(data_out_0_2));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(r0),
        .D(data_IBUF[0]),
        .Q(r_reg_n_0),
        .R(rst_b));
endmodule

(* ORIG_REF_NAME = "processor_B" *) 
module processor_B_3
   (data_in_2_2_reg,
    data_out_1_2,
    rst_b,
    data_in_1_2_reg,
    CLK,
    r_1_1,
    data_in_1_1,
    data_in_1_2,
    Q);
  output data_in_2_2_reg;
  output data_out_1_2;
  input rst_b;
  input data_in_1_2_reg;
  input CLK;
  input r_1_1;
  input data_in_1_1;
  input data_in_1_2;
  input [0:0]Q;

  wire CLK;
  wire [0:0]Q;
  wire data_in_1_1;
  wire data_in_1_2;
  wire data_in_1_2_reg;
  wire data_in_2_2_reg;
  wire data_out_1_2;
  wire r_1_1;
  wire rst_b;

  LUT5 #(
    .INIT(32'h00006FA0)) 
    data_in_2_2_i_1
       (.I0(data_in_2_2_reg),
        .I1(r_1_1),
        .I2(data_in_1_1),
        .I3(data_in_1_2),
        .I4(Q),
        .O(data_out_1_2));
  FDRE #(
    .INIT(1'b0)) 
    r_reg
       (.C(CLK),
        .CE(1'b1),
        .D(data_in_1_2_reg),
        .Q(data_in_2_2_reg),
        .R(rst_b));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
