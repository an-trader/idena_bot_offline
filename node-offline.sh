#!/bin/bash

PORT=9009
API_KEY=$(cat $HOME/idena/datadir/api.key)
DNA_ADDRESS=$(curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d '{"method": "dna_getCoinbaseAddr","params":[],"id": 8,"key":"'$API_KEY'"}' | jq -r '.result')
TOKEN="Token_TG_bot"
CHAT_ID="ID_your_TG"

URL="https://api.telegram.org/bot$TOKEN/sendMessage"


DATA='{"method": "dna_identity","params":["'$DNA_ADDRESS'"],"id": 0,"key":"'$API_KEY'"}'
RESULT=$(curl http://127.0.0.1:$PORT -H "content-type:application/json;" -d "$DATA")
STATUS=$(echo $RESULT | jq -r '.result.online')


if [ $STATUS = "true" ]; then
        echo "Node_online"
else
        EMOJ="\xF0\x9F\x94\xB4"
        TIME_OFF="$(date +%d).$(date +%m).$(date +%y) $(date +%H):$(date +%M)"
        MESSAGE="Idena Offline"
        DNA_URL="https://scan.idena.io/address/0x............."
        curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$(echo -e "$TIME_OFF    $MESSAGE $EMOJ\n$DNA_URL")"
fi