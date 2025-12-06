`include "uart_params.sv"

module uart_rx (
    input clk,
    input rst,
    input rx_line,
    output reg [`DATA_BITS-1:0] rx_data,
    output reg rx_done
);

    reg [`DATA_BITS-1:0] shift_reg;
    reg [3:0] bit_cnt;
    reg receiving;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            rx_done   <= 1'b0;
            bit_cnt   <= 0;
            receiving <= 1'b0;
            rx_data   <= 0;
        end else begin
            if (!receiving && rx_line == 1'b0) begin
                receiving <= 1'b1;
                rx_done   <= 1'b0;
                bit_cnt   <= 0;
                shift_reg <= 0;
            end else if (receiving) begin
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt < `DATA_BITS) begin
                    shift_reg[bit_cnt] <= rx_line;
                end else begin
                    rx_data   <= shift_reg;
                    rx_done   <= 1'b1;
                    receiving <= 1'b0;
                end
            end else begin
                rx_done <= 1'b0;
            end
        end
    end

endmodule