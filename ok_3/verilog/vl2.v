//3
module vl2 (rst, fin, P22,P20_sel,P5,P7,P19,P21,P8,P4,P6,qb,qa);
input rst, fin, P22 ;
input P20_sel,P5,P7,P19,P21;

output reg  P8,P4,P6 ;
output reg[3:0] qb;
output reg[1:0] qa;


reg[15:0] count ;
reg clk, P20_sel_d, OneHz_in_d, P5_d, P7_d, P21_d, clk_h; 
always @(posedge fin)begin 
	if (count >= 8000)begin
		count <= 0;
		clk <= clk^1;
	end
	else 
		count <= count+1;
end

always @(posedge clk)begin 
	 P20_sel_d  <= P20_sel;//切換功能(調時or計時)     
	 OneHz_in_d <= P22;    //           
	 P21_d      <= P21;                 
	 P7_d       <= P7;                  
	 P5_d       <= P5;                  
end
always @(*)begin 
	   if(P20_sel_d == 1)begin
			clk_h <= P19;//input hour clock                      
         P8    <= P7_d;//tell Module update Min-Reg
         P4    <= OneHz_in_d;//p4 led toggle
         P6    <= P7_d; //bridge p7 for clear  Sec-Reg  
		end else begin                          
         clk_h <= OneHz_in_d & P21_d;   
         P8    <= OneHz_in_d & P5_d ;
         P4    <= 0; //p4 close led 
         P6    <= 1;  //sending Module a sign to clear Sec-Reg     
		end
end
always @(negedge clk_h,posedge rst )begin 
	if(rst)begin
		qa <= 2'b0;qb <= 4'b0;
	end else begin
		if(qa>=2 && qb>=3)begin
			qa <= 2'b0;qb <= 4'b0;
		end else if(qb>=9) begin
			qa<=qa+1;qb<=4'b0;
		end else 
			qb<=qb+1;
	end
end

endmodule