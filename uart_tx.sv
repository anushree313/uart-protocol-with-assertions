`include "uart_params.sv"

module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [`DATA_BITS-1:0] tx_data,
    output reg tx_line,
    output reg tx_done
);

    reg [`DATA_BITS-1:0] shift_reg;
    reg [3:0] bit_cnt;
    reg active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_line <= 1'b1;
            tx_done <= 1'b0;
            active  <= 1'b0;
            bit_cnt <= 0;
            shift_reg <= 0;
        end else begin
            if (tx_start && !active) begin
                active     <= 1'b1;
                shift_reg  <= tx_data;
                tx_line    <= 1'b0;
                tx_done    <= 1'b0;
                bit_cnt    <= 0;
            end else if (active) begin
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt < `DATA_BITS) begin
                    tx_line <= shift_reg[bit_cnt];
                end else if (bit_cnt == `DATA_BITS) begin
                    tx_line <= 1'b1;
                    tx_done <= 1'b1;
                    active  <= 1'b0;
                end
            end else begin
                tx_done <= 1'b0;
            end
        end
    end

endmodule