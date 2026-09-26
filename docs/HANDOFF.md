# BearFetch Continuation Handoff

Last reviewed: 2026-09-26

Read this file first, then `docs/DEVELOPMENT_STATUS.md`, before changing the
repository.

## Product boundaries

- Flutter mobile app for parent-guided child AI learning.
- Parent-only email OTP. Learners never receive independent email/mobile auth.
- One learner per family. Keep parent email in Supabase Auth only.
- Steps 1–27 are scripted learning. Steps 28–36 are scripted chatbot-building
  simulations. Do not add live AI, prompt storage, chatbot training, or bot
  records without an explicit new scope.
- Persist only family/learner state, course progress, retry counts, XP, honey,
  achievements, owned/equipped accessories, and sync/deletion metadata.
- Never persist activity answers, selections, free-text prompts, or simulated
  chatbot output.

## Current checkout

- Working tree is clean (no uncommitted changes) as of 2026-09-26.
- Current branch: `checkpoint/revenuecat-ui-release-prep`, pushed to
  `origin`. Not yet merged into `main`. Open the PR from the link GitHub
  printed on push (`https://github.com/alwayskumar-global/bearfetch-app/pull/new/checkpoint/revenuecat-ui-release-prep`)
  when ready to merge.
- Head commit: `75c3792 feat: RevenueCat progress insight, Figma UI fixes,
  splash/icons, manual release flow` — this is the former dirty worktree,
  committed as one checkpoint. It bundles:
  - Figma-aligned onboarding and course activity UI corrections;
  - chatbot-choice/training-example/reset behavior and Step 34 bot-test flow;
  - dynamic shop balance, buy/equip/remove state, equipment artwork variants,
    and shop visual fixes;
  - splash screen, Android/iOS app icons, and launch assets;
  - RevenueCat parent-only progress-insight lifetime purchase, verified
    against RC Test Store on-device (see RevenueCat state below);
  - a cosmetic overlay patch in `profile_screen.dart` so the Profile screen's
    settings row reads "Parent settings" (the baked-in `profile.png` art still
    says "Notifications" at that position; the tap target always routed to
    `/parent-settings` — only the visible label was wrong);
  - manual local release flow; GitHub Actions/self-hosted runner removal.
- `main` still points at `3bbd5e9` until the PR above merges. Do not
  `git reset --hard`, checkout files from `main`, or discard branch changes.

## Architecture map

- Entry/bootstrap: `lib/main.dart`, `lib/core/bootstrap/app_bootstrap.dart`.
- Runtime config: `lib/core/config/app_config.dart`. Public compile-time values
  only; never put service-role, SMTP, signing, Apple, Sentry auth, or RevenueCat
  secret keys in Dart defines.
- State/data: Riverpod repository interfaces in
  `lib/domain/repositories/app_repositories.dart`; Drift/local implementation
  in `lib/data/repositories/local_app_repository.dart`; Supabase adapters in
  `lib/data/repositories/supabase_repositories.dart`.
- Routing/auth: `lib/core/routing/app_router.dart` and
  `lib/core/state/auth_state.dart`.
- Product UI: `lib/features/`; activity definitions/content come from
  `assets/content/course_manifest.json`.
- Privacy/deletion operations: `docs/OPERATIONS.md`.

## Run and verify

```bash
cd /Users/krishnakumar/Documents/Bearfetch-App
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test
git diff --check
```

Development run/build uses ignored local config:

```bash
cp config/development.example.json config/development.json
flutter run --flavor development --dart-define-from-file=config/development.json
flutter build apk --debug --flavor development \
  --dart-define-from-file=config/development.json
```

For local Supabase tests, start only one Docker engine. This machine previously
had both Docker Desktop and Colima active; the `docker` CLI targeted Colima.

```bash
supabase start
supabase db reset --local
supabase test db
supabase db lint --local --level warning
```

## Configuration and secret boundaries

