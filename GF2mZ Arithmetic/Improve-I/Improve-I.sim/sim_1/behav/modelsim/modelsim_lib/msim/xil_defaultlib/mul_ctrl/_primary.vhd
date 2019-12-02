library verilog;
use verilog.vl_types.all;
entity mul_ctrl is
    generic(
        WIDTH           : integer := 8;
        DEPTH           : integer := 64;
        m               : integer := 79;
        d               : integer := 3;
        DELAY           : integer := 6
    );
    port(
        clk             : in     vl_logic;
        rst_b           : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        A_di            : in     vl_logic_vector;
        A_we            : out    vl_logic;
        A_addr          : out    vl_logic_vector;
        A_do            : out    vl_logic_vector;
        B_dia           : in     vl_logic_vector;
        B_wea           : out    vl_logic;
        B_addra         : out    vl_logic_vector;
        B_doa           : out    vl_logic_vector;
        B_dib           : in     vl_logic_vector;
        B_web           : out    vl_logic;
        B_addrb         : out    vl_logic_vector;
        B_dob           : out    vl_logic_vector;
        C_di            : in     vl_logic_vector;
        C_we            : out    vl_logic;
        C_addr          : out    vl_logic_vector;
        C_do            : out    vl_logic_vector;
        mul_start       : out    vl_logic;
        mul_done        : in     vl_logic;
        mul00_op_a      : out    vl_logic_vector;
        mul00_op_b      : out    vl_logic_vector;
        mul00_op_c      : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of m : constant is 1;
    attribute mti_svvh_generic_type of d : constant is 1;
    attribute mti_svvh_generic_type of DELAY : constant is 1;
end mul_ctrl;
