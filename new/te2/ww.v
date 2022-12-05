module ww(seg_S,rst,scan_key,touch_key,fin);
input  fin;
input rst;
input [3:0] touch_key;
output reg [2:0] scan_key;
output [6:0] seg_S;



wire touchment;
wire clk;
reg [15:0] count;
reg [3:0] keycode;
reg [3:0]shiftflag;



always@(posedge fin)count <= count + 1'b1;

function [6:0] dt_translate;// translate number for seg
	input[3:0]date;
	begin
	case (date)
		4'd0: dt_translate = 7'b1000000;     //number 0 -> 0x7e
		4'd1: dt_translate = 7'b1111001;     //number 1 -> 0x30
		4'd2: dt_translate = 7'b0100100;     //number 2 -> 0x6d
		4'd3: dt_translate = 7'b0110000;     //number 3 -> 0x79
		4'd4: dt_translate = 7'b0011001;     //number 4 -> 0x33
		4'd5: dt_translate = 7'b0010010;     //number 5 -> 0x5b
		4'd6: dt_translate = 7'b0000011;     //number 6 -> 0x5f
		4'd7: dt_translate = 7'b1111000;     //number 7 -> 0x70
		4'd8: dt_translate = 7'b0000000;     //number 8 -> 0x7f
		4'd9: dt_translate = 7'b0010000;      //number 9 -> 0x7b
		
		4'd10: dt_translate = 7'b0100111;      //number * -> spec
		4'd11: dt_translate = 7'b0110011;      //number # -> spec
		default dt_translate = 7'b1111111;    
	endcase
	end
endfunction

always@(posedge clk)begin
	case (scan_key)
		3'b100:scan_key<=3'b010;  
		3'b010:scan_key<=3'b001;  
		3'b001:scan_key<=3'b100;  
		default scan_key<=3'b100;  
	endcase
end

always@(negedge clk)begin
	
	if(scan_key== 3'b100)
				case (touch_key)
					4'b1000:keycode<=4'd1;  
					4'b0100:keycode<=4'd4;  
					4'b0010:keycode<=4'd7;  
					4'b0001:keycode<=4'd10;  
				endcase
	else if(scan_key== 3'b010)
				case (touch_key)
					4'b1000:keycode<=4'd2;  
					4'b0100:keycode<=4'd5;  
					4'b0010:keycode<=4'd8;  
					4'b0001:keycode<=4'd0;  
				endcase
	else if(scan_key== 3'b001)
				case (touch_key)
					4'b1000:keycode<=4'd3;  
					4'b0100:keycode<=4'd6;  
					4'b0010:keycode<=4'd9;  
					4'b0001:keycode<=4'd11;  
				endcase	
	
end




assign seg_S = dt_translate(keycode);
assign clk = count[15];


endmodule