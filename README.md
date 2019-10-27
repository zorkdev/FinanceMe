# FinanceMe App

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-blue.svg)

## 🛠 Branching Strategy

Use `develop` branch for development and `master` for release.

## 🚀 Build Instructions

This project uses [Mint](https://github.com/yonaskolb/Mint). Build instructions:

``` bash
$ git clone https://github.com/yonaskolb/Mint.git
$ cd Mint
$ swift run mint install yonaskolb/mint
$ git clone https://github.com/zorkdev/FinanceMe.git
$ cd FinanceMe
$ mint bootstrap
$ open FinanceMe.xcworkspace
```

To run static analysis on the project, use the analyze script:

``` bash
$ sh Scripts/analyze.sh
```

Environment variables required for build scripts:

`APPLE_ID`: Developer Apple ID  
`APPLE_ID_PW`: Developer Apple ID app-specific password  
`LOCAL_PW`: Local macOS user password  
`TEST_USER_EMAIL`: Email for the test user to run integration tests against  
`TEST_USER_PW`: Password for the test user to run integration tests against
