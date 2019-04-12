library verilog;
use verilog.vl_types.all;
entity pcap2gmii is
    generic(
        pPCAP_FILENAME  : string  := "none";
        pIPG_LENGTH     : integer := 12;
        pPREAMBLE_LENGTH: integer := 7
    );
    port(
        iclk            : in     vl_logic;
        ipause          : in     vl_logic;
        oval            : out    vl_logic;
        odata           : out    vl_logic_vector(7 downto 0);
        opkt_cnt        : out    vl_logic_vector(7 downto 0)
    );
end pcap2gmii;
