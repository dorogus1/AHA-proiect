module time_counter_with_display(
    input clk,        
    input rst,
    input [2:0] in,    
    input button,    
    output wire [6:0] seg1, 
    output wire [6:0] seg2, 
    output wire [6:0] seg3, 
    output wire [6:0] seg4, 
    output reg [2:0]state;
    output reg led     
);
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    reg [25:0] clk_divider;  
    reg clk_1hz;             
    reg [5:0] second_count;  
    reg [5:0] minute_count;  
    reg [3:0] sec_unit_count;   
    reg [3:0] sec_tens_count;   
    reg [3:0] min_unit_count;   
    reg [3:0] min_tens_count;   


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_divider <= 0;
            clk_1hz <= 0;
        end else if (clk_divider == 50000000 / 2 - 1) begin
            clk_divider <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            clk_divider <= clk_divider + 1;
        end
    end


    always @(posedge clk_1hz or posedge rst) begin
        if (rst) begin
            second_count <= 0;
            minute_count <= 0;
            sec_unit_count <= 0;
            sec_tens_count <= 0;
            min_unit_count <= 0;
            min_tens_count <= 0;
        end else begin
            case(state)
                S0: if(in==3'b000)
                    state = S0;
                    if(in==3'b001)
                    state = S1;
                S1: if(in==3'b000) begin
                        state=S1;
                        if (second_count == 59) begin
                            second_count <= 0;

                            // Minute
                            if (minute_count == 59) begin
                                minute_count <= 0;
                                min_unit_count <= 0;
                                min_tens_count <= 0;
                            end else begin
                                minute_count <= minute_count + 1;

                                if (min_unit_count == 9) begin
                                    min_unit_count <= 0;

                                    if (min_tens_count == 5) begin
                                        min_tens_count <= 0;
                                    end else begin
                                        min_tens_count <= min_tens_count + 1;
                                    end
                                end else begin
                                    min_unit_count <= min_unit_count + 1;
                                end
                            end
                        end else begin
                            second_count <= second_count + 1;


                            if (sec_unit_count == 9) begin
                                sec_unit_count <= 0;


                                if (sec_tens_count == 5) begin
                                    sec_tens_count <= 0;
                                end else begin
                                    sec_tens_count <= sec_tens_count + 1;
                                end
                            end else begin
                                sec_unit_count <= sec_unit_count + 1;
                            end
                        end
                    end
                    if(in==3'b001) begin
                        state=S1;
                        if (second_count == 59) begin
                            second_count <= 0;

                            // Minute
                            if (minute_count == 59) begin
                                minute_count <= 0;
                                min_unit_count <= 0;
                                min_tens_count <= 0;
                            end else begin
                                minute_count <= minute_count + 1;

                                if (min_unit_count == 9) begin
                                    min_unit_count <= 0;

                                    if (min_tens_count == 5) begin
                                        min_tens_count <= 0;
                                    end else begin
                                        min_tens_count <= min_tens_count + 1;
                                    end
                                end else begin
                                    min_unit_count <= min_unit_count + 1;
                                end
                            end
                        end else begin
                            second_count <= second_count + 1;


                            if (sec_unit_count == 9) begin
                                sec_unit_count <= 0;


                                if (sec_tens_count == 5) begin
                                    sec_tens_count <= 0;
                                end else begin
                                    sec_tens_count <= sec_tens_count + 1;
                                end
                            end else begin
                                sec_unit_count <= sec_unit_count + 1;
                            end
                        end
                    end
                    if(in==3'b010)
                        state = S2;
                    if(in==3'b011)
                        state = S3;
                S2: if(in==3'b000)
                        state=S2;
                    if(in==3'b001)
                        state=S1;
                    if(in==3'b010)
                        state=S2;
                S3: if(in==3'b000)begin
                        second_count <= 0;
                        minute_count <= 0;
                        sec_unit_count <= 0;
                        sec_tens_count <= 0;
                        min_unit_count <= 0;
                        min_tens_count <= 0;
                        state=S3;
                    end
                    if(in==3'b001)begin
                        second_count <= 0;
                        minute_count <= 0;
                        sec_unit_count <= 0;
                        sec_tens_count <= 0;
                        min_unit_count <= 0;
                        min_tens_count <= 0;
                        state=S1;
                    end
                    if(in==3'b011)begin
                        second_count <= 0;
                        minute_count <= 0;
                        sec_unit_count <= 0;
                        sec_tens_count <= 0;
                        min_unit_count <= 0;
                        min_tens_count <= 0;
                        state=S3;
                    end
            endcase
            if(button)begin
                in<=in+1;
            end
        end
    end

    // LED se aprinde si se stinge o data pe secunda
    always @(posedge clk_1hz or posedge rst) begin
        if (rst) begin
            led <= 0;
        end else begin
            led <= ~led;
        end
    end

    time_display display_all (
        .digit1(sec_unit_count), 
        .digit2(sec_tens_count),  
        .digit3(min_unit_count), 
        .digit4(min_tens_count), 
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4)
    );

endmodule
