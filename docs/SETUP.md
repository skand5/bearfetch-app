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
```

Run development:

```bash
flutter run \
  --flavor development \
  --dart-define-from-file=config/development.json
```

Do not commit `config/development.json` or `config/production.json`.

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

## 5. Supabase, Resend, and Sentry accounts

Accounts are not required for Section 1 development builds. Before authentication work:

1. Create one Supabase project in chosen US region.
2. Record project URL and public anon/publishable key.
3. Never copy service-role key into Flutter config.
4. Create Resend account and verify sender domain.
5. Publish SPF, DKIM, and DMARC DNS records.
6. Configure Resend as Supabase custom SMTP; disable link/open tracking.
7. Create Sentry Flutter project and record public DSN.

Single remote project risk: after public launch, remote database is production. Rehearse migrations locally with Supabase CLI, back up production, and never use production for destructive development tests.

## 6. GitHub Actions secrets

Quality CI needs no project credentials. Manual release workflow needs:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
SENTRY_DSN
SENTRY_AUTH_TOKEN
SENTRY_ORG
SENTRY_PROJECT
SUPABASE_ACCESS_TOKEN
SUPABASE_PROJECT_REF
SUPABASE_DB_PASSWORD
ANDROID_KEYSTORE_BASE64
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
ANDROID_STORE_PASSWORD
APPLE_TEAM_ID
IOS_CERTIFICATE_BASE64
IOS_CERTIFICATE_PASSWORD
IOS_PROVISIONING_PROFILE_BASE64
IOS_PROVISIONING_PROFILE_NAME
KEYCHAIN_PASSWORD
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_PRIVATE_KEY
```

`SENTRY_AUTH_TOKEN`, Supabase management credentials, and App Store Connect keys are reserved for later deployment/symbol-upload jobs. They must remain CI-only.

Encode binary signing files without line wrapping:

```bash
base64 < /secure/path/bearfetch-upload.jks | tr -d '\n'
base64 < /secure/path/apple-distribution.p12 | tr -d '\n'
base64 < /secure/path/BearFetch.mobileprovision | tr -d '\n'
```

Protect release environment with required reviewer approval. Do not expose secrets to pull requests from forks.

## 7. Section 1 verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
dart run build_runner build
git diff --exit-code -- lib/data/local/app_database.g.dart
flutter build apk --debug --flavor development --dart-define=APP_ENV=development
git diff --check
```

Signed AAB and IPA jobs remain unavailable until signing/account secrets exist. iOS local verification additionally requires full Xcode.
