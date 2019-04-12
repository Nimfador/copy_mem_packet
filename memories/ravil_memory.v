module ravil_memory (o_FIFO, o_reg, iclk, i_rst, idv, i_error, i_crc, irx_d, iFSM_state); 
    output wire [10:0]      o_FIFO;
    output wire [7:0]       o_reg;
    input wire              iclk;
    input wire              i_rst; 
    input wire              idv;
    input wire              i_error;
    input wire              i_crc;
    input wire [7:0]        irx_d;
    input wire [2:0]        iFSM_state;

    // Initialize input regs

    // regs for register memory
    reg r_iwr_en; // Enables work of register memory
    reg [13:0] r_iw_addr='0;
    reg [13:0] r_ir_addr='0;
    reg [7:0] r_iw_data='0;
    wire [7:0] r_or_data;
    reg [10:0] r_counter='0; //Calculates lenght of packet

    // regs for FIFO memory
    reg r_FIFO_clk;
    reg r_FIFO_ird='0; // Enables FIFO to read
    reg r_FIFO_iwr='0; // Enables FIFO to write
    wire r_FIFO_oempty;
    wire r_FIFO_ofull;
    wire [10:0] r_FIFO_or_data;
 
    fifo
    #(
        .pBITS                  (11),         // pointers widht
        .pWIDHT                 (2)           // For storage up to 4 Packet Lenghtes
    ) 
        length_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_FIFO_ird), 
        .iwr                    (r_FIFO_iwr),
        .iw_data                (r_counter),
        .oempty                 (r_FIFO_oempty),
        .ofull                  (r_FIFO_ofull),
        .or_data                (r_FIFO_or_data)
    );

    reg_file   //8 Kbit
    #(
        .pBITS                  (8),          
        .pWIDHT                 (14)
    ) 
        memory_for_packet
    (
        .iclk                   (iclk),
        .iwr_en                 (i_iwr_en),
        .iw_addr                (r_iw_addr),
        .ir_addr                (r_ir_addr),
        .iw_data                (r_iw_data),
        .or_data                (r_or_data)
    );

    always @(posedge iclk or posedge i_rst)
        begin
        if (idv == 1'b1)
            case (iFSM_state)
            3'b000: begin
            if (i_crc == 1'b1) begin // Maybe connect to negedge of Data Valid 
                r_iwr_en<=1'b0;
                r_FIFO_ird<=1'b0;
                r_FIFO_iwr<=1'b1;
                r_iw_addr<= r_counter;
            end
                 else begin r_iwr_en<=1'b0;  
                    r_FIFO_iwr<=1'b0;
                    r_FIFO_ird<=1'b0;
                    r_counter<='0;
            end
            end
            3'b001, 3'b010 : begin        
                r_iwr_en   <= 1'b0;
                r_FIFO_iwr <= 1'b0;
                r_FIFO_ird <= 1'b0;
            end
            default: 
            begin
                r_FIFO_iwr<=1'b0;
                r_FIFO_ird<=1'b0;
                r_iwr_en<=1'b1;
                r_counter<= r_counter+1;
                r_iw_addr<= r_iw_addr + r_counter;
            end
            endcase
        end
        
assign o_FIFO=r_FIFO_or_data;
assign o_reg=r_or_data;
             
endmodule