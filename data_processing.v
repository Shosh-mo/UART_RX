module data_processing ( enable , RX_IN , prescale , data_no_parity , data_parity , clk , rst , PAR_EN , processing_done , strt_glitch);
input enable , RX_IN , clk , rst , PAR_EN;
input [5:0] prescale;
output reg [10:0] data_parity;
output reg [9:0] data_no_parity;
output reg processing_done , strt_glitch;
reg [5:0] c;
reg [3:0] index;


always @(posedge clk) begin
    if(~rst) begin
        data_parity <= 0;
        data_no_parity <= 0;
        c <= 0;
        index <= 0;
        processing_done <= 0;
    end
    else if(enable) begin
        c <= c + 1;
/////////////////////////////////////////////////////////////
        if(index == 0) begin
            if( RX_IN == 1 ) begin
                strt_glitch <= 1;
            end
            else begin
                strt_glitch <= 0;
            end
        end
        else begin
            strt_glitch <= 0;
        end
/////////////////////////////////////////////////////////////
        if(c+1 == prescale) begin
            c <= 0;
            if(PAR_EN == 1) begin //i have 11 bits
                data_parity[index] <= RX_IN; //start bit will be at location 0
                index <= index + 1;
                processing_done <= 0;
            end

            else begin ///////PAR_EN = 0
               data_no_parity[index] <= RX_IN;
                index <= index + 1;
                processing_done <= 0;
            end
        end
////////////////////////////////////////////
        else if(index == 9 && PAR_EN == 0 && RX_IN == 0) begin
            c <= c + 1;
            if(c+3 == prescale) begin
                data_no_parity[index] <= RX_IN;
                index <= 0;
                processing_done <= 1;
                c <= 0;
            end
        end
        else if(index == 10 && PAR_EN == 1 && RX_IN == 0) begin
           c <= c + 1;
           if(c+3 == prescale) begin
                data_parity[index] <= RX_IN;
                index <= 0;
                processing_done <= 1;
                c <= 0;
           end
        end
////////////////////////////////////////////
        else begin
            if(index == 9 && PAR_EN == 0) begin
                    data_no_parity[index] <= RX_IN;
                    index <= 0;
                    processing_done <= 1;
                    c <= 0;
            end
           else if(index == 10 && PAR_EN == 1) begin
                    data_parity[index] <= RX_IN;
                    index <= 0;
                    processing_done <= 1;
                    c <= 0;
            end
            
        end

    end
    else begin
        processing_done <= 0;
        strt_glitch <= 0;
        index <= 0;
        c <= 0;
        data_no_parity <= 0;
        data_parity <= 0;
    end

    if(strt_glitch == 1) begin
        data_no_parity <= 0;
        data_parity <= 0;
        c <= 0;
    end

end

endmodule
