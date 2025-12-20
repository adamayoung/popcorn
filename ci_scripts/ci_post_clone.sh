#!/bin/sh

set -eo pipefail

# Disable macro fingerprint validation
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# SwiftLint on Analyze action
if [ $CI_XCODEBUILD_ACTION = 'analyze' ];
then
    brew install swiftlint swiftformat

    cd $CI_PRIMARY_REPOSITORY_PATH
    swiftlint --strict .
    swiftformat --lint .
fi
