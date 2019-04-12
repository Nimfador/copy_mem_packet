module Ethernet_frame_analyzer_tb_w_io(
    input wire                      iclk, 
    output wire [2:0]               o_fsm_state,
    output wire [7:0]               o_rx_data,
    output wire                     o_rx_er,
    output wire                     o_rx_dv
);

    wire [7:0] wgmii_data;
    wire wgmii_rx_val;
    
    //reg iclk;
    reg enable;
    reg reset;
    reg r_inv_enable;

    wire [2:0]  wfsm_state;
    wire        o_fsm_state_ch;
    wire        o_rx_dv_4cd;
    wire        o_rx_er_4cd;
    wire [7:0]  o_rx_d4cd;

    wire [7:0]  wgmii_data_inv;
    
    pcap2gmii
    #(
        .pPCAP_FILENAME     ("1111.pcap") 
    ) 
        genpack
    (
        .iclk           (iclk),
        .ipause         (1'b0),
        .oval           (wgmii_rx_val),
        .odata          (wgmii_data),
        .opkt_cnt       ()
    );

    Ethernet_RX_frame_5cd
    DUT5cd
    (
        .i_rx_clk               (iclk),
        .i_rx_dv                (wgmii_rx_val),
        .i_rx_er                (reset),
        .i_rx_d                 (wgmii_data_inv),
        .o_fsm_state            (wfsm_state),
        .o_fsm_state_changed    (o_fsm_state),
        .o_rx_dv_4cd            (o_rx_dv_4cd),
        .o_rx_er_4cd            (o_rx_er_4cd),
        .o_rx_d4cd              (o_rx_d4cd)
    );

    inverse_data #( .pDATA_WIDTH (8)) data_inv
    ( 
        .idata                  (wgmii_data),  
        .ienable                (r_inv_enable),
        .odata                  (wgmii_data_inv) 
    );
    
    

    always @(posedge iclk) $display(o_fsm_state);

        


    
    assign  o_fsm_state = wfsm_state;
    assign  o_rx_data = o_rx_d4cd;
    assign  o_rx_er = o_rx_er_4cd;
    assign  o_rx_dv = o_rx_dv_4cd;

endmodule