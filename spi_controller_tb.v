`timescale 1ns / 1ps

module tb_spi_controller();

    reg         clk;
    reg         rst_n;
    wire        spi_sclk;
    wire        spi_mosi;
    reg         spi_miso;
    wire        spi_cs_n;

    spi_controller uut (
        .clk                    (clk),
        .rst_n                  (rst_n),
        .spi_sclk               (spi_sclk),
        .spi_mosi               (spi_mosi),
        .spi_miso               (spi_miso),
        .spi_cs_n               (spi_cs_n)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        spi_miso = 0;
        #20;
        rst_n = 1;

        always @(posedge spi_sclk) begin
            if (spi_cs_n == 0) begin
                spi_miso <= spi_mosi;
            end
        end

        #1000;
        $finish;
    end

endmodule
