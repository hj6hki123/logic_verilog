module vd2 (fin,enable,P13,P14,colum,scan,keycode,pulse_o1,pulse_o2,P1);
input fin,enable,P13,P14;
input[2:0] colum ;

output[3:0] scan; 
output[3:0] keycode;
output	pulse_o1, pulse_o2, P1; 

wire press_out;
reg clk, input_db;
reg [1:0] h2code;
reg [3:0]keycode;
reg [15:0] count;
reg [3:0]scan;

reg [3:0]register_shift = 4'b0000;


assign P1 = ~(P13 | P14);
assign press_out = (colum[2] | colum[1] | colum[0]);
assign pulse_o1 = register_shift[2];
assign pulse_o2 = register_shift[3];

always@(posedge fin)begin

if(count>=8000)begin
	clk <=clk^1'b1;
	count<=0;
end
else 
	count <= count + 1'b1;
end


always@(posedge clk)begin
	if(colum == 3'b000)begin
		if(h2code>=3)
			h2code <= 0;
		else
			h2code <= h2code+1'b1;
	end else if(colum == 3'b001)		//scan colum_input (first)
		keycode <=  {2'b00 , h2code}; 	//output BCD CODE {00,+1~3}
	else if(colum == 3'b010)		//scan colum_input (second)
		keycode <=  {2'b01 , h2code};	//output BCD CODE {01,+1~3} = b'0100 = d'4 +1~3
	else if(colum == 3'b100)		//scan colum_input (third)
		keycode <=  {2'b10 , h2code};	//output BCD CODE {10,+1~3} = b'1000 = d'8 +1~3
end

always@(h2code)begin
	case(h2code)          
      2'b00 : scan <= 4'b0001; //shifting scan row from 1 to 4
      2'b01 : scan <= 4'b0010;
      2'b10 : scan <= 4'b0100;
      2'b11 : scan <= 4'b1000;
	endcase
end
always @(negedge clk) input_db<= press_out;
always @(posedge clk,posedge input_db)begin
if(input_db)
	register_shift <= 4'b0001;
else
	register_shift <= {register_shift[2:0],1'b0};

end

	
endmodule 
