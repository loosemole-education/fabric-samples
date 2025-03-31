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

echo "Sets up network using network.sh and ./addOrg3/addOrg3.sh, with their modified docker-compose and crypto yamls..."
./network.sh up createChannel -c dpki4der-test
sleep 1
cd ./addOrg3
./addOrg3.sh up -c dpki4der-test
sleep 1

echo "\nPackages the asset_transfer_basic chaincode, as it is in $chaincode_path..."
cd ..
./package_asset_transfer_basic_cc.sh $label $file_name $chaincode_path
sleep 2

echo "\nInstalling the packaged chaincode on peer0 of org1, and org 2..."
./install_chaincode_on_peer_in_org.sh 1 $file_name
./install_chaincode_on_peer_in_org.sh 2 $file_name

echo "\nApprove chaincode as packaged, first from peer0 of org1, then peer0 of org2..."
./approve_chaincode_labeled_x_for_org_y.sh $label 1 $file_name
./approve_chaincode_labeled_x_for_org_y.sh $label 2 $file_name
sleep 4

echo "\nCommit chaincode defintion as approved by peer0 of org1 and 2, as a peer from org1"
./commit_cc_def.sh $file_name