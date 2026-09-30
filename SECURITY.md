# Security policy

## Reporting

Do not open a public issue for vulnerabilities, credentials, child-data
exposure, authentication bypasses, or billing flaws.

Use GitHub private vulnerability reporting after repository visibility is
changed to public. Until then, contact repository owner privately through the
existing GitHub account contact route.

Include reproduction steps, affected version or commit, impact, and any safe
proof of concept. Do not include live credentials or personal data.

## Secret boundary

Never commit or paste into issues, pull requests, logs, screenshots, or Dart
defines:

- Supabase service-role keys
- Resend or SMTP credentials
- RevenueCat secret keys
- Sentry auth tokens
- Android/iOS signing material
- child or parent personal data

Public Supabase anon keys and RevenueCat public SDK keys are client values.
They still require backend RLS, auth, and dashboard-side access controls.
