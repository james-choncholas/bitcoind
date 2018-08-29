#!/bin/bash
set -e

echo -e "\n\nTesting cli"
sudo docker exec bitcoind bitcoin-cli -rpcuser=btcrpc -rpcpassword=lol getconnectioncount

echo -e "\n\nTesting rpc"
curl -v --user btcrpc:lol \
    --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' \
    -H 'content-type: text/plain;' \
    http://127.0.0.1:8332/
