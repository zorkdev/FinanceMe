#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR
sh Scripts/analyze.sh iOS
sh Scripts/upload.sh
