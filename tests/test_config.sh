#!/bin/sh
# Unit tests for skills/english-together/scripts/config.sh
# Usage: sh tests/test_config.sh

ROOT=$(cd "$(dirname "$0")/.." && pwd)
CONFIG_SH="$ROOT/skills/english-together/scripts/config.sh"
. "$ROOT/tests/lib.sh"

TMPDIR_T=$(mktemp -d)
trap 'rm -rf "$TMPDIR_T"' EXIT
export ENGLISH_TOGETHER_CONFIG="$TMPDIR_T/nested/config"

run() { sh "$CONFIG_SH" "$@"; }

# --- defaults when no config file exists
assert_eq "enabled=false
ratio=20
correction=on" "$(run show)" "show prints defaults without a config file"
assert_eq "20" "$(run get ratio)" "get ratio default"
assert_eq "false" "$(run get enabled)" "get enabled default"

# --- set ratio, including rounding and % suffix
run set ratio 30 >/dev/null
assert_eq "30" "$(run get ratio)" "set ratio 30"
assert_eq "1" "$([ -f "$ENGLISH_TOGETHER_CONFIG" ] && echo 1)" "config file is created in nested dir"
run set ratio 35 >/dev/null
assert_eq "40" "$(run get ratio)" "35 rounds up to 40"
run set ratio 34 >/dev/null
assert_eq "30" "$(run get ratio)" "34 rounds down to 30"
run set ratio 50% >/dev/null
assert_eq "50" "$(run get ratio)" "accepts % suffix"
run set ratio 0 >/dev/null
assert_eq "0" "$(run get ratio)" "accepts 0"
run set ratio 100 >/dev/null
assert_eq "100" "$(run get ratio)" "accepts 100"

# --- invalid ratios are rejected and leave the value unchanged
assert_fails "rejects 101" run set ratio 101
assert_fails "rejects -10" run set ratio -10
assert_fails "rejects non-number" run set ratio abc
assert_fails "rejects empty" run set ratio ""
assert_eq "100" "$(run get ratio)" "value unchanged after invalid input"

# --- enabled / correction toggles
run set enabled on >/dev/null
assert_eq "true" "$(run get enabled)" "enabled on -> true"
run set enabled false >/dev/null
assert_eq "false" "$(run get enabled)" "enabled false -> false"
run set enabled true >/dev/null
assert_eq "true" "$(run get enabled)" "enabled true -> true"
run set correction off >/dev/null
assert_eq "off" "$(run get correction)" "correction off"
run set correction on >/dev/null
assert_eq "on" "$(run get correction)" "correction on"
assert_fails "rejects enabled maybe" run set enabled maybe
assert_fails "rejects correction yes-please" run set correction yes-please

# --- other keys are preserved across sets
assert_eq "enabled=true
ratio=100
correction=on" "$(run show)" "show reflects all keys"

# --- broken config values fall back to defaults
printf 'enabled=banana\nratio=999\ncorrection=\ngarbage line\n' > "$ENGLISH_TOGETHER_CONFIG"
assert_eq "enabled=false
ratio=20
correction=on" "$(run show)" "invalid stored values fall back to defaults"

# --- unknown commands / keys
assert_fails "rejects unknown command" run frobnicate
assert_fails "rejects unknown key" run set colour blue
assert_fails "rejects get unknown key" run get colour

finish
