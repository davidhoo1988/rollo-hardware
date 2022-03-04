library verilog;
use verilog.vl_types.all;
entity processor_B is
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        data_in         : in     vl_logic;
        start_in        : in     vl_logic;
        op_in           : in     vl_logic_vector(1 downto 0);
        op_out          : out    vl_logic_vector(1 downto 0);
        start_out       : out    vl_logic;
        data_out        : out    vl_logic;
        r               : out    vl_logic
    );
end processor_B;
