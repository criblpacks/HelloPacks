USE_HTTPS_GIT=$PUBLIC_REPO
# Checks whether a private or public repository is being used.
if [[ "$USE_HTTPS_GIT" == "true" ]]; then
PACK_REPO_URL="$PACK_REPO_HTTPS_URL"
else
PACK_REPO_URL="git+https://$REPO_OWNER:$PACK_REPO_SSH_TOKEN@github.com/$REPO_NAME.git"
fi
# Reads the list of worker groups to install the pack to
WG_LIST="$(pwd)/$CRIBL_WG_LIST"
# Gets the access token to authenticate with the Cribl API
echo "Running auth request"
AUTH_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "https://login.cribl.cloud/oauth/token" \
-H "Content-Type: application/json" \
-d "{\"grant_type\": \"client_credentials\",\"client_id\": \"$CRIBL_CLIENT_ID\", \"client_secret\": \"$CRIBL_CLIENT_SECRET\", \"audience\": \"https://api.cribl.cloud\"}" \
|| exit 1)
AUTH_HTTP_CODE=$(echo "$AUTH_RESPONSE" | tail -n1)
ACCESS_TOKEN=$(echo "$AUTH_RESPONSE" | sed '$d' | jq -r '.access_token')
echo "Checking auth response"
# Checks if the authentication request was successful
if [ "$AUTH_HTTP_CODE" -eq 200 ]; then
echo "Request succeeded with status code $AUTH_HTTP_CODE."
echo "----------------------------------------"
else
echo "Request failed with status code $AUTH_HTTP_CODE."
echo "----------------------------------------"
# Exit on the first non-200 response
exit 1
fi
echo "Running pack install request"
while IFS= read -r WORKERGROUP || [[ -n "$WORKERGROUP" ]]; do
MAIN_ENDPOINT="$CRIBL_ENDPOINT"
WG_ENDPOINT="$MAIN_ENDPOINT/$WORKERGROUP/packs"
INSTALL_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$WG_ENDPOINT" \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-H 'Content-Type: application/json' \
-d "{\"source\": \"$PACK_REPO_URL\",\"force\":$OVERRIDE,\"spec\":\"$PACK_BRANCH\",\"allowCustomFunctions\":false}" \
|| exit 1)
INSTALL_HTTP_CODE=$(echo "$INSTALL_RESPONSE" | tail -n1)
INSTALL_RESPONSE_BODY=$(echo "$INSTALL_RESPONSE" | sed '$d')
INSTALL_PACK_ID=$(echo "$INSTALL_RESPONSE_BODY" | jq -r '.items[0].id')
INSTALL_PACK_VERSION=$(echo "$INSTALL_RESPONSE_BODY" | jq -r '.items[0].version')
# Checks if the pack installation request was successful
if [ "$INSTALL_HTTP_CODE" -eq 200 ]; then
    echo "Pack install request succeeded with status code $INSTALL_HTTP_CODE."
    echo "The pack: $INSTALL_PACK_ID version: $INSTALL_PACK_VERSION was installed to worker group: $WORKERGROUP."
    echo "----------------------------------------"
else
    echo "Pack install request failed with status code $INSTALL_HTTP_CODE."
    echo "----------------------------------------"
    # Exit on the first non-200 response
    exit 1
fi
done < "$WG_LIST"