#include <HX711.h>
//#include "HX711.h"

// HX711 DT and SCK pins
const int HX711_DOUT = 23;
const int HX711_SCK = 22;

// Create an instance of the HX711 class
HX711 hx711;

const int interruptPin = 36;

long minADCValue = 999999999;
long maxADCValue = 0;

bool calibrateMode = 0;


void interruptFunc() {
  calibrateMode = !digitalRead(interruptPin);
}

void setup() {
  // Begin serial communication with a baud rate of 115200
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin), interruptFunc, LOW);

  Serial.begin(115200);
  // Begin the HX711
  hx711.begin(HX711_DOUT, HX711_SCK);
  // Set the scale factor and tare the scale
  // The value for set_scale will need to be adjusted based on calibration
  hx711.set_scale();
  hx711.tare();
}

void calibrationFunc() {
  if (calibrateMode) {
    Serial.println("CALIBRATION MODE STARTED");
    minADCValue = 999999999;
    maxADCValue = 0;
    while (calibrateMode) {
      long strain = hx711.read();
      Serial.print("Reading: ");
      Serial.print(strain);
      Serial.print("  | ");
      minADCValue = min(minADCValue, strain);
      maxADCValue = max(maxADCValue, strain);
      Serial.print(minADCValue);
      Serial.print("  | ");
      Serial.println(maxADCValue);
    }
    Serial.println("CALIBRATION MODE ENDED");
  } else {
    return;
  }
}

void loop() {
  // Check if HX711 is ready to read
  if (hx711.is_ready()) {
    // Read the difference in strain
    long strain = map(hx711.read(), minADCValue, maxADCValue, 0, 1024);
    // Print the strain to the serial monitor
    Serial.print("Strain: ");
    Serial.println(strain);
    calibrationFunc();
  } else {
    // Error message if HX711 is not ready
    Serial.println("HX711 not ready");
  }
  // Wait for 100 milliseconds before reading again
  delay(100);
}
