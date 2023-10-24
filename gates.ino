const int BUT1PIN = 2;
const int BUT2PIN = 3;
const int BUT3PIN = 4;
const int BUT4PIN = 5;
const int BUT5PIN = 6;
const int BUT6PIN = 7;
const int LED1 = 8;
const int LED2 = 9;
const int LED3 = 10;
const int LED4 = 11;
#define FADESPEED 5

void setup() {
  // put your setup code here, to run once:
  pinMode(BUT1PIN,INPUT);
  pinMode(BUT2PIN,INPUT);
  pinMode(BUT3PIN,INPUT);
  pinMode(BUT4PIN,INPUT);
  pinMode(BUT5PIN,INPUT);
  pinMode(BUT6PIN,INPUT);
  pinMode(LED1,OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // digitalWrite(BUT7PIN, HIGH);
  // int r;
  // for (r = 0; r < 256; r++) { 
  //   digitalWrite(LED, r);
  //   delay(FADESPEED);
  // } 
  // put your main code here, to run repeatedly:
  if(digitalRead(BUT1PIN) == HIGH || digitalRead(BUT2PIN) == HIGH
  ||digitalRead(BUT3PIN) == HIGH||digitalRead(BUT4PIN) == HIGH
  ||digitalRead(BUT5PIN) == HIGH) {
    digitalWrite(LED1, HIGH);
    digitalWrite(LED3, HIGH);
    digitalWrite(LED2, LOW);
    digitalWrite(LED4, LOW);
  }
  else {
    digitalWrite(LED2, HIGH);
    digitalWrite(LED4, HIGH);
    digitalWrite(LED1, LOW);
    digitalWrite(LED3, LOW);
  }
  
  if(digitalRead(BUT1PIN) == HIGH) Serial.println("1");
  else if(digitalRead(BUT2PIN) == HIGH) Serial.println("2");
  else if(digitalRead(BUT3PIN) == HIGH) Serial.println("3");
  else if(digitalRead(BUT4PIN) == HIGH) Serial.println("4");
  else if(digitalRead(BUT5PIN) == HIGH) Serial.println("5");
  else if(digitalRead(BUT6PIN) == HIGH) Serial.println("6");
  else Serial.println("0");
  delay(100);
}
