library verilog;
use verilog.vl_types.all;
entity Ethernet_RX_frame_5cd is
    port(
        i_rx_clk        : in     vl_logic;
        i_rx_dv         : in     vl_logic;
        i_rx_er         : in     vl_logic;
        i_rx_d          : in     vl_logic_vector(7 downto 0);
        o_fsm_state     : out    vl_logic_vector(2 downto 0);
        o_fsm_state_changed: out    vl_logic;
        o_rx_dv_4cd     : out    vl_logic;
        o_rx_er_4cd     : out    vl_logic;
        o_rx_d4cd       : out    vl_logic_vector(7 downto 0)
    );
end Ethernet_RX_frame_5cd;
