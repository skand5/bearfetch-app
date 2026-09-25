# BearFetch

Offline-first Flutter learning app for children. Course content and chatbot-building activities are scripted assets; application contains no AI/chatbot runtime.

Start continuation work with [docs/HANDOFF.md](docs/HANDOFF.md). It records
current worktree state, product boundaries, verification commands, secrets, and
next work.

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

See [docs/SETUP.md](docs/SETUP.md) for local signing, environment, Supabase,
Resend, Sentry, validation, and release setup.
