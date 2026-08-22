create extension if not exists pgcrypto with schema extensions;

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table public.parents (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Parent' check (char_length(display_name) between 1 and 80),
  access_state text not null default 'onboarding'
    check (access_state in ('onboarding', 'active', 'withdrawn', 'pending_deletion')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.learners (
  id uuid primary key default extensions.gen_random_uuid(),
  parent_id uuid not null unique references public.parents(id) on delete cascade,
  nickname text not null check (char_length(nickname) between 1 and 40),
  avatar_id text not null check (char_length(avatar_id) between 1 and 80),
  age_band text not null check (age_band in ('3–5 yr', '6–11 yr', '12+ yr')),
  language text not null default 'English' check (char_length(language) between 1 and 40),
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.consent_records (
  id uuid primary key default extensions.gen_random_uuid(),
  parent_id uuid not null references public.parents(id) on delete cascade,
  consent_version text not null check (char_length(consent_version) between 1 and 80),
  notice_version text not null check (char_length(notice_version) between 1 and 80),
  status text not null check (status in ('active', 'withdrawn')),
  consented_at timestamptz not null,
  confirmation_sent_at timestamptz,
  confirmed_at timestamptz,
  withdrawn_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (
    (status = 'active' and withdrawn_at is null)
    or (status = 'withdrawn' and withdrawn_at is not null)
  )
);

create unique index one_active_consent_per_parent
  on public.consent_records(parent_id)
  where status = 'active';

create table public.courses (
  id text primary key,
  version integer not null check (version > 0),
  total_display_steps integer not null check (total_display_steps between 1 and 100),
  completion_reward_id text not null unique,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.activities (
  id text primary key,
  course_id text not null references public.courses(id) on delete restrict,
  unit_number integer not null check (unit_number between 1 and 20),
  display_step integer not null check (display_step between 1 and 36),
  sequence_number integer not null check (sequence_number > 0),
  reward_id text not null unique,
  next_activity_id text references public.activities(id) deferrable initially deferred,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, sequence_number)
);

create table public.accessories (
  id text primary key,
  display_name text not null,
  slot text not null check (slot in ('hat', 'glasses', 'outfit', 'backpack', 'featured')),
  price_honey integer not null check (price_honey >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.activity_progress (
  learner_id uuid not null references public.learners(id) on delete cascade,
  activity_id text not null references public.activities(id) on delete restrict,
  completed_at timestamptz not null,
  retry_count integer not null default 0 check (retry_count >= 0),
  completion_event_id text not null check (char_length(completion_event_id) between 1 and 128),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (learner_id, activity_id),
  unique (learner_id, completion_event_id)
);

create table public.course_completions (
  learner_id uuid not null references public.learners(id) on delete cascade,
  course_id text not null references public.courses(id) on delete restrict,
  completion_event_id text not null check (char_length(completion_event_id) between 1 and 128),
  completed_at timestamptz not null default now(),
  primary key (learner_id, course_id),
  unique (learner_id, completion_event_id)
);

create table public.reward_transactions (
  id uuid primary key default extensions.gen_random_uuid(),
  learner_id uuid not null references public.learners(id) on delete cascade,
  kind text not null check (kind in ('xp', 'honey')),
  amount integer not null check (amount <> 0),
  reason_type text not null check (reason_type in ('activity', 'course', 'purchase', 'adjustment')),
  reason_id text not null,
  idempotency_key text not null check (char_length(idempotency_key) between 1 and 180),
  occurred_at timestamptz not null default now(),
  unique (learner_id, idempotency_key)
);

create table public.achievements (
  learner_id uuid not null references public.learners(id) on delete cascade,
  achievement_id text not null,
  earned_at timestamptz not null default now(),
  primary key (learner_id, achievement_id)
);

create table public.owned_accessories (
  learner_id uuid not null references public.learners(id) on delete cascade,
  accessory_id text not null references public.accessories(id) on delete restrict,
  purchased_at timestamptz not null default now(),
  primary key (learner_id, accessory_id)
);

create table public.equipped_accessories (
  learner_id uuid not null references public.learners(id) on delete cascade,
  slot text not null check (slot in ('hat', 'glasses', 'outfit', 'backpack', 'featured')),
  accessory_id text not null references public.accessories(id) on delete restrict,
  equipped_at timestamptz not null default now(),
  primary key (learner_id, slot)
);

create table public.deletion_requests (
  id uuid primary key default extensions.gen_random_uuid(),
  parent_id uuid not null references public.parents(id) on delete cascade,
  target text not null check (target in ('learner', 'family')),
  target_id uuid not null,
  status text not null default 'pending' check (status in ('pending', 'cancelled', 'completed')),
  requested_at timestamptz not null default now(),
  purge_after timestamptz not null,
  cancelled_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index one_pending_deletion_per_parent
  on public.deletion_requests(parent_id)
  where status = 'pending';

create table private.server_events (
  event_id text not null check (char_length(event_id) between 1 and 128),
  parent_id uuid not null references public.parents(id) on delete cascade,
  operation text not null,
  created_at timestamptz not null default now(),
  primary key (parent_id, event_id)
);

create or replace function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger parents_set_updated_at before update on public.parents
for each row execute function private.set_updated_at();
create trigger learners_set_updated_at before update on public.learners
for each row execute function private.set_updated_at();
create trigger consent_records_set_updated_at before update on public.consent_records
for each row execute function private.set_updated_at();
create trigger courses_set_updated_at before update on public.courses
for each row execute function private.set_updated_at();
create trigger activities_set_updated_at before update on public.activities
for each row execute function private.set_updated_at();
create trigger accessories_set_updated_at before update on public.accessories
for each row execute function private.set_updated_at();
create trigger activity_progress_set_updated_at before update on public.activity_progress
for each row execute function private.set_updated_at();
create trigger deletion_requests_set_updated_at before update on public.deletion_requests
for each row execute function private.set_updated_at();

create or replace function private.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.parents (id) values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function private.handle_new_auth_user();

create or replace function private.current_parent_id()
returns uuid
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  parent_id uuid := auth.uid();
begin
  if parent_id is null then
    raise exception 'authentication_required' using errcode = '42501';
  end if;
  if not exists (select 1 from public.parents p where p.id = parent_id) then
    raise exception 'parent_not_found' using errcode = 'P0002';
  end if;
  return parent_id;
end;
$$;

create or replace function private.active_learner_id()
returns uuid
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  learner_id uuid;
  current_parent_id uuid := private.current_parent_id();
begin
  if not exists (
    select 1 from public.parents p
    where p.id = current_parent_id and p.access_state = 'active'
  ) then
    raise exception 'learner_access_restricted' using errcode = '42501';
  end if;
  select l.id into learner_id
  from public.learners l
  where l.parent_id = current_parent_id and l.deleted_at is null;
  if learner_id is null then
    raise exception 'learner_not_found' using errcode = 'P0002';
  end if;
  return learner_id;
end;
$$;

create or replace function private.record_event(operation_name text, requested_event_id text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  inserted_count integer;
begin
  if requested_event_id is null or char_length(requested_event_id) not between 1 and 128 then
    raise exception 'invalid_event_id' using errcode = '22023';
  end if;
  insert into private.server_events (event_id, parent_id, operation)
  values (requested_event_id, private.current_parent_id(), operation_name)
  on conflict (parent_id, event_id) do nothing;
  get diagnostics inserted_count = row_count;
  return inserted_count = 1;
end;
$$;

create or replace function private.record_parent_consent_impl(
  requested_consent_version text,
  requested_notice_version text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
  consent_id uuid;
begin
  if char_length(trim(requested_consent_version)) not between 1 and 80
    or char_length(trim(requested_notice_version)) not between 1 and 80 then
    raise exception 'invalid_consent_version' using errcode = '22023';
  end if;
  update public.consent_records
  set status = 'withdrawn', withdrawn_at = now()
  where consent_records.parent_id = current_parent_id and status = 'active';
  insert into public.consent_records (
    parent_id, consent_version, notice_version, status, consented_at
  ) values (
    current_parent_id, trim(requested_consent_version), trim(requested_notice_version), 'active', now()
  ) returning id into consent_id;
  update public.parents set access_state = 'active' where id = current_parent_id;
  return jsonb_build_object('status', 'active', 'consentId', consent_id);
end;
$$;

create or replace function private.complete_activity_impl(
  requested_activity_id text,
  requested_event_id text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_learner_id uuid := private.active_learner_id();
  reward_id text;
  inserted_id uuid;
begin
  select a.reward_id into reward_id
  from public.activities a join public.courses c on c.id = a.course_id
  where a.id = requested_activity_id and a.active and c.active;
  if reward_id is null then
    raise exception 'invalid_activity_id' using errcode = '22023';
  end if;
  if not private.record_event('complete_activity', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event', 'awarded', false);
  end if;
  insert into public.activity_progress (
    learner_id, activity_id, completed_at, completion_event_id
  ) values (current_learner_id, requested_activity_id, now(), requested_event_id)
  on conflict (learner_id, activity_id) do nothing
  returning activity_progress.learner_id into inserted_id;
  if inserted_id is null then
    return jsonb_build_object('status', 'already_completed', 'awarded', false);
  end if;
  insert into public.reward_transactions
    (learner_id, kind, amount, reason_type, reason_id, idempotency_key)
  values
    (current_learner_id, 'xp', 10, 'activity', reward_id, 'activity:' || requested_activity_id || ':xp'),
    (current_learner_id, 'honey', 5, 'activity', reward_id, 'activity:' || requested_activity_id || ':honey');
  return jsonb_build_object('status', 'completed', 'awarded', true, 'xp', 10, 'honey', 5);
end;
$$;

create or replace function private.complete_course_impl(requested_event_id text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_learner_id uuid := private.active_learner_id();
  current_course_id text;
  current_reward_id text;
  inserted_id uuid;
begin
  select c.id, c.completion_reward_id into current_course_id, current_reward_id
  from public.courses c where c.active order by c.created_at limit 1;
  if current_course_id is null then
    raise exception 'active_course_not_found' using errcode = 'P0002';
  end if;
  if exists (
    select 1 from public.activities a
    where a.course_id = current_course_id and a.active
      and not exists (
        select 1 from public.activity_progress p
        where p.learner_id = current_learner_id and p.activity_id = a.id
      )
  ) then
    raise exception 'course_not_complete' using errcode = '22023';
  end if;
  if not private.record_event('complete_course', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event', 'awarded', false);
  end if;
  insert into public.course_completions (learner_id, course_id, completion_event_id)
  values (current_learner_id, current_course_id, requested_event_id)
  on conflict (learner_id, course_id) do nothing
  returning course_completions.learner_id into inserted_id;
  if inserted_id is null then
    return jsonb_build_object('status', 'already_completed', 'awarded', false);
  end if;
  insert into public.reward_transactions
    (learner_id, kind, amount, reason_type, reason_id, idempotency_key)
  values
    (current_learner_id, 'xp', 100, 'course', current_reward_id, 'course:' || current_reward_id || ':xp'),
    (current_learner_id, 'honey', 50, 'course', current_reward_id, 'course:' || current_reward_id || ':honey');
  insert into public.achievements (learner_id, achievement_id)
  values
    (current_learner_id, 'ai-explorer-badge'),
    (current_learner_id, 'llm-starter-certificate')
  on conflict do nothing;
  return jsonb_build_object('status', 'completed', 'awarded', true, 'xp', 100, 'honey', 50);
end;
$$;

create or replace function private.purchase_accessory_impl(
  requested_accessory_id text,
  requested_event_id text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_learner_id uuid := private.active_learner_id();
  price integer;
  honey_balance bigint;
begin
  perform pg_advisory_xact_lock(hashtextextended(current_learner_id::text, 0));
  select a.price_honey into price
  from public.accessories a
  where a.id = requested_accessory_id and a.active;
  if price is null then
    raise exception 'invalid_accessory_id' using errcode = '22023';
  end if;
  if exists (
    select 1 from public.owned_accessories o
    where o.learner_id = current_learner_id and o.accessory_id = requested_accessory_id
  ) then
    return jsonb_build_object('status', 'already_owned');
  end if;
  select coalesce(sum(r.amount), 0) into honey_balance
  from public.reward_transactions r
  where r.learner_id = current_learner_id and r.kind = 'honey';
  if honey_balance < price then
    return jsonb_build_object('status', 'insufficient_honey', 'required', price, 'balance', honey_balance);
  end if;
  if not private.record_event('purchase_accessory', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event');
  end if;
  insert into public.owned_accessories (learner_id, accessory_id)
  values (current_learner_id, requested_accessory_id);
  if price > 0 then
    insert into public.reward_transactions
      (learner_id, kind, amount, reason_type, reason_id, idempotency_key)
    values
      (current_learner_id, 'honey', -price, 'purchase', requested_accessory_id,
       'purchase:' || requested_accessory_id || ':honey');
  end if;
  return jsonb_build_object('status', 'purchased', 'price', price, 'balance', honey_balance - price);
end;
$$;

create or replace function private.equip_accessory_impl(
  requested_accessory_id text,
  requested_event_id text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_learner_id uuid := private.active_learner_id();
  accessory_slot text;
begin
  select a.slot into accessory_slot
  from public.accessories a
  join public.owned_accessories o
    on o.accessory_id = a.id and o.learner_id = current_learner_id
  where a.id = requested_accessory_id and a.active;
  if accessory_slot is null then
    raise exception 'accessory_not_owned' using errcode = '42501';
  end if;
  if not private.record_event('equip_accessory', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event');
  end if;
  insert into public.equipped_accessories (learner_id, slot, accessory_id, equipped_at)
  values (current_learner_id, accessory_slot, requested_accessory_id, now())
  on conflict (learner_id, slot) do update
    set accessory_id = excluded.accessory_id, equipped_at = excluded.equipped_at;
  return jsonb_build_object('status', 'equipped', 'slot', accessory_slot);
end;
$$;

create or replace function private.withdraw_consent_impl()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
begin
  update public.consent_records
  set status = 'withdrawn', withdrawn_at = now()
  where consent_records.parent_id = current_parent_id and status = 'active';
  update public.parents set access_state = 'withdrawn' where id = current_parent_id;
  return jsonb_build_object('status', 'withdrawn');
end;
$$;

create or replace function private.schedule_deletion_impl(requested_target text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
  target_id uuid;
  request_id uuid;
  purge_at timestamptz := now() + interval '30 days';
begin
  if requested_target = 'family' then
    target_id := current_parent_id;
  elsif requested_target = 'learner' then
    select id into target_id from public.learners
    where learners.parent_id = current_parent_id and deleted_at is null;
    if target_id is null then
      raise exception 'learner_not_found' using errcode = 'P0002';
    end if;
  else
    raise exception 'invalid_deletion_target' using errcode = '22023';
  end if;
  if exists (
    select 1 from public.deletion_requests
    where deletion_requests.parent_id = current_parent_id and status = 'pending'
  ) then
    raise exception 'deletion_already_pending' using errcode = '23505';
  end if;
  insert into public.deletion_requests (parent_id, target, target_id, purge_after)
  values (current_parent_id, requested_target, target_id, purge_at)
  returning id into request_id;
  update public.parents set access_state = 'pending_deletion' where id = current_parent_id;
  return jsonb_build_object('status', 'pending', 'requestId', request_id, 'purgeAfter', purge_at);
end;
$$;

create or replace function private.cancel_deletion_impl(requested_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
  cancelled_count integer;
  next_state text;
begin
  update public.deletion_requests
  set status = 'cancelled', cancelled_at = now()
  where id = requested_request_id
    and deletion_requests.parent_id = current_parent_id
    and status = 'pending';
  get diagnostics cancelled_count = row_count;
  if cancelled_count = 0 then
    raise exception 'pending_deletion_not_found' using errcode = 'P0002';
  end if;
  if exists (
    select 1 from public.consent_records c
    where c.parent_id = current_parent_id and c.status = 'active'
  ) then next_state := 'active'; else next_state := 'withdrawn'; end if;
  update public.parents set access_state = next_state where id = current_parent_id;
  return jsonb_build_object('status', 'cancelled', 'accessState', next_state);
end;
$$;

create or replace function public.record_parent_consent(consent_version text, notice_version text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.record_parent_consent_impl(consent_version, notice_version); $$;
create or replace function public.complete_activity(activity_id text, event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.complete_activity_impl(activity_id, event_id); $$;
create or replace function public.complete_course(event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.complete_course_impl(event_id); $$;
create or replace function public.purchase_accessory(accessory_id text, event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.purchase_accessory_impl(accessory_id, event_id); $$;
create or replace function public.equip_accessory(accessory_id text, event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.equip_accessory_impl(accessory_id, event_id); $$;
create or replace function public.withdraw_consent()
returns jsonb language sql security definer set search_path = ''
as $$ select private.withdraw_consent_impl(); $$;
create or replace function public.schedule_deletion(target text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.schedule_deletion_impl(target); $$;
create or replace function public.cancel_deletion(request_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select private.cancel_deletion_impl(request_id); $$;

alter table public.parents enable row level security;
alter table public.learners enable row level security;
alter table public.consent_records enable row level security;
alter table public.courses enable row level security;
alter table public.activities enable row level security;
alter table public.accessories enable row level security;
alter table public.activity_progress enable row level security;
alter table public.course_completions enable row level security;
alter table public.reward_transactions enable row level security;
alter table public.achievements enable row level security;
alter table public.owned_accessories enable row level security;
alter table public.equipped_accessories enable row level security;
alter table public.deletion_requests enable row level security;

create policy parents_select_own on public.parents for select to authenticated
using ((select auth.uid()) = id);
create policy parents_update_own on public.parents for update to authenticated
using ((select auth.uid()) = id) with check ((select auth.uid()) = id);

create policy learners_select_own on public.learners for select to authenticated
using ((select auth.uid()) = parent_id);
create policy learners_insert_own on public.learners for insert to authenticated
with check ((select auth.uid()) = parent_id);
create policy learners_update_own on public.learners for update to authenticated
using ((select auth.uid()) = parent_id) with check ((select auth.uid()) = parent_id);

create policy consent_select_own on public.consent_records for select to authenticated
using ((select auth.uid()) = parent_id);
create policy courses_read_authenticated on public.courses for select to authenticated using (active);
create policy activities_read_authenticated on public.activities for select to authenticated using (active);
create policy accessories_read_authenticated on public.accessories for select to authenticated using (active);

create policy progress_select_own on public.activity_progress for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy course_completions_select_own on public.course_completions for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy rewards_select_own on public.reward_transactions for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy achievements_select_own on public.achievements for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy owned_accessories_select_own on public.owned_accessories for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy equipped_accessories_select_own on public.equipped_accessories for select to authenticated
using (learner_id in (select l.id from public.learners l where l.parent_id = (select auth.uid())));
create policy deletion_requests_select_own on public.deletion_requests for select to authenticated
using ((select auth.uid()) = parent_id);

revoke all on public.parents, public.learners, public.consent_records, public.courses,
  public.activities, public.accessories, public.activity_progress,
  public.course_completions, public.reward_transactions, public.achievements,
  public.owned_accessories, public.equipped_accessories,
  public.deletion_requests from anon, authenticated;
grant select on public.parents to authenticated;
grant update (display_name) on public.parents to authenticated;
grant select on public.learners to authenticated;
grant insert (parent_id, nickname, avatar_id, age_band, language)
  on public.learners to authenticated;
grant update (nickname, avatar_id, age_band, language)
  on public.learners to authenticated;
grant select on public.consent_records, public.courses, public.activities, public.accessories,
  public.activity_progress, public.course_completions, public.reward_transactions,
  public.achievements, public.owned_accessories, public.equipped_accessories,
  public.deletion_requests to authenticated;

revoke all on function public.record_parent_consent(text, text) from public, anon, authenticated;
revoke all on function public.complete_activity(text, text) from public, anon, authenticated;
revoke all on function public.complete_course(text) from public, anon, authenticated;
revoke all on function public.purchase_accessory(text, text) from public, anon, authenticated;
revoke all on function public.equip_accessory(text, text) from public, anon, authenticated;
revoke all on function public.withdraw_consent() from public, anon, authenticated;
revoke all on function public.schedule_deletion(text) from public, anon, authenticated;
revoke all on function public.cancel_deletion(uuid) from public, anon, authenticated;
grant execute on function public.record_parent_consent(text, text) to authenticated;
grant execute on function public.complete_activity(text, text) to authenticated;
grant execute on function public.complete_course(text) to authenticated;
grant execute on function public.purchase_accessory(text, text) to authenticated;
grant execute on function public.equip_accessory(text, text) to authenticated;
grant execute on function public.withdraw_consent() to authenticated;
grant execute on function public.schedule_deletion(text) to authenticated;
grant execute on function public.cancel_deletion(uuid) to authenticated;

revoke all on function private.record_parent_consent_impl(text, text) from public, anon, authenticated;
revoke all on function private.complete_activity_impl(text, text) from public, anon, authenticated;
revoke all on function private.complete_course_impl(text) from public, anon, authenticated;
revoke all on function private.purchase_accessory_impl(text, text) from public, anon, authenticated;
revoke all on function private.equip_accessory_impl(text, text) from public, anon, authenticated;
revoke all on function private.withdraw_consent_impl() from public, anon, authenticated;
revoke all on function private.schedule_deletion_impl(text) from public, anon, authenticated;
revoke all on function private.cancel_deletion_impl(uuid) from public, anon, authenticated;
revoke execute on all functions in schema private from public, anon, authenticated;

insert into public.courses (id, version, total_display_steps, completion_reward_id)
values ('ai-course-01', 1, 36, 'course-ai-01-complete');

insert into public.activities
  (id, course_id, unit_number, display_step, sequence_number, reward_id, next_activity_id)
values
  ('unit-01-01', 'ai-course-01', 1, 1, 1, 'activity-unit-01-01', 'unit-01-02'),
  ('unit-01-02', 'ai-course-01', 1, 2, 2, 'activity-unit-01-02', 'unit-01-03'),
  ('unit-01-03', 'ai-course-01', 1, 4, 3, 'activity-unit-01-03', 'unit-01-04'),
  ('unit-01-04', 'ai-course-01', 1, 6, 4, 'activity-unit-01-04', 'unit-02-01'),
  ('unit-02-01', 'ai-course-01', 2, 8, 5, 'activity-unit-02-01', 'unit-02-02'),
  ('unit-02-02', 'ai-course-01', 2, 10, 6, 'activity-unit-02-02', 'unit-02-03'),
  ('unit-02-03', 'ai-course-01', 2, 12, 7, 'activity-unit-02-03', 'unit-03-01'),
  ('unit-03-01', 'ai-course-01', 3, 15, 8, 'activity-unit-03-01', 'unit-03-02'),
  ('unit-03-02', 'ai-course-01', 3, 17, 9, 'activity-unit-03-02', 'unit-03-03'),
  ('unit-03-03', 'ai-course-01', 3, 19, 10, 'activity-unit-03-03', 'unit-04-01'),
  ('unit-04-01', 'ai-course-01', 4, 22, 11, 'activity-unit-04-01', 'unit-04-02'),
  ('unit-04-02', 'ai-course-01', 4, 24, 12, 'activity-unit-04-02', 'unit-04-03'),
  ('unit-04-03', 'ai-course-01', 4, 24, 13, 'activity-unit-04-03', 'unit-04-04'),
  ('unit-04-04', 'ai-course-01', 4, 28, 14, 'activity-unit-04-04', 'unit-04-05'),
  ('unit-04-05', 'ai-course-01', 4, 30, 15, 'activity-unit-04-05', 'unit-04-06'),
  ('unit-04-06', 'ai-course-01', 4, 32, 16, 'activity-unit-04-06', 'unit-04-07'),
  ('unit-04-07', 'ai-course-01', 4, 34, 17, 'activity-unit-04-07', null);

insert into public.accessories (id, display_name, slot, price_honey)
values
  ('Star Cap', 'Star Cap', 'hat', 25),
  ('Moon Glasses', 'Moon Glasses', 'glasses', 0),
  ('Rocket Pack', 'Rocket Pack', 'backpack', 0),
  ('Galaxy Helm', 'Galaxy Helm', 'hat', 180);
