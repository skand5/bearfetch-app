# BearFetch Development Status

Last updated: 2026-08-22

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
email delivery, legal approval, and the Section 4 restricted-state routes remain
pending below.

## Configured only — not yet production-activated

- `config/development.json` contains user-supplied public runtime values and is
  Git-ignored.
- Supabase Auth, migrations, RLS, and RPCs are implemented and verified locally.
  Public remote values being present does **not** mean migrations were applied,
  remote Auth/SMTP was configured, or production was verified.
- Sentry DSN and environment being present does **not** mean Sentry initialization, consent gating, PII scrubbing, or symbol upload are complete.
- GitHub workflow files exist locally, but they do not run until the repository/remote and Actions secrets are configured.
- iOS scheme scaffolding exists, but signing and archive verification are incomplete.

## Next — Section 4: sync, privacy, and operations

- Process the local outbox with exponential backoff, idempotency keys, connectivity triggers, and app-resume triggers.
- Reconcile remote state after login, reinstall, and use on a second device.
- Apply conflict policies:
  - furthest valid learning completion wins;
  - latest server-accepted profile/equipment timestamp wins;
  - completed learning is never rolled back by older remote progress.
- Add Parent Settings and Privacy routes for viewing data, consent confirmation, export, consent withdrawal, learner deletion, family deletion, deletion cancellation, sign-out.
- Add explicit router guards and restricted UI for withdrawn consent and pending
  deletion; the server states exist but the app routes are deferred to this
  section.
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

- Confirm the exact remote Supabase project, backup state, and deployment window
  before linking or applying the locally verified migration.
- Run hosted cross-parent/RPC smoke tests after the remote migration is applied.
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
6. Resume GitHub CI activation and iOS signing when the deferred prerequisites
   are ready.
