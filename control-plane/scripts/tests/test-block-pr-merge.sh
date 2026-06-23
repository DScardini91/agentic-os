#!/usr/bin/env bash
# Quick fixture test for block-pr-merge regex
REGEX='git[[:space:]]+push([[:space:]]+--?[a-zA-Z=_-]+)*[[:space:]]+[[:alnum:]_./-]+[[:space:]]+(\+|[[:alnum:]_./-]*:)?(refs/heads/)?(main|master)([[:space:]]|$)'

should_block=(
  "git push origin main"
  "git push origin master"
  "git push origin HEAD:main"
  "git push origin refs/heads/main"
  "git push origin feature:main"
  "git push origin +main"
  "git push --force origin main"
  "git push --force-with-lease origin main"
  "git push -u origin main"
)
should_pass=(
  "git push origin feature-branch"
  "git push origin claude/some-branch"
  "git push origin maintenance-2026"
  "git status"
  "git commit -m 'main'"
  "echo main"
)

pass=0; fail=0
for cmd in "${should_block[@]}"; do
  if echo "$cmd" | grep -qE "$REGEX"; then
    echo "BLOCK ✓  $cmd"; pass=$((pass+1))
  else
    echo "BLOCK ✗  $cmd  (should block but didn't)"; fail=$((fail+1))
  fi
done
for cmd in "${should_pass[@]}"; do
  if echo "$cmd" | grep -qE "$REGEX"; then
    echo "PASS  ✗  $cmd  (should pass but blocked)"; fail=$((fail+1))
  else
    echo "PASS  ✓  $cmd"; pass=$((pass+1))
  fi
done
echo "---"
echo "$pass pass / $fail fail"
