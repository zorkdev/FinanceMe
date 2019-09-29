# FinanceMe App

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-blue.svg)

## 🛠 Branching Strategy

Use `develop` branch for development and `master` for release.

## 🚀 Build Instructions

This project uses [Homebrew](https://brew.sh) and [Mint](https://github.com/yonaskolb/Mint). Build instructions:

``` bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ git clone https://github.com/zorkdev/FinanceMe.git
$ cd FinanceMe
$ brew bundle
$ mint bootstrap
$ open FinanceMe.xcworkspace
```

To run static analysis on the project, use the analyze script:

``` bash
$ sh analyze.sh
```
