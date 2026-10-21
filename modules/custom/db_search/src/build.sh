#!/bin/sh
set -eu
src_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$src_dir/../../../.." && pwd)
docker build --platform linux/amd64 -t icrp-search -f "$src_dir/Dockerfile" --progress plain "$repo_dir"
docker run --platform linux/amd64 --rm -v "$src_dir/../assets:/tmp/output" icrp-search
