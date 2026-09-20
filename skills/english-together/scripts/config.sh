#!/bin/sh
# english-together settings helper (POSIX sh, no dependencies).
#
# Usage:
#   config.sh show                       print all settings as key=value
#   config.sh get <key>                  print one value
#   config.sh set ratio <0-100>          share of the learning language,
#                                        rounded to the nearest 10 ("30%" also ok)
#   config.sh set enabled on|off
#   config.sh set correction on|off
#   config.sh set direction ja2en|en2ja  ja2en: Japanese speaker learning English
#                                        en2ja: English speaker learning Japanese
#   config.sh set adaptive on|off
#   config.sh adapt down                 the user asked for their own language:
#                                        lower the ratio by 10 and reset the counter
#   config.sh adapt tick                 one session started smoothly: count it, and
#                                        raise the ratio by 10 after SMOOTH_TARGET
#
# `adapt` does nothing while adaptive=off. It prints the settings plus
# "raised=true" or "lowered=true" when it changed the ratio.
#
# Settings file: $ENGLISH_TOGETHER_CONFIG or ~/.config/english-together/config

CONFIG_FILE=${ENGLISH_TOGETHER_CONFIG:-"$HOME/.config/english-together/config"}

DEFAULT_ENABLED=false
DEFAULT_RATIO=20
DEFAULT_CORRECTION=on
DEFAULT_DIRECTION=ja2en
DEFAULT_ADAPTIVE=on
DEFAULT_SMOOTH_SESSIONS=0

# Smooth sessions needed before the ratio goes up by one step.
SMOOTH_TARGET=3
STEP=10

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

normalize_switch() {
  case "$1" in
    on | true) echo on ;;
    off | false) echo off ;;
    *) return 1 ;;
  esac
}

normalize_direction() {
  case "$1" in
    ja2en | en2ja) echo "$1" ;;
    *) return 1 ;;
  esac
}

normalize_count() {
  case "$1" in
    '' | *[!0-9]*) return 1 ;;
  esac
  [ ${#1} -le 2 ] || return 1
  echo $(( 1 * $1 ))
}

load() {
  enabled=$DEFAULT_ENABLED
  ratio=$DEFAULT_RATIO
  correction=$DEFAULT_CORRECTION
  direction=$DEFAULT_DIRECTION
  adaptive=$DEFAULT_ADAPTIVE
  smooth_sessions=$DEFAULT_SMOOTH_SESSIONS
  [ -r "$CONFIG_FILE" ] || return 0
  while IFS='=' read -r key value || [ -n "$key" ]; do
    case "$key" in
      enabled) v=$(normalize_enabled "$value") && enabled=$v ;;
      ratio) v=$(normalize_ratio "$value") && ratio=$v ;;
      correction) v=$(normalize_switch "$value") && correction=$v ;;
      direction) v=$(normalize_direction "$value") && direction=$v ;;
      adaptive) v=$(normalize_switch "$value") && adaptive=$v ;;
      smooth_sessions) v=$(normalize_count "$value") && smooth_sessions=$v ;;
    esac
  done < "$CONFIG_FILE"
}

show() {
  printf 'enabled=%s\nratio=%s\ncorrection=%s\ndirection=%s\nadaptive=%s\nsmooth_sessions=%s\n' \
    "$enabled" "$ratio" "$correction" "$direction" "$adaptive" "$smooth_sessions"
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
      direction) echo "$direction" ;;
      adaptive) echo "$adaptive" ;;
      smooth_sessions) echo "$smooth_sessions" ;;
      *) die "unknown key '$2'" ;;
    esac
    ;;
  set)
    case "$2" in
      ratio) ratio=$(normalize_ratio "$3") || die "ratio must be a number from 0 to 100 (got '$3')" ;;
      enabled) enabled=$(normalize_enabled "$3") || die "enabled must be on or off (got '$3')" ;;
      correction) correction=$(normalize_switch "$3") || die "correction must be on or off (got '$3')" ;;
      direction) direction=$(normalize_direction "$3") || die "direction must be ja2en or en2ja (got '$3')" ;;
      adaptive) adaptive=$(normalize_switch "$3") || die "adaptive must be on or off (got '$3')" ;;
      *) die "unknown key '$2'" ;;
    esac
    save
    show
    ;;
  adapt)
    case "$2" in
      down)
        [ "$adaptive" = on ] || exit 0
        smooth_sessions=0
        if [ "$ratio" -gt 0 ]; then
          ratio=$(( ratio - STEP ))
          save
          show
          echo "lowered=true"
        else
          save
          show
        fi
        ;;
      tick)
        [ "$adaptive" = on ] || exit 0
        if [ "$ratio" -ge 100 ]; then
          exit 0
        fi
        smooth_sessions=$(( smooth_sessions + 1 ))
        if [ "$smooth_sessions" -ge "$SMOOTH_TARGET" ]; then
          ratio=$(( ratio + STEP ))
          smooth_sessions=0
          save
          show
          echo "raised=true"
        else
          save
          show
        fi
        ;;
      *)
        die "usage: config.sh adapt down|tick"
        ;;
    esac
    ;;
  *)
    die "usage: config.sh show | get <key> | set <key> <value> | adapt down|tick"
    ;;
esac
