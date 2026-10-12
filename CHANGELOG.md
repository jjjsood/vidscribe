# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioning: [SemVer](https://semver.org/).
The Debian changelog in `debian/changelog` carries the same entries.

## [0.1] - 2026-10-12

First release.

- Turns a video URL (anything yt-dlp supports, e.g. Instagram, YouTube) or a local audio/video file into a timed transcript with whisper.cpp.
- Output formats `txt`, `srt`, `vtt` and `json` (`-f`); `--json-full` adds per-token timing. Written file names are printed to stdout.
- Several URLs/files in one call; a failing source does not stop the others, the exit status is non-zero.
- Whisper model selectable with `-m` (default `small`), spoken language with `-l` (default `auto`), output directory with `-o`.
- Models are downloaded once to `~/.local/share/vidscribe` and verified against the SHA-256 published by Hugging Face.
- `-c BROWSER` passes browser cookies to yt-dlp for login-walled videos.
- `--keep-video` also saves the downloaded media file (merged file only, not yt-dlp's split streams).
- `--cpu` disables the GPU; `-V`/`--version` prints the version.
- Existing transcripts are never overwritten (`title-2.*`, `title-3.*`, ...).
- Downloaded titles are sanitized for file names (slashes and control characters removed, length capped).
- Includes man page, Debian package, Makefile, CI, and a smoke test with a CC BY-SA speech fixture.
