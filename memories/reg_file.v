module reg_file
    #(
        parameter               pBITS = 8,
                                pWIDHT = 2
    )
    (
        input wire              iclk,
        input wire              iwr_en,
        input wire              irst,
        input wire [pWIDHT-1:0] iw_addr,
        input wire [pWIDHT-1:0] ir_addr,
        input wire [pBITS-1:0]  iw_data,
        output wire [pBITS-1:0] or_data
    );

    // signal declaration
    reg [pBITS-1:0] rarray [2**pWIDHT-1:0];
    integer         num_b;          // adddress of array in for loop

    // body
    always @(posedge iclk ) begin
        if (iwr_en) begin                           // write
            rarray[iw_addr] <= iw_data;    
        end
        else if (irst) begin
            for (num_b = 0; num_b < (2**pWIDHT-1); num_b = num_b + 1) begin     // reset
                rarray[num_b] = '0;
            end
        end
    end

    


    assign or_data = rarray[ir_addr];

endmodule