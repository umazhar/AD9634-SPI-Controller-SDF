module spi_fsm (
    input wire              clk,
    input wire              rst_n,
    input wire              spi_sclk,
    input wire              load,
    input wire [23:0]       data_in,
    output reg              spi_mosi,
    output reg              spi_cs_n,
    input wire              spi_miso,
    output reg [23:0]       data_out
);

    localparam              IDLE = 0, 
                            START = 1, 
                            TRANSFER = 2, 
                            STOP = 3;

    reg [2:0]               current_state;
    reg [2:0]               next_state;
    reg [23:0]              data_reg;
    reg [5:0]               bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            spi_cs_n <= 1;
            data_reg <= 24'b0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    if (load) begin
                        data_reg <= data_in;
                        bit_count <= 24;
                        next_state <= START;
                    end else begin
                        next_state <= IDLE;
                    end
                end
                START: begin
                    spi_cs_n <= 0;
                    next_state <= TRANSFER;
                end
                TRANSFER: begin
                    if (bit_count == 0) begin
                        next_state <= STOP;
                    end else begin
                        if (spi_sclk) begin
                            spi_mosi <= data_reg[23];
                            data_reg <= data_reg << 1;
                        end
                        if (!spi_sclk) begin
                            bit_count <= bit_count - 1;
                        end
                    end
                end
                STOP: begin
                    spi_cs_n <= 1;
                    next_state <= IDLE;
                end
                default: next_state <= IDLE;
            endcase
        end
    end

    //  output state
    
    always @(posedge clk) begin
        if (current_state == IDLE) begin
            data_out <= data_reg;
        end
    end

endmodule
