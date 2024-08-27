module UART_RX_tb ();
reg RX_IN ,  PAR_EN , PAR_TYP , clk , rst;
reg [5:0] prescale;
wire data_valid;
wire [7:0] P_DATA;

reg clk_tx;
reg [10:0] u_parity;
reg [9:0] u_no_parity;

integer  i;
UART_RX DUT0 (RX_IN , PAR_EN , PAR_TYP , prescale , clk , rst , P_DATA , data_valid);

initial begin
    clk = 0;
    forever 
        #1 clk = ~clk;
end

initial begin
    clk_tx = 0;
    forever 
        #8 clk_tx = ~clk_tx;
end

initial begin
    rst = 0;
    prescale = 8;
    PAR_EN = 0;
    PAR_TYP = 0;
    RX_IN = 1;
    u_no_parity = 10'b0000000000;
    u_parity = 11'b00000000000;

    @(negedge clk_tx);
    rst = 1;

    //test_case1
    u_no_parity = 10'b1010101010; 
    rx_input_no_parity(u_no_parity);


    //test_case2
    u_no_parity = 10'b1110111000;
    rx_input_no_parity(u_no_parity);

    //IDLE
    RX_IN = 1;
    repeat(4)
        @(negedge clk_tx);

    RX_IN = 0;  // start glitch
    @(negedge clk);
    RX_IN = 1;
    @(negedge clk_tx);

    //test_case3
    u_no_parity = 10'b1110100110;
    rx_input_no_parity(u_no_parity);

    RX_IN = 0;  // start glitch
    @(negedge clk);
    RX_IN = 1;
    repeat(2)
        @(negedge clk);
    RX_IN = 0;
    @(negedge clk);

    RX_IN = 1;
        @(negedge clk_tx);

    //test_case4
    PAR_EN = 1;
    PAR_TYP = 1;
    u_parity = 11'b11100000110;
    rx_input_with_parity(u_parity);

    //IDLE
    RX_IN = 1;
    repeat(4)
        @(negedge clk_tx);

    //test_case5
    PAR_TYP = 0;
    u_parity = 11'b11100100110;
    rx_input_with_parity(u_parity);

    //test_case6
    PAR_TYP = 1;
    u_parity = 11'b01100100110;
    rx_input_with_parity(u_parity);

    //test_case7
    PAR_TYP = 1;
    u_parity = 11'b11111111110; 
    rx_input_with_parity(u_parity);

    RX_IN = 0;  // start glitch
    @(negedge clk);
    RX_IN = 1;
    @(negedge clk_tx);           

    //test_case8
    PAR_EN = 1;
    PAR_TYP = 1;
    u_parity = 11'b01100100100;
    rx_input_with_parity(u_parity);

    //test_case9
    PAR_EN = 0;
    u_no_parity = 10'b1101010100;
    rx_input_no_parity (u_no_parity);

    //IDLE
    RX_IN = 1;
    @(negedge clk_tx);

    //test_case10
    PAR_EN = 0;
    u_no_parity = 10'b1000110000;
    rx_input_no_parity (u_no_parity);

    //test_case11
    PAR_EN = 0;
    u_no_parity = 10'b0000110110;
    rx_input_no_parity (u_no_parity);

    //IDLE
    RX_IN = 1;
    repeat(4)
        @(negedge clk_tx);

    $stop;
    
end
task rx_input_no_parity (input [9:0] u);
    for(i=0 ; i<10 ; i=i+1) begin
        RX_IN = u[i];
        @(negedge clk_tx);
    end
endtask

task rx_input_with_parity (input [10:0] v);
    for(i=0 ; i<11 ; i=i+1) begin
        RX_IN = v[i];
        @(negedge clk_tx);
    end
endtask

endmodule
