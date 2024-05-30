#include <SoftwareSerial.h>

SoftwareSerial bluetooth(2, 3); // RX, TX

int ledPinR = 9; // Pin para el LED rojo
int ledPinG = 10; // Pin para el LED verde
int ledPinB = 11; // Pin para el LED azul

void setup() {
  // Inicializar el puerto serial para la comunicación con Bluetooth
  bluetooth.begin(9600);

  // Configurar los pines de salida para los LEDs
  pinMode(ledPinR, OUTPUT);
  pinMode(ledPinG, OUTPUT);
  pinMode(ledPinB, OUTPUT);
}

void loop() {
  // Esperar a que lleguen datos por Bluetooth
  if (bluetooth.available() >= 3) {
    // Leer los valores de intensidad de los colores rojo, verde y azul
    int redValue = bluetooth.read();
    int greenValue = bluetooth.read();
    int blueValue = bluetooth.read();

    // Ajustar la intensidad de los LEDs RGB
    analogWrite(ledPinR, redValue);
    analogWrite(ledPinG, greenValue);
    analogWrite(ledPinB, blueValue);
  }
}
