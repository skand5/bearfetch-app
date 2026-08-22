begin;

create extension if not exists pgtap with schema extensions;
select plan(24);

insert into auth.users (id, email, raw_user_meta_data)
values
  ('30000000-0000-0000-0000-000000000003', 'rpc-parent@example.test', '{}'),
  ('40000000-0000-0000-0000-000000000004', 'rpc-parent-two@example.test', '{}');

insert into public.learners (id, parent_id, nickname, avatar_id, age_band, language)
values
  ('33000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000003', 'RPC', 'astronaut-bear', '6–11 yr', 'English'),
  ('44000000-0000-0000-0000-000000000004', '40000000-0000-0000-0000-000000000004', 'RPC Two', 'astronaut-bear', '6–11 yr', 'English');

insert into public.reward_transactions
  (learner_id, kind, amount, reason_type, reason_id, idempotency_key)
values ('33000000-0000-0000-0000-000000000003', 'honey', 30, 'adjustment', 'test-fixture', 'test-fixture:honey');

set local role authenticated;
select set_config('request.jwt.claim.sub', '30000000-0000-0000-0000-000000000003', true);

select is(public.record_parent_consent('consent-v1', 'notice-v1')->>'status', 'active', 'consent activates parent');
select is((select access_state from public.parents), 'active', 'parent access becomes active');

select is(public.complete_activity('unit-01-01', 'rpc-activity-1')->>'status', 'completed', 'first completion succeeds');
select is(public.complete_activity('unit-01-01', 'rpc-activity-1')->>'status', 'duplicate_event', 'same event is idempotent');
select is(public.complete_activity('unit-01-01', 'rpc-activity-2')->>'status', 'already_completed', 'new event cannot reward completed activity');
select is((select count(*) from public.activity_progress), 1::bigint, 'one progress row exists');
select is((select count(*) from public.reward_transactions where reason_type = 'activity'), 2::bigint, 'activity creates exactly two rewards');
select is((select sum(amount) from public.reward_transactions where reason_type = 'activity' and kind = 'xp'), 10::bigint, 'activity awards 10 XP once');
select is((select sum(amount) from public.reward_transactions where reason_type = 'activity' and kind = 'honey'), 5::bigint, 'activity awards 5 honey once');

select is(public.purchase_accessory('Star Cap', 'rpc-purchase-1')->>'status', 'purchased', 'affordable accessory purchase succeeds');
select is(public.purchase_accessory('Star Cap', 'rpc-purchase-2')->>'status', 'already_owned', 'duplicate ownership is blocked');
select is((select count(*) from public.owned_accessories where accessory_id = 'Star Cap'), 1::bigint, 'ownership granted once');
select is((select sum(amount) from public.reward_transactions where kind = 'honey'), 10::bigint, 'purchase deducts honey atomically');
select is(public.purchase_accessory('Galaxy Helm', 'rpc-purchase-3')->>'status', 'insufficient_honey', 'insufficient honey blocks purchase');

select is(public.equip_accessory('Star Cap', 'rpc-equip-1')->>'status', 'equipped', 'owned accessory can be equipped');
select is((select accessory_id from public.equipped_accessories where slot = 'hat'), 'Star Cap', 'equipped state persisted');
select is(
  public.schedule_deletion(
    'learner',
    'rpc-delete-schedule-1',
    '55555555-0000-0000-0000-000000000005'::uuid
  )->>'status',
  'pending',
  'learner deletion enters restricted pending state'
);
select is(
  public.schedule_deletion(
    'learner',
    'rpc-delete-schedule-1',
    '55555555-0000-0000-0000-000000000005'::uuid
  )->>'status',
  'duplicate_event',
  'deletion scheduling is idempotent'
);
select is(
  public.cancel_deletion(
    '55555555-0000-0000-0000-000000000005'::uuid,
    'rpc-delete-cancel-1'
  )->>'status',
  'cancelled',
  'pending deletion can be cancelled by its parent'
);
select is((select access_state from public.parents), 'active', 'cancelling deletion restores active access');

reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', '40000000-0000-0000-0000-000000000004', true);
select public.record_parent_consent('consent-v1', 'notice-v1');
select is(public.complete_activity('unit-01-01', 'rpc-activity-1')->>'status', 'completed', 'event idempotency is scoped per parent');

reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', '30000000-0000-0000-0000-000000000003', true);

select is(public.withdraw_consent('rpc-withdraw-1')->>'status', 'withdrawn', 'consent withdrawal succeeds');
select is((select access_state from public.parents), 'withdrawn', 'withdrawal immediately restricts parent');
select throws_ok(
  $$ select public.complete_activity('unit-01-02', 'rpc-after-withdrawal') $$,
  '42501',
  'learner_access_restricted',
  'learning RPC is blocked after withdrawal'
);

select * from finish();
rollback;
