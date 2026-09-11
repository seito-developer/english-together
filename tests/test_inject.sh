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

# --- disabled (default): no output, exit 0
assert_eq "" "$(sh "$INJECT" session)" "session: no output when disabled"
assert_eq "" "$(sh "$INJECT" prompt)" "prompt: no output when disabled"
sh "$INJECT" prompt >/dev/null; assert_eq "0" "$?" "prompt: exit 0 when disabled"

# --- enabled
sh "$CONFIG_SH" set enabled on >/dev/null
sh "$CONFIG_SH" set ratio 30 >/dev/null
sh "$CONFIG_SH" set correction off >/dev/null

session_out=$(sh "$INJECT" session)
assert_contains "$session_out" "english-together is ON" "session: header"
assert_contains "$session_out" "English ratio: 30%" "session: ratio"
assert_contains "$session_out" "correction: off" "session: correction"
assert_contains "$session_out" "## 3. Never mix these" "session: includes rules.md"

prompt_out=$(sh "$INJECT" prompt)
assert_contains "$prompt_out" '"hookEventName":"UserPromptSubmit"' "prompt: event name"
assert_contains "$prompt_out" "English ratio 30%, correction off" "prompt: settings in reminder"

if command -v python3 >/dev/null 2>&1; then
  printf '%s' "$prompt_out" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["hookSpecificOutput"]["additionalContext"]' 2>/dev/null
  assert_eq "0" "$?" "prompt: output is valid JSON with additionalContext"
fi

# --- hook input on stdin is ignored safely
prompt_stdin=$(printf '{"prompt":"hello"}' | sh "$INJECT" prompt)
assert_eq "$prompt_out" "$prompt_stdin" "prompt: same output with stdin payload"

# --- unknown mode: silent, exit 0 (hooks must never block the conversation)
assert_eq "" "$(sh "$INJECT" bogus)" "unknown mode: no output"
sh "$INJECT" bogus >/dev/null 2>&1; assert_eq "0" "$?" "unknown mode: exit 0"

finish
