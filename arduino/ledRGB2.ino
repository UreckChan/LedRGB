#include <SoftwareSerial.h>

SoftwareSerial bluetooth(2, 3); // RX, TX

int redPin = 9;
int greenPin = 10;
int bluePin = 11;

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  if (bluetooth.available()) {
    char command = bluetooth.read();
    if (command == 'R') {
      analogWrite(redPin, bluetooth.parseInt());
    } else if (command == 'G') {
      analogWrite(greenPin, bluetooth.parseInt());
    } else if (command == 'B') {
      analogWrite(bluePin, bluetooth.parseInt());
    } else if (command == 'F') {
      analogWrite(redPin, 0);
      analogWrite(greenPin, 0);
      analogWrite(bluePin, 0);
    }
  }
}
