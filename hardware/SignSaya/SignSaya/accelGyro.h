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
  uint32_t lastRun = xTaskGetTickCount();
  angleData_t result;
  Adafruit_MPU6050 mpu;
  sensors_event_t a, g, temp;
  float angleX, angleY;
  const float filterCoefficient = 0.98;  // Weight between 0 and 1
  const float degreeValue = 180.0 / M_PI;

  void updateSensor() {
    mpu.getEvent(&a, &g, &temp);
  }

public:
  float sensorValues[7] = {};

  accelSensor() {
  }

  void begin(const int SDA_PIN, const int SCL_PIN, const int pin) {
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
    // updateSensor();
    // Serial.print("Accel: ");
    // Serial.print(a.acceleration.x);
    // Serial.print(", ");
    // Serial.print(a.acceleration.y);
    // Serial.print(", ");
    // Serial.print(a.acceleration.z);
    // Serial.print("  || Gyro: ");
    // Serial.print(a.gyro.x);
    // Serial.print(", ");
    // Serial.print(a.gyro.y);
    // Serial.print(", ");
    // Serial.print(a.gyro.z);
    // Serial.print("  || Chip Temperature: ");
    // Serial.println(temp.temperature);
    complementaryFilter();
  }

  // Function to apply complementary filter
  angleData_t complementaryFilter() {

    // This function sends the scaled reading of 360 degrees into 8 bit value.
    // to convert the 8 bit value to 360 degress, use the following formula:
    //     scaledAngleAxis * 1.40625 - 180


    // Get raw sensor data
    accelSensor::updateSensor();

    // Calculate angles from accelerometer (low pass - gravity)
    float accAngleX = atan2(a.acceleration.y, a.acceleration.z) * degreeValue;
    float accAngleY = atan2(a.acceleration.x, a.acceleration.z) * degreeValue;

    uint32_t interval = xTaskGetTickCount() - lastRun;

    // Integrate gyro data (high pass - rotational rate) to estimate angles
    angleX += g.gyro.x * interval / 1000.0;
    angleY += g.gyro.y * interval / 1000.0;
    lastRun = xTaskGetTickCount();
    // Complementary filter
    angleX = filterCoefficient * angleX + (1.0 - filterCoefficient) * accAngleX;
    angleY = filterCoefficient * angleY + (1.0 - filterCoefficient) * accAngleY;

    result.angleX = static_cast<uint8_t>(255.0f * ((angleX + 180) / 360));
    result.angleY = static_cast<uint8_t>(255.0f * ((angleY + 180) / 360));

    return result;
  }
};