- Ignored local configs: `config/development.json`, `config/production.json`.
- Public app values: `APP_ENV`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`,
  `SENTRY_DSN`, `SENTRY_ENVIRONMENT`,
  `REVENUECAT_ANDROID_PUBLIC_SDK_KEY`,
  `REVENUECAT_IOS_PUBLIC_SDK_KEY`.
- Development-only RevenueCat Test Store key:
  `REVENUECAT_TEST_STORE_API_KEY`. Never use it in production.
- Store Android keystore/key properties and Apple signing material outside Git;
  see `docs/SETUP.md`.
- Supabase/Resend/Sentry server credentials remain server/local-release-machine
  secrets. Never expose them through Flutter or public Supabase config.

## RevenueCat state

- Parent Settings owns purchase UI. It unlocks only active entitlement
  `progress_insight_requests`.
- Product: non-consumable `$4.99` `bearfetch_progress_insight_lifetime`,
  attached to entitlement `progress_insight_requests` and to the `$rc_lifetime`
  package in the current RevenueCat offering.
- RevenueCat **Test Store** is configured end to end and verified working on
  the Android emulator: product, entitlement, and offering/package created in
  the RC dashboard; `REVENUECAT_TEST_STORE_API_KEY` set in the ignored
  `config/development.json`; purchase completes and the entitlement persists
  (tracked by RevenueCat against the demo parent user id, independent of local
  app state/reinstall).
- The post-purchase UI no longer collects a free-text request or opens a
  `mailto:` composer. An unlocked parent sees a static confirmation only:
  "Your lifetime access is active. We will email your family a progress
  insight directly — no further action needed." This is forward-looking copy;
  **no backend email pipeline exists yet** (still a deliberate non-goal below).
  `url_launcher` was removed from `parent_settings_screen.dart` since nothing
  in the file uses it anymore.
- Missing public key/offering/package must stay disabled. No local unlock.
- Remaining external work: real Android/iOS RevenueCat apps (public SDK keys),
  Google Play/App Store sandbox purchase+restore tests. Test Store path needs
  no store account and is sufficient for RevenueCat Shipaton "Next Gen Award"
  submission, which explicitly does not require a store release.

## Next work

1. Open/merge the PR for `checkpoint/revenuecat-ui-release-prep` into `main`
   (repo must be public with a LICENSE file for the RevenueCat Shipaton
   "Next Gen Award" submission — verify both before merging).
2. Run full manual regression: onboarding/auth, all course steps, Step 34,
   rewards, shop purchase/equip/remove, restart persistence, privacy/deletion.
3. RevenueCat Test Store entitlement/purchase/restore is verified (see
   RevenueCat state below); Google Play/App Store sandbox tests remain.
4. Complete deferred Resend/Supabase production email setup.
5. Complete release gates: signed Android AAB/Play testing, then iOS signing,
   archive, and App Store testing.
6. Complete legal/privacy release review before child-directed public launch.

## Deliberate non-goals

- No GitHub Actions or self-hosted runner. Local manual validation is required.
- No push backend.
- No real AI/chatbot backend.
- No automatic support-email sending or backend email for progress insights.

## Copyable continuation prompt

```text
You are continuing BearFetch in /Users/krishnakumar/Documents/Bearfetch-App.

Read docs/HANDOFF.md, docs/DEVELOPMENT_STATUS.md, docs/SETUP.md, and AGENTS.md
if present before acting. Treat docs/HANDOFF.md as current working handoff;
DEVELOPMENT_STATUS.md records longer-term completed/deferred boundaries.

Current branch is checkpoint/revenuecat-ui-release-prep, pushed to origin,
not yet merged to main. First inspect git status, git branch, and git log to
confirm you are still on it. Do not discard, reset, or check out files from
main over this branch's work (UI, splash/icon, shop equipment artwork,
RevenueCat, GitHub Actions removal) unless the user explicitly asks otherwise.

Product rules: parent-only email OTP; no learner auth; one learner per family;
steps 28–36 are scripted simulations; no live AI/chatbot/prompt storage. Do
not persist activity answers, free text, or simulated bot output. Keep all
secrets out of Flutter, Dart defines, Git, and public Supabase config.

Use manual local checks: dart format --output=none --set-exit-if-changed lib
test; flutter analyze --no-pub; flutter test; git diff --check. Build/run with
--flavor development --dart-define-from-file=config/development.json. Do not
add GitHub Actions/self-hosted runner unless user explicitly reverses decision.

For RevenueCat, keep purchases parent-only and entitlement-gated. Missing
public key/offering/product must disable purchase, never fake-unlock it.
Report verified facts separately from external prerequisites. Make scoped
changes, test proportionally, and update docs/HANDOFF.md plus
docs/DEVELOPMENT_STATUS.md whenever current state or pending work changes.
```
