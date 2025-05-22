#!/usr/bin/env bash
# ---------------------------------------------------------------------------
#  Ruft die HTS-About-Seite auf und extrahiert die Versionsnummer.
#  Aufruf:
#     ./get_version.sh mirror        # Standard
#     ./get_version.sh prerelease
#  Die Seite ist öffentlich erreichbar – kein Login nötig.
# ---------------------------------------------------------------------------

set -u    # undefined-vars stoppen (KEIN set -e / pipefail hier!)

ENV=${1:-mirror}        # default = mirror

case "$ENV" in
  mirror)      BASE="https://mirror.hogrefe-ws.com/HTSMirror"     ;;
  prerelease)  BASE="https://eval.hogrefe-ws.com/HTSPrerelease"   ;;
  *)
    echo "Usage: $0 [mirror|prerelease]" >&2
    exit 1
    ;;
esac

URL="$BASE/main#ln=de-DE&to=About"

# Seite abrufen  (-k = TLS-Warnungen ignorieren, -L = Redirects folgen)
HTML=$(curl -skL -H "Referer: $BASE/main" "$URL") || {
  echo "❌  curl failed – cannot reach $URL" >&2
  exit 1
}

#   … Version 5.4.9-b927b2e  …  →  5.4.9-b927b2e
VERSION=$(echo "$HTML" \
            | grep -Eo 'Version[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+-[a-z0-9]+' \
            | head -n1 \
            | awk '{print $2}')

if [[ -z "$VERSION" ]]; then
  echo "❌  no version string found on $ENV" >&2
  exit 1
fi

echo "✅  Version number on $ENV: $VERSION"

