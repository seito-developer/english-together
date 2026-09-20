#!/bin/sh
# english-together hook: injects the mixing rules and current settings.
#
# Usage:
#   inject.sh session-start   SessionStart (startup): count the session for the
#                             adaptive ratio, then print the rules and settings
#   inject.sh session         SessionStart (resume/clear/compact): print only
#   inject.sh prompt          UserPromptSubmit: print a one-line reminder as JSON
#
# Prints nothing when the mode is off. Always exits 0 so it never blocks the
# conversation.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SKILL_DIR="$ROOT/skills/english-together"
CONFIG_SH="$SKILL_DIR/scripts/config.sh"

# Drain the hook payload on stdin; it is not needed.
[ -t 0 ] || cat >/dev/null

setting() { sh "$CONFIG_SH" get "$1" 2>/dev/null; }

enabled=$(setting enabled) || exit 0
[ "$enabled" = "true" ] || exit 0

raised=""
if [ "$1" = "session-start" ]; then
  case "$(sh "$CONFIG_SH" adapt tick 2>/dev/null)" in
    *raised=true*) raised=yes ;;
  esac
fi

ratio=$(setting ratio) || exit 0
correction=$(setting correction) || exit 0
direction=$(setting direction) || exit 0
adaptive=$(setting adaptive) || exit 0

case "$1" in
  session | session-start)
    printf 'english-together is ON (direction: %s, ratio: %s%%, correction: %s, adaptive: %s).\n' \
      "$direction" "$ratio" "$correction" "$adaptive"
    if [ -n "$raised" ]; then
      printf 'The last few sessions went smoothly, so the ratio just went up to %s%%. Mention this in one short line in your first reply.\n' "$ratio"
    fi
    printf 'Follow the rules below in every reply. The user can change this with /english-together <0-100|on|off|correct on|off|direction ja2en|en2ja|adaptive on|off|status>.\n\n'
    cat "$SKILL_DIR/references/rules-core.md" 2>/dev/null
    printf '\n'
    cat "$SKILL_DIR/references/levels-$direction.md" 2>/dev/null
    ;;
  prompt)
    printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[english-together] ON — %s, ratio %s%%, correction %s, adaptive %s. Follow the english-together mixing rules."}}\n' \
      "$direction" "$ratio" "$correction" "$adaptive"
    ;;
esac

exit 0
