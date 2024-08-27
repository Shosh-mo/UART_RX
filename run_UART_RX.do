vlib work
vlog UART_RX.v UART_RX_tb.v
vsim -voptargs=+acc work.UART_RX_tb
#add wave *
add wave /UART_RX_tb/*
#add wave /UART_RX_tb/DUT0/F1/*
#add wave /UART_RX_tb/DUT0/stp2/*
#add wave /UART_RX_tb/DUT0/par1/*
#add wave /UART_RX_tb/DUT0/dp1/*
#add wave /UART_RX_tb/DUT0/strt1/*
run -all
#quit -sim