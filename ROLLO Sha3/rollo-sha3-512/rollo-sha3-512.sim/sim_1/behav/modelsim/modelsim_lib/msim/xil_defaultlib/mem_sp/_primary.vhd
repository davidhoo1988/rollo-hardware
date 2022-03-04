library verilog;
use verilog.vl_types.all;
entity mem_sp is
    generic(
        WIDTH           : integer := 8;
        DEPTH           : integer := 64;
        \FILE\          : string  := ""
    );
    port(
        clk             : in     vl_logic;
        di              : in     vl_logic_vector;
        addr            : in     vl_logic_vector;
        en              : in     vl_logic;
        we              : in     vl_logic;
        do              : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of \FILE\ : constant is 1;
end mem_sp;
