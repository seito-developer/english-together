#!/bin/sh
# Minimal assertion helpers shared by the test scripts.

PASS=0
FAIL=0

assert_eq() {
  # assert_eq <expected> <actual> <description>
  if [ "$1" = "$2" ]; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    printf 'FAIL: %s\n  expected: %s\n  actual:   %s\n' "$3" "$1" "$2"
  fi
}

assert_contains() {
  # assert_contains <haystack> <needle> <description>
  case "$1" in
    *"$2"*) PASS=$((PASS + 1)) ;;
    *) FAIL=$((FAIL + 1)); printf 'FAIL: %s\n  missing: %s\n' "$3" "$2" ;;
  esac
}

assert_fails() {
  # assert_fails <description> <command...>
  desc=$1; shift
  if "$@" >/dev/null 2>&1; then
    FAIL=$((FAIL + 1))
    printf 'FAIL: %s (command succeeded)\n' "$desc"
  else
    PASS=$((PASS + 1))
  fi
}

finish() {
  printf '%s: %d passed, %d failed\n' "$(basename "$0")" "$PASS" "$FAIL"
  [ "$FAIL" -eq 0 ]
}
