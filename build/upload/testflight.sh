#!/bin/bash

set -e  # Exit on error

PROJECT_NAME="love"
SRC_DIR="src"
DERIVED_DIR="build/upload/derived"
LOG_FILE="$DERIVED_DIR/upload.log"
LOVE_FILE="$DERIVED_DIR/$PROJECT_NAME.love"
ARCHIVE_PATH="$DERIVED_DIR/$PROJECT_NAME.xcarchive"
EXPORT_PATH="$DERIVED_DIR/export"
IPA_PATH="$EXPORT_PATH/$PROJECT_NAME.ipa"
EXPORT_OPTIONS_PLIST="build/upload/ExportOptions.plist"
PROJECT="build/platform/xcode/$PROJECT_NAME.xcodeproj"
SCHEME="$PROJECT_NAME-ios"

echo "TestFlight upload script. For details check log at $LOG_FILE"

# Check required env vars
if [[ -z "$API_KEY_ID" || -z "$API_ISSUER_ID" ]]; then
  echo "❌ Error: Please export API_KEY_ID and API_ISSUER_ID first."
  echo "Example:"
  echo "  export API_KEY_ID='1A2BC3DEFG'"
  echo "  export API_ISSUER_ID='11223344-5566-7788-99aa-bbccddeeff00'"
  exit 1
fi

# Check for private key existence
if [[ ! -f "$HOME/.appstoreconnect/private_keys/AuthKey_$API_KEY_ID.p8" ]]; then
  echo "❌ Error: Private key not found at $HOME/.appstoreconnect/private_keys/AuthKey_$API_KEY_ID.p8"
  echo "Please ensure you have downloaded it from App Store Connect."
  exit 1
fi

rm -rf "$DERIVED_DIR"
mkdir -p "$DERIVED_DIR"

echo "==> 1/4: Creating $PROJECT_NAME.love from sources"
{
  rm -f "$LOVE_FILE"
  cd "$SRC_DIR"
  zip -r "../$LOVE_FILE" ./*
  cd ..
} > "$LOG_FILE" 2>&1

# Check if only the love file is requested
if [[ "$1" == "-l" || "$1" == "--love-file-only" ]]; then
  echo "✅ Love archive is updated."
  exit 0
fi

echo "==> 2/4: Cleaning and archiving Xcode project"
{
  xcodebuild clean -project "$PROJECT" -scheme "$SCHEME"
  xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -archivePath "$ARCHIVE_PATH" \
    -destination 'generic/platform=iOS' \
    -allowProvisioningUpdates
} > "$LOG_FILE" 2>&1

echo "==> 3/4: Exporting IPA"
{
  xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" \
    -exportPath "$EXPORT_PATH" \
    -allowProvisioningUpdates
} > "$LOG_FILE" 2>&1

echo "==> 4/4: Uploading IPA to TestFlight"
{
  xcrun iTMSTransporter -m upload \
    -assetFile "$IPA_PATH" \
    -apiKey "$API_KEY_ID" \
    -apiIssuer "$API_ISSUER_ID" \
    -v informational
} > "$LOG_FILE" 2>&1

echo "✅ Upload complete. Check TestFlight on App Store Connect."