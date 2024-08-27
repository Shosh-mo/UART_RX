module fsm (PAR_EN , RX_IN , enable , processing_done , data_parity , data_no_parity , 
stp_chk_en , stop_bit , stp_err , strt_glitch ,
par_chk_en , par_err , data_valid , P_DATA , data_parity_chk , clk , rst);

parameter IDLE = 2'b00;
parameter DATA_PROCESSING = 2'b01;
parameter CHECKING = 2'b10;

input PAR_EN , RX_IN , processing_done ,
 stp_err ,  strt_glitch , par_err , clk , rst;

 input [10:0] data_parity;
 input [9:0]  data_no_parity;

output reg stop_bit , data_valid;
output reg [7:0] P_DATA;
output stp_chk_en , par_chk_en ;
output enable;
output reg [8:0] data_parity_chk;

reg [1:0] cs , ns;
//state memory
always @(posedge clk) begin
    if(~rst)
        cs <= IDLE;
    else
        cs <= ns;
end

//next state
always @(*) begin
    case(cs)
        IDLE:
            if(RX_IN)
                ns = IDLE;
            else
                ns = DATA_PROCESSING;

        DATA_PROCESSING:
            if(strt_glitch == 1)
                ns = IDLE;
            else if(~processing_done)
                ns = DATA_PROCESSING;
            else 
                ns = CHECKING;

        CHECKING:     
            if(RX_IN || stp_err)
                ns = IDLE;
            else
                ns = DATA_PROCESSING;

        default: ns = IDLE;
    endcase
end

//output logic
assign par_chk_en = (cs == CHECKING && PAR_EN == 1);
assign stp_chk_en = (cs == CHECKING);
assign enable = (cs == DATA_PROCESSING || ns == DATA_PROCESSING);

always @(*) begin
    if(cs == CHECKING) begin
        if(PAR_EN) begin
            data_parity_chk = data_parity[9:1];
            stop_bit = data_parity[10];
            P_DATA = data_parity[8:1];
        end 
        else begin
            stop_bit = data_no_parity[9];
            data_parity_chk = 0;
            P_DATA = data_no_parity[8:1];
        end
    end
    else begin
        stop_bit = 0;
        data_parity_chk = 0;
        P_DATA = 0; 
    end
end

always @(*) begin
    if (cs == CHECKING) begin
        if(par_err == 0 && stp_err == 0)
            data_valid <= 1;
        else
            data_valid <= 0;
    end
    else 
        data_valid <= 0;
end

endmodule
