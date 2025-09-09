#!/bin/bash

# Change this to your simulator name or UDID
SIM_NAME="iPhone 16 Pro"

echo "🔄 Cleaning Flutter build..."
flutter clean

echo "📦 Fetching Flutter packages..."
flutter pub get

echo "🖥 Launching iOS Simulator: $SIM_NAME..."
open -a Simulator

# Wait a few seconds for simulator to boot
echo "⏳ Waiting 5 seconds for simulator to boot..."
sleep 5

echo "🚀 Running Flutter app on $SIM_NAME..."
flutter run -d "$SIM_NAME"

echo "✅ Done!"
