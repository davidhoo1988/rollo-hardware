library verilog;
use verilog.vl_types.all;
entity processor_B_3 is
    port(
        data_in_2_2_reg : out    vl_logic;
        data_out_1_2    : out    vl_logic;
        rst_b           : in     vl_logic;
        data_in_1_2_reg : in     vl_logic;
        CLK             : in     vl_logic;
        r_1_1           : in     vl_logic;
        data_in_1_1     : in     vl_logic;
        data_in_1_2     : in     vl_logic;
        Q               : in     vl_logic_vector(0 downto 0)
    );
end processor_B_3;
