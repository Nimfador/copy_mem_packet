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
    input wire [2:0]                    iframe_state,

    input wire                          ird_en,

    output wire                         oempty,
    output wire                         ofull,
    output wire [pDATA_WIDTH-1:0]       or_data,

    output wire [pFIFO_WIDTH-1:0]        olen_pac, 
    output wire                         onext_last

    );
    
    localparam                          lpBUS1 = $clog2(pDEPTH_RAM);

    reg [1:0]                           rWR_state;              // OK
    reg [1:0]                           rWR_state_next;         // OK

    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_ptr_succ;           // Last successfull pointer            
    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_ptr_now;
    reg [$clog2(pDATA_WIDTH)-1:0]       rRd_count;     

    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_ptr_succ;           // Last successfull pointer
    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_ptr_now;
    reg [$clog2(pDATA_WIDTH)-1:0]       rWr_count;
    reg                                 rWr_en = 1'b0;

    reg [$clog2(pDATA_WIDTH)-1:0]                 rLast_RB_addr;

    // Memory contol registers
    reg                     rfifo_rd_en;
    reg                     rfifo_wr_en;
    reg [pFIFO_WIDTH-1:0]   rfifo_d;
    

    fifo
    #(
        .pBITS                  (pFIFO_WIDTH),         // pointers widht
        .pWIDHT                 (pFIFO_DEPTH)          
    ) lenght_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (rfifo_rd_en),                      //    
        .iwr                    (rfifo_wr_en),                     // 
        .iw_data                (rfifo_d),             // 
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
        .i_addr_wr              (rWr_ptr_now),
        .i_addr_r               (rRd_ptr_now), 
        .i_write                (iWr_en),
        .i_data                 (irx_d),
        .o_data                 (or_data)
    );

    // Write_data 
    always @(posedge iclk) begin 
        case(rWR_state)
            2'b00: begin                 // wait_packet
                if (idv & (iframe_state == 3'b011) & irx_er) begin
                    rWR_state <= rWR_state_next;
                    rWr_en <= 1'b1;
                end       
            end
            2'b01: begin                 // write_packet_to_mem
                if (irx_er) begin
                    rWR_state <= 2'b00;
                end
                else if (idv == 'b0) begin 
                    rWR_state <= rWR_state_next;
                    rWr_en <=1'b0;
                end
                else begin
                    if (rWr_ptr_now + 'b1 == pDEPTH_RAM) begin
                        rWr_count <= rWr_count + 'd1;
                        rWr_ptr_now <= 'b0;
                    end
                    else begin
                        rWr_count <= rWr_count + 'd1;
                        rWr_ptr_now <= rWr_ptr_succ + rWr_count;   
                    end
                end
            end
            2'b10: begin                 // check_CRC
                if (irx_er == 1'b1) begin
                    rWR_state <= rWR_state_next;
                end
                else begin
                    if(rfifo_wr_en) begin
                        rfifo_wr_en <= 1'b0;
                        rWR_state <= rWR_state_next;
                        rWr_ptr_succ <= rWr_ptr_now;
                    end
                    else begin
                        rfifo_wr_en <= 1'b1;
                        rfifo_d[$clog2(pDEPTH_RAM)-1:0] <= rWr_count;
                    end
                end
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

    // Read_data
//    always @() begin
//        
//
//    end

    // Read and write pointers check
    assign ofull = (((rWr_ptr_succ > rRd_ptr_succ) ? 
                     (rRd_ptr_succ - rWr_ptr_succ) : 
                     (rWr_ptr_succ - rRd_ptr_succ)) > 1536) ? 1'b0 : 1'b1;
    assign oempty = (rWr_ptr_succ == rRd_ptr_succ) ?  1'b1 : 1'b0;
    // next last
    assign onext_last = (rRd_count == 'b1) ? 1'b1 : 0'b0;
endmodule
