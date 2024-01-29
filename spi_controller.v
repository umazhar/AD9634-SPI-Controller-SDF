module spi_controller (
    input  wire        clk,
    input  wire        rst_n,
    output reg         spi_sclk,
    output reg         spi_mosi,
    input  wire        spi_miso,
    output reg         spi_cs_n
);