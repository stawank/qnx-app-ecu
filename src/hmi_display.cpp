// ============================================
// File: src/hmi_display.cpp
// ============================================
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/neutrino.h>
#include "common/messages.h"
#include "common/utils.h"

int main(int argc, char *argv[]) {
    log_message("HMIDisplay", "Starting...");

    // Create a channel to receive warning commands
    int chid = ChannelCreate(0);
    if (chid == -1) {
        perror("ChannelCreate failed");
        return EXIT_FAILURE;
    }

    log_message("HMIDisplay", "Channel created successfully");

    // TODO: Receive warning commands from WarningController
    // TODO: Display alerts

    // For now, just run a simple loop
    int count = 0;
    while(1) {
        char msg[100];
        snprintf(msg, sizeof(msg), "Running... iteration %d", count++);
        log_message("HMIDisplay", msg);
        sleep(2);

        // Exit after 10 iterations for testing
        if (count >= 10) {
            break;
        }
    }

    ChannelDestroy(chid);
    log_message("HMIDisplay", "Shutting down");

    return EXIT_SUCCESS;
}
