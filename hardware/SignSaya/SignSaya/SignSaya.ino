#include <Arduino.h>
#include "config.h"
#include "accelGyro.h"
#include "fingers.h"

accelSensor ACCEL;

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    delay(10);
  };
  ACCEL.begin();
  FingerInstance pinkyFinger(PINKYPIN);
  FingerInstance ringFinger(RINGPIN);
  FingerInstance middleFinger(MIDDLEPIN);
  FingerInstance indexFinger(INDEXPIN);
  FingerInstance thumbFinger(THUMBPIN);
}

void loop() {
  ACCEL.printData();

  delay(10);
}