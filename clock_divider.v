module clock_divider (
    input wire clk,        
    input wire rst_n,      
    output reg div_clk     
);

    localparam              SPI_CLK_DIV = 4; //set to 4 rn change later lol
    reg [SPI_CLK_DIV-1:0]   clk_div;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
            div_clk <= 0;
        end else begin
            if (clk_div == (SPI_CLK_DIV-1)) begin
                div_clk <= ~div_clk;
                clk_div <= 0;
            end else begin
                clk_div <= clk_div + 1;
            end
        end
    end

endmodule
