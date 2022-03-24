/*
 *  This sketch demonstrates how to set up a simple HTTP-like server.
 *  The server will set a GPIO pin depending on the request
 *    http://server_ip/gpio/0 will set the GPIO2 low,
 *    http://server_ip/gpio/1 will set the GPIO2 high
 *  server_ip is the IP address of the ESP8266 module, will be 
 *  printed to Serial when the module is connected.
 */

#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>

const char* ssid = "EE";             //輸入WIFI名稱
const char* password = "12345678";     //輸入WIFI密碼

WiFiServer server(80);      //  開啟此板子的PORT 80


int incomeByte[7];
int data;
int z=0;
int sum;
int xo;
unsigned long error;
SoftwareSerial mySerial(5, 11); // RX, TX

void setup() {
  Serial.begin(115200);     // 速度為115200
  delay(10);

  Serial.begin(38400);
  mySerial.begin(2400);
  
  pinMode(2, OUTPUT);       //腳位2為輸出 板子上為D4
  digitalWrite(2, 0);       //腳位2為低電位
  pinMode(13, OUTPUT);       //腳位2為輸出 板子上為D1
  digitalWrite(13, 0);       //腳位2為低電位

  
  // WIFI連線作業
  Serial.println();   //印空格
  Serial.println();   //印空格
  Serial.print("Connecting to ");  //印出連線到WIFI
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);      //使用WIFI和密碼開始連線
  
  while (WiFi.status() != WL_CONNECTED) {   //此為無窮迴圈 未連線時一直跳出...
    delay(500);
    Serial.print(".");
  }
  Serial.println("");   //連線成功後會跳出連線成功
  Serial.println("WiFi connected");
  
  // 伺服器啟動
  server.begin();
  Serial.println("Server started"); 

  // 列印出此伺服器分配到的IP
  Serial.println(WiFi.localIP());
}

void loop() {

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

       xo = c;
       
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
    }
  }     

 
  // 確認是否連線中，不是的話跳出迴圈
  WiFiClient client = server.available();
  if (!client) {
    return;
  }
  
  // 等待傳到這個伺服器的訊息，一直等一直等
  Serial.println("new client");
  while(!client.available()){
    delay(1);
  }
  
  // 收到傳過來的訊息後，將收到的訊息存成req
  String req = client.readStringUntil('\r');
  Serial.println(req);  //印出收到的訊息
  client.flush();
  
  // 開始比對收到的訊息來決定做什麼事情
  int val; int a; int b; 
  if (req.indexOf("/gpio/0") != -1)   //如果收到gpio/0
    val = 0;  
  else if (req.indexOf("/gpio/1") != -1)  //如果收到gpio/1
    val = 1;  
  else if (req.indexOf("/gpio/5") != -1)  //如果收到gpio/1
    val = val;   
  else {                                   //如果收到其他
    Serial.println("invalid request");
    client.stop();
    return;
  }

if (req.indexOf("/gpio/0") != -1)   //如果收到gpio/0
    a = 1;  
  else if (req.indexOf("/gpio/1") != -1)  //如果收到gpio/1
    a = 0; 
  else if (req.indexOf("/gpio/5") != -1)  //如果收到gpio/1
    a = a;     
  else {                                   //如果收到其他
    Serial.println("invalid request");
    client.stop();
    return;
  }

if (req.indexOf("/gpio/0") != -1)   //如果收到gpio/0
   b = 0;  
else if (req.indexOf("/gpio/1") != -1)  //如果收到gpio/1
    b = 0;  
else if (req.indexOf("/gpio/5") != -1)  //如果收到gpio/1
    b = 1;         
  else {                                   //如果收到其他
    Serial.println("invalid request");
    client.stop();
    return;
  }

  
  // Set GPIO2 according to the request
  digitalWrite(2, val);     //依照收到的訊息改變燈的亮暗
  digitalWrite(13, a);

  client.flush();


  
  // 準備發給收訊者的回應，內容是html的格式，代表收訊者會收到簡單的網頁
  String s = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\nPM2.5 is ";
  s += xo;  
  s += "ug/m3 now ";  
  s += "</html>\n";



  // 準備好發給收訊者
  client.print(s);
  delay(1);
  Serial.println("Client disonnected");


if (b>0){
 digitalWrite(2, LOW);     //依照收到的訊息改變燈的亮暗
 digitalWrite(13,LOW);
}
    //sensor  

}