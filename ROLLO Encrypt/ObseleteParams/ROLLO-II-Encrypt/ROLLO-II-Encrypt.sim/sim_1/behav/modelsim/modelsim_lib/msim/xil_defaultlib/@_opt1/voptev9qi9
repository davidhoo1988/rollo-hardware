library verilog;
use verilog.vl_types.all;
entity ROLLO_II_Encrypt is
    generic(
        n               : integer := 149;
        m               : integer := 83;
        r               : integer := 5;
        d               : integer := 8;
        digit           : integer := 5
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
    attribute mti_svvh_generic_type of r : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end ROLLO_II_Encrypt;
