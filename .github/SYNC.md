# Upstream Sync Workflows

Notify-only GitHub Actions that watch external sources and open a PR when something changes. They never auto-merge — you review the upstream change, decide what (if anything) to mirror into the repo, then merge the PR to bump the recorded baseline.

## Active workflows

| Workflow | Source | Marker | Cron (UTC) | PR branch |
|----------|--------|--------|------------|-----------|
| `upstream-sync-check.yml` | [`forrestchang/andrej-karpathy-skills`](https://github.com/forrestchang/andrej-karpathy-skills) | HEAD commit SHA | `0 13 * * *` (13:00 daily) | `upstream-sync/notify` |
| `notion-sync-check.yml` | [Zevi's AI Development Workflow](https://shorthaired-billboard-f9a.notion.site/Zevi-s-AI-Development-Workflow-2c86baffbc90810fa63bd0ee8ecffce9) | Notion `last_edited_time` | `30 13 * * *` (13:30 daily) | `notion-sync/notify` |

## How it works

1. **State file** at `.github/<source>-sync/last-<key>.txt` stores the last-known marker.
2. **Workflow** runs on cron + `workflow_dispatch`. Fetches the current marker, compares to the stored one.
3. **On divergence**: updates the state file, builds a PR body explaining the change, then uses `peter-evans/create-pull-request@v6` to open *or update* a PR on a stable `<source>-sync/notify` branch.
4. **On merge**: the new state file lands in `main`. The next run treats that as the baseline, so the same change never fires twice.

## Repo settings required

GitHub → **Settings → Actions → General → Workflow permissions**:
- "Read and write permissions"
- "Allow GitHub Actions to create and approve pull requests"

Without these, the action can push the branch but can't open the PR.

## Conventions

- **Stagger crons** by 30 min so they don't all fire together.
- **One PR branch per source**, `<source>-sync/notify`. `peter-evans/create-pull-request` dedups by branch — you never get duplicate PRs.
- **Notify-only**: workflows never edit content files (e.g. `zevi-*.md`, `EXAMPLES.md`). The PR only bumps the state file.
- **Use preinstalled tools** on `ubuntu-latest`: `jq`, `curl`, `date -u`, `gh`. Avoid embedded multi-line Python or heredocs inside `run: |` — un-indented inner lines break YAML block-scalar parsing.

## Adding a new source

1. **Pick a stable change marker.**
   - Git repos → HEAD SHA via `gh api repos/<owner>/<repo>/commits/<branch> --jq .sha`
   - Notion pages → `last_edited_time` from `https://<site>.notion.site/api/v3/loadPageChunk` (POST, see existing workflow for payload)
   - Plain web pages → `Last-Modified` header or content hash
   - RSS / feeds → `<lastBuildDate>` or latest item GUID

2. **Bootstrap the state file** with the current marker so the first run is a no-op:
   ```bash
   mkdir -p .github/<source>-sync
   echo "<current-marker>" > .github/<source>-sync/last-<key>.txt
   ```

3. **Copy the template below** to `.github/workflows/<source>-sync-check.yml` and fill in the four `TODO` markers.

4. **Commit & push.** Pushing a new workflow file requires `workflow` scope on your local `gh` token; if a push is rejected for that, run `gh auth refresh -h github.com -s workflow` and retry.

5. **Manually trigger once** from the Actions tab to confirm it runs green. Since the state file was bootstrapped with the current marker, expect "no change, skipping PR".

## Workflow template

```yaml
name: <Source> sync check

on:
  schedule:
    - cron: 'MM HH * * *'   # TODO: pick a UTC time, stagger by 30m from existing workflows
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  check:
    runs-on: ubuntu-latest
    env:
      SOURCE_URL: TODO   # human-readable URL for the PR body
    steps:
      - uses: actions/checkout@v4

      - name: Compare marker
        id: compare
        run: |
          set -euo pipefail
          last_known=$(tr -d '[:space:]' < .github/<source>-sync/last-<key>.txt)
          # TODO: replace this line with the fetch that produces the new marker.
          # Examples:
          #   gh repo: new=$(gh api repos/<owner>/<repo>/commits/main --jq .sha)
          #   notion:  curl -sSf -X POST .../loadPageChunk -d '...' > /tmp/r.json
          #            new=$(jq -r --arg id "$PAGE_ID" '.recordMap.block[$id].value.value.last_edited_time' /tmp/r.json)
          new="TODO"
          echo "last_known=$last_known" >> "$GITHUB_OUTPUT"
          echo "new=$new"               >> "$GITHUB_OUTPUT"
          if [ "$last_known" = "$new" ]; then
            echo "changed=false" >> "$GITHUB_OUTPUT"
          else
            echo "changed=true"  >> "$GITHUB_OUTPUT"
          fi
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}   # only needed if using gh api

      - name: Build PR body
        if: steps.compare.outputs.changed == 'true'
        env:
          LAST_KNOWN: ${{ steps.compare.outputs.last_known }}
          NEW: ${{ steps.compare.outputs.new }}
        run: |
          set -euo pipefail
          {
            echo "[Source](${SOURCE_URL}) changed."
            echo
            echo "**Previous marker:** \`${LAST_KNOWN}\`"
            echo "**Latest marker:**   \`${NEW}\`"
            echo
            echo "TODO: list which repo files might need updating in response."
            echo
            echo "Merging this PR records the new marker so the next check uses it as baseline."
          } > /tmp/pr-body.md

      - name: Update state file
        if: steps.compare.outputs.changed == 'true'
        run: echo "${{ steps.compare.outputs.new }}" > .github/<source>-sync/last-<key>.txt

      - name: Open or update PR
        if: steps.compare.outputs.changed == 'true'
        uses: peter-evans/create-pull-request@v6
        with:
          branch: <source>-sync/notify
          base: main
          title: "<Source> changed"
          body-path: /tmp/pr-body.md
          commit-message: "chore: bump <source> sync marker"
```

## Troubleshooting

- **YAML rejected at push or in Actions UI** — most often caused by un-indented multi-line content (Python heredocs, embedded scripts) inside `run: |`. Move that logic to `jq`/`date -u` or a separate file under `.github/<source>-sync/`.
- **"refusing to allow an OAuth App to create or update workflow"** — local `gh` token missing `workflow` scope. Fix: `gh auth refresh -h github.com -s workflow`.
- **PR step succeeds, no PR appears** — repo setting "Allow GitHub Actions to create and approve pull requests" is off. Toggle it under Settings → Actions → General.
- **Workflow keeps re-firing on the same change** — the merge of the previous notify PR was rejected or skipped, so the state file never moved forward. Either merge it or close it and manually update `last-<key>.txt`.
