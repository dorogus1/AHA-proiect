module time_display(
    input [3:0] digit1,          
    input [3:0] digit2,          
    input [3:0] digit3,          
    input [3:0] digit4,          
    output reg [6:0] seg1,       
    output reg [6:0] seg2,       
    output reg [6:0] seg3,       
    output reg [6:0] seg4        
);

    // Functia pentru afisare pe 7-segmente
    always @(*) begin
	// Afisaj pentru secunde
        case (digit1)
            4'd0: seg1 = 7'b0111111;
            4'd1: seg1 = 7'b0000110;
            4'd2: seg1 = 7'b1011011;
            4'd3: seg1 = 7'b1001111;
            4'd4: seg1 = 7'b1100110;
            4'd5: seg1 = 7'b1101101;
            4'd6: seg1 = 7'b1111101;
            4'd7: seg1 = 7'b0000111;
            4'd8: seg1 = 7'b1111111;
            4'd9: seg1 = 7'b1101111;
            default: seg1 = 7'b0000000;
        endcase


        case (digit2)
            4'd0: seg2 = 7'b0111111;
            4'd1: seg2 = 7'b0000110;
            4'd2: seg2 = 7'b1011011;
            4'd3: seg2 = 7'b1001111;
            4'd4: seg2 = 7'b1100110;
            4'd5: seg2 = 7'b1101101;
            4'd6: seg2 = 7'b1111101;
            4'd7: seg2 = 7'b0000111;
            4'd8: seg2 = 7'b1111111;
            4'd9: seg2 = 7'b1101111;
            default: seg2 = 7'b0000000;
        endcase
	// Afisaj pentru minute
        case (digit3)
            4'd0: seg3 = 7'b0111111;
            4'd1: seg3 = 7'b0000110;
            4'd2: seg3 = 7'b1011011;
            4'd3: seg3 = 7'b1001111;
            4'd4: seg3 = 7'b1100110;
            4'd5: seg3 = 7'b1101101;
            4'd6: seg3 = 7'b1111101;
            4'd7: seg3 = 7'b0000111;
            4'd8: seg3 = 7'b1111111;
            4'd9: seg3 = 7'b1101111;
            default: seg3 = 7'b0000000;
        endcase

        case (digit4)
            4'd0: seg4 = 7'b0111111;
            4'd1: seg4 = 7'b0000110;
            4'd2: seg4 = 7'b1011011;
            4'd3: seg4 = 7'b1001111;
            4'd4: seg4 = 7'b1100110;
            4'd5: seg4 = 7'b1101101;
            4'd6: seg4 = 7'b1111101;
            4'd7: seg4 = 7'b0000111;
            4'd8: seg4 = 7'b1111111;
            4'd9: seg4 = 7'b1101111;
            default: seg4 = 7'b0000000;
        endcase
    end
endmodule
