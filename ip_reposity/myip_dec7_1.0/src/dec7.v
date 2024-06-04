module dec7(
    input [3:0] dec_in,
    output reg [6:0] dec_out
);

always @(*)
begin
    case (dec_in)
        4'b0000: dec_out = 7'b1111110; // 0
        4'b0001: dec_out = 7'b0110000; // 1
        4'b0010: dec_out = 7'b1101101; // 2
        4'b0011: dec_out = 7'b1111001; // 3
        4'b0100: dec_out = 7'b0110011; // 4
        4'b0101: dec_out = 7'b1011011; // 5
        4'b0110: dec_out = 7'b1011111; // 6
        4'b0111: dec_out = 7'b1110010; // 7
        4'b1000: dec_out = 7'b1111111; // 8
        4'b1001: dec_out = 7'b1111011; // 9
        default: dec_out = 7'b0000000;
    endcase
end

endmodule