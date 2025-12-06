module uart_rx_corrected (
    input  logic              clk,
    input  logic              rst,
    input  logic              rx_line,
    output logic [DATA_BITS-1:0] rx_data,
    output logic              rx_done,
    output logic              frame_valid
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    logic [1:0]              state;
    logic [DATA_BITS-1:0]    shift_reg;
    logic [3:0]              bit_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            rx_done     <= 1'b0;
            frame_valid <= 1'b0;
            bit_cnt     <= '0;
            shift_reg   <= '0;
            rx_data     <= '0;
        end
        else begin
            case (state)
                IDLE: begin
                    rx_done <= 1'b0;

                    // Detect start bit (falling edge)
                    if (rx_line == 1'b0) begin
                        state       <= START;
                        bit_cnt     <= '0;
                        frame_valid <= 1'b1;
                    end
                end

                START: begin
                    state   <= DATA;
                    bit_cnt <= '0;
                end

                DATA: begin
                    // Proper boundary at DATA_BITS
                    if (bit_cnt < DATA_BITS) begin
                        shift_reg[bit_cnt] <= rx_line;
                        bit_cnt            <= bit_cnt + 1;
                    end
                    else begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    // Check stop bit = 1
                    if (rx_line == 1'b1) begin
                        rx_data     <= shift_reg;
                        rx_done     <= 1'b1;
                        frame_valid <= 1'b0;
                    end
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
