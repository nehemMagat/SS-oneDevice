//#include <Arduino.h>
#include "config.h"
#include "bleSetup.h"
#include "accelGyro.h"
#include "fingers.h"

accelSensor ACCEL;
bleInstance ble;

FingerInstance pinkyFinger(PINKYPIN);
FingerInstance ringFinger(RINGPIN);
FingerInstance middleFinger(MIDDLEPIN);
FingerInstance indexFinger(INDEXPIN);
FingerInstance thumbFinger(THUMBPIN);

int packageSent = 0;

typedef struct {
  float accelX;
  float accelY;
  float accelZ;
  float gyroX;
  float gyroY;
  float gyroZ;
} accelGyroData_t;

typedef struct {
  float pinky;
  float ring;
  float middle;
  float index;
  float thumb;
  accelGyroData_t accelData;
} handData_t;

struct fingerError {
  int pinky;
  int ring;
  int middle;
  int index;
  int thumb;
};

fingerError fingerErrorCheck = { 0, 0, 0, 0, 0 };

QueueHandle_t pinkyQueue;
QueueHandle_t ringQueue;
QueueHandle_t middleQueue;
QueueHandle_t indexQueue;
QueueHandle_t thumbQueue;
QueueHandle_t handQueue;
QueueHandle_t IMUQueue;

int missedIMUData = 0;

long lastCountdown = 0;

void pinkyFingerFunc(void *pvParameters);
void ringFingerFunc(void *pvParameters);
void middleFingerFunc(void *pvParameters);
void indexFingerFunc(void *pvParameters);
void thumbFingerFunc(void *pvParameters);
void accelGyroFunc(void *pvParameters);
void dataParser(void *pvParameters);
void bleSender(void *pvParameters);

void setup() {
  pinMode(HANDPIN, INPUT);
  Serial.begin(115200);
  while (!Serial) {
    delay(10);
  };
  String handSide;
  int randNumber = random(100000);
  String UBluetoothName = bluetoothName;
  if (digitalRead(HANDPIN)) {
    handSide = "R";
  } else {
    handSide = "L";
  }

  UBluetoothName += handSide + randNumber;
  char uBlCharArray[UBluetoothName.length() + 1];
  UBluetoothName.toCharArray(uBlCharArray, UBluetoothName.length() + 1);
  ble.begin(uBlCharArray);
  ACCEL.begin(I2C_SDA_PIN, I2C_SCL_PIN);

  pinkyQueue = xQueueCreate(fingerQueueLength, sizeof(float));
  ringQueue = xQueueCreate(fingerQueueLength, sizeof(float));
  middleQueue = xQueueCreate(fingerQueueLength, sizeof(float));
  indexQueue = xQueueCreate(fingerQueueLength, sizeof(float));
  thumbQueue = xQueueCreate(fingerQueueLength, sizeof(float));

  handQueue = xQueueCreate(handQueueLength, sizeof(handData_t));
  IMUQueue = xQueueCreate(IMUQueueLength, sizeof(accelGyroData_t));

  xTaskCreatePinnedToCore(&pinkyFingerFunc, "pinkyFunc", fingerStackSize, NULL, fingerPriority, NULL, APPCORE);
  xTaskCreatePinnedToCore(&ringFingerFunc, "ringFunc", fingerStackSize, NULL, fingerPriority, NULL, APPCORE);
  xTaskCreatePinnedToCore(&middleFingerFunc, "middleFunc", fingerStackSize, NULL, fingerPriority, NULL, APPCORE);
  xTaskCreatePinnedToCore(&indexFingerFunc, "indexFunc", fingerStackSize, NULL, fingerPriority, NULL, APPCORE);
  xTaskCreatePinnedToCore(&thumbFingerFunc, "thumbFunc", fingerStackSize, NULL, fingerPriority, NULL, APPCORE);
  xTaskCreatePinnedToCore(&accelGyroFunc, "mpuFunc", 2048, NULL, accelPriority, NULL, APPCORE);

  xTaskCreatePinnedToCore(&dataParser, "dataPreparation", 10240, NULL, blePriority, NULL, SYSTEMCORE);
  xTaskCreatePinnedToCore(&bleSender, "dataTransmission", 10240, NULL, blePriority, NULL, SYSTEMCORE);
}

void loop() {
  // ACCEL.tryData();
}

