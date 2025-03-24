#!/bin/bash
set -eu

echo "Sets up network using network.sh and ./addOrg3/addOrg3.sh, with their modified docker-compose and crypto yamls..."
./network.sh up createChannel -c dpki4der-test
cd ./addOrg3
./addOrg3.sh up -c dpki4der-test

echo "\nPackages the asset_transfer_basic chaincode, as it is in ../asset-transfer-basic/chaincode-go..."
cd ..
./package_asset_transfer_basic_cc.sh

echo "\nInstalling the packaged chaincode on peer0 of org1, and org 2..."
./install_chaincode_on_peer_in_org.sh 1
./install_chaincode_on_peer_in_org.sh 2

echo "\nApprove chaincode as packaged, first from peer0 of org1, then peer0 of org2..."
./approve_chaincode_labeled_x_for_org_y.sh "basic_1.0" 1
./approve_chaincode_labeled_x_for_org_y.sh "basic_1.0" 2

echo "\nCommit chaincode defintion as approved by peer0 of org1 and 2, as a peer from org1"
./commit_cc_def.sh