module vd1 (clk,p3_rst,p2_CountSpeed,p4_ScanSpeed,bcdcode,scan);
input clk;
input p3_rst,p2_CountSpeed,p4_ScanSpeed;
output reg[3:0]bcdcode;
output reg[1:0]scan;

reg [1:0]shiftflag;
reg ENB_CountSpeed,ENB_ScanSpeed;
reg[3:0] code1,code10,code100,code1000;
always@(posedge clk)begin

	ENB_CountSpeed <=  p2_CountSpeed;
	ENB_ScanSpeed <= p4_ScanSpeed;

end

always@(posedge ENB_ScanSpeed)begin
	case(shiftflag)
	2'b00:begin
		scan <= 2'b00;
		bcdcode<= code1000;
		shiftflag <= shiftflag+1'b1;
	end
	2'b01:begin 
		scan <= 2'b01;
		bcdcode<= code100;
		shiftflag <= shiftflag+1'b1;

	end
	2'b10:begin
		scan <= 2'b10;
		bcdcode<= code10;
		shiftflag <= shiftflag+1'b1;

	end
	2'b11:begin 
		scan <= 2'b11;
		bcdcode<= code1;
		shiftflag <= 2'b00;
	end
	endcase

	

end
always@(posedge ENB_CountSpeed,posedge p3_rst)begin
if(p3_rst)begin
	code1 <= 0;
	code10 <= 0;
	code100 <= 0;
	code1000 <= 0;
end 

else 
	begin
	if(code1>=9)begin
	code1 <= 0;
	code10 <= code10+1'b1;
	if(code10>=9)begin
		code10 <= 0;
		code100 <= code100+1'b1;
		if(code100>=9)begin
			code100 <= 0;
			code1000 <= code1000+1'b1;
			if(code1000>=9)
				code100 <= 0;
			end
		end
	end
	
else
	code1 <= code1+1'b1;
end
end
endmodule


