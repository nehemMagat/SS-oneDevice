typedef struct {
  uint8_t angleX;
  uint8_t angleY;
} angleData_t;

typedef struct {
  uint8_t pinky;
  uint8_t ring;
  uint8_t middle;
  uint8_t index;
  uint8_t thumb;
  angleData_t angles;
} handData_t;

struct fingerError {
  int pinky;
  int ring;
  int middle;
  int index;
  int thumb;
};

