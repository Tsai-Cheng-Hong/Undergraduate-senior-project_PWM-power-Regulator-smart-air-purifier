#include <SoftwareSerial.h>
#include "Wire.h"
#include "LiquidCrystal_I2C.h"
int incomeByte[7];
int data;
int z=0;
int sum;
int gasSensor = 2; // 指定要量測的analog腳位為2
int gasval = 0;
unsigned long error;




SoftwareSerial mySerial(10, 11); // RX, TX
LiquidCrystal_I2C lcd(0x27,2,1,0,4,5,6,7,3,POSITIVE);

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(38400);
  // set the data rate for the SoftwareSerial port
  mySerial.begin(2400);
  Serial.begin(9600);
  
  lcd.begin(16,2);
  lcd.backlight();
  delay(2000);
  lcd.noBacklight();
  delay(2000);
  lcd.backlight();
  delay(1000);

pinMode (7, OUTPUT);
digitalWrite(7, LOW);
}

void loop() { // run over and over



  
  while (mySerial.available()){
 
    data=mySerial.read();
    if(data == 170){
      z=0;
      incomeByte[z]=data;
    }
    else{
      z++;
      incomeByte[z]=data;
    } 
    if(z==6)
    {
      sum=incomeByte[1]+ incomeByte[2]+ incomeByte[3] + incomeByte[4];
 
      if(incomeByte[5]==sum && incomeByte[6]==255 )
      {
 
        // Serial.print("Data OK! |");
        for(int k=0;k<7;k++)
        {
          Serial.print(incomeByte[k]);
          Serial.print("|");
        } 
 
        Serial.print(" Vo=");
        float vo=(incomeByte[1]*256.0+incomeByte[2])/1024.0*5.00;
        Serial.print(vo,3);
        Serial.print("v | ");
        float c=vo*700;
        // 這裡我修改過咯，2014年11月23日，v1.1
        // 普通Arduinio玩家也可以算出濃度啦！
        // 當然更精準的還需要自行標定哦：)  
        Serial.print(" PM2.5 = ");
        Serial.print(c,2);
        Serial.print("ug/m3 ");
        Serial.println();
        gasval = analogRead(gasSensor);
        Serial.println( gasval );
        lcd.setCursor(0,0);
        lcd.print( "PM2.5=");
        lcd.setCursor(6,0);
        lcd.print(c);
        lcd.setCursor(11,0);
        lcd.print("ug/m3 ");
        lcd.setCursor(0,1);
        lcd.print("VOC = ");
        lcd.setCursor(6,1);
        lcd.print(gasval);

        if (c <=15.4)
        {
        lcd.setCursor(10,1);
        lcd.print("Nice.");
        }
        else if (c <= 35.4)
        {
        lcd.setCursor(10,1);
        lcd.print("good.");  
        }
        else if (c <=54.4)
        {
        lcd.setCursor(10,1);
        lcd.print(".bad.");
        }
        else if (c <=150.4)
        {
        lcd.setCursor(10,1);
        lcd.print("worse");         
        }
        else if (c >150.4)
        {
        lcd.setCursor(10,1);
        lcd.print("worst");         
        }

        if (c>=35.4)
        {
          digitalWrite(7, HIGH);
        }
        else
        {
          digitalWrite(7, LOW);
        }
        
      }
      else{
        z=0;
        mySerial.flush();
        data='/0';
        for(int m=0;m<7;m++){
          incomeByte[m]=0;
        }
        /* 
         error++;
         Serial.print(" ### This is ");
         Serial.print(error);
         Serial.println(" Error ###");
         */
      }
      z=0;
       delay(1000);
    }
  }

  
}