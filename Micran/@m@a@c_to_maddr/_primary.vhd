library verilog;
use verilog.vl_types.all;
entity MAC_to_maddr is
    generic(
        pDATA_WIDTH     : integer := 8;
        pSIZE_IN        : integer := 48;
        pSIZE_OUT       : integer := 14
    );
    port(
        iclk            : in     vl_logic;
        idata           : in     vl_logic_vector;
        ivalid          : in     vl_logic;
        oaddr           : out    vl_logic_vector;
        oready          : out    vl_logic
    );
end MAC_to_maddr;
