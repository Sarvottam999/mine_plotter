#!/bin/bash

DEVICE_ID="10BD8X17Y90008R"  # Set your preferred device ID

echo "Building APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Installing APK on device: $DEVICE_ID..."
    flutter install -d $DEVICE_ID
else
    echo "Build failed. Check errors above."
    exit 1
fi
