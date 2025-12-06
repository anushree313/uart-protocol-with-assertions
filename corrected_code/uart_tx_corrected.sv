module uart_tx_corrected (
    input  logic              clk,
    input  logic              rst,
    input  logic              tx_start,
    input  logic [DATA_BITS-1:0] tx_data,
    output logic              tx_line,
    output logic              tx_done,
    output logic              tx_valid
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    logic [1:0]              state;
    logic [DATA_BITS-1:0]    shift_reg;
    logic [3:0]              bit_cnt;
    logic                    active;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx_line   <= 1'b1;
            tx_done   <= 1'b0;
            tx_valid  <= 1'b0;
            active    <= 1'b0;
            bit_cnt   <= '0;
            shift_reg <= '0;
        end
        else begin
            case (state)
                IDLE: begin
                    tx_done  <= 1'b0;
                    tx_valid <= 1'b0;

                    if (tx_start && !active) begin
                        state  <= START;
                        active <= 1'b1;

                        // Initialize ALL bits properly
                        for (int i = 0; i < DATA_BITS; i++) begin
                            shift_reg[i] <= tx_data[i];
                        end

                        tx_line  <= 1'b0;   // start bit
                        tx_valid <= 1'b1;
                    end
                end

                START: begin
                    state   <= DATA;
                    bit_cnt <= '0;
                end

                DATA: begin
                    // Increment by 1, not 2
                    if (bit_cnt < DATA_BITS) begin
                        tx_line <= shift_reg[bit_cnt];
                        bit_cnt <= bit_cnt + 1;
                    end
                    else begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    tx_line  <= 1'b1;   // stop bit
                    tx_done  <= 1'b1;
                    tx_valid <= 1'b0;
                    state    <= IDLE;
                    active   <= 1'b0;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
