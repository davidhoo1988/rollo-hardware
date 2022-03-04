module comb_SA #(parameter DAT_W = 4)(
  input wire clk,
  input wire rst_b,
  input start,
  input wire [DAT_W-1:0] data,
  output reg finish,
  output wire r_A_and,
  output wire dout_and
);

  reg [2 : 1] start_tmp;
  reg [2 : 1] start_row;

  always @(posedge clk) begin
    start_tmp[1] <= start;
    start_row[1] <= start_tmp[1];
    start_tmp[2] <= start_row[1];
    start_row[2] <= start_tmp[2];
  end

  always @(posedge clk) begin
     finish <= start_row[2];
  end

  /////////////////////////////////////
  // row 0
  // row 0, col 0

     wire start_in_0_0;
     wire start_out_0_0;

     wire [1:0] op_out_0_0;

     wire r_0_0;

     wire data_in_0_0;
     wire data_out_0_0;

     assign data_in_0_0 = data[DAT_W-1];

     assign start_in_0_0 = start;

     processor_A A_0_0 (
       .clk        (clk),
       .rst_b      (rst_b),
       .data_in    (data_in_0_0),
       .start_in   (start_in_0_0),
       .op_out     (op_out_0_0),
       .start_out  (start_out_0_0),
       .data_out   (data_out_0_0),
       .r          (r_0_0)
     );

  // row 0, col 1

     wire start_in_0_1;
     wire start_out_0_1;

     wire [1:0] op_in_0_1;
     wire [1:0] op_out_0_1;

     wire data_in_0_1;
     wire data_out_0_1;

     assign data_in_0_1 = data[DAT_W-2];

     assign start_in_0_1 = start_out_0_0;
     assign op_in_0_1 = op_out_0_0;
  
     processor_B B_0_1 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_0_1),
       .start_in  (start_in_0_1),
       .op_in     (op_in_0_1),
       .op_out    (op_out_0_1),
       .start_out (start_out_0_1),
       .data_out  (data_out_0_1),
       .r         ()
     );

  // row 0, col 2

     wire start_in_0_2;
     wire start_out_0_2;

     wire [1:0] op_in_0_2;
     wire [1:0] op_out_0_2;

     wire data_in_0_2;
     wire data_out_0_2;

     assign data_in_0_2 = data[DAT_W-3];

     assign start_in_0_2 = start_out_0_1;
     assign op_in_0_2 = op_out_0_1;
  
     processor_B B_0_2 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_0_2),
       .start_in  (start_in_0_2),
       .op_in     (op_in_0_2),
       .op_out    (op_out_0_2),
       .start_out (start_out_0_2),
       .data_out  (data_out_0_2),
       .r         ()
     );

  // row 0, col 3

     wire start_in_0_3;
     wire start_out_0_3;

     wire [1:0] op_in_0_3;
     wire [1:0] op_out_0_3;

     wire data_in_0_3;
     wire data_out_0_3;

     assign data_in_0_3 = data[DAT_W-4];

     assign start_in_0_3 = start_out_0_2;
     assign op_in_0_3 = op_out_0_2;
  
     processor_B B_0_3 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_0_3),
       .start_in  (start_in_0_3),
       .op_in     (op_in_0_3),
       .op_out    (op_out_0_3),
       .start_out (start_out_0_3),
       .data_out  (data_out_0_3),
       .r         ()
     );

  /////////////////////////////////////
  // row 1
  // row 1, col 1

     wire start_in_1_1;
     wire start_out_1_1;

     wire [1:0] op_out_1_1;

     wire r_1_1;

     reg data_in_1_1;
     wire data_out_1_1;

     always @(posedge clk) begin
         data_in_1_1 <= data_out_0_1;
     end

     assign start_in_1_1 = start_row[1];


     processor_A A_1_1 (
       .clk        (clk),
       .rst_b      (rst_b),
       .data_in    (data_in_1_1),
       .start_in   (start_in_1_1),
       .op_out     (op_out_1_1),
       .start_out  (start_out_1_1),
       .data_out   (data_out_1_1),
       .r          (r_1_1)
     );

  // row 1, col 2

     wire start_in_1_2;
     wire start_out_1_2;

     wire [1:0] op_in_1_2;
     wire [1:0] op_out_1_2;

     reg data_in_1_2;
     wire data_out_1_2;

     always @(posedge clk) begin
         data_in_1_2 <= data_out_0_2;
     end

     assign start_in_1_2 = start_out_1_1;
     assign op_in_1_2 = op_out_1_1;
  
     processor_B B_1_2 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_1_2),
       .start_in  (start_in_1_2),
       .op_in     (op_in_1_2),
       .op_out    (op_out_1_2),
       .start_out (start_out_1_2),
       .data_out  (data_out_1_2),
       .r         ()
     );

  // row 1, col 3

     wire start_in_1_3;
     wire start_out_1_3;

     wire [1:0] op_in_1_3;
     wire [1:0] op_out_1_3;

     reg data_in_1_3;
     wire data_out_1_3;

     always @(posedge clk) begin
         data_in_1_3 <= data_out_0_3;
     end

     assign start_in_1_3 = start_out_1_2;
     assign op_in_1_3 = op_out_1_2;
  
     processor_B B_1_3 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_1_3),
       .start_in  (start_in_1_3),
       .op_in     (op_in_1_3),
       .op_out    (op_out_1_3),
       .start_out (start_out_1_3),
       .data_out  (data_out_1_3),
       .r         ()
     );

  /////////////////////////////////////
  // row 2
  // row 2, col 2

     wire start_in_2_2;
     wire start_out_2_2;

     wire [1:0] op_out_2_2;

     wire r_2_2;

     reg data_in_2_2;
     wire data_out_2_2;

     always @(posedge clk) begin
         data_in_2_2 <= data_out_1_2;
     end

     assign start_in_2_2 = start_row[2];


     processor_A A_2_2 (
       .clk        (clk),
       .rst_b      (rst_b),
       .data_in    (data_in_2_2),
       .start_in   (start_in_2_2),
       .op_out     (op_out_2_2),
       .start_out  (start_out_2_2),
       .data_out   (data_out_2_2),
       .r          (r_2_2)
     );

  // row 2, col 3

     wire start_in_2_3;
     wire start_out_2_3;

     wire [1:0] op_in_2_3;
     wire [1:0] op_out_2_3;

     reg data_in_2_3;
     wire data_out_2_3;

     always @(posedge clk) begin
         data_in_2_3 <= data_out_1_3;
     end

     assign start_in_2_3 = start_out_2_2;
     assign op_in_2_3 = op_out_2_2;
  
     processor_B B_2_3 (
       .clk       (clk),
       .rst_b     (rst_b),
       .data_in   (data_in_2_3),
       .start_in  (start_in_2_3),
       .op_in     (op_in_2_3),
       .op_out    (op_out_2_3),
       .start_out (start_out_2_3),
       .data_out  (data_out_2_3),
       .r         ()
     );

  /////////////////////////////////////
  // outputs 

  assign r_A_and = r_0_0 & r_1_1 & r_2_2;
  assign dout_and = data_out_2_2 & data_out_2_3;

endmodule

