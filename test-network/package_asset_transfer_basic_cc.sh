#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    label=basic_1.0
else
    label="$1"
fi

if [ $# -lt 2 ]; then
    file_name=basic
else
    file_name="$2"
fi

if [ $# -lt 3 ]; then
    chaincode_path="../asset-transfer-basic/chaincode-go/"
else
    chaincode_path="$3"
fi

# Note where the script is executed (presumably in the test-network folder)
back_path="${PWD}"

echo "Creating package \"$file_name\", w. label: \"$label\""

cd $chaincode_path
GO111MODULE=on go mod vendor
cd $back_path

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer lifecycle chaincode package $file_name.tar.gz --path $chaincode_path --lang golang --label "$label"
