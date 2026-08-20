# BearFetch

Offline-first Flutter learning app for children. Course content and chatbot-building activities are scripted assets; application contains no AI/chatbot runtime.

## Toolchain

- Flutter `3.41.4` / Dart `3.11.1`
- Java `17`
- Android compile SDK `37`
- Full Xcode installation for iOS builds

## Local run

```bash
cp config/development.example.json config/development.json
flutter pub get
flutter run --flavor development --dart-define-from-file=config/development.json
```

Development build may run without backend credentials until Supabase integration lands. Production builds fail at startup unless every required public value is supplied.

See [docs/SETUP.md](docs/SETUP.md) for signing, environment, CI, Supabase, Resend, and Sentry setup.
