#!/bin/bash
xcodebuild clean -workspace MyFinance.xcworkspace -scheme MyFinance-iOS
xcodebuild build-for-testing -workspace MyFinance.xcworkspace -scheme MyFinance-iOS -UseModernBuildSystem=NO -destination 'platform=iOS Simulator,name=iPhone 8' > build.log
Pods/SwiftLint/swiftlint analyze --compiler-log-path build.log --reporter html > report.html
