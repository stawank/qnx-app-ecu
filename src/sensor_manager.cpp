// ============================================
// File: src/sensor_manager.cpp
// ============================================
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/neutrino.h>
#include "common/messages.h"
#include "common/utils.h"

int main(int argc, char *argv[]) {
    log_message("SensorManager", "Starting...");

    // Create a channel to receive requests (if needed)
    int chid = ChannelCreate(0);
    if (chid == -1) {
        perror("ChannelCreate failed");
        return EXIT_FAILURE;
    }

    log_message("SensorManager", "Channel created successfully");

    // TODO: Connect to DistanceCalculator
    // TODO: Periodically generate sensor data

    // For now, just run a simple loop
    int count = 0;
    while(1) {
        char msg[100];
        snprintf(msg, sizeof(msg), "Running... iteration %d", count++);
        log_message("SensorManager", msg);
        sleep(2);

        // Exit after 10 iterations for testing
        if (count >= 10) {
            break;
        }
    }

    ChannelDestroy(chid);
    log_message("SensorManager", "Shutting down");

    return EXIT_SUCCESS;
}
