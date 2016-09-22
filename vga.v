module vga(
	input clk,
	input rst,
	output [15:0] pos_x,
	output [15:0] pos_y,
	output blank_n,
	output sync_h,
	output sync_v
);

reg [1:0] x_mode;
reg [15:0] x_count;
reg [1:0] y_mode;
reg [15:0] y_count;

assign pos_x = x_count;
assign pos_y = y_count;
assign blank_n = (x_mode == 0) && (y_mode == 0);
assign sync_h = (x_mode == 2);
assign sync_v = (y_mode == 2);


initial begin
	x_mode = 0;
	x_count = 0;
	y_mode = 0;
	y_count = 0;
end

always @ (posedge clk) begin
	if (rst) begin
		x_mode <= 0;
		x_count <= 0;
		y_mode <= 0;
		y_count <= 0;
	end else begin
		case (x_mode)
			0:	begin
					if (x_count < 640-1)
						x_count <= (x_count+1);
					else begin
						x_count <= 0;
						x_mode <= (x_mode + 1);
					end
				end
			1:	begin
					if (x_count < 16-1)
						x_count <= (x_count+1);
					else begin
						x_count <= 0;
						x_mode <= (x_mode + 1);
					end
				end
			2:	begin
					if (x_count < 96-1)
						x_count <= (x_count+1);
					else begin
						x_count <= 0;
						x_mode <= (x_mode + 1);
					end
				end
			3:	begin
					if (x_count < 48-1)
						x_count <= (x_count+1);
					else begin
						x_count <= 0;
						x_mode <= (x_mode + 1);
						// note -- increment line counter here
						case (y_mode)
							0:	begin
									if (y_count < 480-1)
										y_count <= (y_count+1);
									else begin
										y_count <= 0;
										y_mode <= (y_mode + 1);
									end
								end
							1:	begin
									if (y_count < 10-1)
										y_count <= (y_count+1);
									else begin
										y_count <= 0;
										y_mode <= (y_mode + 1);
									end
								end
							2:	begin
									if (y_count < 2-1)
										y_count <= (y_count+1);
									else begin
										y_count <= 0;
										y_mode <= (y_mode + 1);
									end
								end
							3:	begin
									if (y_count < 33-1)
										y_count <= (y_count+1);
									else begin
										y_count <= 0;
										y_mode <= (y_mode + 1);
									end
								end
						endcase
					end
				end
		endcase
	end
end


endmodule

