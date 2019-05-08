library verilog;
use verilog.vl_types.all;
entity mac_mem_tb is
    generic(
        pTIME           : integer := 300;
        pCLK_PER_SEC    : integer := 12500000;
        pNUM_PORTS      : integer := 4;
        pADDR_WIDTH     : integer := 14
    );
end mac_mem_tb;
