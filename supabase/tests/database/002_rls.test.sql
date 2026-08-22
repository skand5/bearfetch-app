begin;

create extension if not exists pgtap with schema extensions;
select plan(14);

insert into auth.users (id, email, raw_user_meta_data)
values
  ('10000000-0000-0000-0000-000000000001', 'parent-one@example.test', '{}'),
  ('20000000-0000-0000-0000-000000000002', 'parent-two@example.test', '{}');

insert into public.learners (id, parent_id, nickname, avatar_id, age_band, language)
values
  ('11000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'One', 'astronaut-bear', '6–11 yr', 'English'),
  ('22000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'Two', 'astronaut-bear', '6–11 yr', 'English');

insert into public.activity_progress
  (learner_id, activity_id, completed_at, completion_event_id)
values
  ('11000000-0000-0000-0000-000000000001', 'unit-01-01', now(), 'rls-progress-one'),
  ('22000000-0000-0000-0000-000000000002', 'unit-01-01', now(), 'rls-progress-two');

insert into public.reward_transactions
  (learner_id, kind, amount, reason_type, reason_id, idempotency_key)
values
  ('11000000-0000-0000-0000-000000000001', 'xp', 10, 'activity', 'activity-unit-01-01', 'rls-one-xp'),
  ('22000000-0000-0000-0000-000000000002', 'xp', 10, 'activity', 'activity-unit-01-01', 'rls-two-xp');

set local role authenticated;
select set_config('request.jwt.claim.sub', '10000000-0000-0000-0000-000000000001', true);

select is((select count(*) from public.parents), 1::bigint, 'parent sees only own parent row');
select is((select id from public.parents), '10000000-0000-0000-0000-000000000001'::uuid, 'visible parent is caller');
select is((select count(*) from public.learners), 1::bigint, 'parent sees only own learner');
select is((select nickname from public.learners), 'One', 'cross-parent learner hidden');
select is((select count(*) from public.activity_progress), 1::bigint, 'cross-parent progress hidden');
select is((select count(*) from public.reward_transactions), 1::bigint, 'cross-parent rewards hidden');
select is((select count(*) from public.courses), 1::bigint, 'authenticated parent can read active course metadata');
select is((select count(*) from public.activities), 17::bigint, 'authenticated parent can read activity metadata');

select ok(not has_table_privilege('authenticated', 'public.reward_transactions', 'INSERT'), 'client cannot insert rewards');
select ok(not has_table_privilege('authenticated', 'public.activity_progress', 'INSERT'), 'client cannot insert progress');
select ok(not has_table_privilege('authenticated', 'public.achievements', 'INSERT'), 'client cannot insert achievements');
select ok(not has_table_privilege('authenticated', 'public.owned_accessories', 'INSERT'), 'client cannot grant ownership');
select ok(not has_table_privilege('authenticated', 'public.activities', 'UPDATE'), 'client cannot edit activity metadata');
select ok(not has_table_privilege('authenticated', 'public.accessories', 'UPDATE'), 'client cannot edit accessory metadata');

select * from finish();
rollback;

