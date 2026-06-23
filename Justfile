# agentic-os Justfile — common operator commands
#
# Install just: `brew install just` (macOS) · `cargo install just` (Linux)
# Run `just` to see all commands; `just <command>` to invoke.

default:
    @just --list

# Install the template on a fresh clone — verify prereqs, chmod, prime caches, validate
install:
    bash scripts/install.sh

# Verify prerequisites only (jq, python3, gh) without making changes
check:
    bash scripts/install.sh --check

# Run the full validation suite locally (mirrors CI)
validate:
    bash scripts/validate-all.sh

# Validate just the harness frontmatter and state.md coverage
validate-harness:
    bash control-plane/scripts/validate-harness.sh

# Recompile the skill routing index (also runs at SessionStart when stale)
compile-skills:
    python3 control-plane/scripts/compile-skill-routing.py --stdout

# Recompile the concept routing index
compile-concepts:
    python3 control-plane/scripts/compile-concept-routing.py --stdout

# Run the block-pr-merge regex fixture suite (15 cases)
test-merge-block:
    bash control-plane/scripts/tests/test-block-pr-merge.sh

# Tidy memory tiers — TTL compaction (scratchpads 48h, state files 30d)
tidy:
    bash control-plane/scripts/memory-ttl-compaction.sh

# Check agent state files for drift vs recent commits
drift-check:
    bash control-plane/scripts/state-drift-check.sh

# Show canon items due for re-check within 7 days
canon-due:
    bash control-plane/scripts/canon-recheck-due.sh

# Pull the trailing decision-log entries (aged 7-30 days) for weekly review
decision-review:
    bash control-plane/scripts/decision-log-trailing.sh

# Reset the bootstrap flow — re-creates the sentinel + clears progress file
reset-bootstrap:
    touch .bootstrap-pending
    rm -f .bootstrap-progress.json
    @echo "Bootstrap reset. Re-open Claude Code to begin the interview."
