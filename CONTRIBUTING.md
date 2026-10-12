# Contributing

vidscribe is one Bash script on purpose. Prefer deleting code over adding it,
and do not add a dependency for something a few lines can do.

1. `make lint check` must pass (needs `shellcheck`).
2. Behaviour changes need an assertion in `tests/smoke.sh`; run `make test` for anything that touches transcription.
3. Update `vidscribe.1`, `README.md`, `CHANGELOG.md` and `debian/changelog` together with the code.
4. Keep commit messages short and in the imperative ("Add --cpu flag").

Releasing: bump `VERSION` in `vidscribe` and the man page header, add the entries to
`CHANGELOG.md` and `debian/changelog`, run `make deb`, tag `vX.Y`.

Test fixtures under `tests/fixtures/` keep their own license, see `ATTRIBUTION.md` there.
