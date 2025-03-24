#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    label=basic_1.0
else
    label="$1"
fi

echo "Creating package, w. label: $label"

cd ../asset-transfer-basic/chaincode-go/
GO111MODULE=on go mod vendor
cd ../../test-network
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer lifecycle chaincode package basic.tar.gz --path ../asset-transfer-basic/chaincode-go/ --lang golang --label "$label"
