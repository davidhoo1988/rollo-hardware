library verilog;
use verilog.vl_types.all;
entity processor_A is
    port(
        r_0_0           : out    vl_logic;
        r_A_and_OBUF    : out    vl_logic;
        r0              : out    vl_logic;
        rst_b           : in     vl_logic;
        CLK             : in     vl_logic;
        start_IBUF      : in     vl_logic;
        data_IBUF       : in     vl_logic_vector(0 downto 0);
        r_1_1           : in     vl_logic;
        r_2_2           : in     vl_logic
    );
end processor_A;
