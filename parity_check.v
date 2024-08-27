module parity_check (par_chk_en , par_err , PAR_TYP , data_parity_chk);
input par_chk_en , PAR_TYP;
input [8:0] data_parity_chk;
output reg par_err;
reg parity_expected;

always@(*) begin
    if(par_chk_en) begin
        if(PAR_TYP) begin //odd parity
            parity_expected = ~(^data_parity_chk[7:0]);

            if(parity_expected != data_parity_chk[8])
                par_err = 1;
            else
                par_err = 0;

        end
        else begin  //even parity
            parity_expected = ^data_parity_chk[7:0];

            if(parity_expected != data_parity_chk[8])
                par_err = 1;
            else
                par_err = 0;   
        end
    end
    else begin
        parity_expected = 0;
        par_err = 0;
    end
end

endmodule
