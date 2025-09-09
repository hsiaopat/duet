#!/bin/bash

echo "🔄 Cleaning Flutter build cache..."
flutter clean

echo "📦 Getting Flutter packages..."
flutter pub get

echo "🧹 Erasing all iOS simulators..."
xcrun simctl erase all

echo "🚪 Restarting Simulator app..."
killall Simulator 2>/dev/null
open -a Simulator

echo "✅ Done! Your iOS environment is fresh."
