library verilog;
use verilog.vl_types.all;
entity processor_A_1 is
    port(
        r_2_2           : out    vl_logic;
        rst_b           : in     vl_logic;
        CLK             : in     vl_logic;
        Q               : in     vl_logic_vector(0 downto 0);
        data_in_2_2     : in     vl_logic
    );
end processor_A_1;
