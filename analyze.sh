#!/bin/bash

# Set variables
PROJECT_NAME="WeatherDemo"
SCHEME_NAME="WeatherDemo"

# Build the Xcode project
echo "Building the Xcode project..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" \
		-scheme "$SCHEME_NAME" \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO \
		analyze

if [ $? -eq 0 ]; then
    echo "Static code analysis completed successfully."
else
    echo "Static code analysis failed."
    exit 1
fi