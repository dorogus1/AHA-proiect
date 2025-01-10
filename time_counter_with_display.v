module time_counter_with_display(
    input clk,        
    input rst,
    input switch0,    
    input switch1,    
    input switch2,      
    output wire [6:0] seg1, 
    output wire [6:0] seg2, 
    output wire [6:0] seg3, 
    output wire [6:0] seg4, 
    output reg [2:0] state,
    output reg led     
);
    parameter S0 = 3'b000;  // Initial state
    parameter S1 = 3'b001;  // Counting state
    parameter S2 = 3'b010;  // Pause state
    parameter S3 = 3'b011;  // Reset state
    
    reg [25:0] clk_divider;  
    reg clk_1hz;             
    reg [5:0] second_count;  
    reg [5:0] minute_count;  
    reg [3:0] sec_unit_count;   
    reg [3:0] sec_tens_count;   
    reg [3:0] min_unit_count;   
    reg [3:0] min_tens_count;   

    wire [2:0] in;
    assign in = {switch2, switch1, switch0};

    // Clock divider for 1Hz clock
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

    // State machine and counter logic
    always @(posedge clk_1hz or posedge rst) begin
        if (rst) begin
            state <= S0;
            second_count <= 0;
            minute_count <= 0;
            sec_unit_count <= 0;
            sec_tens_count <= 0;
            min_unit_count <= 0;
            min_tens_count <= 0;
        end else begin
            case(state)
                S0: begin  // Initial state
                    if(in == 3'b001)
                        state <= S1;
                end
                
                S1: begin  // Counting state
                    if(in == 3'b010)
                        state <= S2;
                    else if(in == 3'b011)
                        state <= S3;
                    else begin  // Continue counting if in S1
                        if (second_count == 59) begin
                            second_count <= 0;
                            if (minute_count == 59) begin
                                minute_count <= 0;
                                min_unit_count <= 0;
                                min_tens_count <= 0;
                            end else begin
                                minute_count <= minute_count + 1;
                                if (min_unit_count == 9) begin
                                    min_unit_count <= 0;
                                    if (min_tens_count == 5)
                                        min_tens_count <= 0;
                                    else
                                        min_tens_count <= min_tens_count + 1;
                                end else
                                    min_unit_count <= min_unit_count + 1;
                            end
                        end else begin
                            second_count <= second_count + 1;
                            if (sec_unit_count == 9) begin
                                sec_unit_count <= 0;
                                if (sec_tens_count == 5)
                                    sec_tens_count <= 0;
                                else
                                    sec_tens_count <= sec_tens_count + 1;
                            end else
                                sec_unit_count <= sec_unit_count + 1;
                        end
                    end
                end
                
                S2: begin  // Pause state
                    if(in == 3'b001)
                        state <= S1;
                end
                
                S3: begin  // Reset state
                    second_count <= 0;
                    minute_count <= 0;
                    sec_unit_count <= 0;
                    sec_tens_count <= 0;
                    min_unit_count <= 0;
                    min_tens_count <= 0;
                    if(in == 3'b001)
                        state <= S1;
                end
                
                default: state <= S0;
            endcase
        end
    end

    // LED blinker - 1Hz
    always @(posedge clk_1hz or posedge rst) begin
        if (rst)
            led <= 0;
        else
            led <= ~led;
    end

    // Display module instantiation
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
