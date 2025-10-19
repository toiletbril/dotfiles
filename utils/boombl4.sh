#!/bin/sh

set -eu

slash_to_comma() {
  printf '%s\n' "$1" | tr '/' ','
}

if test "$#" -lt 1; then
  printf '%s\n' "USAGE: $0 <album-root>"
  exit 1
fi

ROOT=$1
test -d "$ROOT" || { printf '%s\n' "ERROR: '$ROOT' is not a directory" >&2; exit 1; }

find "$ROOT" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r DIR; do
  printf 'entering %s\n' "$DIR"

  FIRST_AUDIO=$(find "$DIR" -type f \( -iname '*.flac' -o -iname '*.mp3' \) | head -n 1)
  test -n "$FIRST_AUDIO" || continue

  ALBUM=$(ffprobe -v error -show_entries format_tags=album  -of default=nw=1:nk=1 "$FIRST_AUDIO")
  ARTIST=$(ffprobe -v error -show_entries format_tags=artist -of default=nw=1:nk=1 "$FIRST_AUDIO")
  YEAR_RAW=$(ffprobe -v error -show_entries format_tags=date  -of default=nw=1:nk=1 "$FIRST_AUDIO")

  YEAR=$(printf '%s\n' "$YEAR_RAW" | sed -n 's/^\([0-9]\{4\}\).*/\1/p')
  test -n "$YEAR" || YEAR='0000'

  find "$DIR" -type f \( -iname '*.flac' -o -iname '*.mp3' \) | while IFS= read -r FILE; do
    RAW=$(ffprobe -v error -show_entries format_tags=track -of default=nw=1:nk=1 "$FILE")
    TNUM=${RAW%%/*}; test -n "$TNUM" || TNUM=0
    TNUM=${TNUM##0}; test -n "$TNUM" || TNUM=0
    NUM="$(printf '%02d' "$TNUM")"

    TITLE=$(ffprobe -v error -show_entries format_tags=title -of default=nw=1:nk=1 "$FILE")
    SAFE_TITLE="$(slash_to_comma "$TITLE")"
    EXT="${FILE##*.}"

    NEW_NAME="${NUM} - ${SAFE_TITLE}.${EXT}"
    TARGET="$(dirname "$FILE")/$NEW_NAME"

    if test ! -e "$TARGET"; then
      printf 'renaming %s -> %s\n' "$FILE" "$TARGET"
      mv -- "$FILE" "$TARGET"
    fi
  done

  NEW_DIR=$(slash_to_comma "${YEAR} - ${ARTIST} - ${ALBUM}")
  DEST="$ROOT/$NEW_DIR"
  if test "$DIR" != "$DEST" && test ! -e "$DEST"; then
    printf 'renaming %s -> %s\n' "$DIR" "$DEST"
    mv -- "$DIR" "$DEST"
  fi
done
