
const int Analog0 = A0;  
const int Analog1 = A1;  
const int Analog2 = A2; 
const int Analog3 = A3; 
 
const int analogOutPin = 9;

void setup() {
  Serial.begin(9600);
  
}


void loop() {

  int photoValue = analogRead(A0);
  int potentiometerValue = analogRead(A1);
  int bendValue = analogRead(A2);
  int potentiometer2Value = analogRead(A3);
  
//  int output = map(photoValue, 0, 1000, 0, 255);
 
  Serial.println(potentiometer2Value);

  delay(50);
}
