#!/bin/bash

ESP_IDF_DIR=$1

if [ ! -d "$ESP_IDF_DIR" ]
then
    echo "Error directory does not exist"
    echo "help: $0 </path/to/esp-idf/"
    exit 1
fi

# Already available in a:FreeRTOS
COMPONENTS_NOT_REQUIRED="freertos unity"

pushd $ESP_IDF_DIR

for i in $COMPONENTS_NOT_REQUIRED; do
    echo "Removing component $i"
    rm -rf components/$i
done

# Only keep port and esp_crt_bundle directories in mbedTLS
echo "Keeping port and esp_crt_bundle for mbedtls component"
mkdir -p temp_dir
cp -r components/mbedtls/port components/mbedtls/esp_crt_bundle temp_dir
rm -rf components/mbedtls/*
cp -r temp_dir/ components/mbedtls/
rm -rf temp_dir

popd
