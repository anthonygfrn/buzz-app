#!/bin/bash
# Install XcodeGen if it's not already installed
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen not found. Installing..."
    brew install xcodegen
fi

ls .

# Change to the project directory
cd ..

# Generate the Xcode project using XcodeGen
echo "Generating Xcode project..."
xcodegen

# Ensure the .xcodeproj file is generated
if [ ! -d "buzz-app.xcodeproj" ]; then
    echo "Error: buzz-app.xcodeproj not found!"
    exit 1
fi

# Ensure the project.xcworkspace folder exists
if [ ! -d "buzz-app.xcodeproj/project.xcworkspace" ]; then
    echo "Error: project.xcworkspace not found!"
    exit 1
fi

echo "Checking xcshareddata directory..."
# Create xcshareddata directory if it doesn't exist
if [ ! -d "buzz-app.xcodeproj/project.xcworkspace/xcshareddata" ]; then
    echo "Creating xcshareddata directory..."
    mkdir -p buzz-app.xcodeproj/project.xcworkspace/xcshareddata
fi

# Create swiftpm directory if it doesn't exist
if [ ! -d "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm" ]; then
    echo "Creating swiftpm directory..."
    mkdir -p buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
fi

# Create Package.resolved file if it doesn't exist
if [ ! -f "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Creating Package.resolved file..."
    touch buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
fi

# Resolve package dependencies to generate Package.resolved
echo "Resolving package dependencies..."
xcodebuild -resolvePackageDependencies -project buzz-app.xcodeproj -scheme buzz-app

# Check if Package.resolved was created
if [ -f "buzz-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Package.resolved generated successfully."
else
    echo "Failed to generate Package.resolved."
    exit 1
fi
