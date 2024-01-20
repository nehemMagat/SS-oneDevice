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
constexpr uint8_t I2C_SDA_PIN = 38;
constexpr uint8_t I2C_SCL_PIN = 39;

// FINGER PINS
constexpr uint8_t PINKYPIN = 4;
constexpr uint8_t RINGPIN = 5;
constexpr uint8_t MIDDLEPIN = 6;
constexpr uint8_t INDEXPIN = 7;
constexpr uint8_t THUMBPIN = 17;

// OTHER VARIABLES
bool isWireBegun = false;
constexpr uint8_t arrayLength = 10; //Length of array to be  averaged
float maxFingerValue = 4096; //max value of finger output for dataset
