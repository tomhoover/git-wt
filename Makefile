# ── Configuration ─────────────────────────────────────────────────────────────

SHELL        := /usr/bin/env bash
SRC          := src/git-wt
TEST_DIR     := test
TEST_FILE    := $(TEST_DIR)/git-wt.bats
BATS         := bats
SHELLCHECK   := shellcheck
SHFMT        := shfmt
GIT_CLIFF    := git-cliff

# Release configuration — override these when copying to another project
VERSION_FILE ?= src/git-wt
VERSION_VAR  ?= VERSION

# SHFMT_OPTS  := -i 4 -ln bash
# -ln bash: explicit language flag; omitted because shfmt infers bash from the shebang
#  including it caused errors with bats test files

# shfmt options: indent with 2 spaces, keep consistent with vim modeline
SHFMT_OPTS  := -i 2 -bn -ci

# shellcheck options: warn on everything, target bash
SHELLCHECK_OPTS := --shell=bash --severity=warning

.PHONY: all lint shellcheck shfmt-check fmt test test-tap test-verbose deps clean clean-deps clean-worktrees check-tools release help

# ── Default ───────────────────────────────────────────────────────────────────

all: lint test ## Run lint and test

# ── Linting ───────────────────────────────────────────────────────────────────

lint: shellcheck shfmt-check ## Run all linters (shellcheck + shfmt check)

shellcheck: ## Run shellcheck on src and test files
	$(SHELLCHECK) $(SHELLCHECK_OPTS) $(SRC)
	$(SHELLCHECK) $(SHELLCHECK_OPTS) --shell=bash $(TEST_FILE)

shfmt-check: ## Check formatting with shfmt (non-destructive)
	$(SHFMT) $(SHFMT_OPTS) -d $(SRC)
	$(SHFMT) $(SHFMT_OPTS) -d $(TEST_FILE)

# ── Formatting ────────────────────────────────────────────────────────────────

fmt: ## Auto-format src and test files with shfmt (in place)
	$(SHFMT) $(SHFMT_OPTS) -w $(SRC)
	$(SHFMT) $(SHFMT_OPTS) -w $(TEST_FILE)

# ── Testing ───────────────────────────────────────────────────────────────────

test: ## Run all bats tests
	@[[ -d "$(TEST_DIR)/libs/bats-assert" ]] || { echo "ERROR: run 'make deps' first"; exit 1; }
	$(BATS) $(TEST_FILE)

test-tap: ## Run bats tests with TAP output (useful for CI)
	$(BATS) --formatter tap $(TEST_FILE)

test-verbose: ## Run bats tests with verbose output
	$(BATS) --verbose-run $(TEST_FILE)

# ── Dependency bootstrap ──────────────────────────────────────────────────────

deps: ## Install bats-assert, bats-support into test/libs
	@command -v $(BATS) &>/dev/null || { echo "ERROR: $(BATS) is not installed"; exit 1; }
	@mkdir -p $(TEST_DIR)/libs
	@if [[ ! -d "$(TEST_DIR)/libs/bats-assert" ]]; then \
		git clone --depth 1 https://github.com/bats-core/bats-assert \
			$(TEST_DIR)/libs/bats-assert; \
	fi
	@if [[ ! -d "$(TEST_DIR)/libs/bats-support" ]]; then \
		git clone --depth 1 https://github.com/bats-core/bats-support \
			$(TEST_DIR)/libs/bats-support; \
	fi

# ── Clean ─────────────────────────────────────────────────────────────────────

clean: clean-deps clean-worktrees ## Remove deps and stray test worktrees

clean-deps: ## Remove installed bats dependencies
	rm -rf $(TEST_DIR)/libs

clean-worktrees: ## Remove any stray bats test worktrees
	@git worktree list --porcelain \
		| grep '^worktree ' \
		| grep '+bats_' \
		| awk '{print $$2}' \
		| while read -r path; do git worktree remove --force "$$path" 2>/dev/null || true; done
	@git branch -D bats_xyz bats_dirty bats_remote 2>/dev/null || true
	@git branch -D bats_ns/bats_xyz 2>/dev/null || true
	@git update-ref -d refs/remotes/origin/bats_remote 2>/dev/null || true
	@git worktree prune

# ── Checks ────────────────────────────────────────────────────────────────────

check-tools: ## Verify required tools are installed
	@for tool in $(BATS) $(SHELLCHECK) $(SHFMT); do \
		if ! command -v $$tool &>/dev/null; then \
			echo "ERROR: $$tool is not installed or not in PATH"; \
			exit 1; \
		fi; \
	done
	@echo "All required tools found."

# ── Release ───────────────────────────────────────────────────────────────────

release: lint test ## Bump version, update CHANGELOG, commit, and tag (then: git push && git push --tags)
	@git diff --quiet && git diff --cached --quiet \
		|| { echo "ERROR: working tree is dirty — commit or stash first"; exit 1; }
	@command -v $(GIT_CLIFF) &>/dev/null \
		|| { echo "ERROR: git-cliff not found — run 'mise install'"; exit 1; }
	@NEW_VERSION=$$($(GIT_CLIFF) --bumped-version | tr -d 'v'); \
	echo "Bumping to v$${NEW_VERSION}"; \
	$(GIT_CLIFF) --bump -o CHANGELOG.md; \
	sed -i.bak -Ee "s/(^$(VERSION_VAR)=).*/\1$${NEW_VERSION}/" $(VERSION_FILE) \
		&& rm $(VERSION_FILE).bak; \
	git add CHANGELOG.md $(VERSION_FILE); \
	git commit -m "chore: release v$${NEW_VERSION}"; \
	git tag "v$${NEW_VERSION}"; \
	echo ""; \
	echo "Release v$${NEW_VERSION} ready. Run:"; \
	echo "  git push && git push --tags"

# ── Help ──────────────────────────────────────────────────────────────────────

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# vim: set noexpandtab tabstop=4 shiftwidth=4:
