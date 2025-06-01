# Build HaruNotes
xcodebuild -project HaruNotes.xcodeproj -scheme HaruNotes build

# Run HaruNotes on simulator
xcrun simctl boot "iPhone 15 Pro"  # Boot simulator
xcodebuild -project HaruNotes.xcodeproj -scheme HaruNotes -destination 'platform=iOS Simulator,name=iPhone 15 Pro' run