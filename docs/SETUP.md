# BearFetch setup and release foundation

## 1. Required local tools

Install in this order:

1. Flutter `3.41.4` with Dart `3.11.1`.
2. Java `17`.
3. Android SDK with compile SDK `37`, platform tools, build tools, and accepted licenses.
4. Full Xcode, not Command Line Tools only. Select it with `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`.
5. CocoaPods if Flutter reports pod integration is required.

Verify:

```bash
flutter doctor -v
java -version
xcodebuild -version
```

Current machine has Command Line Tools selected, not full Xcode. iOS compile/archive verification remains blocked until full Xcode is installed and selected.

## 2. Build environments

Permanent production identifiers:

```text
Android application ID: com.bearfetch.app
iOS bundle ID:          com.bearfetch.app
```

Development identifiers:

```text
Android application ID: com.bearfetch.app.dev
iOS bundle ID:          com.bearfetch.app.dev
```

Never place service-role keys, SMTP credentials, signing secrets, Apple private keys, or `SENTRY_AUTH_TOKEN` in Dart defines. Dart defines are compiled into app.

Prepare local development config:

```bash
cp config/development.example.json config/development.json
```

Required production values:

```text
APP_ENV=production
SUPABASE_URL=https://PROJECT_REF.supabase.co
SUPABASE_ANON_KEY=public anon/publishable client key
SENTRY_DSN=public Sentry Flutter DSN
SENTRY_ENVIRONMENT=production
REVENUECAT_ANDROID_PUBLIC_SDK_KEY=RevenueCat Android public SDK key
REVENUECAT_IOS_PUBLIC_SDK_KEY=RevenueCat iOS public SDK key
```

Run development:

```bash
flutter run \
  --flavor development \
  --dart-define-from-file=config/development.json
```

Do not commit `config/development.json` or `config/production.json`.

### RevenueCat purchase setup

The parent-only Progress insight request is a one-time, non-consumable $4.99
purchase. It is disabled until RevenueCat returns a configured offering; no
local demo bypass exists.

Complete setup in this order:

1. Create RevenueCat apps for Android `com.bearfetch.app` and iOS
   `com.bearfetch.app`.
2. Create each platform's non-consumable product with identifier
   `bearfetch_progress_insight_lifetime` and price $4.99.
3. Create entitlement `progress_insight_requests`.
4. Add each product to the current/default offering as its lifetime package.
5. Put only each app's RevenueCat **public SDK key** in the platform key fields
   above. Never use a RevenueCat secret key in Flutter, Dart defines, local mobile
   build arguments, APKs, or iOS bundles.
6. For hackathon development, put a RevenueCat Test Store key only in the
   uncommitted `config/development.json` field
   `REVENUECAT_TEST_STORE_API_KEY`. It has precedence in development and must
   be empty for production.
7. In Google Play Console, activate billing and test with a licensed tester.
   The Android billing permission is already in
   `android/app/src/main/AndroidManifest.xml`.
8. In Apple Developer / App Store Connect, enable In-App Purchase for the App
   ID and create the matching non-consumable product. This is a portal setting,
   not a distributable entitlement file.

Manual release gate: Test purchase and Restore Purchase in RevenueCat Test
Store first, then both Google Play and App Store sandboxes. Verify active
`progress_insight_requests` entitlement in RevenueCat dashboard before release.

## 3. Android release signing

Create upload keystore outside repository:

```bash
keytool -genkeypair -v \
  -keystore /secure/path/bearfetch-upload.jks \
  -keyalg RSA \
  -keysize 4096 \
  -validity 10000 \
  -alias bearfetch-upload
```

Copy template:

```bash
cp android/key.properties.example android/key.properties
```

Set absolute keystore path and real passwords inside `android/key.properties`. File and keystore are ignored by Git. Store both in password manager and encrypted backup. Losing upload key creates store-recovery work; losing Play App Signing access can block updates.

Build:

```bash
flutter build appbundle \
  --release \
  --flavor production \
  --dart-define-from-file=config/production.json
```

Production release Gradle tasks fail before compilation if `android/key.properties` or any required signing field is missing.

## 4. Apple signing

Required Apple setup:

1. Register App ID `com.bearfetch.app` in Apple Developer.
2. Create App Store Connect app using same bundle ID.
3. Create Apple Distribution certificate.
4. Create App Store provisioning profile.
5. Copy `ios/Flutter/Signing.example.xcconfig` to `ios/Flutter/Signing.local.xcconfig`.
6. Fill Team ID and exact provisioning-profile name.
7. Keep certificate, `.p12`, `.p8`, and profiles outside Git.

Build:

```bash
flutter build ipa \
  --release \
  --flavor production \
  --export-options-plist=ios/ExportOptions.local.plist \
  --dart-define-from-file=config/production.json
```

iOS schemes:

```text
development
production
```

## 5. Supabase local development

Required dependencies:

1. Supabase CLI `2.75.0` or compatible.
2. Docker Desktop running.

Start and validate the local stack before changing a migration:

```bash
supabase start
supabase db reset --local
supabase test db
supabase db lint --local --level warning
```

Local development endpoints are printed by `supabase status`. Mailpit is used
for local OTP delivery; it does not send real email. Do not copy local secret or
service-role keys into Flutter configuration.

Migration order:

1. Add or change a timestamped file in `supabase/migrations/`.
2. Run `supabase db reset --local` to prove clean replay.
3. Run pgTAP and lint gates above.
4. Review the SQL and generated diff.
5. Apply remotely only after the project is linked and a production backup and
   deployment window are confirmed.

Never test destructive database operations against the single remote project.

## 6. Supabase, Resend, and Sentry accounts

Accounts are not required for Section 1 development builds. Before authentication work:

1. Create one Supabase project in chosen US region.
2. Record project URL and public anon/publishable key.
3. Never copy service-role key into Flutter config.
4. Create Resend account and verify sender domain.
5. Publish SPF, DKIM, and DMARC DNS records.
6. Configure Resend as Supabase custom SMTP; disable link/open tracking.
7. Create Sentry Flutter project and record public DSN.

Single remote project risk: after public launch, remote database is production. Rehearse migrations locally with Supabase CLI, back up production, and never use production for destructive development tests.

## 7. Local release material

GitHub Actions is not used. Keep all release material on the trusted release
machine and outside Git:

- Android upload keystore and `android/key.properties`.
- Apple distribution certificate, provisioning profile, App Store Connect key,
  and `ios/Flutter/Signing.local.xcconfig`.
- Supabase management credentials and Sentry auth token only when a local
  server migration or symbol-upload command requires them.

Never place these in Flutter Dart defines, `config/*.json`, Supabase client
configuration, or source control. Store copies in an encrypted password manager
or encrypted backup.

## 8. Manual validation and builds

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
dart run build_runner build
git diff --exit-code -- lib/data/local/app_database.g.dart
flutter build apk --debug --flavor development --dart-define-from-file=config/development.json
supabase test db
supabase db lint --local --level warning
git diff --check
```

Build signed Android AAB after configuring `android/key.properties` and
`config/production.json`:

```bash
flutter build appbundle --release --flavor production \
  --dart-define-from-file=config/production.json
```

Build iOS IPA after configuring Apple signing and full Xcode:

```bash
flutter build ipa --release --flavor production \
  --export-options-plist=ios/ExportOptions.local.plist \
  --dart-define-from-file=config/production.json
```
