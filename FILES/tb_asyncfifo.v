`timescale 1ns / 1ps





module tb_asyncfifo;

    // PARAMETERS 
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 8;    
    parameter USABLE_DEPTH = 7;  

    parameter WR_CLK_PER = 10;    
    parameter RD_CLK_PER = 16;    

    // SIGNALS
    reg wr_clk = 0;
    reg rd_clk = 0;
    reg rst;

    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;

    wire [DATA_WIDTH-1:0] dout;
    wire full, empty, almost_full, almost_empty;
    wire overflow, underflow;

    // DUT 
    asyncfifo dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .overflow(overflow),
        .underflow(underflow)
    );

    // CLOCKS 
    always #(WR_CLK_PER/2) wr_clk = ~wr_clk;
    always #(RD_CLK_PER/2) rd_clk = ~rd_clk;

    // STORED INPUT DATA
    reg [DATA_WIDTH-1:0] stim_mem [0:USABLE_DEPTH-1];
    integer i;

 initial begin
    stim_mem[0] = 8'd10;
    stim_mem[1] = 8'd20;
    stim_mem[2] = 8'd30;
    stim_mem[3] = 8'd40;
    stim_mem[4] = 8'd50;
    stim_mem[5] = 8'd60;
    stim_mem[6] = 8'd70;
end

    // RESET
    initial begin
        rst   = 1;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        #20 rst = 0;
    end

    // WRITE PROCESS
    integer wptr;

initial begin
    wait(!rst);

    forever begin
        wptr = 0;

        while (wptr < USABLE_DEPTH) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1;
                din   = stim_mem[wptr];
                $display("WRITE : %0d", stim_mem[wptr]);
                wptr = wptr + 1;
            end
            @(posedge wr_clk);
            wr_en = 0;
        end
    end
end

    // READ PROCESS 
    integer rptr;

initial begin
    wait(!rst);
    #40;

    forever begin
        rptr = 0;

        while (rptr < USABLE_DEPTH) begin
            @(posedge rd_clk);
            if (!empty)
                rd_en = 1;

            @(posedge rd_clk);
            rd_en = 0;

            if (!empty) begin
                $display("READ  : %0d", dout);
                rptr = rptr + 1;
            end
        end
    end
end


    // MONITOR
    initial begin
        $monitor(
            "T=%0t | wr_en=%b rd_en=%b | din=%b dout=%b | full=%b empty=%b",
            $time, wr_en, rd_en, din, dout, full, empty
        );
    end

    initial begin
        #800;
        $finish;
    end

endmodule

