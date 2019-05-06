library verilog;
use verilog.vl_types.all;
entity FSM_frame is
    port(
        iclk            : in     vl_logic;
        ilen            : in     vl_logic_vector(10 downto 0);
        ienable         : in     vl_logic;
        ishift_reg      : in     vl_logic_vector(31 downto 0);
        ost             : out    vl_logic_vector(2 downto 0);
        odata_byte      : out    vl_logic_vector(7 downto 0)
    );
end FSM_frame;
