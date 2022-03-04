library verilog;
use verilog.vl_types.all;
entity padder is
    generic(
        n               : integer := 47;
        m               : integer := 79;
        digit           : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        \in\            : in     vl_logic_vector;
        in_ready        : in     vl_logic;
        is_last         : in     vl_logic;
        \out\           : out    vl_logic_vector(575 downto 0);
        out_ready       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of digit : constant is 1;
end padder;
