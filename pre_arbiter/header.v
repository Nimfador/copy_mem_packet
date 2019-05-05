// paprameters for packet state 
localparam [2:0] lpNO_FRAME  =  3'b000,     // No data
                 lpPREAMBLE =  3'b001,     // Preambula
                 lpDELIMETER =  3'b010,     // Delimiter
                 lpDA  =  3'b011,     // Destination Adress
                 lpSA  =  3'b100,     // Source Adress
                 lpLENGTH = 3'b101,   //Length
                 lpDATA = 3'b110,     // Data
                 lpFCS  = 3'b111;     // CRC  


// parameters for memory

 parameter        pDATA_WIDTH        = 8,                     
                  pMIN_PACKET_LENGHT = 64,
                  pMAX_PACKET_LENGHT = 1536,
                  pFIFO_WIDTH        = $clog2(pMAX_PACKET_LENGHT),
                  pDEPTH_RAM         = 2*pMAX_PACKET_LENGHT,
                  pFIFO_DEPTH        = pDEPTH_RAM/pMIN_PACKET_LENGHT; 




