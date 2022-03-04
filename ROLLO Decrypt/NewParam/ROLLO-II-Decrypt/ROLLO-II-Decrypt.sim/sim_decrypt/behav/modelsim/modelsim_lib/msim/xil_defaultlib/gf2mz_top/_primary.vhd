library verilog;
use verilog.vl_types.all;
entity gf2mz_top is
    generic(
        n               : integer := 189;
        m               : integer := 83;
        d               : integer := 5;
        WIDTH           : vl_notype;
        DEPTH           : vl_notype;
        DELAY           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        A_di            : in     vl_logic_vector;
        A_do            : out    vl_logic_vector;
        A_addr          : out    vl_logic_vector;
        A_we            : out    vl_logic;
        B_dia           : in     vl_logic_vector;
        B_dib           : in     vl_logic_vector;
        B_doa           : out    vl_logic_vector;
        B_dob           : out    vl_logic_vector;
        B_addra         : out    vl_logic_vector;
        B_addrb         : out    vl_logic_vector;
        B_wea           : out    vl_logic;
        B_web           : out    vl_logic;
        C_di            : in     vl_logic_vector;
        C_do            : out    vl_logic_vector;
        C_addr          : out    vl_logic_vector;
        C_we            : out    vl_logic;
        done            : out    vl_logic;
        dout            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 3;
    attribute mti_svvh_generic_type of DEPTH : constant is 3;
    attribute mti_svvh_generic_type of DELAY : constant is 1;
end gf2mz_top;
