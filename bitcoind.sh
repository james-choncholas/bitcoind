#!/bin/bash
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
random_pw=$(dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64)

# port 8333 is remote access
# port 8332 is for local RPC

# check if a container is running
if [ "$(sudo docker ps -q -f name=bitcoind)" ]; then
    echo "stopping containter"
    sudo docker stop bitcoind -t0
    sudo docker rm $(sudo docker ps --filter=status=exited --filter=status=created -q)
fi
echo "starting bitcoind container"
sudo docker run -d \
    --name=bitcoind \
    -p 8333:8333 \
    -p 127.0.0.1:8332:8332 \
    -e DISABLEWALLET=1 \
    -e PRINTTOCONSOLE=1 \
    -e REST=1 \
    -e SERVER=1 \
    -e TXINDEX=1 \
    -e RPCUSER=btcrpc \
    -e RPCPASSWORD=$random_pw \
    -e MAXCONNECTIONS=25 \
    -e MAXUPLOADTARGET=0 \
    -v /mnt/harddrive/bitcoin:/bitcoin \
    --cpus=1 \
    bitcoind

echo "tailing logs file"
sudo docker logs -f bitcoind


# To connect to the container:
#sudo docker exec -it bitcoind bash -l
# then you can run bitcoin-cli getconnectioncount or getblockchaininfo

# To test the command line interface:
#echo -e "\n\nTesting cli"
#sudo docker exec bitcoind bitcoin-cli -rpcuser=btcrpc -rpcpassword=lol getconnectioncount

# To test the RPC interface 
#echo -e "\n\nTesting rpc"
#curl -v --user btcrpc:lol \
#    --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' \
#    -H 'content-type: text/plain;' \
#    http://127.0.0.1:8332/
