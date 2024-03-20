#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

#define GYRO_SENSITIVITY 16.4  // Sensitivity of gyroscope in LSB/(deg/s)


// Filter constants
#define ALPHA 0.98  // Weight for gyroscope data
#define BETA 0.02   // Weight for accelerometer data

// Variables to store filtered orientation
float roll, pitch, yaw;

// Variables to store previous orientation
float prevRoll = 0, prevPitch = 0, prevYaw = 0;

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

  void begin(const int SDA_PIN, const int SCL_PIN) {
    //if (!isWireBegun) {
    Wire.begin(SDA_PIN, SCL_PIN);
    //} else {
    //  Serial.println("Wire has been initiated, Skipping step.");
    //}
    Serial.println("Finding MPU6050");
    if (!mpu.begin()) {
      Serial.println("Failed to find MPU6050 chip");
      while (1) {
        delay(10);
      }
    }
    mpu.setAccelerometerRange(MPU6050_RANGE_2_G);
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
    mpu.setGyroRange(MPU6050_RANGE_250_DEG);
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
    Serial.print("Accel: ");
    Serial.print(a.acceleration.x);
    Serial.print(", ");
    Serial.print(a.acceleration.y);
    Serial.print(", ");
    Serial.print(a.acceleration.z);
    Serial.print("  || Gyro: ");
    Serial.print(a.gyro.x);
    Serial.print(", ");
    Serial.print(a.gyro.y);
    Serial.print(", ");
    Serial.print(a.gyro.z);
    Serial.print("  || Chip Temperature: ");
    Serial.println(temp.temperature);
  }

  void tryData() {
    float* data = update();
    float accelData[3] = { data[0], data[1], data[2] };
    float gyroData[3] = { data[3], data[4], data[5] };
    float dt = 0.01;  // Adjust this value according to your sampling rate

    complementaryFilter(accelData, gyroData, dt);

    Serial.print("Roll: ");
    Serial.print(roll);
    Serial.print("\tPitch: ");
    Serial.print(pitch);
    Serial.print("\tYaw: ");
    Serial.println(yaw);

    delay(10);  // Adjust delay as needed
  }
  // Function to apply complementary filter
  void complementaryFilter(float* accelData, float* gyroData, float dt) {
    // Calculate roll and pitch angles from accelerometer data
    float accRoll = atan2(accelData[1], accelData[2]) * RAD_TO_DEG;
    float accPitch = atan2(-accelData[0], sqrt(accelData[1] * accelData[1] + accelData[2] * accelData[2])) * RAD_TO_DEG;

    // Calculate roll and pitch angles from gyroscope data
    float gyroRoll = prevRoll + gyroData[0] / GYRO_SENSITIVITY * dt;
    float gyroPitch = prevPitch + gyroData[1] / GYRO_SENSITIVITY * dt;
    float gyroYaw = prevYaw + gyroData[2] / GYRO_SENSITIVITY * dt;

    // Apply complementary filter to combine accelerometer and gyroscope data
    roll = ALPHA * gyroRoll + BETA * accRoll;
    pitch = ALPHA * gyroPitch + BETA * accPitch;
    yaw = gyroYaw;  // Yaw estimation from gyroscope only (without magnetometer)

    // Update previous orientation values
    prevRoll = roll;
    prevPitch = pitch;
    prevYaw = yaw;
  }
};