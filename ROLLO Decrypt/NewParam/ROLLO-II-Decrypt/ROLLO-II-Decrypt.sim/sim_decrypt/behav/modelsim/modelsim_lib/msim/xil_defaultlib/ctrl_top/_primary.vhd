library verilog;
use verilog.vl_types.all;
entity ctrl_top is
    generic(
        d               : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        gf2mz_start     : out    vl_logic;
        gf2mz_done      : in     vl_logic;
        S1S2gen_start   : out    vl_logic;
        S1S2gen_done    : in     vl_logic;
        RSR_start       : out    vl_logic;
        RSR_done        : in     vl_logic;
        sha3_start      : out    vl_logic;
        sha3_done       : in     vl_logic;
        status          : out    vl_logic_vector(2 downto 0);
        iterate         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of d : constant is 1;
end ctrl_top;
