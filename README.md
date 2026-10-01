# BearFetch

BearFetch is a gamified AI learning app for K–12 students that turns AI literacy into an interactive, hands-on experience. Its first course, From Understanding to Building LLMs, uses activities covering AI chatbots, tokens, prediction, prompting, and chatbot building, with XP, badges, certificates, and Honey Jars rewarding progress. BearFetch also includes a parent experience with Progress Insight, connecting student learning progress with parent visibility.

## Hackathon

Shipaton 2026 Next Gen submission material:

- [Submission checklist](docs/HACKATHON.md)
- [Setup and configuration](docs/SETUP.md)
- [Security policy](SECURITY.md)
- [MIT license](LICENSE)

## Stack

- Flutter `3.41.4` / Dart `3.11.1`
- Java `17`
- Android compile SDK `37`
- Supabase Auth/data sync
- RevenueCat parent-only lifetime entitlement

## Run locally

```bash
cp config/development.example.json config/development.json
flutter pub get
flutter run --flavor development --dart-define-from-file=config/development.json
```

Never commit `config/development.json`, `config/production.json`, keystores,
service-role keys, SMTP/Resend credentials, RevenueCat secret keys, or child
data. Dart defines become part of app binary.

## RevenueCat demo

Parent Settings contains Progress insight lifetime purchase. Development Test
Store config uses local-only `REVENUECAT_TEST_STORE_API_KEY`. It must stay out
of Git and production builds.

Run before pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

See [docs/SETUP.md](docs/SETUP.md) for signing, production values, Supabase,
RevenueCat, Sentry, and release setup. See [docs/HANDOFF.md](docs/HANDOFF.md)
for current scope and known deferred work.
