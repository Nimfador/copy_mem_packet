module ravil_memory (o_FIFO, o_reg, iclk, i_rst, idv, i_error, i_crc_correct, irx_d, iFSM_state, i_reg_read_addr); 
    output wire [10:0]      o_FIFO;
    output wire [7:0]       o_reg;
    input wire              iclk;
    input wire              i_rst; 
    input wire              idv;
    input wire              i_error;
    input wire              i_crc_correct;
    input wire [7:0]        irx_d;
    input wire [2:0]        iFSM_state;
    input wire [13:0]       i_reg_read_addr;

    // Initialize input regs

    // regs for register memory
    reg r_iwr_en; // Enables work of register memory
    reg [13:0] r_iw_addr='0;
    reg [10:0] r_counter='0; //Calculates lenght of packet

    // regs for FIFO memory
    reg r_FIFO_ird='0; // Enables FIFO to read
    reg r_FIFO_iwr='0; // Enables FIFO to write
    wire r_FIFO_oempty='0;
    wire r_FIFO_ofull='0;
     
    fifo
    #(
        .pBITS                  (11),         // pointers widht
        .pWIDHT                 (2)           // For storage up to 4 Packet Lenghtes
    ) 
        length_of_packet
    (
        .iclk                   (iclk),
        .ireset                 (i_rst),
        .ird                    (r_FIFO_ird), //Enables to read
        .iwr                    (r_FIFO_iwr), //Enables to write
        .iw_data                (r_counter),
        .oempty                 (r_FIFO_oempty),
        .ofull                  (r_FIFO_ofull),
        .or_data                (o_FIFO)
    );

    reg_file   //8 Kbit
    #(
        .pBITS                  (8),          
        .pWIDHT                 (14)
    ) 
        memory_for_packet
    (
        .iclk                   (iclk),
        .iwr_en                 (r_iwr_en),
        .iw_addr                (r_iw_addr),
        .ir_addr                (i_reg_read_addr),
        .iw_reg_data            (irx_d),                //Data, incoming to reg
        .or_data                (o_reg)                 //Output of reg memory
    );

    always @(posedge iclk)
        begin
        if (idv == 1'b1) begin
            case (iFSM_state)
            3'b000, 3'b001 : begin        
                r_iwr_en <= 1'b0;
                r_FIFO_iwr <= 1'b0;
                r_FIFO_ird <= 1'b0;
            end
            default: 
            begin
                r_FIFO_iwr<=1'b0;
                r_FIFO_ird<=1'b0;
                r_iwr_en<=1'b1;
                r_counter<= r_counter+1;
                r_iw_addr<= r_counter;
            end
            endcase
            end
        else if ((idv==1'b0)&&(iFSM_state==3'b000)&&(r_counter!==0))
            begin
                if ((i_crc_correct==1'b1)&&(i_error==1'b0))
                r_iwr_en<=1'b0;
                r_FIFO_ird<=1'b1;
                r_FIFO_iwr<=1'b1;
            end
        end

    
        
/*begin
            if ((i_crc_correct==1'b1)&(i_error==1'b0)) begin // Maybe connect to negedge of Data Valid 
                r_iwr_en<=1'b0;
                r_FIFO_ird<=1'b0;
                r_FIFO_iwr<=1'b1;
                //r_iw_addr<= r_iw_addr+r_counter;
                end
                 else begin r_iwr_en<=1'b0;  
                    r_FIFO_iwr<=1'b0;
                    r_FIFO_ird<=1'b0;
                    end
*/

             
endmodule