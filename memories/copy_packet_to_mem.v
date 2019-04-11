module copy_packet_to_mem 
    #(
        parameter pFIFO_WIDTH   = 16,                  // 2 bytes for lenght of packet
                  pFIFO_DEPTH   = 56,                   // max value of packets of min lenght in memory
                  pDATA_WIDTH   = 8,                    // same rx_data bus 
                  pDEPTH_RAM    = 3072,                 // packets of 1536 bytes
                  pMAX_PACKET_LENGHT = 1536
    )
    (
    input wire                          iclk,
    input wire                          i_rst,
    input wire                          idv,
    input wire [pDATA_WIDTH-1:0]        irx_d,
    input wire                          irx_er,
    input wire [2:0]                    iFSM_state,

    input wire                          ir_addr,

    output wire                         oempty,
    output wire                         ofull,
    output wire [pDATA_WIDTH-1:0]       or_data,

    output wire [pFIFO_WIDTH-1:0]        olen_pac

    );
    

    reg [1:0]                           rWR_state;              // OK
    reg [1:0]                           rWR_state_next;         // OK

    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_ptr_succ;           // Last successfull pointer            
    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_ptr_now;
    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_count;     

    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_ptr_succ;           // Last successfull pointer
    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_ptr_now;
    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_count;


    reg [pFIFO_WIDTH-1:0]                rLenght_of_packet_RB;
    reg [$clog2(pDATA_WIDTH)-1:0]                 rLast_RB_addr;

    // Memory contol registers
    reg                     r_fifo_r_en;
    reg                     r_fifo_wr_en;
    reg                     r_RB_wr_en;
    
    reg                     rCRC_true;
    reg [pFIFO_SIZE-1:0]    rLastRD_addr;

    fifo
    #(
        .pBITS                  (pFIFO_WIDTH),         // pointers widht
        .pWIDHT                 (pFIFO_DEPTH)          
    ) lenght_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_fifo_r_en),                      //    
        .iwr                    (r_fifo_wr_en),                     // 
        .iw_data                (rLenght_of_packet_RB),             // 
        .oempty                 (),
        .ofull                  (),
        .or_data                (olen_pac)
    );

    sram
    #(
        .DATA_WIDTH             (pDATA_WIDTH), 
        .DEPTH                  (pDEPTH_RAM)
    ) ram_for_packets
    (
        .i_clk                  (iclk),
        .i_addr_wr              (),
        .i_addr_r               (), 
        .i_write                (),
        .i_data                 (),
        .o_data                 ()
    );

    // Read_dat 
    always @(posedge iclk) begin 
        case(rWR_state)
            2'b00: begin                 // wait_packet
                   
            end
            2'b01: begin                 // write_packet_to_mem
                
            end
            2'b10: begin                 // check_CRC
                
            end
        endcase
    end

    always @* begin
        case(rWR_state)
            2'b00:  rWR_state_next <= 2'b01;
            2'b01:  rWR_state_next <= 2'b10;
            2'b10:  rWR_state_next <= 2'b00;
        endcase
    end

    // Read and write pointers check
    assign ofull = (((rWr_ptr_succ > rRd_ptr_succ) ? 
                     (rRd_ptr_succ - rWr_ptr_succ) : 
                     (rWr_ptr_succ - rRd_ptr_succ)) > 1536) ? 1'b0 : 1'b1;
    assign oempty = (rWr_ptr_succ == rRd_ptr_succ) ?  1'b1 : 1'b0;

endmodule
