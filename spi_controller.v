module spi_controller (
    input  wire                 clk,        
    input  wire                 rst_n,      
    output reg                  spi_sclk,   
    output reg                  spi_mosi,   
    input  wire                 spi_miso,   
    output reg                  spi_cs_n,   

    input  wire [23:0] data_in,    // data

                                // [23:18] = bus direction and number of bytes to transfer
                                // [17:8] = address where data is to be written
                                // [7:0] = data to be transferred (MSB to LSB)

    input  wire        load,       // Signal to load data

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
        .clk(clk),
        .rst_n(rst_n),
        .div_clk(spi_sclk)
    );

    spi_fsm fsm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .spi_sclk(spi_sclk),
        .load(load),
        .data_in(data_in),
        .spi_mosi(spi_mosi),
        .spi_cs_n(spi_cs_n),
        .spi_miso(spi_miso),
        .data_out(data_out)
    );

endmodule
