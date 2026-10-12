<div align="center">
  <img src="vidscribe.svg" width="96" alt="vidscribe logo">

  # vidscribe

  *Video link in, timed transcript out. Runs locally.*

  [![CI](https://github.com/jjjsood/vidscribe/actions/workflows/ci.yml/badge.svg)](https://github.com/jjjsood/vidscribe/actions/workflows/ci.yml)
  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
  ![Shell](https://img.shields.io/badge/shell-bash-4eaa25.svg)
  ![Platform](https://img.shields.io/badge/platform-Debian%20%7C%20Ubuntu-a80030.svg)

  [Features](#features) • [Installation](#installation) • [Usage](#usage) • [Options](#options)
</div>

vidscribe turns the speech in a video into a transcript with timestamps. Give it a link
(YouTube, Instagram, and everything else [yt-dlp](https://github.com/yt-dlp/yt-dlp) supports)
or a local audio/video file. Transcription runs on your machine with
[whisper.cpp](https://github.com/ggml-org/whisper.cpp), nothing is sent to a cloud service.

```console
$ vidscribe https://www.youtube.com/watch?v=jNQXAC9IVRw -l en -f srt
./Me at the zoo.srt
$ cat "Me at the zoo.srt"
1
00:00:00,000 --> 00:00:03,000
 Alright so here we are, one of the elephants.
...
```

## Features

- Writes `txt`, `srt`, `vtt` and `json`; the last three carry timestamps, optionally per token
- Works with URLs and local files, several sources per run
- GPU acceleration through Vulkan, with a `--cpu` fallback
- Script friendly: output file names go to stdout, failures set the exit status
- Never overwrites an earlier transcript (`talk.srt`, then `talk-2.srt`, ...)
- One Bash script on top of `yt-dlp`, `ffmpeg`, `whisper.cpp` and `curl`

## Installation

On Debian or Ubuntu:

```sh
sudo apt install yt-dlp ffmpeg whisper.cpp curl
git clone https://github.com/jjjsood/vidscribe.git && cd vidscribe
sudo make install
```

To install without root, use `make install PREFIX=~/.local`. To build a `.deb` instead,
run `make deb` and install `../vidscribe_*_all.deb`.

For GPU transcription, also install `libggml0-backend-vulkan`.

> [!NOTE]
> The whisper model is downloaded on first use to `~/.local/share/vidscribe` and checked
> against the SHA-256 published by Hugging Face. The default `small` model is about 470 MB.

## Usage

```sh
# a video link, English audio, subtitles only
vidscribe https://www.youtube.com/watch?v=ID -l en -f srt

# a local file with a more accurate model
vidscribe talk.mp4 -m large-v3-turbo

# several sources in one run, into a folder
vidscribe a.mp4 b.mp4 https://example.org/video -o ~/transcripts
```

> [!TIP]
> Login-walled Instagram reels need cookies from a logged-in browser:
> `vidscribe https://www.instagram.com/reel/ID/ -c firefox`

With several sources, a failing one is reported and skipped, and the exit status is
non-zero if any source failed. Playlists are not expanded; every URL counts as one video.

## Options

```
vidscribe URL|FILE... [options]
  -f LIST       formats: txt,srt,vtt,json            (default: all)
  -m MODEL      small, medium, large-v3-turbo, ...   (default: small)
  -l LANG       auto, de, en, ...                    (default: auto)
  -o DIR        output directory                     (default: .)
  -c BROWSER    take cookies from a browser, e.g. firefox
  --json-full   JSON with per-token timing
  --keep-video  also save the downloaded media (URL only)
  --cpu         do not use the GPU
  -V, -h        version, help
```

See `man vidscribe` for details.
