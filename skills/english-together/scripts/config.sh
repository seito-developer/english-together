#!/bin/sh
# english-together settings helper (POSIX sh, no dependencies).
#
# Usage:
#   config.sh show                      print all settings as key=value
#   config.sh get <key>                 print one value (enabled|ratio|correction)
#   config.sh set ratio <0-100>         rounded to the nearest 10 ("30%" also ok)
#   config.sh set enabled on|off
#   config.sh set correction on|off
#
# Settings file: $ENGLISH_TOGETHER_CONFIG or ~/.config/english-together/config

CONFIG_FILE=${ENGLISH_TOGETHER_CONFIG:-"$HOME/.config/english-together/config"}

DEFAULT_ENABLED=false
DEFAULT_RATIO=20
DEFAULT_CORRECTION=on

die() {
  printf 'english-together: %s\n' "$1" >&2
  exit 1
}

# Normalizes a ratio to a multiple of 10 in 0..100. Prints nothing if invalid.
normalize_ratio() {
  n=${1%%%}
  case "$n" in
    '' | *[!0-9]*) return 1 ;;
  esac
  [ ${#n} -le 3 ] || return 1
  n=$(printf '%s' "$n" | sed 's/^0*//')
  n=${n:-0}
  [ "$n" -le 100 ] || return 1
  echo $(( (n + 5) / 10 * 10 ))
}

normalize_enabled() {
  case "$1" in
    on | true) echo true ;;
    off | false) echo false ;;
    *) return 1 ;;
  esac
}

normalize_correction() {
  case "$1" in
    on | true) echo on ;;
    off | false) echo off ;;
    *) return 1 ;;
  esac
}

load() {
  enabled=$DEFAULT_ENABLED
  ratio=$DEFAULT_RATIO
  correction=$DEFAULT_CORRECTION
  [ -r "$CONFIG_FILE" ] || return 0
  while IFS='=' read -r key value || [ -n "$key" ]; do
    case "$key" in
      enabled) v=$(normalize_enabled "$value") && enabled=$v ;;
      ratio) v=$(normalize_ratio "$value") && ratio=$v ;;
      correction) v=$(normalize_correction "$value") && correction=$v ;;
    esac
  done < "$CONFIG_FILE"
}

show() {
  printf 'enabled=%s\nratio=%s\ncorrection=%s\n' "$enabled" "$ratio" "$correction"
}

save() {
  dir=$(dirname "$CONFIG_FILE")
  mkdir -p "$dir" || die "cannot create $dir"
  tmp="$CONFIG_FILE.tmp.$$"
  show > "$tmp" && mv "$tmp" "$CONFIG_FILE" || {
    rm -f "$tmp"
    die "cannot write $CONFIG_FILE"
  }
}

load

case "$1" in
  show)
    show
    ;;
  get)
    case "$2" in
      enabled) echo "$enabled" ;;
      ratio) echo "$ratio" ;;
      correction) echo "$correction" ;;
      *) die "unknown key '$2' (use enabled, ratio or correction)" ;;
    esac
    ;;
  set)
    case "$2" in
      ratio) ratio=$(normalize_ratio "$3") || die "ratio must be a number from 0 to 100 (got '$3')" ;;
      enabled) enabled=$(normalize_enabled "$3") || die "enabled must be on or off (got '$3')" ;;
      correction) correction=$(normalize_correction "$3") || die "correction must be on or off (got '$3')" ;;
      *) die "unknown key '$2' (use enabled, ratio or correction)" ;;
    esac
    save
    show
    ;;
  *)
    die "usage: config.sh show | get <key> | set <key> <value>"
    ;;
esac
