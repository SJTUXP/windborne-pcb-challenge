#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYLOAD="$SCRIPT_DIR/application_payload.json"

if [[ ! -f "$PAYLOAD" ]]; then
  echo "application_payload.json was not found. Copy and edit application_payload_template.json first." >&2
  exit 1
fi

if grep -q "YOUR_USERNAME" "$PAYLOAD"; then
  echo "Replace YOUR_USERNAME before submitting." >&2
  exit 1
fi

status="$(
  curl \
    --silent \
    --show-error \
    --output response_body.txt \
    --write-out "%{http_code}" \
    --request POST \
    --header "Content-Type: application/json" \
    --data @"$PAYLOAD" \
    "https://windbornesystems.com/career_applications.json"
)"

echo "Status: $status"
echo "Response:"
cat response_body.txt
echo

if [[ "$status" != "200" ]]; then
  echo "Application was not accepted. Review response_body.txt." >&2
  exit 1
fi
