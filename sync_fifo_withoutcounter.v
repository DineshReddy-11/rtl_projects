// simultaneous read/write is no need to mention separately , because both operations happens at the same clock, pointer location won't change .
// most importantantly we need to have extra bit for pointers in order to detect the empty and full conditions.

module sync_fifo( input clk, rst, wr_en ,rd_en , 
					input [15:0] data_in,
					output reg [15:0]data_out,
					output empty,full );
					
reg [5:0]wr_pointer,rd_pointer;
reg [15:0] fifo_mem [31:0] ;	

always @(posedge clk or posedge rst) begin   //we can go with either the synchronous reset or asynchronous reset.
		
		if (rst)  begin
			wr_pointer <= 0;
			rd_pointer <= 0;
			data_out <= 0;
		end	
			
		else  begin
			
			if (wr_en && !full ) begin
			fifo_mem[wr_pointer[4:0]] <= data_in;
			wr_pointer <= wr_pointer + 1'b1;
			
			end

			if (rd_en && !empty ) begin
			data_out <= fifo_mem[rd_pointer[4:0]];
			rd_pointer <= rd_pointer + 1'b1;
			
			end
		
		end
	end	
	
	
assign empty = (wr_pointer == rd_pointer);
assign full = (wr_pointer[5] != rd_pointer[5] && wr_pointer[4:0] == rd_pointer[4:0]);

endmodule
		
		
			
			
					