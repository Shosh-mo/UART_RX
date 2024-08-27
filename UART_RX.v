module UART_RX (RX_IN , PAR_EN , PAR_TYP , prescale , clk , rst , P_DATA , data_valid);
input RX_IN ,  PAR_EN , PAR_TYP , clk , rst;
input [5:0] prescale;
output data_valid;
output [7:0] P_DATA;

wire enable , processing_done , stp_chk_en , stop_bit , stp_err ,
strt_chk_en , strt_glitch , par_chk_en , par_err;

wire [10:0] data_parity;
wire [8:0] data_parity_chk;
wire [9:0] data_no_parity;

fsm F1 (PAR_EN , RX_IN , enable , processing_done , data_parity , data_no_parity , 
stp_chk_en , stop_bit , stp_err , strt_glitch ,
par_chk_en , par_err , data_valid , P_DATA , data_parity_chk , clk , rst);

data_processing  dp1 (enable , RX_IN , prescale , data_no_parity , data_parity , clk , rst , PAR_EN , processing_done , strt_glitch);

parity_check par1 (par_chk_en , par_err , PAR_TYP , data_parity_chk);

stop_check stp2 (stp_chk_en , stp_err , stop_bit);


endmodule
