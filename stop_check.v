module stop_check (stp_chk_en , stp_err , stop_bit);
input stp_chk_en , stop_bit;
output reg stp_err;

always @(*) begin
    if(stp_chk_en) begin
        if(stop_bit == 0)
            stp_err = 1;
        else
            stp_err = 0;
    end
    else
        stp_err = 0;
end

endmodule
