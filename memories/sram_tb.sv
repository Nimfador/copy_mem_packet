module sram_tb;

    reg                     r_clock;
    reg [$clog2(3072)-1:0]  r_w_addr='d19;
    reg [$clog2(3072)-1:0]  r_r_addr='d20;
    reg                     r_write;
    reg [7:0]               r_input;
    reg [7:0]              r_output='0;
    
    sram
    DUT
   (
        .i_clk                  (r_clock),
        .i_addr_wr              (r_w_addr),
        .i_addr_r               (r_r_addr), 
        .i_write                (r_write),
        .i_data                 (r_input),
        .o_data                 (r_output)
    );


    always #1
    begin
        r_clock = ~r_clock;
    end

    always @(posedge r_clock)
    begin 
    r_w_addr<=r_w_addr-1;
    r_r_addr<=r_r_addr-1;
    end



    always 
        begin 
        r_input<=8'd256;
        #4
        r_input<=8'd3;
        #4
        r_input<=8'd15;
        #4
        r_input<=8'd0;
    end;



    initial
    begin
       r_clock = 0;
       r_write = 1;

       #200
       r_write = 0;
       #20
       r_write = 1;
    end    


    initial begin
        #500 $finish;
    end



endmodule