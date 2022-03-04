library verilog;
use verilog.vl_types.all;
entity mem_dp is
    generic(
        WIDTH           : integer := 8;
        DEPTH           : integer := 64;
        \FILE\          : string  := ""
    );
    port(
        clka            : in     vl_logic;
        wea             : in     vl_logic;
        ena             : in     vl_logic;
        dia             : in     vl_logic_vector;
        addra           : in     vl_logic_vector;
        doa             : out    vl_logic_vector;
        clkb            : in     vl_logic;
        web             : in     vl_logic;
        enb             : in     vl_logic;
        dib             : in     vl_logic_vector;
        addrb           : in     vl_logic_vector;
        dob             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of \FILE\ : constant is 1;
end mem_dp;
