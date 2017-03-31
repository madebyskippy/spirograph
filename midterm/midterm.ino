#include <CapacitiveSensor.h>
/* all inputs
 * 3 photoR
 * 2 potentiometers
 * 1 capacitor
 * 1 bend sensor 
 * 
 */
//for debugging:
boolean isPrint = false;
boolean isWrite = true;
 
CapacitiveSensor   cs_4_2 = CapacitiveSensor(4,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin,
int photoPins[3] = {A0,A1,A2};
int bendPin = A3;
int potenPins[2] = {A5,A5};

//the values its reading in
int photoresistors[3];
int bend;
int potentiometers[2];
int capacitor;

void setup() {
  // put your setup code here, to run once:
  
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  photoresistors[0] = analogRead(photoPins[0]);
  photoresistors[1] = analogRead(photoPins[1]);
  photoresistors[2] = analogRead(photoPins[2]);
  bend = analogRead(bendPin);
  potentiometers[0] = analogRead(potenPins[0]);
//  potentiometers[1] = analogRead(potenPins[1]);
  capacitor = cs_4_2.capacitiveSensor(30);
  if (isPrint){
    Serial.print(photoresistors[0]);
    Serial.print("\t");
    Serial.print(photoresistors[1]);
    Serial.print("\t");
    Serial.print(photoresistors[2]);
    Serial.print("\t");
    Serial.print("bend: ");
    Serial.print(bend);
    Serial.print("\t");
    Serial.print(potentiometers[0]);
  //  Serial.print("\t");
  //  Serial.print(potentiometers[1]);
    Serial.print("\t");
    Serial.println(capacitor);
  }
  if (isWrite){
    //for capacitor, ones place is a 0
    if (capacitor > 2000){
      Serial.write(10);
    }else{
      Serial.write(20);
    }

    int val;
    //these two are the speeds of the first two circles
    //for potentiometer, ones place is a 1
    val = map(potentiometers[0],0,1000,0,10);
    val = val*10+1;
    Serial.write(val);

    //for bend, ones place is a 2
    val = map(bend,100,1000,0,10);
    val = val*10+2;
    Serial.write(val);

    //photoresistors are radius
    //for photoR 1, ones place is a 3
    val = map(photoresistors[0],600,800,0,10);
    val = val*10+3;
    Serial.write(val);
    
    //for photoR 1, ones place is a 4
    val = map(photoresistors[1],600,800,0,10);
    val = val*10+4;
    Serial.write(val);
    
    //for photoR 1, ones place is a 5
    val = map(photoresistors[2],300,800,0,10);
    val = val*10+5;
    Serial.write(val);
  }
  delay(100);
}
