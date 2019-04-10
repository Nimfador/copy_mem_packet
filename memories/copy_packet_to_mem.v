module copy_packet_to_mem 
    #(
        parameter pFIFO_LENGHT = 4,    // 8  
                  pRB_WIDHT    = 14,
                  pFIFO_SIZE   = 16,
                  pMEM_WIDTH   = 8
    )
    (
    input wire                          iclk,
    input wire                          i_rst,
    input wire                          idv,
    input wire [pMEM_WIDTH-1:0]         irx_d,
    input wire                          irx_er,
    input wire [2:0]                    iFSM_state,

    input wire                          ir_addr,

    output wire                         oempty,
    output wire                         ofull,
    output wire [pMEM_WIDTH-1:0]        or_data,

    output wire [pFIFO_SIZE-1:0]        olen_pac

    );
    

    reg [1:0]               rFSM_state_wr;
    reg [1:0]               rFSM_state_wr_next;

    reg [pRB_WIDHT-1:0]     rPointer_to_RBw;            
    reg [pRB_WIDHT-1:0]     rPointer_to_RBr;
    reg [pFIFO_SIZE-1:0]    rLenght_of_packet_RB;
    reg [pRB_WIDHT-1:0]     rLast_RB_addr;

    // Memory contol registers
    reg                     r_fifo_r_en;
    reg                     r_fifo_wr_en;
    reg                     r_RB_wr_en;
    
    reg                     rCRC_true;
    reg [pFIFO_SIZE-1:0]    rLastRD_addr;

    fifo
    #(
        .pBITS                  (pFIFO_SIZE),         // pointers widht
        .pWIDHT                 (pFIFO_LENGHT)          
    ) lenght_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_fifo_r_en),                      //    
        .iwr                    (r_fifo_wr_en),                     // 
        .iw_data                (rLenght_of_packet_RB),             // 
        .oempty                 (oempty),
        .ofull                  (ofull),
        .or_data                (olen_pac)
    );

    reg_file
    #(
        .pBITS                  (8),         // 
        .pWIDHT                 (pRB_WIDHT)   
    ) round_buffer
    (
        .iclk                   (iclk),
        .iwr_en                 (r_RB_wr_en),
        .irst                   (i_rst),
        .iw_addr                (rPointer_to_RBw),
        .ir_addr                (rPointer_to_RBr),
        .iw_data                (irx_d),
        .or_data                (or_data)
    );

    // general FSM for module 
    always @(posedge iclk) begin 
        case(rFSM_state_wr)
            2'b00: begin                 // wait_packet
                    //rLenght_of_packet_RB <= '0;
                if (idv & iFSM_state == 3'b011 & !irx_er) begin
                    rFSM_state_wr <= rFSM_state_wr_next;
                end
            end
            2'b01: begin                 // write_packet_to_mem
                if (!idv & !irx_er)
                    rFSM_state_wr <= rFSM_state_wr_next;
                else if (irx_er) rFSM_state_wr <= 2'b00;
                else begin
                    rPointer_to_RBw <= rLastRD_addr + rLenght_of_packet_RB;
                    rLenght_of_packet_RB <= rLenght_of_packet_RB + 1;
                    r_RB_wr_en <= 1'b1;
                end
            end
            2'b10: begin                 // check_CRC
                if (!irx_er & rCRC_true) begin
                    rFSM_state_wr <= rFSM_state_wr_next;
                    rCRC_true <= '0;
                    r_fifo_wr_en <= '0;
                    rLenght_of_packet_RB <= '0;
                end
                else if (!irx_er & !rCRC_true) begin 
                    rLastRD_addr <= rPointer_to_RBw;
                    rCRC_true <= '1;
                    r_fifo_wr_en <= '1;
                    r_RB_wr_en <= 1'b0;
                end
                else rFSM_state_wr <= rFSM_state_wr_next;
            end
        endcase
    end

    always @* begin
        case(rFSM_state_wr)
            2'b00:  rFSM_state_wr_next = 2'b01;
            2'b01:  rFSM_state_wr_next = 2'b10;
            2'b10:  rFSM_state_wr_next = 2'b00;
        endcase
    end

    

endmodule
