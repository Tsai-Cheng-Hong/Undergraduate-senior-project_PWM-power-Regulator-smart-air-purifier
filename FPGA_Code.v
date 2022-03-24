module ddpohjs(clk,c,reset,directopen,out,led,led2,led3,ct,h,m,min,hour,ok,am,bcd,sec,cnt,si,pwmc,pwm,pwmout,wifi,wifi1,quality,full);
input clk,reset,directopen,ct,h,m,ok,wifi,wifi1,quality; //輸入時脈跟按鈕還有開關 wifi K16 wifi1 L15: quakity h16;
output reg out,full;   //Pin:m11 
output reg [25:0] c=0; //除頻
output reg led=0,led2=0,led3=0;   //Pin:c10 and e10 and c11
output reg [5:0] min=0,hour=0,sec=0; //時分秒設定
output reg [3:0] am;	 //七段顯示器
output reg [7:0] bcd; //七段顯示器
output reg [15:0] pwmc,pwm;
output reg pwmout;
//鬧鐘的]定 begin
output reg [14:0] cnt; //音調W
output reg si;         //輸出Pin:d11 音調:si
reg [14:0] Q2;		
//鬧鐘的設定 end

// 承宏的專題 Tsai Cheng-Hong.

//主程式 begin
always@(posedge clk)
c=c+1;
always@(posedge c[25])  //c25的時候 每分鐘44秒 誤差為+1秒
begin
		if (reset || directopen==0 && ct==0 && wifi==0 && wifi1==0)  //重製電源跟關閉電源
			begin
			out=0; //電源關閉
			led=0; //綠燈關閉
			led2=0;//黃燈關閉
			led3=0;//紅燈關閉 
			min=0; //分
			hour=0;//時
			sec=0; //秒

			end

 	if (directopen==0 && ct==0)
		begin
			min=0; //分
			hour=0;//時
			sec=0; //秒
		end
		
	 if (wifi==1)
		begin
			out=1; //電源}啟
			led=1; //綠燈開啟
			led2=0;//黃O關閉
			led3=0;//紅燈關
		end
		
	if (wifi1==1)
		begin
			out=0; //電源}啟
			led=0; //綠燈開啟
			led2=0;//黃燈關閉
			led3=0;//紅燈關
		end
		
	if (wifi1==1 && directopen==1)
		begin
			out=0; //電源}啟
			led=0; //綠燈開啟
			led2=0;//黃燈關閉
			led3=0;//紅燈關
		end
		
 else if (directopen) //直接啟動
			begin
			out=1; //電源}啟
			led=1; //綠燈開啟
			led2=0;//黃燈關閉
			led3=0;//紅燈關
			end
 else if (ct)   //計時
			begin
				if (m)    //分
					begin
						if (min==59) 
							begin
							min=0; 	  	//分到59時歸零 
							led=0;		//設定時綠燈暗
							led2=1;    	//設定時黃燈亮
							led3=0;		//]定時紅燈暗
							out=0;		//設定時電源關閉
							end
						else
							begin
							min=min+1; 	//小於59時按按鈕分會+1分鐘
							led=0;		//設定時綠燈暗
							led2=1;	  	//設定時黃燈亮
							led3=0;		//設定時紅燈暗
							out=0;		//設定時電源關閉
							end
					end
		 else if (h)    //時
					begin
						if (hour==23)
							begin
							hour=0;	  	//時到23時歸s
							led=0;		//設定時綠燈暗
							led2=1;	  	//設定時黃燈亮
							led3=0;		//設定時紅燈暗
							out=0;		//設定時電源關閉
							end
						else
							begin
							hour=hour+1;//小23時按按鈕會+1小時
							led=0;		//設定時綠燈暗
							led2=1;		//設定時黃燈亮
							led3=0;		//設定時紅燈t
							out=0;		//設定時電源關閉
							end
					end
		 else if (ok)   //時間設定完成
					begin
					
						if (sec==1 && hour==0 && min==0)  //鬧鐘設定 只有在倒數1秒時叫
							begin
							cnt=19120;
							end
				 else 
							begin
							cnt=0;								 //其他時候不叫
							end
							
						if (min==0 && hour==0 && sec==0) //時分秒同為0的時候
							begin
							led=0;		//綠燈一直都是關閉
							led2=0;		//紅燈一直都是關閉
							led3=0;		//倒數完後紅燈關閉
							out=0;		//倒數q源
							min=0;		//分倒數完0
							hour=0;		//時倒數完後維持0
							sec=0;		//秒倒數完後維持0
							end
							

				 else if (sec==0 && min==0 && hour!=0)	//秒為0 分時不為0的時候
							begin
							sec=44;		//秒向分借位
							min=59;		//分向時借位
							hour=hour-1;//時因為借位-1
							led=0;		//綠燈一直都是關閉
							led2=0;		//黃燈一直都是關閉
							led3=1;		//倒數時紅燈O開啟的
							out=1;		//倒數時電源都是開啟的
							end
				else if (sec==0 && min!=0)	//秒為0 分不為0的時候
							begin
							sec=44;
							min=min-1;	//分向時借位
							hour=hour;  //時因為借位-1
							led=0;		//綠O@直都是關閉
							led2=0;		//黃燈一直都是關閉
							led3=1;		//倒數時紅燈都是開啟的
							out=1;		//倒數時q源都是開啟的
							end		
				 else
							begin
							sec=sec-1;	//秒的部分持續做下數
							led=0;		//綠燈一直都是關閉
							led2=0;		//黃燈一直都是關閉
							led3=1;		//倒數時紅燈都是開啟的
							out=1;		//倒數時電源都是開啟的
							end
						
					end
			end


