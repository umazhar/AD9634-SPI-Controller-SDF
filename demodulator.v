module qpsk_modulator(
    input clk,
    input rst_n,
    input enable,
    input [1:0] data_in, 
    output reg signed [11:0] I_out, 
    output reg signed [11:0] Q_out  
);

localparam [11:0] SYMBOL_MAX_POS = 12'h0801; // Represents cos(45 deg) and sin(45 deg) for 12-bit     2047
localparam [11:0] SYMBOL_MAX_NEG = 12'h07FF; // Represents cos(45 deg) and sin(45 deg) for 12-bit     -2047

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        I_out <= 0;
        Q_out <= 0;
    end else if (enable) begin
        case (data_in)
            2'b00: begin
                //45
                I_out <= SYMBOL_MAX_POS; 
                Q_out <= SYMBOL_MAX_POS;
            end
            2'b01: begin
                //135
                I_out <= SYMBOL_MAX_NEG; 
                Q_out <= SYMBOL_MAX_POS; 
            end
            2'b10: begin
                //225
                I_out <= SYMBOL_MAX_POS; 
                Q_out <= SYMBOL_MAX_NEG; 
            end
            2'b11: begin
                //315
                I_out <= SYMBOL_MAX_NEG; 
                Q_out <= SYMBOL_MAX_NEG; 
            end
        endcase
    end
end

endmodule
