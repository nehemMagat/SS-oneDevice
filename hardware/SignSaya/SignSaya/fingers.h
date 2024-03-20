class FingerInstance {
private:
  float fingerArray[arrayLength] = {0};
  float minInputValue = 0;
  float maxInputValue = 4095;
  uint8_t pinNumber;
  bool calibrationStarted = false;
  float prevMinInputValue = minInputValue;
  float prevMaxInputValue = maxInputValue;
  bool arrayCalibrated = true;
  float currentValue = 0;

  float mapRead() {
    return map(analogRead(pinNumber), minInputValue, maxInputValue, 0, maxFingerValue);
  }

  float movingAverage(float newEntry) {
    if (!arrayCalibrated) {
      for (int index = arrayLength - 1; index > 0; index--) {
        fingerArray[index] = map(fingerArray[index], prevMinInputValue, prevMaxInputValue, minInputValue, maxInputValue);
      }
      arrayCalibrated = true;
    }

    float total = newEntry;
    for (int index = arrayLength - 1; index > 0; index--) {
      fingerArray[index] = fingerArray[index - 1];  // Shift values in the array
      total += fingerArray[index];
    }
    fingerArray[arrayLength-1] = newEntry;
    return total / arrayLength;
  }

public:
  FingerInstance(uint8_t fingerPin) : pinNumber(fingerPin) {
    pinMode(pinNumber, INPUT);
  }

  int read() {
    currentValue = mapRead();
    return movingAverage(currentValue);
  }

  int rawRead(){
    return analogRead(pinNumber);
  }

  void calibrate() {
    if (!calibrationStarted) {
      prevMaxInputValue = maxInputValue;
      prevMinInputValue = minInputValue;
      minInputValue = 99999999999;
      maxInputValue = 0;
      calibrationStarted = true;
      arrayCalibrated = false;
    }
    float currentSensorValue = analogRead(pinNumber);
    minInputValue = min(minInputValue, currentSensorValue);
    maxInputValue = max(maxInputValue, currentSensorValue);
  }
};
