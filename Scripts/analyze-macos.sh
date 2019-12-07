#!/bin/bash

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-macOS

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-macOS \
    > build.log

swift run -c release swiftlint analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji
