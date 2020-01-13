#!/bin/sh

cd $XCS_PRIMARY_REPO_DIR
sh Scripts/analyze.sh macOS
sh Scripts/notarization.sh
