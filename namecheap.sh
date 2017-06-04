#!/bin/bash

IP=$(curl -sSL -H 'Accept: application/json' https://ipinfo.io/ | jq -r '.ip')

if [ -z "$IP" ]; then
    echo 'Unable to detect IP address'
    exit 1
fi

echo "Detected public IP: $IP"

if [ -z "$DDNS_HOST" ]; then
    echo 'Missing DDNS_HOST variable'
    exit 1
fi

if [ -z "$DDNS_DOMAIN" ]; then
    echo 'Missing DDNS_DOMAIN variable'
    exit 1
fi

if [ -z "$DDNS_PASSWORD" ]; then
    echo 'Missing DDNS_PASSWORD variable'
    exit 1
fi

RESULT=$(curl -sSL -H 'Accept: application/json' "https://dynamicdns.park-your-domain.com/update?host=${DDNS_HOST}&domain=${DDNS_DOMAIN}&password=${DDNS_PASSWORD}&ip=${IP}")
RC=$?
if [ $RC -ne 0 ]; then
    echo 'Error updating DDNS A record!'
    echo 'Response was: '
    echo $RESULT
    echo ''
    exit $RC
fi

echo 'DDNS A record updated'

