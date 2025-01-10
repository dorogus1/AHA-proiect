`timescale 1ns/1ps

module time_counter_with_display_tb();

    // Inputs
    reg clk;
    reg rst;
    reg switch0;
    reg switch1;
    reg switch2;

    // Outputs
    wire [6:0] seg1;
    wire [6:0] seg2;
    wire [6:0] seg3;
    wire [6:0] seg4;
    wire [2:0] state;
    wire led;

    // Instantiate the Device Under Test (DUT)
    time_counter_with_display DUT (
        .clk(clk),
        .rst(rst),
        .switch0(switch0),
        .switch1(switch1),
        .switch2(switch2),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .state(state),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        switch0 = 0;
        switch1 = 0;
        switch2 = 0;

        // Wait 100 ns for global reset
        #100;
        rst = 0;

        // Test Case 1: Initial state (S0)
        $display("Test Case 1: Testing initial state (S0)");
        #100;
        if(state !== 3'b000) $display("Error: Initial state should be S0");

        // Test Case 2: Transition to counting state (S1)
        $display("Test Case 2: Testing transition to counting state (S1)");
        switch0 = 1;
        #100;
        if(state !== 3'b001) $display("Error: State should be S1");

        // Test Case 3: Let it count for a few cycles
        $display("Test Case 3: Testing counting functionality");
        #1000;

        // Test Case 4: Pause state (S2)
        $display("Test Case 4: Testing pause state (S2)");
        switch0 = 0;
        switch1 = 1;
        #100;
        if(state !== 3'b010) $display("Error: State should be S2");

        // Test Case 5: Reset state (S3)
        $display("Test Case 5: Testing reset state (S3)");
        switch0 = 1;
        switch1 = 1;
        #100;
        if(state !== 3'b011) $display("Error: State should be S3");

        // Test Case 6: Return to counting after reset
        $display("Test Case 6: Testing return to counting after reset");
        switch0 = 1;
        switch1 = 0;
        switch2 = 0;
        #100;
        if(state !== 3'b001) $display("Error: State should be S1");

        // Test Case 7: Test LED blinking
        $display("Test Case 7: Testing LED blinking");
        #2000; // Wait to observe LED changes

        // End simulation
        #1000;
        $display("Simulation completed");
        $finish;
    end

    // Optional: Monitor state changes
    always @(state) begin
        $display("Time %t: State changed to %b", $time, state);
    end

    // Optional: Monitor counter values
    always @(DUT.second_count or DUT.minute_count) begin
        $display("Time %t: Seconds=%d, Minutes=%d", 
                $time, DUT.second_count, DUT.minute_count);
    end

endmodule