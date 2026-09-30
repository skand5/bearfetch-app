# Contributing

## Local setup

```bash
cp config/development.example.json config/development.json
flutter pub get
flutter run --flavor development --dart-define-from-file=config/development.json
```

`config/development.json` is local-only. Never commit it.

## Before a pull request

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Security and privacy

Do not add secrets, signing files, production config, generated APKs, or real
child/parent data. See [SECURITY.md](SECURITY.md) and
[docs/SETUP.md](docs/SETUP.md).
