// ============================================
// File: src/common/messages.h
// ============================================
#ifndef MESSAGES_H
#define MESSAGES_H

#include <stdint.h>

// Message types
#define MSG_SENSOR_DATA     0x01
#define MSG_PROXIMITY_INFO  0x02
#define MSG_WARNING_CMD     0x03

// Sensor data from ultrasonic sensors
struct SensorDataMsg {
    uint16_t type;          // MSG_SENSOR_DATA
    uint32_t sensor_id;     // Which sensor (0-7)
    float distance_cm;      // Distance in centimeters
    uint64_t timestamp;     // When captured
};

// Processed proximity information
struct ProximityInfoMsg {
    uint16_t type;          // MSG_PROXIMITY_INFO
    float min_distance;     // Closest obstacle
    uint32_t closest_sensor;
    uint8_t zone;           // 0=safe, 1=caution, 2=danger
};

// Warning command for HMI
struct WarningCommandMsg {
    uint16_t type;          // MSG_WARNING_CMD
    uint8_t alert_level;    // 0=off, 1=low, 2=high
    uint16_t beep_freq_ms;  // Beep frequency
};

#endif // MESSAGES_H
