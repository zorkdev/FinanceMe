#!/usr/bin/env sh

set -euo pipefail

sh $XCS_PRIMARY_REPO_DIR/Scripts/keychain.sh
sh $XCS_PRIMARY_REPO_DIR/Scripts/config.sh
sh $XCS_PRIMARY_REPO_DIR/Scripts/build_number.sh
