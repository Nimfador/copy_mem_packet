module ravil_memory_tb();

    wire [7:0] wgmii_data;
    wire wgmii_rx_val;
    
    reg iclk;
    reg enable;
    reg reset;

    wire [2:0]  o_fsm_state;
    wire        o_fsm_state_ch;
    wire        o_rx_dv_4cd;
    wire [7:0]  o_rx_d4cd;
    wire        o_FR_error;
    reg [10:0]  r_FIFO;
    reg [7:0]   r_reg_memory;
    reg [13:0]  r_read_adress='0;

    pcap2gmii
    #(
        .pPCAP_FILENAME     ("test.pcap") 
    ) 
        genpack
    (
        .iclk           (iclk),
        .ipause         (1'b0),
        .oval           (wgmii_rx_val),
        .odata          (wgmii_data),
        .opkt_cnt       ()
    );

    frame_receiver
    module_1 
    (
        .iclk               	(iclk),
        .irx_dv                 (wgmii_rx_val),
        .irx_er                 (reset),
        .irx_data               (wgmii_data),
        .o_state                (o_fsm_state),
        .o_change               (o_fsm_state_ch),
        .o_dv                   (o_rx_dv_4cd),
        .o_data                 (o_rx_d4cd),
        .o_error                (o_FR_error)        
    );   

    ravil_memory
    DUT
    (
        .iclk                   (iclk),
        .i_rst                  (reset),
        .idv                    (o_rx_dv_4cd),
        .i_error                (o_FR_error),
        .i_crc_correct          (o_crc_correct),
        .irx_d                  (o_rx_d4cd),
        .iFSM_state             (o_fsm_state),
        .i_reg_read_addr        (r_read_adress),
        .o_FIFO                 (r_FIFO),
        .o_reg                  (r_reg_memory)
        );
    
    always #1
    begin
        iclk = ~iclk;
    end

    always @(posedge iclk) $display(o_fsm_state);

    initial
    begin
       iclk = 0;
       enable = 1;
       reset = 0;
       #2
       reset = 1;
       #2
       reset = 0;
       #1500
       reset = 1;
       #20
       reset = 0;
    end    

  always 
        begin 
        #37
        r_read_adress<=r_read_adress+1;
    end;


    initial begin
        #5000 $finish;
    end
endmodule