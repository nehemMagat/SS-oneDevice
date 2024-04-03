/*
    DO NOT USE PINS IN THIS LIST
    0 = STRAPPING PIN FOR BOOT BUTTON
    3 = STRAPPING PIN FOR JTAG
    15 = Crystal Oscillator
    16 = Crystal Oscillator
    19 = USB_D- ON USB PORT
    20 = USB_D+ ON USB PORT
    43 = TX COM0
    44 = RX COM0
    46 = STRAPPING PIN FOR LOG
    45 = STRAPPING PIN FOR VSPI
*/

// I2C SETUP
constexpr int I2C_SDA_PIN = 46; 
constexpr int I2C_SCL_PIN = 3;

// FINGER PINS
constexpr int PINKYPIN = 9; //9
constexpr int RINGPIN = 10; //10
constexpr int MIDDLEPIN = 11; //11
constexpr int INDEXPIN = 12; //12
constexpr int THUMBPIN = 13; //13

constexpr bool HANDPIN = 7; //14
constexpr int bluetoothIndicator = 8;


//freeRTOS VARIABLES
constexpr int fingerQueueLength = 10;
constexpr int handQueueLength = 15;
constexpr int IMUQueueLength = 15;
constexpr int IMUQueueWait = 5;
constexpr int fingerQueueWait = 5;

constexpr int fingerStackSize = 1280;
constexpr int mpuStackSize = 2560;

constexpr int fingerPriority = 2;
constexpr int accelPriority = 2;
constexpr int blePriority = 4;

constexpr int APPCORE = 1;
constexpr int SYSTEMCORE = 0;

constexpr int fingerSamplingRate = 250; // hz, MAXIMUM ONLY, DOES NOT GUARRANTEE ACTUAL SAMPLING RATE DUE TO freeRTOS
constexpr int IMUSamplingRate = 750; // hz, MAXIMUM ONLY, DOES NOT GUARRANTEE ACTUAL SAMPLING RATE DUE TO freeRTOS

// BLUETOOTH VARIABLES
constexpr char bluetoothName[] = "SignSaya";

// OTHER VARIABLES
bool isWireBegun = false;
constexpr int arrayLength = fingerSamplingRate * 1; //Length of array to be  averaged
int maxFingerValue = 255; //max value of finger output for dataset

#define LOG_LOCAL_LEVEL ESP_LOG_VERBOSE
#include "esp_log.h"


