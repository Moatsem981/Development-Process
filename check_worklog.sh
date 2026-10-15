#!/bin/sh
# check_worklog.sh - the progress-documentation gate.
#
# READ THIS FIRST. If the repository ALREADY has a worklog gate, do not add this
# script. Extend the existing gate to require the second record as well. Two
# gates enforcing overlapping rules is the failure mode: they drift, they
# disagree, and each acquires its own bypass flag, so one record can be skipped
# while the other is enforced. That is the exact state a gate exists to prevent.
# Use this script only for a greenfield repo with no gate yet.
#
# WHAT IT ENFORCES: if a branch changes product code but adds no lines to BOTH
# records, it exits 1. Product code cannot ship without coverage in both.
#   WORKLOG.md       the narrative: why this work happened.
#   CODE_WORKLOG.md  the per-unit index: what each unit is, why it is shaped
#                    that way, what depends on it.
#
# WHY BOTH: those are different questions with different lifetimes. A session is
# over once it ends; a unit outlives every session that touched it. One gate
# covers both because they fail for the same reason (nobody remembers) and the
# fix is the same. ONE bypass flag deliberately, not two: a second flag lets one
# record be skipped while the other is enforced.
#
# WHAT IT DELIBERATELY DOES NOT CHECK, and is honest about: whether the entries
# are any GOOD, whether they describe THIS work, or whether the dependency edges
# are reciprocal. That is judgment. This gate guarantees the entries EXIST. Pair
# it with the Stop-hook auditor (see stop-hook-settings.json) for the rest.
#
# INSTALL:
#   1. Save at scripts/check_worklog.sh and chmod +x.
#   2. Add to the aggregate gate script (the one your pre-push hook runs).
#   3. Adjust PRODUCT_PREFIXES and the two record paths below to the repo.
#
# BYPASS for a genuine one-off, logged another way: SKIP_WORKLOG_CHECK=1.
# Using it as a habit is the exact failure this gate exists to stop.

set -u

# ---- configure for the repo -------------------------------------------------
# Directories holding product code. A changed file is product code if it sits
# under one of these AND is not a .md file (READMEs and planning docs are not
# product code, so changing one requires nothing).
PRODUCT_PREFIXES="src/ lib/ app/ packages/ migrations/"
NARRATIVE="docs/WORKLOG.md"
CODE_RECORD="docs/CODE_WORKLOG.md"
# ---- end configuration ------------------------------------------------------

if [ "${SKIP_WORKLOG_CHECK:-}" = "1" ]; then
  echo "check_worklog: SKIP_WORKLOG_CHECK=1 set, skipping both records. Log the work another way."
  exit 0
fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "check_worklog: not a git repository, nothing to check."
  exit 0
}
cd "$REPO_ROOT" || exit 0

# Find where this branch diverged from the mainline, so the whole branch is
# measured and not only the last commit. Prefer the remote tip, which is what a
# push is measured against.
BASE=""
for ref in origin/main main origin/master master; do
  BASE=$(git merge-base "$ref" HEAD 2>/dev/null) && [ -n "$BASE" ] && break
  BASE=""
done

# Changed files = committed since base, UNION working tree (staged + unstaged)
# vs HEAD. The union keeps the gate honest whether it runs pre-commit, mid-work,
# or pre-push. Untracked files are excluded on purpose: code git does not know
# about cannot ship.
changed_files() {
  { [ -n "$BASE" ] && git diff --name-only "$BASE" HEAD
    git diff --name-only HEAD
  } 2>/dev/null | sed '/^$/d' | sort -u
}

is_product_code() {
  case "$1" in *.md) return 1 ;; esac
  for p in $PRODUCT_PREFIXES; do
    case "$1" in "$p"*) return 0 ;; esac
  done
  return 1
}

# Added content lines for one record, over the same scope. Real added lines are
# required, so a whitespace-only touch does not satisfy the gate. Untracked case:
# git diff cannot see a file git does not know about, so a brand-new record would
# read as zero and fail the gate its own creation satisfies. An untracked,
# non-empty record is entirely added content.
added_lines() {
  record="$1"
  if [ -z "$(git ls-files -- "$record" 2>/dev/null)" ]; then
    if [ -f "$record" ]; then grep -c '[^[:space:]]' "$record" 2>/dev/null || echo 0
    else echo 0; fi
    return
  fi
  { [ -n "$BASE" ] && git diff --numstat "$BASE" HEAD -- "$record"
    git diff --numstat HEAD -- "$record"
  } 2>/dev/null | awk '{ if ($1 ~ /^[0-9]+$/) s += $1 } END { print s + 0 }'
}

PRODUCT_CHANGES=""
COUNT=0
for f in $(changed_files); do
  if is_product_code "$f"; then
    PRODUCT_CHANGES="$PRODUCT_CHANGES $f"
    COUNT=$((COUNT + 1))
  fi
done

if [ "$COUNT" -eq 0 ]; then
  echo "check_worklog OK: no product-code changes on this branch, so no entry is required."
  exit 0
fi

N_ADDED=$(added_lines "$NARRATIVE")
C_ADDED=$(added_lines "$CODE_RECORD")

# Report BOTH misses at once. Failing on the first would hide the second, and the
# author would fix one, re-run, and be blocked again by the other.
if [ "$N_ADDED" -eq 0 ] || [ "$C_ADDED" -eq 0 ]; then
  echo ""
  echo "check_worklog FAILED: this branch changes product code without documenting it."
  echo ""
  echo "  Product-code files changed ($COUNT):"
  i=0
  for f in $PRODUCT_CHANGES; do
    i=$((i + 1)); [ "$i" -gt 25 ] && { echo "    ... and $((COUNT - 25)) more"; break; }
    echo "    - $f"
  done
  echo ""
  echo "  Record status:"
  [ "$N_ADDED" -eq 0 ] && echo "    - $NARRATIVE: MISSING" || echo "    - $NARRATIVE: ok, +$N_ADDED line(s)"
  [ "$C_ADDED" -eq 0 ] && echo "    - $CODE_RECORD: MISSING" || echo "    - $CODE_RECORD: ok, +$C_ADDED line(s)"
  echo ""
  echo "  Fix:"
  [ "$N_ADDED" -eq 0 ] && echo "    $NARRATIVE: add a dated entry at the top (newest first) in the layout used"
  [ "$N_ADDED" -eq 0 ] && echo "      by the entries already there. See WORKLOG-entry-template.md."
  [ "$C_ADDED" -eq 0 ] && echo "    $CODE_RECORD: add or update the CW- entry for each unit you touched, BOTH"
  [ "$C_ADDED" -eq 0 ] && echo "      halves of every dependency edge, and the reverse-index row."
  echo ""
  echo "  The narrative says why the work happened; the code record says what breaks if"
  echo "  the unit changes. Genuine one-off exception: SKIP_WORKLOG_CHECK=1 (covers both)."
  echo ""
  exit 1
fi

echo "check_worklog OK: $COUNT product-code file(s) changed; $NARRATIVE +$N_ADDED, $CODE_RECORD +$C_ADDED."
exit 0
