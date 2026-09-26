# BearFetch Development Status

Last updated: 2026-09-26

This is the canonical completion and pending-work record for the BearFetch app. Update it whenever a section, external prerequisite, release gate, or explicitly deferred item changes.

## Status legend

- **Complete**: implemented, verified, and committed locally.
- **Configured only**: values or scaffolding exist, but the runtime integration is not implemented or verified.
- **Next**: approved work to implement next.
- **Later — user deferred**: intentionally postponed by the user; it must remain visible until completed.
- **External prerequisite**: requires an account, credential, legal decision, store setup, or machine setup.
- **Release gate**: must pass before a public production release.

## Complete

### Current worktree handoff — 2026-09-26

- `docs/HANDOFF.md` is canonical for current checkout continuation:
  architecture map, configuration, manual verification, product boundaries,
  and next work.
- The former dirty worktree (UI/payment/tooling work) is committed as a single
  checkpoint on branch `checkpoint/revenuecat-ui-release-prep`
  (`75c3792 feat: RevenueCat progress insight, Figma UI fixes, splash/icons,
  manual release flow`) and pushed to `origin`. Working tree is clean. The
  branch is **not yet merged into `main`** — open the PR when ready.
- GitHub Actions and self-hosted runner remain intentionally removed. Manual
  local checks in `docs/SETUP.md` are required before merge/release.
- RevenueCat Test Store purchase/entitlement flow is device-verified (see
  RevenueCat section below). The Profile screen's settings row visibly said
  "Notifications" while always routing to Parent settings; a cosmetic overlay
  patch in `profile_screen.dart` corrects the visible label to match.

### RevenueCat parent-only progress insight purchase

- Parent Settings contains a RevenueCat-gated lifetime purchase for a human
  progress-insight request. Child UI, course access, privacy controls, and
  honey shop remain free and unchanged.
- Unlock state comes only from active RevenueCat entitlement
  `progress_insight_requests`; missing keys, offerings, or product packages
  leave the buy path disabled.
- An unlocked parent sees a static confirmation only (no text field, no
  `mailto:` composer): lifetime access is active and BearFetch will email a
  progress insight directly. This is intentionally forward-looking copy — no
  backend email flow exists. `url_launcher` was removed since nothing else in
  `parent_settings_screen.dart` used it.
- **Verified 2026-09-25 on the Android emulator against RevenueCat's Test
  Store**: product `bearfetch_progress_insight_lifetime` (non-consumable,
  $4.99), entitlement `progress_insight_requests`, and the `$rc_lifetime`
  package on the current offering are created in the RC dashboard;
  `REVENUECAT_TEST_STORE_API_KEY` is set in the git-ignored
  `config/development.json`; purchase completes instantly with no real store
  account, and the entitlement is tracked by RevenueCat against the parent
  user id (persists independent of local app reinstall/demo-state reset).
- Real Android/iOS RevenueCat apps (public SDK keys), Google Play/App Store
  sandbox purchase+restore tests, and Play Console/App Store Connect product
  setup remain external prerequisites for a store release. They are **not**
  required for the RevenueCat Shipaton "Next Gen Award" submission, which
  explicitly waives the store-release requirement — the Test Store flow
  already satisfies that award's "working RevenueCat purchase" bar.

### Approved Flutter UI baseline

- Current approved Figma-to-Flutter prototype is committed as the visual baseline.
- Local routes and scripted activity screens are present.
- Steps 28–36 remain scripted visual simulations only. They do not create, train, configure, store, or test a real chatbot.
- No AI API, chatbot engine, live prompt processing, or backend bot records are required.
- Baseline commit: `d74df72 chore: capture approved Flutter UI baseline`.

Visual acceptance remains the current Flutter UI and approved Figma screenshots. Any future wiring must preserve accepted dimensions, typography, spacing, artwork, and interaction states.

### Parent-only sign-in correction

- The onboarding **Sign in** action opens the parent account screen in an
  explicit returning-parent mode; it no longer bypasses credentials and routes
  directly to Home in local builds.
- Returning parents enter their account email only and receive a six-digit
  email sign-in code. New family account creation continues to require the
  parent name and email.
