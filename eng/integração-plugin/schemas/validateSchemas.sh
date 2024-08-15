#!/bin/bash

# First install the tool fake-schema-cli
# npm install -g fake-schema-cli

set -e
for i in $(find -name response*schema.json -o -name request*schema.json);
do
    echo -e "\n>>> $i\n"
    cd $(dirname "$i")
    cat $(basename "$i") | fake-schema -i 1
    cd - > /dev/null
done