/*---------------------------------------------------------
CHIP I/O(pin1 - pin8) 1-8        |     segment a-dot      |
-------------------------------- |------------------------|
CHIP I/O(pin11 - pin14) 9-12     |     segment com1-com4  |
---------------------------------|------------------------|
CHIP I/O(pin61)                  |     RESET              |
----------------------------------------------------------*/

module sevenseg(clk,seg_S,com_s,rst);

  parameter  COUNT_1hz=50000000;
  parameter  COUNT_10hz=5000000;
  parameter  COUNT_100hz=500000;
  parameter  COUNT_1000hz=50000;


  input rst;
  input clk;
  output reg [7:0]seg_S ;
  output reg [3:0]com_s;


  reg freq_1000HZ=0;
  reg freq_10HZ=0;
  reg [3:0]shiftflag=4'b0001;
  //reg [15:0]timeCNT=16'd0;

  integer count=0;
  integer count1=0;


  reg[3:0]NUM1=4'd0;
  reg[3:0]NUM2=4'd0;
  reg[3:0]NUM3=4'd0;
  reg[3:0]NUM4=4'd0;



  function [7:0] dt_translate;// �C�q½Ķ�禡 translate number for seg
    input[3:0]date;
    begin
      case (date)
        4'd0:
          dt_translate = 8'b11000000;     //number 0 -> 0x7e
        4'd1:
          dt_translate = 8'b11111001;     //number 1 -> 0x30
        4'd2:
          dt_translate = 8'b10100100;     //number 2 -> 0x6d
        4'd3:
          dt_translate = 8'b10110000;     //number 3 -> 0x79
        4'd4:
          dt_translate = 8'b10011001;     //number 4 -> 0x33
        4'd5:
          dt_translate = 8'b10010010;     //number 5 -> 0x5b
        4'd6:
          dt_translate = 8'b10000011;     //number 6 -> 0x5f
        4'd7:
          dt_translate = 8'b11111000;     //number 7 -> 0x70
        4'd8:
          dt_translate = 8'b10000000;     //number 8 -> 0x7f
        4'd9:
          dt_translate = 8'b10010000;      //number 9 -> 0x7b
        default dt_translate = 8'b11111011;
      endcase
    end



  endfunction


  always @(posedge clk )
  begin  //���W Frequency division  original:100mHZ After:1000HZ

    if(count>=COUNT_1000hz)
    begin
      count=0;
      freq_1000HZ=freq_1000HZ ^1;
    end
    else
      count=count+1;
    ////////////////////////////////
    if(count1>=COUNT_10hz)
    begin
      count1=0;
      freq_10HZ=freq_10HZ ^1;
    end
    else
      count1=count1+1;




  end



  always @(posedge freq_1000HZ )
  begin// �C�q���y correspond scan state

    shiftflag<=shiftflag<<1;
    case (shiftflag)
      4'b0001:
      begin
        com_s<=4'b0111;
        seg_S<=dt_translate(NUM1);
      end

      4'b0010:
      begin
        com_s<=4'b1011;
        seg_S<=dt_translate(NUM2);
      end

      4'b0100:
      begin
        com_s<=4'b1101;
        seg_S<=dt_translate(NUM3);
      end

      4'b1000:
      begin
        com_s<=4'b1110;
        shiftflag<=4'b0001;
        seg_S<=dt_translate(NUM4);
      end

    endcase



  end


  always @(posedge freq_10HZ ,negedge rst)
  begin//�p�ƾ� 7seg counting 10hz
    /*timeCNT<=timeCNT+1;
    if(timeCNT>=16'd9999)timeCNT<=16'd0;;
     
     
     
    NUM1<=timeCNT/1000;
    NUM2<=(timeCNT%1000)/100;
    NUM3<=(timeCNT%100)/10;
    NUM4<=(timeCNT)%10;
     
    */


    if(rst==0)
    begin
      NUM1=0;
      NUM2=0;
      NUM3=0;
      NUM4=0;
    end
    else
    begin



      if(NUM4>9)   //���Logic Elements����
      begin
        NUM4=0;
        NUM3=NUM3+1;
        if(NUM3>9)
        begin
          NUM3=0;
          NUM2=NUM2+1;
          if(NUM2>9)
          begin
            NUM2=0;
            NUM1=NUM1+1;
            if(NUM1>9)
            begin
              NUM1=0;
              NUM2=0;
              NUM3=0;
            end
          end
        end
      end
      else
        NUM4=NUM4+1;

    end

  end



endmodule