- Learners, including learners aged 12+, do not receive independent email or
  mobile authentication. Any future independent teen-account proposal requires
  a separate approved privacy, consent, authentication, and legal scope.

### Section 1 — Repository and release foundation

- Git repository initialized and current UI baseline committed.
- Android production application ID and iOS production bundle ID set to `com.bearfetch.app`.
- Development identifiers use the `.dev` suffix.
- Development and production flavors/schemes added.
- Runtime validation added for:
  - `APP_ENV`
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - `SENTRY_DSN`
  - `SENTRY_ENVIRONMENT`
- Secret, signing, environment, and generated-output exclusions added to `.gitignore`.
- Android upload-keystore configuration and validation scaffolding added.
- iOS scheme/configuration templates added.
- Setup and secret-location documentation added in `docs/SETUP.md`.
- Local analysis, tests, and Android debug build passed at the Section 1 checkpoint.
- Section commit: `6f5a229 build: add production release foundation`.

### Section 2 — Offline architecture and persistent state

- Disposable `PrototypeState` removed.
- Drift schema upgraded to v2 with:
  - parent profile and consent state;
  - one learner profile, nickname, avatar, age band, and language;
  - activity completion and retry counts;
  - append-only XP and honey ledger with idempotency keys;
  - achievements;
  - owned accessories;
  - equipped accessories by slot;
  - sync outbox, retry metadata, and sync state.
- v1-to-v2 migration preserves existing profile, progress, rewards, and accessories.
- Activity answers, selections, prompts, and simulated chatbot outputs are not persisted.
- `assets/content/course_manifest.json` contains 17 stable activity IDs while visible course progress remains out of 36 steps.
- Manifest sequence—not display-step number—controls next activity routing.
- Repository contracts added for auth, parent, learner, consent, progress, rewards, shop, sync, and privacy.
- Local Drift repository implementations and immutable Riverpod controllers added.
- Activity completion is transactional and idempotent:
  - `+10 XP` once;
  - `+5 honey` once;
  - one outbox event;
  - repeated taps do not duplicate rewards.
- Course completion awards `+100 XP`, `+50 honey`, AI Explorer badge, and LLM Starter certificate once.
- Purchases are transactional and idempotent; only owned accessories can be equipped.
- Development demo starts Max at the first course activity with 0 XP, 0 honey, no owned or equipped accessories, and no activity progress. Every **Use demo account** sign-in resets those local demo-only values.
- Courses, Shop, and Profile render course progress, balances, owned/equipped accessories, and achievement counts from local state rather than the sample values baked into their Figma artboards.
- Development builds include a clearly labelled local **Use demo account** action.
  It creates no remote user, sends no OTP, performs no Supabase request, and
  enters the local fresh parent/learner experience only. It is unavailable in
  production builds, which continue to require parent email OTP.
- Production starts unconfigured with zero rewards and no accessories.
- Startup-state contracts cover loading, content validation failure, local migration failure, recoverable sync warning, and later expired-session handling.
- Persistent restart behavior verified on Android emulator.
- Verification passed:
  - 24 automated tests;
  - `flutter analyze`;
  - deterministic Drift generation;
  - development ARM64 Android debug APK;
  - emulator install, launch, and cold restart.
- Section commit: `c784fa9 feat: add offline persistent app architecture`.

### Section 3 — Local authentication and server security foundation

- Supabase is initialized before router creation when both public client values
  are configured; persisted sessions are restored by `supabase_flutter`.
- Parent authentication is email-only with six-digit OTP request, verify,
  resend, logout, and expired-session state handling.
- Router policy is implemented and tested for signed-out, expired, learner
  setup, consent setup, and configured-family states.
- Parent and learner data remain local-first and are mirrored to Supabase only
  after authentication.
- Parent email remains only in Supabase Auth. Application tables reference
  `auth.uid()` and do not duplicate the email address.
- Local migrations define parents, one learner per parent, versioned consent,
  progress, course completion, append-only rewards, achievements, accessories,
  equipment, deletion requests, and server-owned activity/accessory metadata.
