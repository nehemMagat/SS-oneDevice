#include <Arduino.h>
#include "config.h"
#include "accelGyro.h"
#include "fingers.h"

accelSensor ACCEL;
FingerInstance pinkyFinger(PINKYPIN);
FingerInstance ringFinger(RINGPIN);
FingerInstance middleFinger(MIDDLEPIN);
FingerInstance indexFinger(INDEXPIN);
FingerInstance thumbFinger(THUMBPIN);

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    delay(10);
  };
  ACCEL.begin();
}

void loop() {
  Serial.print(pinkyFinger.read(), 5);
  Serial.print(" | ");
  Serial.print(ringFinger.read(), 5);
  Serial.print(" | ");
  Serial.print(middleFinger.read(), 5);
  Serial.print(" | ");
  Serial.print(indexFinger.read(), 5);
  Serial.print(" | ");
  Serial.println(thumbFinger.read(), 5);
  delay(10);
}