#!/bin/bash

xcodebuild clean \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-tvOS

xcodebuild build \
    -workspace FinanceMe.xcworkspace \
    -scheme FinanceMe-tvOS \
    -destination 'platform=tvOS Simulator,name=Apple TV 4K' \
    > build.log

swift run -c release swiftlint analyze \
    --config .swiftlint_analyze.yml \
    --compiler-log-path build.log \
    --reporter emoji
