#!/usr/bin/env bash
# Exports BomberGame as a standalone application for the current OS and zips it into dist/.
# Usage: scripts/export.sh   (needs `processing-java` in PATH and the Pathfinder library installed)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# Processing 4.4+ ships `Processing cli` instead of `processing-java`.
if command -v processing-java >/dev/null 2>&1; then
  PROC=(processing-java)
elif command -v Processing >/dev/null 2>&1; then
  PROC=(Processing cli)
else
  echo "processing-java / Processing not found in PATH." >&2
  exit 1
fi

# Processing requires the sketch folder name to match the main .pde file name.
SKETCH="$ROOT"
if [ "$(basename "$ROOT")" != "BomberGame" ]; then
  SKETCH="$STAGE/BomberGame"
  mkdir -p "$SKETCH"
  tar -C "$ROOT" --exclude=.git --exclude=dist -cf - . | tar -C "$SKETCH" -xf -
fi

case "$(uname -s)" in
  Linux*)  PLATFORM=linux ;;
  Darwin*) PLATFORM=macos ;;
  MINGW*|MSYS*|CYGWIN*) PLATFORM=windows ;;
  *) PLATFORM=unknown ;;
esac

OUT="$STAGE/BomberGame-$PLATFORM"
"${PROC[@]}" --sketch="$SKETCH" --output="$OUT" --force --export

mkdir -p "$DIST"
(cd "$STAGE" && zip -qr "$DIST/BomberGame-$PLATFORM.zip" "BomberGame-$PLATFORM")
echo "Created $DIST/BomberGame-$PLATFORM.zip"
