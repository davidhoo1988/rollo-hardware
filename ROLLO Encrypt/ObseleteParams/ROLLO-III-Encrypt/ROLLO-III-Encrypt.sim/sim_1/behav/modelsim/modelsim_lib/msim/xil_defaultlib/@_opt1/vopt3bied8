library verilog;
use verilog.vl_types.all;
entity prng is
    generic(
        n               : integer := 47;
        m               : integer := 101;
        wr              : integer := 6;
        digit           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        in_ready        : in     vl_logic;
        in_seed         : in     vl_logic_vector(95 downto 0);
        in_mod          : in     vl_logic;
        out_rng         : out    vl_logic_vector(95 downto 0);
        out_ready       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of wr : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end prng;
