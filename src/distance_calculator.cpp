// ============================================
// File: src/distance_calculator.cpp
// ============================================
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/neutrino.h>
#include "common/messages.h"
#include "common/utils.h"

int main(int argc, char *argv[]) {
    log_message("DistanceCalculator", "Starting...");

    // Create a channel to receive sensor data
    int chid = ChannelCreate(0);
    if (chid == -1) {
        perror("ChannelCreate failed");
        return EXIT_FAILURE;
    }

    log_message("DistanceCalculator", "Channel created successfully");

    // TODO: Wait for sensor data from SensorManager
    // TODO: Process and forward to WarningController

    // For now, just run a simple loop
    int count = 0;
    while(1) {
        char msg[100];
        snprintf(msg, sizeof(msg), "Running... iteration %d", count++);
        log_message("DistanceCalculator", msg);
        sleep(2);

        // Exit after 10 iterations for testing
        if (count >= 10) {
            break;
        }
    }

    ChannelDestroy(chid);
    log_message("DistanceCalculator", "Shutting down");

    return EXIT_SUCCESS;
}
