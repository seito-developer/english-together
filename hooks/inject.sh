#!/bin/sh
# english-together hook: injects the mixing rules and current settings.
#
# Usage:
#   inject.sh session   SessionStart: print rules.md and settings as plain text
#   inject.sh prompt    UserPromptSubmit: print a one-line reminder as hook JSON
#
# Prints nothing when the mode is off. Always exits 0 so it never blocks the
# conversation.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SKILL_DIR="$ROOT/skills/english-together"
CONFIG_SH="$SKILL_DIR/scripts/config.sh"

# Drain the hook payload on stdin; it is not needed.
[ -t 0 ] || cat >/dev/null

enabled=$(sh "$CONFIG_SH" get enabled 2>/dev/null) || exit 0
[ "$enabled" = "true" ] || exit 0
ratio=$(sh "$CONFIG_SH" get ratio 2>/dev/null) || exit 0
correction=$(sh "$CONFIG_SH" get correction 2>/dev/null) || exit 0

case "$1" in
  session)
    printf 'english-together is ON (English ratio: %s%%, correction: %s).\n' "$ratio" "$correction"
    printf 'Follow the rules below in every reply. The user can change this with /english-together <0-100|on|off|correct on|off|status>.\n\n'
    cat "$SKILL_DIR/references/rules.md" 2>/dev/null
    ;;
  prompt)
    printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[english-together] ON — English ratio %s%%, correction %s. Follow the english-together mixing rules."}}\n' "$ratio" "$correction"
    ;;
esac

exit 0
