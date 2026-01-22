`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.01.2026 12:07:29
// Design Name:
// Module Name: top_asyncfifo
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////








module top_asyncfifo (
    input  wire        clk,        // 100 MHz board clock
    input  wire        rst,        // BTNU (ASYNC RESET)

    input  wire        sw_wr,      // BTNC (Write)
    input  wire        sw_rd,      // BTNR (Read)
    input  wire [7:0]  sw_data,    // SW0-SW7 (FIFO input)

    output wire [7:0]  fifo_dout,  // PMOD JB1 (FIFO output)
    output wire [7:0]  led         // LD0-LD7 (STATUS)
);

    // =====================================================
    // CLOCKS (NO GENERATED CLOCK)
    // =====================================================
    wire wr_clk = clk;
    wire rd_clk = clk;

    // =====================================================
    // DEBOUNCE BLOCK
    // =====================================================
    wire sw_wr_db, sw_rd_db;

    debounce db_wr (.clk(clk), .rst(rst), .noisy_in(sw_wr), .clean_out(sw_wr_db));
    debounce db_rd (.clk(clk), .rst(rst), .noisy_in(sw_rd), .clean_out(sw_rd_db));

    // =====================================================
    // EDGE DETECT (CLOCK ENABLE)
    // =====================================================
    reg sw_wr_d, sw_rd_d;

    always @(posedge clk) begin
        sw_wr_d <= sw_wr_db;
        sw_rd_d <= sw_rd_db;
    end

    wire wr_en_pulse = sw_wr_db & ~sw_wr_d;
    wire rd_en_pulse = sw_rd_db & ~sw_rd_d;

    // =====================================================
    // INPUT DATA LATCH
    // =====================================================
    reg [7:0] data_latched;

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_latched <= 8'd0;
        else if (wr_en_pulse)
            data_latched <= sw_data;
    end

    // =====================================================
    // FIFO SIGNALS
    // =====================================================
    wire [7:0] dout;
    wire full, empty, almost_full, almost_empty;
    wire overflow, underflow;

    // =====================================================
    // ASYNC FIFO INSTANCE
    // =====================================================
    asyncfifo dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst   (rst),

        .wr_en(wr_en_pulse),
        .rd_en(rd_en_pulse),
        .din  (data_latched),

        .dout (dout),
        .full (full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .overflow(overflow),
        .underflow(underflow)
    );

    assign fifo_dout = dout;

    // =====================================================
    // LED STATUS
    // =====================================================
    assign led[0] = empty;
    assign led[1] = almost_empty;
    assign led[2] = full;
    assign led[3] = almost_full;
    assign led[4] = overflow;
    assign led[5] = underflow;

    // =====================================================
    // WRITE / READ PULSE INDICATOR (STRETCHED)
    // =====================================================
    reg [23:0] wr_led_cnt = 0;
    reg [23:0] rd_led_cnt = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_led_cnt <= 0;
            rd_led_cnt <= 0;
        end else begin
            if (wr_en_pulse)
                wr_led_cnt <= 24'hFFFFFF;
            else if (wr_led_cnt != 0)
                wr_led_cnt <= wr_led_cnt - 1;

            if (rd_en_pulse)
                rd_led_cnt <= 24'hFFFFFF;
            else if (rd_led_cnt != 0)
                rd_led_cnt <= rd_led_cnt - 1;
        end
    end

    assign led[6] = (wr_led_cnt != 0);  // WRITE EVENT
    assign led[7] = (rd_led_cnt != 0);  // READ EVENT

endmodule

