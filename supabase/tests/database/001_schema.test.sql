begin;

create extension if not exists pgtap with schema extensions;
select plan(26);

select has_table('public', 'parents', 'parents table exists');
select has_table('public', 'learners', 'learners table exists');
select has_table('public', 'consent_records', 'consent records table exists');
select has_table('public', 'activity_progress', 'activity progress table exists');
select has_table('public', 'course_completions', 'course completions table exists');
select has_table('public', 'reward_transactions', 'reward ledger exists');
select has_table('public', 'achievements', 'achievements table exists');
select has_table('public', 'owned_accessories', 'owned accessories table exists');
select has_table('public', 'equipped_accessories', 'equipped accessories table exists');
select has_table('public', 'deletion_requests', 'deletion requests table exists');
select has_table('public', 'activities', 'server activity metadata exists');
select has_table('public', 'accessories', 'server accessory metadata exists');

select is((select count(*) from public.activities), 17::bigint, '17 stable activities seeded');
select is((select total_display_steps from public.courses where id = 'ai-course-01'), 36, 'course keeps 36 visible steps');
select is((select count(distinct reward_id) from public.activities), 17::bigint, 'activity reward ids are unique');
select is((select count(*) from public.activities where display_step not between 1 and 36), 0::bigint, 'display steps stay in bounds');

select has_function('public', 'complete_activity', array['text', 'text'], 'complete activity RPC exists');
select has_function('public', 'complete_course', array['text'], 'complete course RPC exists');
select has_function('public', 'purchase_accessory', array['text', 'text'], 'purchase RPC exists');
select has_function('public', 'equip_accessory', array['text', 'text'], 'equip RPC exists');

select hasnt_column('public', 'activity_progress', 'answer', 'progress has no answer column');
select hasnt_column('public', 'activity_progress', 'answer_json', 'progress has no answer JSON column');
select hasnt_column('public', 'activity_progress', 'prompt', 'progress has no prompt column');
select hasnt_column('public', 'activity_progress', 'output', 'progress has no simulated output column');

select is(
  has_schema_privilege('authenticated', 'private', 'USAGE'),
  false,
  'authenticated clients cannot use the private schema'
);
select is(
  (
    select bool_and(not has_function_privilege('authenticated', p.oid, 'EXECUTE'))
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'private'
  ),
  true,
  'authenticated clients cannot execute private functions'
);

select * from finish();
rollback;
