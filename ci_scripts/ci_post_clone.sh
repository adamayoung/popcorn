#!/bin/sh

set -e

# SwiftLint on Analyze action

if [ $CI_XCODEBUILD_ACTION = 'analyze' ];
then

    cd $CI_WORKSPACE
    swift format lint -r -p .
fi
