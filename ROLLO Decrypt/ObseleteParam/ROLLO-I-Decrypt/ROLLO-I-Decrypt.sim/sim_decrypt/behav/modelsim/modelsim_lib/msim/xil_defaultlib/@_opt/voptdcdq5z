library verilog;
use verilog.vl_types.all;
entity decrypt_top is
    generic(
        n               : integer := 47;
        m               : integer := 79;
        d               : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        finish          : out    vl_logic;
        data            : out    vl_logic_vector(0 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
end decrypt_top;
