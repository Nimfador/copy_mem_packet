library verilog;
use verilog.vl_types.all;
entity copy_packet_to_mem is
    generic(
        pFIFO_WIDTH     : integer := 16;
        pFIFO_DEPTH     : integer := 56;
        pDATA_WIDTH     : integer := 8;
        pDEPTH_RAM      : integer := 3072;
        pMAX_PACKET_LENGHT: integer := 1536
    );
    port(
        iclk            : in     vl_logic;
        i_rst           : in     vl_logic;
        idv             : in     vl_logic;
        irx_d           : in     vl_logic_vector;
        irx_er          : in     vl_logic;
        iframe_state    : in     vl_logic_vector(2 downto 0);
        ird_en          : in     vl_logic;
        oempty          : out    vl_logic;
        ofull           : out    vl_logic;
        or_data         : out    vl_logic_vector;
        olen_pac        : out    vl_logic_vector;
        onext_last      : out    vl_logic
    );
end copy_packet_to_mem;
