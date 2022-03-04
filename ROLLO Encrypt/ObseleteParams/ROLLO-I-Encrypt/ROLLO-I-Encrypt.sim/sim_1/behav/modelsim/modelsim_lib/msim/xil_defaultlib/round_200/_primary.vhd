library verilog;
use verilog.vl_types.all;
entity round_200 is
    port(
        \in\            : in     vl_logic_vector(199 downto 0);
        round_const     : in     vl_logic_vector(7 downto 0);
        \out\           : out    vl_logic_vector(199 downto 0)
    );
end round_200;
