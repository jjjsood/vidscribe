#!/usr/bin/env bash
# Smoke test.
#   tests/smoke.sh --quick   CLI/validation checks only (no whisper, no network)
#   tests/smoke.sh           also transcribes tests/fixtures/speech.ogg
# Env: VIDSCRIBE_TEST_MODEL (default: tiny) - model for the full run, downloaded on first use.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
v=$here/../vidscribe
fail() { echo "FAIL: $*" >&2; exit 1; }

"$v" --help | grep -q Usage || fail "--help"
"$v" --version | grep -q '^vidscribe [0-9]' || fail "--version"
! "$v" 2>/dev/null || fail "no source must be an error"
! "$v" x -f bogus 2>/dev/null || fail "unknown format must be an error"
! "$v" x -m '../evil' 2>/dev/null || fail "bad model name must be an error"
! "$v" --nope 2>/dev/null || fail "unknown option must be an error"

if [ "${1:-}" != --quick ]; then
  out=$(mktemp -d)
  trap 'rm -rf "$out"' EXIT
  model=${VIDSCRIBE_TEST_MODEL:-tiny}
  speech=$here/fixtures/speech.ogg

  "$v" "$speech" -m "$model" -l en -o "$out" >/dev/null
  grep -q -- '-->' "$out/speech.srt" || fail "srt has no timings"
  grep -qi bird "$out/speech.txt" || fail "transcript misses the word 'bird'"
  [ -s "$out/speech.vtt" ] && [ -s "$out/speech.json" ] || fail "vtt/json missing"

  # same title again must not overwrite; one bad source must not stop the batch but must fail the run
  rc=0
  "$v" "$speech" /nonexistent.ogg -m "$model" -l en -f txt -o "$out" >/dev/null 2>&1 || rc=$?
  [ -s "$out/speech-2.txt" ] || fail "second run overwrote instead of suffixing"
  [ "$rc" -ne 0 ] || fail "failed source must give non-zero exit"
fi
echo smoke ok
