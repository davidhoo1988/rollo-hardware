library verilog;
use verilog.vl_types.all;
entity processor_B_2 is
    port(
        data_out_0_2    : out    vl_logic;
        rst_b           : in     vl_logic;
        r0              : in     vl_logic;
        data_IBUF       : in     vl_logic_vector(1 downto 0);
        CLK             : in     vl_logic;
        r_0_0           : in     vl_logic;
        start_IBUF      : in     vl_logic
    );
end processor_B_2;