- RLS is enabled on every public application table. Ownership is derived from
  `auth.uid()`; client-editable metadata is not trusted.
- Security-definer implementations are private and inaccessible to clients;
  fixed-search-path public wrappers validate the authenticated parent before
  invoking them.
- Implemented RPCs:
  - `record_parent_consent`;
  - `complete_activity`;
  - `complete_course`;
  - `purchase_accessory`;
  - `equip_accessory`;
  - `withdraw_consent`;
  - `schedule_deletion`;
  - `cancel_deletion`.
- Activity and course rewards are idempotent. Purchases are atomic and use an
  append-only honey ledger. Server metadata validates activity/accessory IDs.
- Cross-parent RLS and RPC denial, duplicate events, rewards, purchases,
  equipment, consent, and deletion states are covered by pgTAP.
- Local email auth passed end to end through GoTrue and Mailpit: request,
  resend, six-digit verification, session creation, invalid-code rejection,
  and logout.
- Verification passed:
  - 60 pgTAP database tests;
  - database lint with no schema errors;
  - 32 Flutter unit/widget tests;
  - `flutter analyze` with no issues;
  - development ARM64 Android debug APK.
- The remote Supabase project was not linked, migrated, or mutated during this
  checkpoint.

This is the completed local Section 3 checkpoint. Remote activation, production
email delivery, and legal approval remain pending below.

### Section 4 — Sync, privacy, and operational controls

- Local outbox processing now supports idempotent dispatch, bounded exponential
  retry metadata, app-resume triggers, and connectivity-recovery triggers.
- Remote reconciliation is implemented for authenticated sessions. It replaces
  the local snapshot only after queued writes are accepted; completed learning
  is never rolled back by an older remote state.
- Server mutations for progress, purchases, equipment, withdrawal, deletion
  scheduling, and deletion cancellation use stable event IDs. Deletion uses a
  stable client request ID, so an offline schedule-then-cancel sequence remains
  cancellable after sync.
- Parent Settings and restricted-access routes are implemented: family-data
  view/export, consent withdrawal, learner/family deletion scheduling,
  cancellation, and sign-out. Export and deletion actions require a fresh
  email OTP in authenticated builds.
- Withdrawn-consent and pending-deletion router guards restrict learner access
  immediately and cannot be bypassed through onboarding URLs.
- The 30-day deletion lifecycle is implemented locally and in the database
  contract. The protected `purge-deletions` Edge Function and deployment
  procedure are documented in `docs/OPERATIONS.md`; it is not deployed until
  the remote Supabase project is explicitly linked.
- Sentry is now initialized as consent-gated crash reporting only. It sends no
  event before active consent and strips all user/content/request/breadcrumb
  fields from permitted technical crash events. Analytics, replay,
  screenshots, performance tracing, profiles, and user identity are disabled.
- The notification bell remains local UI only; no push registration or
  notification backend was added.
- Verification passed locally:
  - 64 pgTAP Supabase database/RLS/RPC tests after a clean local reset;
  - 38 Flutter unit/widget tests;
  - `flutter analyze` with no issues;
  - development ARM64 Android debug APK.
- The remote Supabase project was not linked, migrated, or mutated during this
  checkpoint.

## Remote Supabase deployment — 2026-08-22

- Local Supabase CLI is linked to the confirmed `BRFT-APP` project in West US
  (North California).
- The remote database initially had no applied migration history. Both reviewed
  repository migrations are now applied:
  `20260822033441_initial_server_schema.sql` and
  `20260822060000_harden_privacy_sync_operations.sql`.
- Linked migration history exactly matches the repository. Remote schema lint
  completed with no errors.
- No production user data, Supabase Auth configuration, SMTP configuration, or
  Edge Function deployment was changed as part of this database deployment.

## Configured only — not yet production-activated

- `config/development.json` contains user-supplied public runtime values and is
  Git-ignored.
- Supabase Auth, migrations, RLS, and RPCs are implemented and verified locally.
  Public remote values being present does **not** mean migrations were applied,
  remote Auth/SMTP was configured, or production was verified.
- Sentry runtime initialization, consent gating, and PII scrubbing are
  implemented locally. Sentry project verification and local symbol upload
  remain unconfigured until the remote/local release prerequisites are available.
