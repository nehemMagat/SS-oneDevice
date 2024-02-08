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
constexpr int I2C_SDA_PIN = 38; 
constexpr int I2C_SCL_PIN = 39;

// FINGER PINS
constexpr int PINKYPIN = 4; //9
constexpr int RINGPIN = 5; //10
constexpr int MIDDLEPIN = 6; //11
constexpr int INDEXPIN = 7; //12
constexpr int THUMBPIN = 17; //13

constexpr bool HANDPIN = 18; //14
constexpr int bluetoothIndicator = 8;


//freeRTOS VARIABLES
constexpr int fingerQueueLength = 100;
constexpr int handQueueLength = 100;
constexpr int IMUQueueLength = 100;
constexpr int IMUQueueWait = 5;
constexpr int fingerQueueWait = 5;

constexpr int fingerStackSize = 2048;
constexpr int mpuStackSize = 2048;

constexpr int fingerPriority = 2;
constexpr int accelPriority = 2;
constexpr int blePriority = 4;

constexpr int APPCORE = 1;
constexpr int SYSTEMCORE = 0;

constexpr int fingerSamplingRate = 1000; // hz, MAXIMUM ONLY, DOES NOT GUARRANTEE ACTUAL SAMPLING RATE DUE TO freeRTOS
constexpr int IMUSamplingRate = 1000; // hz, MAXIMUM ONLY, DOES NOT GUARRANTEE ACTUAL SAMPLING RATE DUE TO freeRTOS

// BLUETOOTH VARIABLES
constexpr char bluetoothName[] = "SignSaya";

// OTHER VARIABLES
bool isWireBegun = false;
constexpr int arrayLength = fingerSamplingRate * 1; //Length of array to be  averaged
int maxFingerValue = 255; //max value of finger output for dataset

