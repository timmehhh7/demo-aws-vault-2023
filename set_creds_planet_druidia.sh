#! /bin/bash

RAW_JSON=$(vault write -format=json aws-demo/sts/aws-demo-planet-druidia -ttl=15m)

export AWS_ACCESS_KEY_ID=$(echo $RAW_JSON | jq -r .data.access_key)
export AWS_SECRET_ACCESS_KEY=$(echo $RAW_JSON | jq -r .data.secret_key)
export AWS_SESSION_TOKEN=$(echo $RAW_JSON | jq -r .data.security_token)
