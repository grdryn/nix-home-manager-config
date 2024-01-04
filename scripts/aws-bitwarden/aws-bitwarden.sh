#!/bin/bash

#   Copyright 2024 Gerard Ryan
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


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