- iOS scheme scaffolding exists, but signing and archive verification are incomplete.

## Pending — Section 5: verification and production release

- Complete OTP, session, router-guard, RLS, RPC, idempotency, offline sync, multi-device, shop, privacy, deletion, and Sentry privacy tests.
- Run the full activity, retry, result, completion, reward, shop, accessories, navigation, and native back-button regression suite.
- Add/refresh pixel and golden checks against approved Android and iOS screen sizes.
- Build and verify a signed Android App Bundle.
- Build and verify a signed iOS archive.
- Complete Android and iOS release-candidate review.
- Before launch: remove test data/accounts, rotate applicable credentials, enable backups and rate limits, freeze direct production dashboard edits, and rehearse migrations locally.

## Later — explicitly deferred by the user

These items are intentionally postponed, not complete and not removed from scope.

### Resend email delivery

- User decision: **“I will check Resend later.”**
- Create/confirm the Resend account.
- Verify the sender domain.
- Configure SPF, DKIM, and DMARC.
- Disable open/link tracking.
- Configure Resend as Supabase Auth custom SMTP or the approved Supabase Resend integration.
- Configure the Supabase OTP email template to include `{{ .Token }}`.
- Keep Resend API/SMTP credentials in Supabase/server secret storage only. Do **not** add a `RESEND_API_KEY` to Flutter JSON files.
- This must be completed before production OTP and consent emails are release-ready.

### Manual local release

- GitHub Actions and self-hosted runner configuration were removed by user
  decision. No automated checks, artifact uploads, or GitHub-held signing
  secrets remain.
- Before each merge or release, run the manual format, analysis, test, Drift,
  database, and build commands in `docs/SETUP.md` on the trusted release
  machine.
- Keep Android and Apple signing material, Supabase management credentials, and
  Sentry upload credentials outside Git and outside Flutter client config.

### iOS signing and App Store setup

- User decision: **iOS will be handled next week/later.**
- Install/select full Xcode; the current machine checkpoint had Command Line Tools only.
- Confirm Apple Developer membership and Team ID.
- Create/confirm the App Store Connect app record for `com.bearfetch.app`.
- Configure distribution certificate, provisioning profile, App Store Connect API key, and local signing files.
- Verify simulator behavior and produce a signed archive.

## External prerequisites and open release gates

- Run hosted cross-parent/RPC smoke tests in a controlled non-production test
  fixture before enabling parent sign-in for real users.
- Resend sender/domain configuration is deferred and outstanding.
- Sentry project credentials are configured publicly, but production-safe runtime integration remains outstanding.
- Android upload keystore, secure backup, passwords, Play App Signing, and Play Console app setup are not yet confirmed complete.
- Apple Developer, App Store Connect, signing identities, and full Xcode are outstanding/deferred.
- Qualified US counsel approval is required before describing email-plus consent as legally sufficient or releasing the child-directed flow publicly.
- Restore/confirm the SRS and user-journey source documents for final requirements traceability if they are not safely retained outside Downloads/Trash.

## Persistent product boundaries

- Steps 1–27 are scripted learning activities.
- Steps 28–36 are scripted visual chatbot-building simulations.
- Do not add a real chatbot, AI API, live training, user-created bot record, prompt storage, or backend bot-testing system.
- Persist only parent/consent state, one learner profile, course progress, retry counts, XP, honey, achievements, and owned/equipped bear accessories.
- Never persist activity answers, selections, free-text prompts, or simulated chatbot outputs.

## Recommended order from this checkpoint

1. Section 4 sync and conflict reconciliation against the local Supabase stack.
2. Section 4 Parent Settings, privacy export/withdrawal/deletion, restricted
   router states, and Sentry privacy controls.
3. Complete deferred Resend configuration before hosted production OTP and
   consent-email verification.
4. Link and migrate the confirmed remote Supabase project in a controlled
   deployment window, then run hosted security smoke tests.
5. Section 5 full regression and Android release preparation.
6. Complete local iOS signing and manual IPA verification when the deferred
   prerequisites are ready.
