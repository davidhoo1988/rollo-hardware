library verilog;
use verilog.vl_types.all;
entity ctrl_top is
    generic(
        INIT            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        GF2MZ           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        GF2MZ_ADD       : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        S1S2GEN         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        RSR             : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        SHA3            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        gf2mz_start     : out    vl_logic;
        gf2mz_done      : in     vl_logic;
        gf2mz_add_start : out    vl_logic;
        gf2mz_add_done  : in     vl_logic;
        S1S2gen_start   : out    vl_logic;
        S1S2gen_done    : in     vl_logic;
        RSR_start       : out    vl_logic;
        RSR_done        : in     vl_logic;
        sha3_start      : out    vl_logic;
        sha3_done       : in     vl_logic;
        status          : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INIT : constant is 1;
    attribute mti_svvh_generic_type of GF2MZ : constant is 1;
    attribute mti_svvh_generic_type of GF2MZ_ADD : constant is 1;
    attribute mti_svvh_generic_type of S1S2GEN : constant is 1;
    attribute mti_svvh_generic_type of RSR : constant is 1;
    attribute mti_svvh_generic_type of SHA3 : constant is 1;
end ctrl_top;
