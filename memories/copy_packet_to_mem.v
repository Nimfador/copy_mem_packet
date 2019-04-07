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
    input wire [2:0]                    iFSM_state,

    output wire                         oempty,
    output wire                         ofull,
    output wire [pMEM_WIDTH-1:0]        or_data,

    output wire [pFIFO_SIZE-1:0]        olen_pac

    );
    

    reg [1:0]               rFSM_state;
    reg [1:0]               rFSM_state_next;

    reg [pRB_WIDHT-1:0]     rPointer_to_RBw;
    reg [pRB_WIDHT-1:0]     rPointer_to_RBr;
    reg [pFIFO_SIZE-1:0]    rLenght_of_packet;

    // Memory contol registers
    reg                     r_fifo_r_en;
    reg                     r_fifo_wr_en;
    reg                     r_RB_wr_en;


    fifo
    #(
        .pBITS                  (pFIFO_SIZE),         // pointers widht
        .pWIDHT                 (pFIFO_LENGHT)          
    ) lenght_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_fifo_r_en),                  //    
        .iwr                    (r_fifo_wr_en),                 // 
        .iw_data                (rLenght_of_packet),            // 
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
        case(rFSM_state)
            2'b00: begin                 // wait_packet
                    rLenght_of_packet <= '0;
                if (idv & iFSM_state == 3'b011) begin
                    rFSM_state <= rFSM_state_next;
                end
            end
            2'b01: begin                 // write_packet_to_mem

            end
            2'b10: begin                 // check_CRC
            
            end
        endcase
    end

    always @* begin
        case(rFSM_state)
            2'b00:  rFSM_state_next = 2'b01;
            2'b01:  rFSM_state_next = 2'b10;
            2'b10:  rFSM_state_next = 2'b00;
        endcase
    end

endmodule
