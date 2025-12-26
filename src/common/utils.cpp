// ============================================
// File: src/common/utils.cpp
// ============================================
#include "utils.h"
#include <sys/neutrino.h>
#include <time.h>
#include <stdio.h>

uint64_t get_timestamp_us() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
}

void log_message(const char* process_name, const char* message) {
    uint64_t timestamp = get_timestamp_us();
    printf("[%llu] [%s] %s\n", (unsigned long long)timestamp, process_name, message);
    fflush(stdout);
}
