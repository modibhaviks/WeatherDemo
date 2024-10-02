#!/bin/bash

# Set variables
PROJECT_NAME="WeatherDemo"
SCHEME_NAME="WeatherDemo"
CONFIGURATION="Debug"
COVERAGE_DIR="coverage"

# Build the Xcode project
echo "Running unit tests..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" \
                -scheme "$SCHEME_NAME" \
                -configuration "$CONFIGURATION" \
                -enableCodeCoverage YES \
                CODE_SIGN_IDENTITY="" \
                CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO \
                -resultBundlePath "$COVERAGE_DIR" \
		'platform=iOS Simulator,name=iPhone 15 Pro,OS=17.4' \
		test

if [ $? -eq 0 ]; then
    echo "Unit tests completed successfully."
else
    echo "Unit tests failed."
    exit 1
fi