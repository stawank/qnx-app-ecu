# List of executables to build
ARTIFACTS = sensor_manager distance_calculator warning_controller hmi_display

#Build architecture/variant string, possible values: x86, armv7le, etc...
PLATFORM ?= aarch64le

#Build profile, possible values: release, debug, profile, coverage
BUILD_PROFILE ?= debug

CONFIG_NAME ?= $(PLATFORM)-$(BUILD_PROFILE)
OUTPUT_DIR = build/$(CONFIG_NAME)

# Create target paths for all executables
TARGETS = $(addprefix $(OUTPUT_DIR)/, $(ARTIFACTS))

#Compiler definitions
CC = qcc -Vgcc_nto$(PLATFORM)
CXX = q++ -Vgcc_nto$(PLATFORM)_cxx
LD = $(CXX)

#User defined include/preprocessor flags and libraries
INCLUDES += -Isrc/common

#LIBS += -L/path/to/my/lib/$(PLATFORM)/usr/lib -lmylib

#Compiler flags for build profiles
CCFLAGS_release += -O2
CCFLAGS_debug += -g -O0 -fno-builtin
CCFLAGS_coverage += -g -O0 -ftest-coverage -fprofile-arcs
LDFLAGS_coverage += -ftest-coverage -fprofile-arcs
CCFLAGS_profile += -g -O0 -finstrument-functions
LIBS_profile += -lprofilingS

#Generic compiler flags (which include build type flags)
CCFLAGS_all += -Wall -fmessage-length=0
CCFLAGS_all += $(CCFLAGS_$(BUILD_PROFILE))
LDFLAGS_all += $(LDFLAGS_$(BUILD_PROFILE))
LIBS_all += $(LIBS_$(BUILD_PROFILE))
DEPS = -Wp,-MMD,$(@:%.o=%.d),-MT,$@

#Macro to expand files recursively: parameters $1 - directory, $2 - extension
rwildcard = $(wildcard $(addprefix $1/*.,$2)) $(foreach d,$(wildcard $1/*),$(call rwildcard,$d,$2))

#Common source files (shared by all executables)
COMMON_SRCS = $(call rwildcard, src/common, c cpp)
COMMON_OBJS = $(addprefix $(OUTPUT_DIR)/, $(addsuffix .o, $(basename $(COMMON_SRCS))))

#Source files for each executable
sensor_manager_SRCS = src/sensor_manager.cpp
distance_calculator_SRCS = src/distance_calculator.cpp
warning_controller_SRCS = src/warning_controller.cpp
hmi_display_SRCS = src/hmi_display.cpp

#Object files for each executable
sensor_manager_OBJS = $(addprefix $(OUTPUT_DIR)/, $(addsuffix .o, $(basename $(sensor_manager_SRCS)))) $(COMMON_OBJS)
distance_calculator_OBJS = $(addprefix $(OUTPUT_DIR)/, $(addsuffix .o, $(basename $(distance_calculator_SRCS)))) $(COMMON_OBJS)
warning_controller_OBJS = $(addprefix $(OUTPUT_DIR)/, $(addsuffix .o, $(basename $(warning_controller_SRCS)))) $(COMMON_OBJS)
hmi_display_OBJS = $(addprefix $(OUTPUT_DIR)/, $(addsuffix .o, $(basename $(hmi_display_SRCS)))) $(COMMON_OBJS)

#Compiling rules
$(OUTPUT_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $(DEPS) -o $@ $(INCLUDES) $(CCFLAGS_all) $(CCFLAGS) $<

$(OUTPUT_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) -c $(DEPS) -o $@ $(INCLUDES) $(CCFLAGS_all) $(CCFLAGS) $<

#Linking rules for each executable
$(OUTPUT_DIR)/sensor_manager: $(sensor_manager_OBJS)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $^ $(LIBS_all) $(LIBS)

$(OUTPUT_DIR)/distance_calculator: $(distance_calculator_OBJS)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $^ $(LIBS_all) $(LIBS)

$(OUTPUT_DIR)/warning_controller: $(warning_controller_OBJS)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $^ $(LIBS_all) $(LIBS)

$(OUTPUT_DIR)/hmi_display: $(hmi_display_OBJS)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $^ $(LIBS_all) $(LIBS)

#Rules section for default compilation and linking
all: $(TARGETS)

clean:
	rm -fr $(OUTPUT_DIR)

rebuild: clean all

# Helper targets to build individual executables
sensor_manager: $(OUTPUT_DIR)/sensor_manager
distance_calculator: $(OUTPUT_DIR)/distance_calculator
warning_controller: $(OUTPUT_DIR)/warning_controller
hmi_display: $(OUTPUT_DIR)/hmi_display

# Show what will be built
info:
	@echo "Building for platform: $(PLATFORM)"
	@echo "Build profile: $(BUILD_PROFILE)"
	@echo "Output directory: $(OUTPUT_DIR)"
	@echo "Executables: $(ARTIFACTS)"
	@echo "Targets: $(TARGETS)"

#Inclusion of dependencies (object files to source and includes)
-include $(COMMON_OBJS:%.o=%.d)
-include $(sensor_manager_OBJS:%.o=%.d)
-include $(distance_calculator_OBJS:%.o=%.d)
-include $(warning_controller_OBJS:%.o=%.d)
-include $(hmi_display_OBJS:%.o=%.d)

.PHONY: all clean rebuild sensor_manager distance_calculator warning_controller hmi_display info