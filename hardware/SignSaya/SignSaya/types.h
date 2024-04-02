struct angles {
  float angleX;
  float angleY;
};

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
  angles imuData;
} handData_t;

struct fingerError {
  int pinky;
  int ring;
  int middle;
  int index;
  int thumb;
};

