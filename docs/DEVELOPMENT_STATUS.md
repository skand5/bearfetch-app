# BearFetch Development Status

Last updated: 2026-08-21

This is the canonical completion and pending-work record for the BearFetch app. Update it whenever a section, external prerequisite, release gate, or explicitly deferred item changes.

## Status legend

- **Complete**: implemented, verified, and committed locally.
- **Configured only**: values or scaffolding exist, but the runtime integration is not implemented or verified.
- **Next**: approved work to implement next.
- **Later — user deferred**: intentionally postponed by the user; it must remain visible until completed.
- **External prerequisite**: requires an account, credential, legal decision, store setup, or machine setup.
- **Release gate**: must pass before a public production release.

## Complete

### Approved Flutter UI baseline

- Current approved Figma-to-Flutter prototype is committed as the visual baseline.
- Local routes and scripted activity screens are present.
- Steps 28–36 remain scripted visual simulations only. They do not create, train, configure, store, or test a real chatbot.
- No AI API, chatbot engine, live prompt processing, or backend bot records are required.
- Baseline commit: `d74df72 chore: capture approved Flutter UI baseline`.

Visual acceptance remains the current Flutter UI and approved Figma screenshots. Any future wiring must preserve accepted dimensions, typography, spacing, artwork, and interaction states.

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
- GitHub Actions CI and release workflow files added locally.
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
- Development first-install fixture seeds Max, 340 XP, 128 honey, Moon Glasses, and Rocket Pack once.
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

## Configured only — not yet implemented end to end

- `config/development.json` contains local public runtime values and is Git-ignored.
- Supabase URL and anon/publishable key being present does **not** mean Supabase Auth, tables, RLS, RPCs, migrations, or sync are complete.
- Sentry DSN and environment being present does **not** mean Sentry initialization, consent gating, PII scrubbing, or symbol upload are complete.
- GitHub workflow files exist locally, but they do not run until the repository/remote and Actions secrets are configured.
- iOS scheme scaffolding exists, but signing and archive verification are incomplete.

## Next — Section 3: Supabase authentication, consent, and server data model

### Flutter authentication and routing

- Initialize Supabase before router creation and restore persisted sessions.
- Change onboarding contact input from email-or-mobile to email only.
- Implement six-digit email OTP request, verify, expiry, resend, logout, and session restoration.
- Add router guards for onboarding, consent, learner setup, authenticated app, withdrawn consent, and pending deletion.

### Supabase database and security

- Rehearse all migrations with local Supabase CLI before applying them remotely.
- Add application tables for parents, learners, consent records, progress, reward transactions, achievements, owned/equipped accessories, deletion requests, and server-side content/accessory metadata.
- Store the parent email only in Supabase Auth; application tables reference `auth.uid()`.
- Enable RLS on every public table and add ownership policies derived only from `auth.uid()`.
- Add cross-parent denial tests for every table and RPC.
- Keep the service-role key only in Edge Functions/server infrastructure; never put it in Flutter config.

### Server operations

- Implement and test:
  - `complete_activity(activity_id, event_id)`;
  - `complete_course(event_id)`;
  - `purchase_accessory(accessory_id, event_id)`;
  - `equip_accessory(accessory_id, event_id)`;
  - `withdraw_consent()`;
  - `schedule_deletion(target)`;
  - `cancel_deletion(request_id)`.
- Validate bundled content/accessory IDs server-side.
- Enforce idempotent activity/course rewards and an append-only reward ledger.
- Make honey purchases online-only and atomic.

### Consent

- Add direct privacy notice and versioned consent text.
- Store email-plus consent record, confirmation state, withdrawal timestamp, and audit timestamps.
- Send a follow-up confirmation email after consent.
- Obtain qualified US counsel approval for the exact COPPA/email-plus eligibility and wording before public release.

## Pending — Section 4: sync, privacy, and operations

- Process the local outbox with exponential backoff, idempotency keys, connectivity triggers, and app-resume triggers.
- Reconcile remote state after login, reinstall, and use on a second device.
- Apply conflict policies:
  - furthest valid learning completion wins;
  - latest server-accepted profile/equipment timestamp wins;
  - completed learning is never rolled back by older remote progress.
- Add Parent Settings and Privacy routes for viewing data, consent confirmation, export, consent withdrawal, learner deletion, family deletion, deletion cancellation, sign-out.
- Require fresh email OTP before export or deletion.
- Immediately restrict learner access and sync after consent withdrawal or a deletion request.
- Implement the 30-day deletion lifecycle, scheduled hard purge, Auth deletion, and documented backup expiry.
- Implement Sentry as crash reporting only:
  - no analytics, replay, screenshots, performance traces, user text, email, learner name, or form/activity answers;
  - `sendDefaultPii = false`;
  - send nothing before active consent;
  - scrub again in `beforeSend`;
  - upload symbols/source maps using CI-only credentials.
- Keep the notification bell local; do not add push registration or a notification backend.

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

### GitHub repository and CI secrets

- User decision: **GitHub is not yet set up.**
- Create/connect the GitHub repository and remote.
- Push the existing local commits.
- Configure branch protection and required checks.
- Add CI-only secrets listed in `docs/SETUP.md`.
- Verify CI, secret scanning, Android release build, and later iOS archive jobs.

### iOS signing and App Store setup

- User decision: **iOS will be handled next week/later.**
- Install/select full Xcode; the current machine checkpoint had Command Line Tools only.
- Confirm Apple Developer membership and Team ID.
- Create/confirm the App Store Connect app record for `com.bearfetch.app`.
- Configure distribution certificate, provisioning profile, App Store Connect API key, and CI secrets.
- Verify simulator behavior and produce a signed archive.

## External prerequisites and open release gates

- Supabase remote project access and production configuration must be confirmed before remote migrations or Auth work are treated as complete.
- Local Supabase CLI and Docker readiness must be verified before migration rehearsal.
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

1. Section 3 local Supabase migrations, metadata, RLS, and RPC tests.
2. Section 3 Flutter email OTP, session restoration, router guards, and consent flow.
3. Complete the deferred Resend configuration before production email verification.
4. Section 4 sync and conflict reconciliation.
5. Section 4 Parent Settings, privacy export/withdrawal/deletion, and Sentry privacy controls.
6. Section 5 full regression and Android release preparation.
7. Resume GitHub CI activation and iOS signing when the deferred prerequisites are ready.

