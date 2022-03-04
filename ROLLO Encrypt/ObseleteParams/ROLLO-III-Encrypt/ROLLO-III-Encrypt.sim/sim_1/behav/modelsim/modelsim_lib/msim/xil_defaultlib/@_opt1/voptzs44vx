library verilog;
use verilog.vl_types.all;
entity ROLLO_III_Encrypt is
    generic(
        n               : integer := 47;
        m               : integer := 101;
        wr              : integer := 6;
        w               : integer := 5;
        digit           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        data            : out    vl_logic_vector(31 downto 0);
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of wr : constant is 1;
    attribute mti_svvh_generic_type of w : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end ROLLO_III_Encrypt;
