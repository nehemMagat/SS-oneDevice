#include "ICM_20948.h"  // Click here to get the library: http://librarymanager/All#SparkFun_ICM_20948_IMU

#define WIRE_PORT Wire  // Your desired Wire port.      Used when "USE_SPI" is not defined

bool AD0_VAL = 0;

ICM_20948_I2C myICM;  // Otherwise create an ICM_20948_I2C object

class accelSensor {
private:
  quaternion_t results;

public:
  void begin(const int SDA_PIN, const int SCL_PIN, const int INTERRUPT_PIN) {
    Wire.begin(SDA_PIN, SCL_PIN);
    Wire.setClock(400000);
    // myICM.enableDebugging();  // Uncomment this line to enable helpful debug messages on Serial

    bool initialized = false;
    while (!initialized) {

      // Initialize the ICM-20948
      // If the DMP is enabled, .begin performs a minimal startup. We need to configure the sample mode etc. manually.

      myICM.begin(WIRE_PORT, AD0_VAL);

      Serial.print(F("Initialization of the sensor returned: "));
      Serial.println(myICM.statusString());

      if (myICM.status != ICM_20948_Stat_Ok) {
        Serial.println(F("Trying again..."));
        AD0_VAL = !AD0_VAL;
        delay(10);
      } else {
        initialized = true;
      }
    }

    bool success = true;  // Use success to show if the DMP configuration was successful

    // Initialize the DMP. initializeDMP is a weak function. You can overwrite it if you want to e.g. to change the sample rate
    success &= (myICM.initializeDMP() == ICM_20948_Stat_Ok);

    // DMP sensor options are defined in ICM_20948_DMP.h
    //    INV_ICM20948_SENSOR_ACCELEROMETER               (16-bit accel)
    //    INV_ICM20948_SENSOR_GYROSCOPE                   (16-bit gyro + 32-bit calibrated gyro)
    //    INV_ICM20948_SENSOR_RAW_ACCELEROMETER           (16-bit accel)
    //    INV_ICM20948_SENSOR_RAW_GYROSCOPE               (16-bit gyro + 32-bit calibrated gyro)
    //    INV_ICM20948_SENSOR_MAGNETIC_FIELD_UNCALIBRATED (16-bit compass)
    //    INV_ICM20948_SENSOR_GYROSCOPE_UNCALIBRATED      (16-bit gyro)
    //    INV_ICM20948_SENSOR_STEP_DETECTOR               (Pedometer Step Detector)
    //    INV_ICM20948_SENSOR_STEP_COUNTER                (Pedometer Step Detector)
    //    INV_ICM20948_SENSOR_GAME_ROTATION_VECTOR        (32-bit 6-axis quaternion)
    //    INV_ICM20948_SENSOR_ROTATION_VECTOR             (32-bit 9-axis quaternion + heading accuracy)
    //    INV_ICM20948_SENSOR_GEOMAGNETIC_ROTATION_VECTOR (32-bit Geomag RV + heading accuracy)
    //    INV_ICM20948_SENSOR_GEOMAGNETIC_FIELD           (32-bit calibrated compass)
    //    INV_ICM20948_SENSOR_GRAVITY                     (32-bit 6-axis quaternion)
    //    INV_ICM20948_SENSOR_LINEAR_ACCELERATION         (16-bit accel + 32-bit 6-axis quaternion)
    //    INV_ICM20948_SENSOR_ORIENTATION                 (32-bit 9-axis quaternion + heading accuracy)

    // Enable the DMP orientation sensor
    success &= (myICM.enableDMPSensor(INV_ICM20948_SENSOR_ORIENTATION) == ICM_20948_Stat_Ok);

    // Enable any additional sensors / features
    //success &= (myICM.enableDMPSensor(INV_ICM20948_SENSOR_RAW_GYROSCOPE) == ICM_20948_Stat_Ok);
    //success &= (myICM.enableDMPSensor(INV_ICM20948_SENSOR_RAW_ACCELEROMETER) == ICM_20948_Stat_Ok);
    //success &= (myICM.enableDMPSensor(INV_ICM20948_SENSOR_MAGNETIC_FIELD_UNCALIBRATED) == ICM_20948_Stat_Ok);

    // Configuring DMP to output data at multiple ODRs:
    // DMP is capable of outputting multiple sensor data at different rates to FIFO.
    // Setting value can be calculated as follows:
    // Value = (DMP running rate / ODR ) - 1
    // E.g. For a 5Hz ODR rate when DMP is running at 55Hz, value = (55/5) - 1 = 10.
    success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Quat9, 0) == ICM_20948_Stat_Ok);  // Set to the maximum
    //success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Accel, 0) == ICM_20948_Stat_Ok); // Set to the maximum
    //success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Gyro, 0) == ICM_20948_Stat_Ok); // Set to the maximum
    //success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Gyro_Calibr, 0) == ICM_20948_Stat_Ok); // Set to the maximum
    //success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Cpass, 0) == ICM_20948_Stat_Ok); // Set to the maximum
    //success &= (myICM.setDMPODRrate(DMP_ODR_Reg_Cpass_Calibr, 0) == ICM_20948_Stat_Ok); // Set to the maximum

    // Enable the FIFO
    success &= (myICM.enableFIFO() == ICM_20948_Stat_Ok);

    // Enable the DMP
    success &= (myICM.enableDMP() == ICM_20948_Stat_Ok);

    // Reset DMP
    success &= (myICM.resetDMP() == ICM_20948_Stat_Ok);

    // Reset FIFO
    success &= (myICM.resetFIFO() == ICM_20948_Stat_Ok);

    // Check success
    if (success) {
#ifndef QUAT_ANIMATION
      Serial.println(F("DMP enabled!"));
#endif
    } else {
      Serial.println(F("Enable DMP failed!"));
      Serial.println(F("Please check that you have uncommented line 29 (#define ICM_20948_USE_DMP) in ICM_20948_C.h..."));
      while (1)
        ;  // Do nothing more
    }
  }

  bool checkDataReady() {
    return (myICM.status == ICM_20948_Stat_Ok) || (myICM.status == ICM_20948_Stat_FIFOMoreDataAvail);
  }

  quaternion_t getData() {
    icm_20948_DMP_data_t data;
    myICM.readDMPdataFromFIFO(&data);

    if ((data.header & DMP_header_bitmap_Quat9) > 0)  // We have asked for orientation data so we should receive Quat9
    {
      // Q0 value is computed from this equation: Q0^2 + Q1^2 + Q2^2 + Q3^2 = 1.
      // In case of drift, the sum will not add to 1, therefore, quaternion data need to be corrected with right bias values.
      // The quaternion data is scaled by 2^30.

      // Scale to +/- 1
      double q1 = ((double)data.Quat9.Data.Q1) / 1073741824.0;  // Convert to double. Divide by 2^30
      double q2 = ((double)data.Quat9.Data.Q2) / 1073741824.0;  // Convert to double. Divide by 2^30
      double q3 = ((double)data.Quat9.Data.Q3) / 1073741824.0;  // Convert to double. Divide by 2^30
      double q0 = sqrt(1.0 - ((q1 * q1) + (q2 * q2) + (q3 * q3)));

      results.q0 = map(q0, -1.0, 1, 0, 255);
      results.q1 = map(q1, -1.0, 1, 0, 255);
      results.q2 = map(q2, -1.0, 1, 0, 255);
      results.q3 = map(q3, -1.0, 1, 0, 255);

      return results;
    }
  }
};
