#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR/FinanceMe
xcrun agvtool new-version -all $XCS_INTEGRATION_NUMBER
