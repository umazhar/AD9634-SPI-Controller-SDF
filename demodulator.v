module qpsk_demodulator(
    input clk,
    input rst_n,
    input signed [11:0] I_in, 
    input signed [11:0] Q_in,
    output reg [1:0] data_out
);

//simple decision boundary at 0 (the SYMBOL_THRESHOLD) to decide whether the I or Q components 
//are positive or negative, mapping them back to the 2-bit binary data.

localparam [11:0] SYMBOL_THRESHOLD = 12'h000; //threshold for pos/neg

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 2'b00;
    end else begin
        if (I_in > SYMBOL_THRESHOLD) begin
            if (Q_in > SYMBOL_THRESHOLD) begin
                data_out <= 2'b00; 
            end else begin
                data_out <= 2'b10; 
            end
        end else begin
            if (Q_in > SYMBOL_THRESHOLD) begin
                data_out <= 2'b01; 
            end else begin
                data_out <= 2'b11; 
            end
        end
    end
end

endmodule
