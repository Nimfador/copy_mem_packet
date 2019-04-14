module ravil_memory  
    #(
        parameter pDATA_WIDTH        = 8,                     
                  pMIN_PACKET_LENGHT = 64,
                  pMAX_PACKET_LENGHT = 1536,
                  pFIFO_WIDTH        = $clog2(pMAX_PACKET_LENGHT),
                  pDEPTH_RAM         = 2*pMAX_PACKET_LENGHT,
                  pFIFO_DEPTH        = pDEPTH_RAM/pMIN_PACKET_LENGHT 
    )
(o_FIFO, o_reg, iclk, i_rst, idv, i_error, irx_d, iFSM_state, i_r_enable); 
    output wire [pFIFO_WIDTH-1:0]                       o_FIFO;
    output wire [pDATA_WIDTH-1:0]                       o_reg;
    input wire                                          iclk;
    input wire                                          i_rst; 
    input wire                                          idv;
    input wire                                          i_error;
    input wire [pDATA_WIDTH-1:0]                        irx_d;
    input wire [2:0]                                    iFSM_state;
    input wire                                          i_r_enable;

    localparam lpWAIT=2'b00;
    localparam lpWRITE=2'b01; 
    localparam lpCHECK=2'b10;  

    // Regs for FSM that controls write process
    reg [1:0]                                           rWR_state = lpWAIT;              
    reg [1:0]                                           rWR_state_next = lpWRITE;

    // regs for register memory
    reg                                                 r_iwr_en='0; // Enables work of register memory
    reg [$clog2(pDEPTH_RAM)-1:0]                        r_iw_addr='0;
    reg [pFIFO_WIDTH-1:0]                               r_counter_adr='0;
    reg [pFIFO_WIDTH-1:0]                               r_counter_len='0;//Calculates lenght of packet
    reg [pFIFO_WIDTH-1:0]                               r_read_counter='0;

    reg [$clog2(pDEPTH_RAM)-1:0]                        r_read_pointer='0;
    reg [$clog2(pDEPTH_RAM)-1:0]                        r_succ_read_pointer='0;

    // regs for FIFO memory
    reg                                                 r_FIFO_ird='0; // Enables FIFO to read
    reg                                                 r_FIFO_iwr='0; // Enables FIFO to write
    wire                                                r_FIFO_oempty='0;
    wire                                                r_FIFO_ofull='0;
     
    fifo
    #(
        .pBITS                  (pFIFO_WIDTH),         
        .pWIDHT                 (pFIFO_DEPTH)          
    ) 
        length_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_FIFO_ird), //Enables to read
        .iwr                    (r_FIFO_iwr), //Enables to write
        .iw_data                (r_counter_len),
        .oempty                 (r_FIFO_oempty),
        .ofull                  (r_FIFO_ofull),
        .or_data                (o_FIFO)
    );

    reg_file   //8 Kbit
    #(
        .pBITS                  (pDATA_WIDTH),          
        .pWIDHT                 (pDEPTH_RAM)
    ) 
        memory_for_packet
    (
        .iclk                   (iclk),
        .iwr_en                 (r_iwr_en),
        .iw_addr                (r_iw_addr),
        .ir_addr                (r_read_pointer),
        .iw_reg_data            (irx_d),                //Data, incoming to reg
        .or_data                (o_reg)                 //Output of reg memory
    );

    always @* begin
        case(rWR_state)
            lpWAIT:   rWR_state_next = lpWRITE; //waiting for packets
            lpWRITE:  rWR_state_next = lpCHECK; //writing to reg_memory
            lpCHECK:  rWR_state_next = lpWAIT; //checking CRC + writing to FIFO
        endcase
    end

    always @(posedge iclk) begin
        case(rWR_state)
        lpWAIT: begin 
            if (idv & (iFSM_state==3'b010) & !i_error) begin
                rWR_state<=rWR_state_next;
                r_iwr_en<=1'b1;
            end
            end
        lpWRITE: begin
            if (i_error) 
                rWR_state<=lpWAIT;
            else begin if (idv == 1'b0)
            begin
                rWR_state<=rWR_state_next;
                r_iwr_en<=1'b0;
            end
            else begin  //later think about overflow
                r_counter_adr<=r_counter_adr+1;
                r_counter_len<=r_counter_len+1;
                r_iw_addr<= r_counter_adr;
            end
            end
            end
        lpCHECK:  begin
                if (i_error) 
                    rWR_state<=rWR_state_next;
                else begin 
                    if (r_FIFO_iwr) begin
                        r_FIFO_iwr<=1'b0;
                        r_counter_len<='d0;
                        rWR_state<=rWR_state_next;
                    end
                    else r_FIFO_iwr<=1'b1;
                    end                 
            end
        endcase
    end

    always @(posedge iclk) begin
        if (i_r_enable) begin
            if (r_read_counter !== 'b0) begin
                if (r_counter_adr + 'b1 == pDEPTH_RAM) begin
                    r_read_counter <= r_read_counter - 'b1;
                    r_read_pointer <= 'b0;
                end
                else begin
                    r_read_pointer <= r_read_pointer - 'b1;
                    r_read_pointer <= r_read_pointer + 'b1;    
                end
                r_FIFO_ird <= 'b0; //Happens, when packet was fully read
            end
            else begin
                r_read_counter<= o_FIFO;
                r_FIFO_ird <= 'b1;
            end
        end
        else begin
            r_read_counter <= 'b0;
            r_succ_read_pointer<=r_read_pointer;
        end
    end


       
    
        

endmodule