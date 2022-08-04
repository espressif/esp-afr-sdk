# Getting Started with Espressif ESP32-S3 boards on Amazon FreeRTOS

## Set up the Espressif hardware
See the [ESP32-S3-DevKitC-1 - Getting Started Guide](https://docs.espressif.com/projects/esp-idf/en/v4.4.2/esp32s3/hw-reference/esp32s3/user-guide-devkitc-1.html) for more information about setting up the ESP32-S3-DevKitC-1 development board hardware.

## Set up your development environment
To communicate with your board, you need to download and install the required toolchain.

### Setting up the toolchain
1. Navigate to the ESP-IDF directory (`cd ./vendors/espressif/esp-idf`)
2. Run the `install.sh` script which installs the required tools (`./install.sh`)
3. Run the `export.sh` to add the required tools to the environment PATH (`. ./export.sh`)

**Note:**
ESP32-S3 compiler is supported by ESP-IDF v4.4.x only - you must use the supported compiler version to build FreeRTOS application. To check the version of your compiler, run the following command.
```
xtensa-esp32s3-elf-gcc --version
```

Above command should print following output:
```
xtensa-esp32s3-elf-gcc (crosstool-NG esp-2021r2-patch3) 8.4.0
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

## Build, flash, and run the FreeRTOS demo project

You can use CMake to generate the build files, build the application binary and Espressif's IDF utility to flash your board.

### To generate the demo application's build files with CMake
```
cmake -DVENDOR=espressif -DBOARD=esp32s3_devkitc -DCOMPILER=xtensa-esp32s3 -S . -B build-directory -GNinja
```
**Note**: If you want to generate the test application build files, add the `-DAFR_ENABLE_TESTS=1` flag.

### To build the application

Use Espressif's IDF utility to build the application:
```
./vendors/espressif/esp-idf/tools/idf.py -B build-directory build
```

Or use the generic CMake interface to build the application:
```
cmake --build build-directory
```

### Flash and run FreeRTOS

Use Espressif's IDF utility (freertos/vendors/espressif/esp-idf/tools/idf.py) to flash your board, run the application, and see logs.
To erase the board's flash, go to the freertos directory and use the following command:
```
./vendors/espressif/esp-idf/tools/idf.py -B build-directory erase_flash
```

You can use the IDF script to flash your board:
```
./vendors/espressif/esp-idf/tools/idf.py -B build-directory flash
```

To monitor:
```
./vendors/espressif/esp-idf/tools/idf.py -B build-directory monitor -p /dev/ttyUSB0
```

## Troubleshooting

- Refer the [AWS FreeRTOS Troubleshooting documentation](https://docs.aws.amazon.com/freertos/latest/userguide/getting_started_espressif.html#getting_started_espressif_troubleshooting)

- Refer the Espressif ESP-IDF programming guide to enable [JTAG Debugging](https://docs.espressif.com/projects/esp-idf/en/v4.4.2/esp32s3/api-guides/jtag-debugging/index.html) on ESP32-S3 based boards.
