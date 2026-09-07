
module sync_fifo_tb;
reg  clk;
reg rst;
reg [7:0] data;
reg  rd;
reg wr;
wire [7:0] data_out;
wire empty;
wire full;

sync_fifo inst ( .clk(clk), .rst(rst), .data(data), .rd(rd), . wr(wr), .data_out(data_out), .empty(empty), .full(full) );

initial begin
clk=1'b0;
end

always #5 clk=~clk;

initial begin
rst=1'b1;
wr=1'b0;
rd=1'b0;
#7; rst=1'b0;
#5; wr=1'b1; data=8'haa;
#10; data=8'hab;
#10; data=8'hba;
#10; data=8'hbb;
#10; rd=1'b1;
#50; rd=1'b0;wr=1'b1; data=8'hff;
#10; data=8'hee;
#10; wr=1'b0; rd=1'b1;
end

endmodule
