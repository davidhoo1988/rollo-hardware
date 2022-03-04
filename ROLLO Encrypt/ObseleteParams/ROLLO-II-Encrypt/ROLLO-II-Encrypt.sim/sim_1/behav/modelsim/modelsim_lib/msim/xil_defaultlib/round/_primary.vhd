library verilog;
use verilog.vl_types.all;
entity round is
    port(
        \in\            : in     vl_logic_vector(1599 downto 0);
        round_const     : in     vl_logic_vector(63 downto 0);
        \out\           : out    vl_logic_vector(1599 downto 0)
    );
end round;
