module spi_controller (
    input  wire                 clk,        
    input  wire                 rst_n,      
    output reg                  spi_sclk,   
    output reg                  spi_mosi,   
    input  wire                 spi_miso,   
    output reg                  spi_cs_n,   
);

    localparam                  IDLE = 0, 
                                START = 1, 
                                TRANSFER = 2, 
                                STOP = 3; 

    localparam                  SPI_CLK_DIV = 4; //  SPI clock frequency set to 4 rn, change later

    reg [2:0]                   current_state, 
    reg [2:0]                   next_state;
    reg [23:0]                  data_reg; 
    reg [5:0]                   bit_count; 
    reg [SPI_CLK_DIV-1:0]       clk_div; 

    clock_divider clk_div_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .div_clk    (spi_sclk)
    );

    // State Machine for SPI Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            spi_cs_n <= 1; 
        end else begin
            case (current_state)
                IDLE: begin
                    next_state <= START;
                    bit_count <= 24; 
                    // Load data_reg and address_reg 
                end
                START: begin
                    spi_cs_n <= 0; // Assert Chip Select
                    next_state <= TRANSFER;
                end
                TRANSFER: begin
                    if (bit_count == 0) begin
                        next_state <= STOP;
                    end else begin
                        // spi transfer, msb first, shift left and decrement bit
                        if (spi_sclk) begin 
                            spi_mosi <= data_reg[23]; 
                            data_reg <= data_reg << 1; 
                            if (!spi_sclk) begin 
                                data_reg[0] <= spi_miso;
                                bit_count <= bit_count - 1; 
                            end
                        end
                    end
                end
                STOP: begin
                    spi_cs_n <= 1; 
                    next_state <= IDLE;
                end
                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

    // addd stuff for output

endmodule
