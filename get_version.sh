#!/usr/bin/env bash
# ------------------------------------------------------------------
# Liest die Version aus der About-Seite des HTS-Systems aus.
# Aufruf:  ./get_version.sh mirror        # oder prerelease
# ------------------------------------------------------------------

set -euo pipefail

ENV=${1:-mirror}          # default = mirror

case "$ENV" in
  mirror)      BASE="https://mirror.hogrefe-ws.com/HTSMirror"      ;;
  prerelease)  BASE="https://eval.hogrefe-ws.com/HTSPrerelease"    ;;
  *)           echo "Usage: $0 [mirror|prerelease]" >&2 ; exit 1   ;;
esac

URL="$BASE/main?ln=de-DE&to=About"

# Seite abrufen  –  -L folgt Redirects, --tlsv1.2 erzwingt aktuelles TLS
HTML=$(curl -fsSL --proto '=https' --tlsv1.2 "$URL") || {
  echo "❌ curl failed on $URL" >&2 ; exit 1 ; }

# »Version 5.4.9-b927b2e«   →  5.4.9-b927b2e
VERSION=$(printf '%s\n' "$HTML" |
          grep -Eio 'Version[^0-9]*[0-9]+\.[0-9]+\.[0-9]+-[A-Za-z0-9]+' |
          head -n1 |
          awk '{print $NF}')

if [[ -z "$VERSION" ]]; then
  echo "❌ no version string found on $ENV" >&2
  exit 1
fi

echo "✅ Version number on $ENV: $VERSION"