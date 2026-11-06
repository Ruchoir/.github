#!/usr/bin/env bash
# Checks the conventions shared by every Ruchoir repository. Run it from the root of a git checkout.
#
# Usage: check-conventions.sh <common-rules-file>
#
# Optional environment:
#   RANGE     a <base>..<head> range: every commit in it must have a Conventional Commit subject
#             and no ticket identifier
#   PR_TITLE  a pull request title: it becomes the squash commit, so it follows the same rules
#   BRANCH    a branch name: `feat/`, `fix/`, ... then a short kebab-case name
#
# Every problem is reported as a GitHub Actions `::error::` line, and the script exits 1 if there
# was any. It never stops at the first one, so a single run lists everything to fix.

set -uo pipefail

rules_file="${1:?usage: check-conventions.sh <common-rules-file>}"
status=0
fail() {
  echo "::error::$*"
  status=1
}

conventional='^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-z0-9./-]+\))?!?: .+'
branch_name='^((build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)/[a-z0-9][a-z0-9.-]*|revert-[0-9]+-.+)$'
ticket='\bRUC-[0-9]+\b'

# Built from bytes, so this file never contains what it looks for.
em_dash="$(printf '\342\200\224')"
robot="$(printf '\360\237\244\226')"
ai_attribution="Co-[Aa]uthored-[Bb]y:.*(Claude|Copilot|ChatGPT|GPT-|Anthropic|OpenAI|Cursor|Gemini)|[Gg]enerated (with|by) (Claude|Copilot|ChatGPT|Gemini|AI)|${robot}"

# 1. No em dash in a tracked text file (golden rule 6). `-I` skips binary files.
if git grep -nIF "$em_dash" -- . ; then
  fail "em dash (U+2014) found: use a colon, a comma, parentheses or a plain hyphen"
fi

# 2. No AI attribution, in the tree or in the history (golden rule 1). AGENTS.md is the one file
#    allowed to talk about agents.
if git grep -nIE "$ai_attribution" -- . ':(exclude,glob)**/AGENTS.md' ; then
  fail "AI attribution found in the tree"
fi
if git log --format='%an%n%ae%n%B' 2>/dev/null | grep -nE "$ai_attribution" ; then
  fail "AI attribution found in the history"
fi

# 3. AGENTS.md opens with the common rules block, unchanged. Line endings are normalised, so a
#    Windows checkout compares equal; any other difference fails.
block() {
  tr -d '\r' < "$1" | awk '
    /<!-- ruchoir:common-rules:start -->/ { inside = 1 }
    inside { print }
    /<!-- ruchoir:common-rules:end -->/ { if (inside) exit }
  '
}
expected="$(block "$rules_file")"
if [ -z "$expected" ]; then
  fail "$rules_file holds no common rules block"
elif [ ! -f AGENTS.md ]; then
  fail "AGENTS.md is missing: every repository opens its AGENTS.md with the common rules block"
else
  actual="$(block AGENTS.md)"
  if [ -z "$actual" ]; then
    fail "AGENTS.md has no common rules block: copy it from Ruchoir/.github, common-rules.md"
  elif [ "$actual" != "$expected" ]; then
    fail "the common rules block of AGENTS.md differs from Ruchoir/.github, common-rules.md: copy it again, unchanged"
    diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | head -n 40
  fi
fi

# 4. Conventional Commits and no ticket identifiers: commits of the range, pull request title,
#    branch name.
check_subject() {
  local what="$1" text="$2"
  if ! printf '%s' "$text" | grep -qE "$conventional"; then
    fail "$what is not a Conventional Commit: $text"
  fi
  if printf '%s' "$text" | grep -qE "$ticket"; then
    fail "$what names a ticket: say what the change does instead: $text"
  fi
}
if [ -n "${RANGE:-}" ]; then
  while IFS= read -r subject; do
    [ -z "$subject" ] && continue
    case "$subject" in
      Merge\ *) continue ;;
    esac
    check_subject "a commit" "$subject"
  done < <(git log --format=%s "$RANGE")
  if git log --format=%b "$RANGE" | grep -nE "$ticket"; then
    fail "a commit body names a ticket: say what the change does instead"
  fi
fi
if [ -n "${PR_TITLE:-}" ]; then
  check_subject "the pull request title" "$PR_TITLE"
fi
if [ -n "${BRANCH:-}" ]; then
  if ! printf '%s' "$BRANCH" | grep -qE "$branch_name"; then
    fail "branch name does not follow the convention (feat/, fix/, ... then kebab case): $BRANCH"
  fi
  if printf '%s' "$BRANCH" | grep -qiE "$ticket"; then
    fail "branch name names a ticket: $BRANCH"
  fi
fi

if [ "$status" -eq 0 ]; then
  echo "conventions: every check passed"
fi
exit "$status"
