module async_fifo( input wr_clk,rd_clk,rst,wr_en,rd_en,
					input [15:0] data_in,
					output reg [15:0] data_out,
					output empty,full);
					
					
reg [15:0]fifo_mem[31:0];


reg [5:0] wr_ptr_bin, rd_ptr_bin;
reg [5:0] wr_ptr_gray, rd_ptr_gray;

reg [5:0] wr_ptr_gray_sync1, rd_ptr_gray_sync1;
reg [5:0] wr_ptr_gray_sync2, rd_ptr_gray_sync2;

reg [5:0] wr_ptr_bin_next, rd_ptr_bin_next;
reg [5:0] wr_ptr_gray_next, rd_ptr_gray_next;

wire write,read;

assign write = (!full && wr_en);
assign read = (!empty && rd_en);

assign wr_ptr_bin_next = wr_ptr_bin + write;
assign rd_ptr_bin_next = rd_ptr_bin + read;

assign wr_ptr_gray_next = wr_ptr_bin_next ^ (wr_ptr_bin_next >>1);
assign rd_ptr_gray_next = rd_ptr_bin_next ^ (rd_ptr_bin_next >>1);


// write operation

always @(posedge wr_clk or posedge rst) begin

	if (rst) begin
		wr_ptr_bin <= 0;
		wr_ptr_gray <= 0;
	end	
		
	else if (write) begin
		fifo_mem[wr_ptr_bin[4:0]]<=data_in;
		wr_ptr_bin <= wr_ptr_bin_next;
		wr_ptr_gray <= wr_ptr_gray_next;
	end
end	

//read operation	
	
always @(posedge rd_clk or posedge rst) begin 

	if(rst) begin
		data_out <= 0;
		rd_ptr_bin <= 0;
		rd_ptr_gray <= 0;
	end
	
	else if (read) begin
		data_out <= fifo_mem[rd_ptr_bin[4:0]];
		rd_ptr_bin <= rd_ptr_bin_next;
		rd_ptr_gray <= rd_ptr_gray_next;
	end
end	

// 2 flipflop synchronization for wr_ptr_gray
		
always @(posedge rd_clk or posedge rst) begin
	if(rst) begin
		wr_ptr_gray_sync1 <= 0;
		wr_ptr_gray_sync2 <= 0;
	end
	
	else begin
	
		wr_ptr_gray_sync1 <= wr_ptr_gray;
		wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
	end
end

// 2 flipflop synchronization for rd_ptr_gray

always @(posedge wr_clk or posedge rst)	begin
	if(rst) begin
		rd_ptr_gray_sync1 <= 0;
		rd_ptr_gray_sync2 <= 0;
	end	
	
	else begin
		rd_ptr_gray_sync1 <= rd_ptr_gray;
		rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
	end
end	
		

assign full = ( ~rd_ptr_gray_sync2[5:4] == wr_ptr_gray_next[5:4]) && (rd_ptr_gray_sync2[3:0] == wr_ptr_gray_next[3:0]);
assign empty = ( wr_ptr_gray_sync2 == rd_ptr_gray_next );

endmodule		
		
		
					
					
					
					