end
//主程式 end

//pwm begin
always@(posedge clk)
	begin
	if (out==1)
		begin
		pwmc=pwmc+1;
			if (pwmc[15]==1)
				begin
				pwmc=0;
					if (pwmc<pwm)
						pwmout=1;
					else
						pwmout=0;
				end
		 if (reset)
full=0;
else	if (quality==1)
full=1;
else
full=0;
		 
		end
	end
	
always@(posedge pwmc[5])
	begin
		if (out==1)
			begin
			pwm=pwm+1;
				if (pwm[15]==1)
					pwm=0;
			end
	end
//pwm	end

/*always@(posedge clk)
begin
	if (reset)
	full=0;
else	if (quality==1)
		full=1;
	else
		full=0;
end
*/

//讓4個七段不同數字 begin
always@(c) 
begin
if(c[15]==0) am=4'b1110;
if(c[16]==0) am=4'b1101;
if(c[17]==0) am=4'b1011;
if(c[18]==0) am=4'b0111;
end
//讓4個七段不同數字 end

//七段的數字設定 begin
always@(c) 
begin
	if (am==4'b1110)
	begin
		if (min==0)  bcd=8'b00000011;
else	if (min==1)  bcd=8'b10011111; 
else	if (min==2)  bcd=8'b00100101; 
else	if (min==3)  bcd=8'b00001101; 
else	if (min==4)  bcd=8'b10011001; 
else	if (min==5)  bcd=8'b01001001; 
else	if (min==6)  bcd=8'b11000001; 
else	if (min==7)  bcd=8'b00011011; 
else	if (min==8)  bcd=8'b00000001; 
else	if (min==9)  bcd=8'b00001001; 

else	if (min==10)  bcd=8'b00000011;
else	if (min==11)  bcd=8'b10011111; 
else	if (min==12)  bcd=8'b00100101; 
else	if (min==13)  bcd=8'b00001101; 
else	if (min==14)  bcd=8'b10011001; 
else	if (min==15)  bcd=8'b01001001; 
else	if (min==16)  bcd=8'b11000001; 
else	if (min==17)  bcd=8'b00011011; 
else	if (min==18)  bcd=8'b00000001; 
else	if (min==19)  bcd=8'b00001001; 

else	if (min==20)  bcd=8'b00000011;
else	if (min==21)  bcd=8'b10011111; 
else	if (min==22)  bcd=8'b00100101; 
else	if (min==23)  bcd=8'b00001101; 
else	if (min==24)  bcd=8'b10011001; 
else	if (min==25)  bcd=8'b01001001; 
else	if (min==26)  bcd=8'b11000001; 
else	if (min==27)  bcd=8'b00011011; 
else	if (min==28)  bcd=8'b00000001; 
else	if (min==29)  bcd=8'b00001001; 

else	if (min==30)  bcd=8'b00000011;
else	if (min==31)  bcd=8'b10011111; 
else	if (min==32)  bcd=8'b00100101; 
else	if (min==33)  bcd=8'b00001101; 
else	if (min==34)  bcd=8'b10011001; 
else	if (min==35)  bcd=8'b01001001; 
else	if (min==36)  bcd=8'b11000001; 
else	if (min==37)  bcd=8'b00011011; 
else	if (min==38)  bcd=8'b00000001; 
else	if (min==39)  bcd=8'b00001001; 

else	if (min==40)  bcd=8'b00000011;
else	if (min==41)  bcd=8'b10011111; 
else	if (min==42)  bcd=8'b00100101; 
else	if (min==43)  bcd=8'b00001101; 
else	if (min==44)  bcd=8'b10011001; 
else	if (min==45)  bcd=8'b01001001; 
else	if (min==46)  bcd=8'b11000001; 
else	if (min==47)  bcd=8'b00011011; 
else	if (min==48)  bcd=8'b00000001; 
else	if (min==49)  bcd=8'b00001001; 

else	if (min==50)  bcd=8'b00000011;
else	if (min==51)  bcd=8'b10011111; 
else	if (min==52)  bcd=8'b00100101; 
else	if (min==53)  bcd=8'b00001101; 
else	if (min==54)  bcd=8'b10011001; 
else	if (min==55)  bcd=8'b01001001; 
else	if (min==56)  bcd=8'b11000001; 
else	if (min==57)  bcd=8'b00011011; 
else	if (min==58)  bcd=8'b00000001; 
else	if (min==59)  bcd=8'b00001001; 
else	if (min==60)  bcd=8'b00000011;
end

else if  (am==4'b1101)
begin
		if (min==0)  bcd=8'b00000011;
else	if (min==1)  bcd=8'b00000011;
else	if (min==2)  bcd=8'b00000011;
else	if (min==3)  bcd=8'b00000011;
else	if (min==4)  bcd=8'b00000011;
else	if (min==5)  bcd=8'b00000011;
else	if (min==6)  bcd=8'b00000011;
else	if (min==7)  bcd=8'b00000011;
else	if (min==8)  bcd=8'b00000011;
else	if (min==9)  bcd=8'b00000011;

else	if (min==10)  bcd=8'b10011111; 
else	if (min==11)  bcd=8'b10011111; 
else	if (min==12)  bcd=8'b10011111; 
else	if (min==13)  bcd=8'b10011111; 
else	if (min==14)  bcd=8'b10011111; 
else	if (min==15)  bcd=8'b10011111; 
else	if (min==16)  bcd=8'b10011111; 
else	if (min==17)  bcd=8'b10011111; 
else	if (min==18)  bcd=8'b10011111; 
else	if (min==19)  bcd=8'b10011111; 

else	if (min==20)  bcd=8'b00100101;
else	if (min==21)  bcd=8'b00100101;
else	if (min==22)  bcd=8'b00100101;
else	if (min==23)  bcd=8'b00100101;
else	if (min==24)  bcd=8'b00100101;
else	if (min==25)  bcd=8'b00100101;
else	if (min==26)  bcd=8'b00100101;
else	if (min==27)  bcd=8'b00100101;
else	if (min==28)  bcd=8'b00100101;
else	if (min==29)  bcd=8'b00100101; 

else	if (min==30)  bcd=8'b00001101;
else	if (min==31)  bcd=8'b00001101; 
else	if (min==32)  bcd=8'b00001101; 
else	if (min==33)  bcd=8'b00001101; 
else	if (min==34)  bcd=8'b00001101; 
else	if (min==35)  bcd=8'b00001101; 
else	if (min==36)  bcd=8'b00001101; 
else	if (min==37)  bcd=8'b00001101; 
else	if (min==38)  bcd=8'b00001101; 
else	if (min==39)  bcd=8'b00001101;
 
else	if (min==40)  bcd=8'b10011001; 
else	if (min==41)  bcd=8'b10011001; 
else	if (min==42)  bcd=8'b10011001;
else	if (min==43)  bcd=8'b10011001; 
else	if (min==44)  bcd=8'b10011001; 
else	if (min==45)  bcd=8'b10011001; 
else	if (min==46)  bcd=8'b10011001; 
else	if (min==47)  bcd=8'b10011001; 
else	if (min==48)  bcd=8'b10011001; 
else	if (min==49)  bcd=8'b10011001;

else	if (min==50)  bcd=8'b01001001; 
else	if (min==51)  bcd=8'b01001001; 
else	if (min==52)  bcd=8'b01001001; 
else	if (min==53)  bcd=8'b01001001; 
else	if (min==54)  bcd=8'b01001001; 
else	if (min==55)  bcd=8'b01001001; 
else	if (min==56)  bcd=8'b01001001; 
else	if (min==57)  bcd=8'b01001001; 
else	if (min==58)  bcd=8'b01001001; 
else	if (min==59)  bcd=8'b01001001;   
end
else	if (am==4'b1011)
	begin
		if (hour==0)  bcd=8'b00000011;
else	if (hour==1)  bcd=8'b10011111; 
else	if (hour==2)  bcd=8'b00100101; 
else	if (hour==3)  bcd=8'b00001101; 
else	if (hour==4)  bcd=8'b10011001; 
else	if (hour==5)  bcd=8'b01001001; 
else	if (hour==6)  bcd=8'b11000001; 
else	if (hour==7)  bcd=8'b00011011; 
else	if (hour==8)  bcd=8'b00000001; 
else	if (hour==9)  bcd=8'b00001001; 

else	if (hour==10)  bcd=8'b00000011;
else	if (hour==11)  bcd=8'b10011111; 
else	if (hour==12)  bcd=8'b00100101; 
else	if (hour==13)  bcd=8'b00001101; 
else	if (hour==14)  bcd=8'b10011001; 
else	if (hour==15)  bcd=8'b01001001; 
else	if (hour==16)  bcd=8'b11000001; 
else	if (hour==17)  bcd=8'b00011011; 
else	if (hour==18)  bcd=8'b00000001; 
else	if (hour==19)  bcd=8'b00001001; 

else	if (hour==20)  bcd=8'b00000011;
else	if (hour==21)  bcd=8'b10011111; 
else	if (hour==22)  bcd=8'b00100101; 
else	if (hour==23)  bcd=8'b00001101; 
else	if (hour==24)  bcd=8'b10011001; 

end

else if  (am==4'b0111)
begin
		if (hour==0)  bcd=8'b00000011;
else	if (hour==1)  bcd=8'b00000011;
else	if (hour==2)  bcd=8'b00000011;
else	if (hour==3)  bcd=8'b00000011;
else	if (hour==4)  bcd=8'b00000011;
else	if (hour==5)  bcd=8'b00000011;
else	if (hour==6)  bcd=8'b00000011;
else	if (hour==7)  bcd=8'b00000011;
else	if (hour==8)  bcd=8'b00000011;
else	if (hour==9)  bcd=8'b00000011;

else	if (hour==10)  bcd=8'b10011111; 
else	if (hour==11)  bcd=8'b10011111; 
else	if (hour==12)  bcd=8'b10011111; 
else	if (hour==13)  bcd=8'b10011111; 
else	if (hour==14)  bcd=8'b10011111; 
else	if (hour==15)  bcd=8'b10011111; 
else	if (hour==16)  bcd=8'b10011111; 
else	if (hour==17)  bcd=8'b10011111; 
else	if (hour==18)  bcd=8'b10011111; 
else	if (hour==19)  bcd=8'b10011111; 

else	if (hour==20)  bcd=8'b00100101;
else	if (hour==21)  bcd=8'b00100101;
else	if (hour==22)  bcd=8'b00100101;
else	if (hour==23)  bcd=8'b00100101;
else	if (hour==24)  bcd=8'b00100101;

end
end
//七段的數字設定end

//鬧鐘的聲音設定 begin
always@(posedge clk)
if (reset||Q2==cnt)
	Q2=0;
else
Q2=Q2+1;

always@(sec)
if (cnt==19120 ||  cnt==17036)
si=Q2[14];
else
si=Q2[13];
//鬧鐘的聲音設定 end

endmodule


