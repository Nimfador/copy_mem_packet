library verilog;
use verilog.vl_types.all;
entity Ethernet_frame_analyzer_tb_w_io is
    port(
        iclk            : in     vl_logic;
        o_fsm_state     : out    vl_logic_vector(2 downto 0);
        o_rx_data       : out    vl_logic_vector(7 downto 0);
        o_rx_er         : out    vl_logic;
        o_rx_dv         : out    vl_logic
    );
end Ethernet_frame_analyzer_tb_w_io;
