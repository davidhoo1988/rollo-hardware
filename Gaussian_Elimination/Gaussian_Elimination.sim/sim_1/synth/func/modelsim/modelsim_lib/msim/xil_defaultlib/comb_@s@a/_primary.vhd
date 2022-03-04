library verilog;
use verilog.vl_types.all;
entity comb_SA is
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        finish          : out    vl_logic;
        r_A_and         : out    vl_logic
    );
end comb_SA;
