#!/bin/bash

# Set variables
PROJECT_NAME="WeatherDemo"
SCHEME_NAME="WeatherDemo"
CONFIGURATION="Debug"

# Build the Xcode project
echo "Building the Xcode project..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" \
           -scheme "$SCHEME_NAME" \
           -configuration "$CONFIGURATION" \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           clean build

if [ $? -eq 0 ]; then
    echo "Build completed successfully."
else
    echo "Build failed."
    exit 1
fi