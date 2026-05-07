# music-organizer Review Roadmap

Review date: 2026-05-07

Target repository: [`outmyth/music-organizer`](https://github.com/outmyth/music-organizer)

This document captures a code and documentation review of `music-organizer` for future roadmap planning. It intentionally does not change the `music-organizer` project code.

## Executive summary

`music-organizer` is a single-script Python music library organizer and M3U playlist generator for audiophile DAP workflows. It handles input scanning, metadata probing and enrichment, CUE splitting, genre classification, cover lookup, output copying, playlist generation, orphan cleanup, and SD-card sync.

The project appears useful and grounded in real music-library needs, especially around Sony Walkman / HAP-Z1ES, Chord Poly, CUE+image albums, CJK metadata, Test folders, and online metadata enrichment. The main improvement opportunities are documentation drift, a few likely logic bugs, safer defaults, and reducing the maintenance burden of a very large single script.

## P0: documentation and behavior alignment

These are low-risk, high-value fixes because they reduce user confusion without requiring a large code refactor.

### 1. Align Chinese genre fallback documentation with code

The README says files containing CJK characters fall back to `Mandopop`, but the current implementation appears to classify such files as `Pop`. Related examples still show `Cantopop` / `Mandopop` output directories, while the genre map appears to normalize several Chinese-pop labels to `Pop`.

Recommendation: choose one behavior and make the README, Chinese README, examples, and `GENRE_MAP` consistent. The lowest-risk option is probably to document `Pop` as the fallback if that is already the current behavior.

### 2. Refresh stale `examples/` output layout

The main README describes playlists at the SD-card root under `out/`, with music under `out/MUSIC/`. Some examples still describe older paths such as `out/MUSIC/Playlists/`, `out/playlists/`, and `music_index.json`.

Recommendation: update examples to match the current root-level `.m3u` output strategy and remove or mark legacy playlist directories as historical.

### 3. Fix skill documentation around compilation folders and AcoustID

The skill documentation says AcoustID is skipped for folders detected as compilations. The current pipeline appears to allow per-track AcoustID album identification even in compilation-like folders, because per-track identification can be more accurate than folder-name fallback.

Recommendation: update the skill documentation to describe the current behavior, unless the intended behavior is actually to preserve compilation folder names.

### 4. Update public project description for Lotoo support

The repository description still mentions Lotoo PAW Gold 2017, while the README says that device is not supported because its absolute-path playlist requirement conflicts with Chord Poly path resolution.

Recommendation: remove Lotoo from the supported-device description, or explicitly describe it as documented-but-not-supported.

### 5. Reformat Markdown source files

The raw README files appear to contain very long physical lines. GitHub renders them, but long lines make diffs, review, blame, and small edits harder.

Recommendation: reflow Markdown into normal paragraphs, tables, and fenced code blocks without changing content.

## P1: likely logic issues

These issues can affect correctness or user data and should be prioritized before broad feature work.

### 1. CUE staging can reuse stale split files

CUE splitting writes to a shared staging area under `/tmp`. If a CUE file or source image changes but staged output files already exist, the pipeline may reuse old split tracks, especially with incremental behavior enabled.

Recommendation: make the staging key include source path plus CUE/audio size, mtime, or content hash; or clear the relevant staging directory before each split.

### 2. `--no-force` compares output size to source size

The incremental skip logic appears to skip existing files only when output size matches source size. This is brittle because metadata rewrite can change file size even when audio is unchanged, and same-size files can still contain different content.

Recommendation: introduce a manifest with source path, source size, source `mtime_ns`, destination path, and a metadata signature. A hash can be added later if needed.

### 3. Multi-disc detection happens before final metadata is known

The pipeline appears to detect multi-disc albums from raw probe metadata before later override, path inference, canonicalization, and online enrichment. Albums with incomplete or inconsistent raw tags can therefore miss multi-disc grouping.

Recommendation: use a two-pass flow: first resolve final metadata for all tracks, then compute multi-disc grouping, then copy files and generate output paths.

### 4. Source metadata writeback is too surprising as a default

The organizer may write cleaned metadata back to source files in `in/`. Even with temporary-file replacement, this is a risky default for users who expect an organizer to only create output copies.

Recommendation: make source writeback opt-in with a flag such as `--writeback-source`, or at least provide `--no-writeback-source` and print a clear warning before modifying inputs.

### 5. `run(cmd, check=True)` does not enforce `check`

The helper accepts a `check` argument but does not appear to raise on non-zero subprocess exit codes. That name is misleading because it resembles `subprocess.run(..., check=True)`.

Recommendation: either remove the unused `check` parameter or implement the expected raising behavior.

### 6. Metadata-copy fallback can silently lose intended tag changes

If the `ffmpeg` metadata rewrite fails, the code appears to fall back to raw `shutil.copy2()`. That can hide failures where the caller expected cleaned or enriched metadata in the output.

Recommendation: warn loudly on fallback. For paths that require metadata changes, consider treating rewrite failure as an error rather than silently copying raw input.

## P2: safety, maintainability, and quality improvements

These are not necessarily bugs, but they would make the project easier to maintain and safer for more users.

### 1. Make dependency installation explicit

The script tries to install Python packages and system tools automatically. This is convenient for a personal script but surprising for an open-source tool, especially when `sudo apt-get` or Homebrew may be invoked.

Recommendation: add `requirements.txt` or `pyproject.toml`, document setup steps, and make automatic installation an explicit command such as `--install-deps`.

### 2. Prefer HTTPS for Last.fm API calls

The Last.fm endpoint appears to use `http://ws.audioscrobbler.com/2.0/`.

Recommendation: use `https://ws.audioscrobbler.com/2.0/`.

### 3. Clean playlist display text separately from path components

Path sanitization and playlist display text have different needs. Metadata with newlines or control characters can break `#EXTINF` lines even if output paths are sanitized.

Recommendation: add a small `clean_playlist_text()` helper that removes CR/LF/control characters while preserving normal display characters.

### 4. Avoid playlist filename collisions

Sanitized playlist names can collide after punctuation removal, truncation, or normalization.

Recommendation: track generated playlist names and suffix collisions with ` (2)`, ` (3)`, and so on.

### 5. Split sanitization by use case

A single `sanitize()` function can over-sanitize user-facing display text or under-sanitize device paths.

Recommendation: split into `sanitize_path_component()`, `sanitize_playlist_filename()`, and `clean_display_text()`.

### 6. Stop committing generated metadata caches unless intentional

The repository includes multiple hidden JSON cache files for online metadata providers. If they are generated from a personal library, they can leak preferences, produce noisy diffs, and grow over time.

Recommendation: ignore generated cache files in `.gitignore`, unless they are intentionally curated fixtures. If fixtures are useful, move them under `examples/fixtures/` with documentation.

### 7. Move user configuration out of the main script

The script appears to keep user-tunable maps such as genre aliases, artist genres, and album metadata overrides in code.

Recommendation: support a checked-in default config plus ignored local config, for example `config.toml` and `config.local.toml`.

### 8. Add pytest coverage for pure logic

The project has many pure functions and deterministic rules that can be tested without real audio files.

Recommended first tests:

- genre fallback for CJK metadata
- Test folder category extraction
- `DISC 2` / `CD2` path inference
- Qobuz bracket album-name extraction
- multi-artist normalization
- playlist paths are `MUSIC/...` and do not contain `..`
- `.m3u` encoding and CRLF behavior
- playlist filename collision handling
- CUE date and track metadata parsing
- manifest-based incremental skip behavior, after implemented

## Suggested implementation order

### Phase 1: low-risk documentation and small safety fixes

1. Align README, Chinese README, examples, and skill documentation with current behavior.
2. Reflow Markdown source files for maintainability.
3. Update repository description around Lotoo support.
4. Ignore generated provider cache files, if they are not intended fixtures.
5. Switch Last.fm requests to HTTPS.
6. Remove or implement the misleading `check` parameter in the subprocess helper.
7. Add visible warnings for metadata-copy fallback.

### Phase 2: correctness fixes

1. Make CUE staging invalidation deterministic.
2. Replace size-only incremental skip logic with a manifest.
3. Make source metadata writeback opt-in.
4. Rework multi-disc detection to use final metadata.

### Phase 3: maintainability

1. Add pytest tests for pure helpers and path rules.
2. Move configuration into external config files.
3. Gradually split the single script into modules after tests exist.
4. Track metadata source and confidence for online enrichment.

## Notes for future reviewers

This review was based on a read-only inspection of the public GitHub repository and raw project files. It should be treated as a roadmap seed, not as a verified bug list with reproducer tests. Before implementing each item, add a focused test or a small reproduction case where possible.
