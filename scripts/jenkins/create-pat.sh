#!/bin/bash -p

# GitHub has no API for creating fine-grained PATs, so this opens the
# token creation page with the name and permissions pre-filled.

read -rp "Enter the name of the PAT: " PAT_NAME
if [ -z "$PAT_NAME" ]; then
  echo "PAT name is required"
  exit 1
fi

read -rp "Expiration in days [90]: " EXPIRES
EXPIRES="${EXPIRES:-90}"

ENCODED_NAME=$(jq -rn --arg n "$PAT_NAME" '$n|@uri')

PERMISSIONS=(
  "actions=write"             # Actions: read/write
  "administration=read"       # Administration: read-only
  "statuses=write"            # Commit statuses: read/write
  "contents=write"            # Contents: read/write
  "dependabot_secrets=write"  # Dependabot secrets: read/write
  "metadata=read"             # Metadata: read-only (required)
  "pull_requests=write"       # Pull requests: read/write
  "secrets=write"             # Secrets: read/write
  "repository_hooks=write"    # Webhooks: read/write
)
QUERY=$(IFS='&'; echo "${PERMISSIONS[*]}")

URL="https://github.com/settings/personal-access-tokens/new?name=${ENCODED_NAME}&expires_in=${EXPIRES}&${QUERY}"

echo "Opening token creation page."
echo "IMPORTANT: under 'Repository access', select 'All repositories' (public and private), then click 'Generate token'."
if command -v open >/dev/null; then
  open "$URL"
elif command -v xdg-open >/dev/null; then
  xdg-open "$URL"
else
  echo "$URL"
fi
