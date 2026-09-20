#!/bin/sh
# Tests for hooks/inject.sh
# Usage: sh tests/test_inject.sh

ROOT=$(cd "$(dirname "$0")/.." && pwd)
INJECT="$ROOT/hooks/inject.sh"
CONFIG_SH="$ROOT/skills/english-together/scripts/config.sh"
. "$ROOT/tests/lib.sh"

TMPDIR_T=$(mktemp -d)
trap 'rm -rf "$TMPDIR_T"' EXIT
export ENGLISH_TOGETHER_CONFIG="$TMPDIR_T/config"

cfg() { sh "$CONFIG_SH" "$@" >/dev/null; }

# --- disabled (default): no output, exit 0
assert_eq "" "$(sh "$INJECT" session </dev/null)" "session: no output when disabled"
assert_eq "" "$(sh "$INJECT" prompt </dev/null)" "prompt: no output when disabled"
assert_eq "" "$(sh "$INJECT" session-start </dev/null)" "session-start: no output when disabled"
sh "$INJECT" prompt </dev/null >/dev/null; assert_eq "0" "$?" "prompt: exit 0 when disabled"
cfg set enabled on
cfg set adaptive on
assert_eq "0" "$(sh "$CONFIG_SH" get smooth_sessions)" "disabled sessions are never counted"

# --- enabled, direction ja2en
cfg set ratio 30
cfg set correction off
cfg set adaptive off

session_out=$(sh "$INJECT" session </dev/null)
assert_contains "$session_out" "english-together is ON" "session: header"
assert_contains "$session_out" "ratio: 30%" "session: ratio"
assert_contains "$session_out" "correction: off" "session: correction"
assert_contains "$session_out" "direction: ja2en" "session: direction"
assert_contains "$session_out" "## 3. Never mix these" "session: includes the core rules"
assert_contains "$session_out" "Level table: ja2en" "session: includes the ja2en levels"
case "$session_out" in
  *"Level table: en2ja"*) assert_eq "absent" "present" "session: must not include the other direction" ;;
  *) assert_eq "absent" "absent" "session: only the current direction is injected" ;;
esac

prompt_out=$(sh "$INJECT" prompt </dev/null)
assert_contains "$prompt_out" '"hookEventName":"UserPromptSubmit"' "prompt: event name"
assert_contains "$prompt_out" "ja2en, ratio 30%, correction off" "prompt: settings in reminder"

if command -v python3 >/dev/null 2>&1; then
  printf '%s' "$prompt_out" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["hookSpecificOutput"]["additionalContext"]' 2>/dev/null
  assert_eq "0" "$?" "prompt: output is valid JSON with additionalContext"
fi

# --- direction en2ja swaps the level table
cfg set direction en2ja
session_out=$(sh "$INJECT" session </dev/null)
assert_contains "$session_out" "Level table: en2ja" "session: includes the en2ja levels"
assert_contains "$session_out" "direction: en2ja" "session: direction en2ja"
cfg set direction ja2en

# --- session-start counts smooth sessions only while adaptive is on
sh "$INJECT" session-start </dev/null >/dev/null
assert_eq "0" "$(sh "$CONFIG_SH" get smooth_sessions)" "session-start: no counting when adaptive is off"

cfg set adaptive on
sh "$INJECT" session-start </dev/null >/dev/null
assert_eq "1" "$(sh "$CONFIG_SH" get smooth_sessions)" "session-start: counts a smooth session"
sh "$INJECT" session </dev/null >/dev/null
assert_eq "1" "$(sh "$CONFIG_SH" get smooth_sessions)" "session (resume/compact): never counts"

sh "$INJECT" session-start </dev/null >/dev/null
raised_out=$(sh "$INJECT" session-start </dev/null)
assert_eq "40" "$(sh "$CONFIG_SH" get ratio)" "session-start: raises the ratio on the third smooth session"
assert_contains "$raised_out" "just went up to 40%" "session-start: announces the new ratio"
assert_contains "$raised_out" "Level table: ja2en" "session-start: still injects the rules"

# --- hook input on stdin is ignored safely
prompt_stdin=$(printf '{"prompt":"hello"}' | sh "$INJECT" prompt)
assert_eq "$(sh "$INJECT" prompt </dev/null)" "$prompt_stdin" "prompt: same output with stdin payload"

# --- unknown mode: silent, exit 0 (hooks must never block the conversation)
assert_eq "" "$(sh "$INJECT" bogus </dev/null)" "unknown mode: no output"
sh "$INJECT" bogus </dev/null >/dev/null 2>&1; assert_eq "0" "$?" "unknown mode: exit 0"

finish
