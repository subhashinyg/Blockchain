# verify the result of the end-to-end test
verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
    echo
    exit 1
  fi
}


CHANNEL_NAME=mychannel
CLI_DELAY=3
LANGUAGE=node
CLI_TIMEOUT=10 
VERBOSE=false
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
CORE_PEER_TLS_ENABLED = "true"
  echo "Creating channel..."
  
  PEER=0
  ORG=1
  CORE_PEER_LOCALMSPID="Org1MSP"
  PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_TLS_ENABLED = true
 peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
 res=$?
 cat log.txt
 verifyResult $res "Channel creation failed"
 	echo "=========== Channel '$CHANNEL_NAME' created ==================="
 	echo "............peer0 org1 Join channel............."
echo "Having all peers join the channel..."
PEER=0
MAX_RETRY=5
peer channel join -b $CHANNEL_NAME.block >&log.txt
res=$?
cat log.txt
verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "
    
# echo"...................peer1 org1 joining.................."
CORE_PEER_ADDRESS=peer1.org1.example.com:7051
echo "Having all peers join the channel..."
PEER=1
ORG=1
MAX_RETRY=5
peer channel join -b $CHANNEL_NAME.block >&log.txt
res=$?
cat log.txt
verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "
       
#echo".................peer0 org2 joining................."
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051
echo "Having all peers join the channel..."
PEER=0
ORG=2
MAX_RETRY=5
peer channel join -b $CHANNEL_NAME.block >&log.txt
res=$?
cat log.txt
verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "

#echo"....................peer1 org2 joining.................."

CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer1.org2.example.com:7051
echo "Having all peers join the channel..."
PEER=1
ORG=2
MAX_RETRY=5
peer channel join -b $CHANNEL_NAME.block >&log.txt
res=$?
cat log.txt
verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "

echo ".............Chaincode install on peer0 org1..........."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
MSPDir=crypto-config/peerOrganizations/org1.example.com/msp
PEER=0
ORG=1
LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/chaincode_example02/node/
VERSION=${3:-1.0}
peer chaincode install -n mycc -v ${VERSION} -l ${LANGUAGE} -p ${CC_SRC_PATH} >&log.txt
res=$?
cat log.txt
verifyResult $res "Chaincode installation on peer${PEER}.org${ORG} has failed"

CORE_PEER_ADDRESS=peer1.org1.example.com:7051
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
MSPDir=crypto-config/peerOrganizations/org1.example.com/msp
PEER=1
ORG=1
LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/chaincode_example02/node/
VERSION=${3:-1.0}
peer chaincode install -n mycc -v ${VERSION} -l ${LANGUAGE} -p ${CC_SRC_PATH} >&log.txt
res=$?
cat log.txt
verifyResult $res "Chaincode installation on peer${PEER}.org${ORG} has failed"

CORE_PEER_ADDRESS=peer0.org2.example.com:7051
CORE_PEER_LOCALMSPID="Org2MSP"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
PEER=0
ORG=2
LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/chaincode_example02/node/
VERSION=${3:-1.0}
peer chaincode install -n mycc -v ${VERSION} -l ${LANGUAGE} -p ${CC_SRC_PATH} >&log.txt
res=$?
cat log.txt
verifyResult $res "Chaincode installation on peer${PEER}.org${ORG} has failed"

#............instantiateChaincode for all peers..........
PEER=0
ORG=1
VERSION=${3:-1.0}
CORE_PEER_LOC  ALMSPID=Org1MSP
GRPC_GO_LOG_SEVERITY_LEVEL=info
GRPC_GO_LOG_VERBOSITY_LEVEL=2
ORDERER_GENERAL_TLS_ENABLED=true
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -l ${LANGUAGE} -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')" >&log.txt
res=$?
cat log.txt
verifyResult $res "Chaincode instantiation on peer${PEER}.org${ORG} on channel '$CHANNEL_NAME' failed"

...chaincodeQuery..
PEER=0
ORG=1
VERSION=${3:-1.0}
EXPECTED_RESULT=$3
local rc=1
local starttime=$(date +%s)
echo "Attempting to Query peer${PEER}.org${ORG} ...$(($(date +%s) - starttime)) secs"
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}' >&log.txt
res=$?
cat log.txt
test $res -eq 0 && VALUE=$(cat log.txt | awk '/Query Result/ {print $NF}')
test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
test $rc -ne 0 && VALUE=$(cat log.txt | egrep '^[0-9]+$')
test "$VALUE" = "$EXPECTED_RESULT" && let rc=0


parsePeerConnectionParameters() {
  # check for uneven number of peer and org parameters
  # ($#)means shell script can check how many parameters are given with code
  if [ $(($# % 2)) -ne 0 ]; then
    exit 1
  fi

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    PEER="peer$1.org$2"
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $PEER.example.com:7051"
    if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "true" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$1_ORG$2_CA")
      PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    fi
    # shift by two to get the next pair of peer/org parameters
    shift
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

parsePeerConnectionParameters 0 1 0 2
res=$?
verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "
peer chaincode invoke -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc $PEER_CONN_PARMS -c '{"Args":["invoke","a","b","10"]}' >&log.txt
cat log.txt
#echo $parsePeerConnectionParameters
verifyResult $res "Invoke execution on $PEERS failed "