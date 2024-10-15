#!/bin/bash
#
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen not found. Installing..."
    brew install xcodegen
fi

ls .

cd ..

echo "Generating Xcode project..."
xcodegen

if [ ! -d "buzz-app.xcodeproj" ]; then
    echo "Error: buzz-app.xcodeproj not found!"
    exit 1
fi

if [ ! -d "buzz-app.xcodeproj/project.xcworkspace" ]; then
    echo "Error: project.xcworkspace not found!"
    exit 1
fi

echo "Checking xcshareddata directory..."

if [ ! -d "buzz-app.xcodeproj/project.xcworkspace/xcshareddata" ]; then
    echo "Creating xcshareddata directory..."
    mkdir -p buzz-app.xcodeproj/project.xcworkspace/xcshareddata
fi

if [ ! -d "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm" ]; then
    echo "Creating swiftpm directory..."
    mkdir -p buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
fi

if [ ! -f "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Creating Package.resolved file..."
    touch buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
fi

echo "Resolving package dependencies..."
xcodebuild -resolvePackageDependencies -project buzz-app.xcodeproj -scheme buzz-app

if [ -f "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Package.resolved generated successfully."
else
    echo "Failed to generate Package.resolved."
    exit 1
fi
