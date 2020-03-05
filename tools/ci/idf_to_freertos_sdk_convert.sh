#!/bin/bash

ESP_IDF_DIR=$1

if [ ! -d "$ESP_IDF_DIR" ]
then
    echo "Error directory does not exist"
    echo "help: $0 </path/to/esp-idf/"
    exit 1
fi

# Already available in a:FreeRTOS
COMPONENTS_NOT_REQUIRED="freertos mbedtls jsmn aws_iot libsodium"

# Components disabled for now but potentially should work with appropriate changes
COMPONENTS_NON_FUNCTIONAL="coap esp-tls esp_http_client esp_https_ota"

# Components specific to IDF v3.2 release
COMPONENTS_IDF_V3_2_SPECIFIC="asio mqtt tcp_transport"

# Components specific to IDF v3.3 release
COMPONENTS_IDF_V3_3_SPECIFIC="esp_https_server unity"

# Other things, examples (users should refer to AFR provided sample apps)
OTHER_STUFF_TO_CLEAN="examples"

pushd $ESP_IDF_DIR

for i in $COMPONENTS_NOT_REQUIRED $COMPONENTS_NON_FUNCTIONAL $COMPONENTS_IDF_V3_2_SPECIFIC $COMPONENTS_IDF_V3_3_SPECIFIC; do
    echo "Removing component $i"
    rm -rf components/$i
done

for i in $OTHER_STUFF_TO_CLEAN; do
    echo "Removing $i"
    rm -rf $i
done

popd
