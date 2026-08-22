# BearFetch Privacy Operations

This document describes deployment-only actions. None of these values belong in
Flutter assets, `config/*.json`, committed `.env` files, or a client binary.

## 30-day deletion purge

The local migration defines `public.purge_due_deletions()` and the protected
Edge Function at `supabase/functions/purge-deletions/index.ts`.

Before activating this in the confirmed remote project:

1. Apply the reviewed migrations through the normal Supabase deployment
   window; do not edit production schema directly in the dashboard.
2. Deploy the `purge-deletions` function. It uses platform-provided
   `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`; do not create a Flutter
   define or public secret for either value.
3. Create a scheduled invocation at least daily using the Supabase scheduler
   or an authenticated server-side scheduler. Send only:
   `Authorization: Bearer <SUPABASE_SERVICE_ROLE_KEY>`.
4. Verify a test learner deletion is inaccessible immediately, can be
   cancelled before `purge_after`, and is hard-purged only after the 30-day
   hold. Family purges remove the linked `auth.users` record and cascade the
   application data.
5. Document the configured Supabase backup retention and ensure it has a
   defined expiry compatible with the product deletion policy. Backups are not
   rewritten by the purge job.

## Sentry crash reporting

The Flutter runtime contains a consent-gated, crash-only Sentry boundary:

- active consent is required before any event can leave the device;
- default PII, sessions, performance traces, profiles, screenshots, print
  breadcrumbs, user context, request data, extra data, messages, and
  breadcrumbs are excluded;
- the runtime never sets a Sentry user identity.

Before production release, configure only CI secrets for source-map/symbol
uploads: `SENTRY_AUTH_TOKEN`, `SENTRY_ORG`, and `SENTRY_PROJECT`. The client
receives only `SENTRY_DSN` and `SENTRY_ENVIRONMENT` as public build values.
Run a release-candidate crash test after consent and inspect the received event
to confirm it contains no parent email, learner nickname, form data, activity
answer, prompt, or screenshot.

## Deferred production activation

Resend SMTP/domain setup, the GitHub remote/Actions secrets, iOS signing, and
remote Supabase linking remain separate prerequisites. See
`docs/DEVELOPMENT_STATUS.md` for their authoritative status.
