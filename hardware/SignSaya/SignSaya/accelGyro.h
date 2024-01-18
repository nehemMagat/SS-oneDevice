#include <iterator>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

class accelSensor {
private:
  Adafruit_MPU6050 mpu;
  sensors_event_t a, g, temp;

  void updateSensor() {
    mpu.getEvent(&a, &g, &temp);
  }

public:
  float sensorValues[7] = {};

  accelSensor() {
  }

  void begin() {
    //if (!isWireBegun) {
    Wire.begin(I2C_SDA_PIN, I2C_SCL_PIN);
    //} else {
    //  Serial.println("Wire has been initiated, Skipping step.");
    //}
    if (!mpu.begin()) {
      Serial.println("Failed to find MPU6050 chip");
      while (1) {
        delay(10);
      }
    }
    mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
    Serial.print("Accelerometer range set to: ");
    switch (mpu.getAccelerometerRange()) {
      case MPU6050_RANGE_2_G:
        Serial.println("+-2G");
        break;
      case MPU6050_RANGE_4_G:
        Serial.println("+-4G");
        break;
      case MPU6050_RANGE_8_G:
        Serial.println("+-8G");
        break;
      case MPU6050_RANGE_16_G:
        Serial.println("+-16G");
        break;
    }
    mpu.setGyroRange(MPU6050_RANGE_500_DEG);
    Serial.print("Gyro range set to: ");
    switch (mpu.getGyroRange()) {
      case MPU6050_RANGE_250_DEG:
        Serial.println("+- 250 deg/s");
        break;
      case MPU6050_RANGE_500_DEG:
        Serial.println("+- 500 deg/s");
        break;
      case MPU6050_RANGE_1000_DEG:
        Serial.println("+- 1000 deg/s");
        break;
      case MPU6050_RANGE_2000_DEG:
        Serial.println("+- 2000 deg/s");
        break;
    }

    mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
    Serial.print("Filter bandwidth set to: ");
    switch (mpu.getFilterBandwidth()) {
      case MPU6050_BAND_260_HZ:
        Serial.println("260 Hz");
        break;
      case MPU6050_BAND_184_HZ:
        Serial.println("184 Hz");
        break;
      case MPU6050_BAND_94_HZ:
        Serial.println("94 Hz");
        break;
      case MPU6050_BAND_44_HZ:
        Serial.println("44 Hz");
        break;
      case MPU6050_BAND_21_HZ:
        Serial.println("21 Hz");
        break;
      case MPU6050_BAND_10_HZ:
        Serial.println("10 Hz");
        break;
      case MPU6050_BAND_5_HZ:
        Serial.println("5 Hz");
        break;
    }
    Serial.println("");
    delay(100);
  }

  float* update() {
    updateSensor();
    sensorValues[0] = a.acceleration.x;
    sensorValues[1] = a.acceleration.y;
    sensorValues[2] = a.acceleration.z;
    sensorValues[3] = a.gyro.x;
    sensorValues[4] = a.gyro.y;
    sensorValues[5] = a.gyro.z;
    sensorValues[6] = temp.temperature;

    return sensorValues;
  }

  void printData() {
    updateSensor();
    Serial.print("Accel X: ");
    Serial.print(a.acceleration.x);
    Serial.print("  | Accel Y: ");
    Serial.print(a.acceleration.y);
    Serial.print("  | Accel Z: ");
    Serial.print(a.acceleration.z);
    Serial.print("  || Gyro X: ");
    Serial.print(a.gyro.x);
    Serial.print("  | Gyro Y: ");
    Serial.print(a.gyro.y);
    Serial.print("  | Gyro Z: ");
    Serial.print(a.gyro.z);
    Serial.print("  || Chip Temperature: ");
    Serial.println(temp.temperature);
  }
};