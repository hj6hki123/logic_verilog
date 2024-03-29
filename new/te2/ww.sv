//UTF-8 Encoding
module ww(seg_S,scan_key,touch_key,fin); //設定輸入輸出
  input  fin;//時鐘clock
  input [3:0] touch_key;//偵測 row 橫列
  output [2:0] scan_key;//掃描 colum 直行
  output [6:0] seg_S;//七段顯示器(a~g)


  //設定連線節點
  wire clk;//除頻時鐘

  //設定暫存器
  reg [2:0] scan_key;
  reg [15:0] count;
  reg [3:0] keycode;

  initial
  begin
    keycode <= 1'b0;
    count <= 1'b0;
  end




  task select_num;
    input [3:0] touch_key;
    input[3:0] num1,num2,num3,num4;
    ref logic  [3:0]keycoden ;

    begin
      case (touch_key)
        4'b1000:
          keycoden<=num1;
        4'b0100:
          keycoden<=num2;
        4'b0010:
          keycoden<=num3;
        4'b0001:
          keycoden<=num4;
      endcase
    end



  endtask



  function [6:0] dt_translate;//For Common anode {abcdefg}
    input[3:0]date;
    begin
      case (date)
        4'd0:
          dt_translate = 7'b0000001;     //number 0 -> 0x7e
        4'd1:
          dt_translate = 7'b1001111;     //number 1 -> 0x30
        4'd2:
          dt_translate = 7'b0010010;     //number 2 -> 0x6d
        4'd3:
          dt_translate = 7'b0000110;     //number 3 -> 0x79
        4'd4:
          dt_translate = 7'b1001100;     //number 4 -> 0x33
        4'd5:
          dt_translate = 7'b0100100;     //number 5 -> 0x5b
        4'd6:
          dt_translate = 7'b0100000;     //number 6 -> 0x5f
        4'd7:
          dt_translate = 7'b0001111;     //number 7 -> 0x70
        4'd8:
          dt_translate = 7'b0000000;     //number 8 -> 0x7f
        4'd9:
          dt_translate = 7'b0000100;      //number 9 -> 0x7b
        4'd10:
          dt_translate = 7'b1110010;      //number * -> spec
        4'd11:
          dt_translate = 7'b1100110;      //number # -> spec
        default dt_translate = 7'b1111111;
      endcase
    end
  endfunction


  always@(posedge fin)count <= count + 1'b1;
  assign clk = count[15];

  always@(posedge clk)
  begin
    case (scan_key)
      3'b100:
        scan_key<=3'b010;
      3'b010:
        scan_key<=3'b001;
      3'b001:
        scan_key<=3'b100;
      default scan_key<=3'b100;
    endcase
  end

  always@(negedge clk)
  begin

    if(scan_key== 3'b100)
      select_num(touch_key,1,4,7,10,keycode);
    else if(scan_key== 3'b010)
      select_num(touch_key,2,5,8,0,keycode);
    else if(scan_key== 3'b001)
      select_num(touch_key,3,6,9,11,keycode);

  end




  assign seg_S = dt_translate(keycode);



endmodule
