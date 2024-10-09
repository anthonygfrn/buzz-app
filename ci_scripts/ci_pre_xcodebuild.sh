bash
#!/bin/bash

ls .

# Change to the project directory
# cd .
# cd ./buzz-app
cd ..

# Resolve Swift package dependencies
echo "Resolving Swift package dependencies..."
if [ -f "*.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ]; then
    echo "Package.resolved already exists."
else
    echo "Resolving packages..."
    xcodebuild -resolvePackageDependencies -project *.xcodeproj
fi
