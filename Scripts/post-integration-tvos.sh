#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR
sh Scripts/analyze.sh tvOS
sh Scripts/upload.sh
