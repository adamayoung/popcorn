#!/bin/sh

set -eo pipefail

# Disable macro fingerprint validation
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# SwiftLint on Analyze action
if [ "$CI_XCODEBUILD_ACTION" = 'analyze' ];
then
    if ! command -v swiftlint >/dev/null 2>&1 || ! command -v swiftformat >/dev/null 2>&1; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew install swiftlint swiftformat
    fi

    cd "$CI_PRIMARY_REPOSITORY_PATH"
    swiftlint --strict .
    swiftformat --lint .
fi
