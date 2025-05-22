#!/usr/bin/env bash
# Aufruf: ./get_version.sh mirror   oder   ./get_version.sh prerelease

set -euo pipefail

ENV=${1:-mirror}                       # Default: mirror

case "$ENV" in
  mirror)      BASE="https://mirror.hogrefe-ws.com/HTSMirror" ;;
  prerelease)  BASE="https://eval.hogrefe-ws.com/HTSPrerelease" ;;
  *) echo "Usage: $0 [mirror|prerelease]" && exit 1 ;;
esac

URL="$BASE/main#ln=de-DE&to=About"

# Seite abrufen
HTML=$(curl -fsSL "$URL")

# „Version 5.4.9-b927b2e“ → b927b2e herausfiltern
VERSION=$(echo "$HTML" \
          | grep -Eo 'Version [0-9]+\.[0-9]+\.[0-9]+-[a-z0-9]+' \
          | head -n1 \
          | awk '{print $2}')

echo "Version number on $ENV: $VERSION"
