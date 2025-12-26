#include <sys/neutrino.h>
#include <sys/dispatch.h>
#include <iostream>

int main() {
    // Connect to service by name
    int coid = name_open("my_service", 0);
    if (coid == -1) {
        std::cerr << "Failed to connect to service\n";
        return -1;
    }

    int number = 42;
    MsgSend(coid, &number, sizeof(number), nullptr, 0);

    std::cout << "I sent number: " << number << std::endl;
    name_close(coid);
    return 0;
}
