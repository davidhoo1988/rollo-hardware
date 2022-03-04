//define pivot note 
module processor_A (
  input  wire       clk,
  input  wire       rst_b,
  input  wire       data_in,
  input  wire       start_in,
  output wire [1:0] op_out,
  output wire       start_out,
  output wire       data_out,
  output reg        r
);

  wire r_reg;
 
  always @(posedge clk) begin
    if(~rst_b) begin
      r <= 0;
    end
    else begin
      r <= r_reg;
    end
  end

  assign start_out  = start_in;

  assign data_out = start_in ? 1'b0 : r;

  assign r_reg = start_in       ? data_in :
                ((data_in==0)   ? r : 1'b1);

  // 00 --- pass  01 --- swap  10 --- add  11 --- nop
  assign op_out = (start_in     ? 2'b11 : 
                  ((data_in==0) ? 2'b00 : 
                  ((r==0)       ? 2'b01 : 2'b10)));

endmodule

//define basic node
module processor_B (
  input  wire       clk,
  input  wire       rst_b,
  input  wire       data_in,
  input  wire       start_in,
  input  wire [1:0] op_in,
  output wire [1:0] op_out,
  output wire        start_out,
  output wire        data_out,
  output reg        r
);

  wire r_reg;
 
  always @(posedge clk) begin
    if(~rst_b) begin
      r <= 0;
    end
    else begin
      r <= r_reg;
    end
  end

  assign start_out = start_in;

  assign data_out = start_in       ? 1'b0 : 
                   (op_in == 2'b01 ? r : 
                   (op_in == 2'b10 ? (data_in ^ r) : 
                   data_in));

  assign r_reg = start_in       ? data_in :
                (op_in == 2'b01 ? data_in :
                 r);

  assign op_out = op_in;

endmodule