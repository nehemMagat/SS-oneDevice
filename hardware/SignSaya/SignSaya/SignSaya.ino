#include <Arduino.h>
#include "config.h"
#include "accelGyro.h"

accelSensor ACCEL;

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    delay(10);
  };
  ACCEL.begin();
}

void loop() {
ACCEL.printData();
  delay(10);
}