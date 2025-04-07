#!/bin/bash
set -eu

# Parse arguments 1 and 2, as package label name and org number, respectively. Defaults to "basic_1.0" and "1".
if [ $# -lt 2 ]; then
    org=1
    if [ $# -lt 1 ]; then
    label=basic_1.0
    else
        label=$1
    fi
else
    label="$1"
    org="$2"
fi

#if [ $# -lt 3 ]; then
#    file_name=basic
#else
#    file_name="$3"
#fi

# Import commands for Peers and import core.yaml path.
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

# Mark the communication to be TLS enabled
export CORE_PEER_TLS_ENABLED=true

case $org in
    "1" )
        export CORE_PEER_LOCALMSPID="Org1MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
        export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
        export CORE_PEER_ADDRESS=localhost:7051 ;;
    "2" )
        export CORE_PEER_LOCALMSPID="Org2MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
        export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
        export CORE_PEER_ADDRESS=localhost:9051 ;;
esac

installed_package="$(peer lifecycle chaincode queryinstalled | grep -oP "(?<=Package ID: )$label:[^,]*")"
echo "$installed_package"

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID dpki4der-test --name $label --version 1.0 --package-id $installed_package --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"