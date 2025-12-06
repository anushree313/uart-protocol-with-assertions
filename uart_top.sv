`include "uart_params.sv"

module uart_top(
    input clk,
    input rst,
    input tx_start,
    input [`DATA_BITS-1:0] tx_data,
    output tx_done,
    output rx_done,
    output [`DATA_BITS-1:0] rx_data
);

    wire tx_line;
    
    // Loopback connection
    assign rx_line = tx_line;

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_line(tx_line),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx_line(rx_line),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule