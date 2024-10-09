#!/bin/bash

# Change to the project directory
cd ..
echo "Current directory: $(pwd)"

# Ensure the .xcodeproj is generated
echo "Generating buzz-app.xcodeproj using xcodegen..."
xcodegen generate --spec project.yml

# Check if the project file exists
if [ ! -d "buzz-app.xcodeproj" ]; then
    echo "Error: buzz-app.xcodeproj not found!"
    exit 1
fi


# Check if the project file exists
if [ ! -d "buzz-app.xcodeproj" ]; then
    echo "Error: buzz-app.xcodeproj not found!"
    exit 1
fi

# Resolve Swift package dependencies
echo "Resolving Swift package dependencies..."
if [ -f "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Package.resolved already exists."
else
    echo "Resolving packages..."
    xcodebuild -resolvePackageDependencies -project "buzz-app.xcodeproj"
fi
