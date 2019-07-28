#!/bin/bash
xcodebuild clean -workspace FinanceMe.xcworkspace -scheme FinanceMe-iOS
xcodebuild build-for-testing -workspace FinanceMe.xcworkspace -scheme FinanceMe-iOS -UseModernBuildSystem=NO -destination 'platform=iOS Simulator,name=iPhone Xs' > build.log
swiftlint analyze --config .swiftlint_analyze.yml --compiler-log-path build.log --reporter html > report.html
