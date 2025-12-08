#!/bin/sh

set -eo pipefail

# Disable macro fingerprint validation
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# SwiftLint on Analyze action
if [ $CI_XCODEBUILD_ACTION = 'analyze' ];
then
    cd $CI_PRIMARY_REPOSITORY_PATH
    swift format lint -r -p .
fi
