
module sync_fifo #(parameter addr=8, 
                   parameter depth=8)(
input clk,
input rst,
input rd,
input wr,
input [addr-1:0] data,
output  empty,
output  full,
output reg [addr-1:0] data_out
);

localparam count = $clog2(depth);
reg [addr-1:0] fifo_mem [0:depth-1];

reg [count:0] wr_ptr, rd_ptr;

assign empty = (wr_ptr == rd_ptr);
assign full = (wr_ptr[count] != rd_ptr[count]) && (rd_ptr[count-1:0] == wr_ptr[count-1:0]);
//write
always @(posedge clk) begin
if(rst) begin
wr_ptr<=5'd0;
rd_ptr<=5'd0;
data_out<=8'd0;
end
else begin
//write
if(~full) begin
if(wr) begin
fifo_mem[wr_ptr[count-1:0]]<=data;
wr_ptr<=wr_ptr+1'b1;
end
end
//read
if(rd & ~empty) begin
data_out<=fifo_mem[rd_ptr[count-1:0]];
rd_ptr<=rd_ptr+1'b1;
end
end

end
endmodule
