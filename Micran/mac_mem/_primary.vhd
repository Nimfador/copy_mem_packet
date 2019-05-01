library verilog;
use verilog.vl_types.all;
entity mac_mem is
    generic(
        pTIME           : integer := 300;
        pCLK_PER_SEC    : integer := 125000000;
        pNUM_PORTS      : integer := 4;
        pADDR_WIDTH     : integer := 14
    );
    port(
        iclk            : in     vl_logic;
        ipnum           : in     vl_logic_vector;
        isa             : in     vl_logic_vector;
        ida             : in     vl_logic_vector;
        iwr_en          : in     vl_logic;
        opnum           : out    vl_logic_vector;
        oready          : out    vl_logic
    );
end mac_mem;
