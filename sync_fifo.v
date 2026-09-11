module sync_fifo( input clk, rst, wr_en ,rd_en , 
					input [15:0] data_in,
					output reg [15:0]data_out,
					output empty,full );
					
reg [4:0]wr_pointer,rd_pointer;
reg [15:0] fifo_mem [31:0] ;
reg [5:0] fifo_count;  					// it should be able to count 32 as well . so we should take 6 bit width.

always @(posedge clk or posedge rst) begin   //we can go with either the synchronous reset or asynchronous reset.
		
		if (rst)  begin
			wr_pointer <= 0;
			rd_pointer <= 0;
			data_out <= 0;
			fifo_count <= 0;
		end	
			
		else  begin
			
			if (wr_en && !full ) begin
			fifo_mem[wr_pointer] <= data_in;
			wr_pointer <= wr_pointer + 1'b1;
			
			end

			if (rd_en && !empty ) begin
			data_out <= fifo_mem[rd_pointer];
			rd_pointer <= rd_pointer + 1'b1;
			
			end
		
		
			case ({wr_en && !full ,rd_en && !empty})   //counter logic is to tell whether the fifo is full or not that's it.
			
			2'b10: fifo_count <= fifo_count + 1'b1;
			2'b01: fifo_count <= fifo_count - 1'b1;
			2'b00: fifo_count <= fifo_count;
			2'b11: fifo_count <= fifo_count;
		
			endcase
		end
	end	
	
	
assign empty = (fifo_count == 6'd0 ? 1 : 0);
assign full = (fifo_count == 6'd32 ? 1 : 0);

endmodule
		
		
			
			
					