/*--------------------------------------------------*/
/*---------------------- Tasks ---------------------*/
/*--------------------------------------------------*/

void bleSender(void *pvParameters) {
  handData_t message;
  for (;;) {
    if ((int)xQueueReceive(handQueue, &message, 0) == pdTRUE) {
      float sendData[] = { message.pinky,
                           message.ring,
                           message.middle,
                           message.index,
                           message.thumb,
                           message.accelData.accelX,
                           message.accelData.accelY,
                           message.accelData.accelZ,
                           message.accelData.gyroX,
                           message.accelData.gyroY,
                           message.accelData.gyroZ };

      ble.write(sendData, sizeof(sendData) / sizeof(float));
    }
    vTaskDelay(pdMS_TO_TICKS(1));
  }
}

void dataParser(void *pvParameters) {
  handData_t machineData;
  for (;;) {
    //Receive data from gloves queue
    int pinkyStatus = xQueueReceive(pinkyQueue, &machineData.pinky, fingerQueueWait);
    int ringStatus = xQueueReceive(ringQueue, &machineData.ring, fingerQueueWait);
    int middleStatus = xQueueReceive(middleQueue, &machineData.middle, fingerQueueWait);
    int indexStatus = xQueueReceive(indexQueue, &machineData.index, fingerQueueWait);
    int thumbStatus = xQueueReceive(thumbQueue, &machineData.thumb, fingerQueueWait);
    int accelStatus = xQueueReceive(IMUQueue, &machineData.accelData, IMUQueueWait);
    if ((pinkyStatus == pdTRUE) || (ringStatus == pdTRUE) || (middleStatus == pdTRUE) || (indexStatus == pdTRUE) || (thumbStatus == pdTRUE) || (accelStatus == pdTRUE)) {
      xQueueSend(handQueue, &machineData, IMUQueueWait);  //updates approx @ 125hz
    } else {
      Serial.println("No Data to be saved");
    }
    vTaskDelay(pdMS_TO_TICKS(3));
  }
}

void accelGyroFunc(void *pvParameters) {
  for (;;) {
    accelGyroData_t imuData;
    float *value = ACCEL.update();
    imuData.accelX = value[0];
    imuData.accelY = value[1];
    imuData.accelZ = value[2];
    imuData.gyroX = value[3];
    imuData.gyroY = value[4];
    imuData.gyroZ = value[5];
    if (xQueueSend(IMUQueue, &imuData, pdMS_TO_TICKS(IMUQueueWait)) != pdPASS) {
      missedIMUData++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / IMUSamplingRate));
  }
}

void pinkyFingerFunc(void *pvParameters) {
  for (;;) {
    float fingerData = pinkyFinger.read();
    if (xQueueSend(pinkyQueue, &fingerData, pdMS_TO_TICKS(fingerQueueWait)) != pdPASS) {
      fingerErrorCheck.pinky++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / fingerSamplingRate));
  }
}

void ringFingerFunc(void *pvParameters) {
  for (;;) {
    float fingerData = ringFinger.read();
    if (xQueueSend(ringQueue, &fingerData, pdMS_TO_TICKS(fingerQueueWait)) != pdPASS) {
      fingerErrorCheck.ring++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / fingerSamplingRate));
  }
}

void middleFingerFunc(void *pvParameters) {
  for (;;) {
    float fingerData = middleFinger.read();
    if (xQueueSend(middleQueue, &fingerData, pdMS_TO_TICKS(fingerQueueWait)) != pdPASS) {
      fingerErrorCheck.middle++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / fingerSamplingRate));
  }
}

void indexFingerFunc(void *pvParameters) {
  for (;;) {
    float fingerData = indexFinger.read();
    if (xQueueSend(indexQueue, &fingerData, pdMS_TO_TICKS(fingerQueueWait)) != pdPASS) {
      fingerErrorCheck.index++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / fingerSamplingRate));
  }
}

void thumbFingerFunc(void *pvParameters) {
  for (;;) {
    float fingerData = thumbFinger.read();
    if (xQueueSend(thumbQueue, &fingerData, pdMS_TO_TICKS(fingerQueueWait)) != pdPASS) {
      fingerErrorCheck.thumb++;
    }
    vTaskDelay(pdMS_TO_TICKS(1000 / fingerSamplingRate));
  }
}
