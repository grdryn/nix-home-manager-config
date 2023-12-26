#!/bin/bash

BITWARDEN_ITEM_NAME="${1}"  # The name of the Bitwarden item containing AWS credentials

BITWARDEN_CLI="bw"

# Get Bitwarden item details
BITWARDEN_ITEM=$("${BITWARDEN_CLI}" get item "${BITWARDEN_ITEM_NAME}" --raw)

get_session_token() {
    export AWS_ACCESS_KEY_ID=$(echo "${BITWARDEN_ITEM}" | jq -r '.fields[] | select(.name=="ACCESS_KEY_ID") | .value')
    export AWS_SECRET_ACCESS_KEY=$(echo "${BITWARDEN_ITEM}" | jq -r '.fields[] | select(.name=="SECRET_ACCESS_KEY") | .value')

    if [[ -n "${AWS_ACCESS_KEY_ID}" && -n "${AWS_SECRET_ACCESS_KEY}" ]]; then
        STS_SESSION_TOKEN_RES=$(aws sts get-session-token | jq '.Credentials')
        RESPONSE=$(jq '. += { Version: 1 }' <<< "${STS_SESSION_TOKEN_RES}")
        echo "${RESPONSE}"
    else
        echo "Error: Unable to retrieve AWS credentials from Bitwarden."
        echo "Make sure the vault is unlocked, using bw unlock"
        exit 1
    fi
}

get_session_token
