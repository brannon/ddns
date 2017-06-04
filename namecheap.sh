#!/bin/bash

DATEFMT='+%Y-%m-%dT%H:%M:%S'

fatal() {
    echo "$(date $DATEFMT) FATAL: $1"
    exit 1
}

log() {
    echo "$(date $DATEFMT) $1"
}

log "Updating DDNS A record"

IP=$(curl -sSL -H 'Accept: application/json' https://ipinfo.io/ | jq -r '.ip')

if [ -z "$IP" ]; then
    fatal 'Unable to detect IP address'
fi

log "Detected public IP: $IP"

if [ -z "$DDNS_HOST" ]; then
    fatal 'Missing DDNS_HOST variable'
fi

if [ -z "$DDNS_DOMAIN" ]; then
    fatal 'Missing DDNS_DOMAIN variable'
fi

if [ -z "$DDNS_PASSWORD" ]; then
    fatal 'Missing DDNS_PASSWORD variable'
fi

RESULT=$(curl -sSL -H 'Accept: application/json' "https://dynamicdns.park-your-domain.com/update?host=${DDNS_HOST}&domain=${DDNS_DOMAIN}&password=${DDNS_PASSWORD}&ip=${IP}")
RC=$?
if [ $RC -ne 0 ]; then
    log 'Error updating DDNS A record!'
    log 'Response was: '
    log $RESULT
    log ''
    exit $RC
fi

log 'DDNS A record updated'

