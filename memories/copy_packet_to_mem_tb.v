module copy_packet_to_mem_tb;

    reg                     iclk      ;         
    reg                     i_rst     ;
    wire                     wdv       ;
    wire [7:0]             wrx_d     ;         // 7:0
    wire                    wrx_er    ;
    wire [7:0]               wFSM_state;
    reg                     ir_addr   ;
    reg                     oempty    ;
    reg                     ofull     ;
    reg                     or_data   ;
    reg                     olen_pac  ;   

    copy_packet_to_mem 
    #(
        .pFIFO_LENGHT           (),    // 8  
        .pRB_WIDHT              (),
        .pFIFO_SIZE             (),
        .pMEM_WIDTH             ()
    ) DUt
    (
        .iclk                   (iclk),
        .i_rst                  (),
        .idv                    (wdv),
        .irx_d                  (wrx_d),
        .irx_er                 (wrx_er),
        .iFSM_state             (wFSM_state),
        .ir_addr                (),
        .oempty                 (),
        .ofull                  (),
        .or_data                (),
        .olen_pac               ()
   );

    module Ethernet_frame_analyzer_tb_w_io(
        .iclk                   (iclk), 
        .o_fsm_state            (wFSM_state),
        .o_rx_data              (wrx_d),
        .o_rx_er                (wrx_er),
        .o_rx_dv                (wdv)
    );

endmodule