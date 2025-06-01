# Build TrainingArc
xcodebuild -project HaruNotes.xcodeproj -scheme HaruNotes build

# Run TrainingArc on simulator
# First boot a simulator, then use:
xcodebuild -project HaruNotes.xcodeproj -scheme HaruNotes -destination 'platform=iOS Simulator,name=iPhone 15 Pro' run


test: this was from right after the green