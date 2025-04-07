#!/bin/bash
set -eu

if [ $# -lt 1 ]; then
    chaincode=basic
else
    chaincode="$1"
fi

# Import commands for Peers and import core.yaml path.
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

# Mark the communication to be TLS enabled
export CORE_PEER_TLS_ENABLED=true

# Set the path for the MSP's config
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer lifecycle chaincode querycommitted --channelID dpki4der-test --name $chaincode --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
