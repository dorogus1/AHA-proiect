module fsm (
    input wire clk,
    input wire reset,
    input wire in[1:0],
    output reg [1:0] state
);
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: if(in==2'00)
                next_state = S0;
                if(in==2'01)
                next_state = S1;

            S1: if(in==2'00)
                next_state = S1;
                if(in==2'01)
                next_state = S1;
                if(in==2'10)
                next_state = S2;
                if(in==2'11)
                next_state = S3;

            S2: if(in==2'00)
                next_state=S2;
                if(in==2'01)
                next_state=S1;
                if(in==2'10)
                next_state=S2;

            S3: if(in==2'00)
                next_state=S3;
                if(in==2'01)
                next_state=S1;
                if(in==2'11)
                next_state=S3;    
            default: next_state = S0;
        endcase
    end

endmodule