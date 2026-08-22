-- Privacy operations are queued while offline. They therefore require the
-- same idempotency guarantees as progress and shop mutations.

drop function if exists public.withdraw_consent();
drop function if exists public.schedule_deletion(text);
drop function if exists public.cancel_deletion(uuid);

create or replace function private.withdraw_consent_impl(requested_event_id text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
begin
  if not private.record_event('withdraw_consent', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event');
  end if;
  update public.consent_records
  set status = 'withdrawn', withdrawn_at = now()
  where consent_records.parent_id = current_parent_id and status = 'active';
  update public.parents set access_state = 'withdrawn' where id = current_parent_id;
  return jsonb_build_object('status', 'withdrawn');
end;
$$;

create or replace function private.schedule_deletion_impl(
  requested_target text,
  requested_event_id text,
  requested_request_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_parent_id uuid := private.current_parent_id();
  target_id uuid;
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
  if not private.record_event('schedule_deletion', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event', 'requestId', requested_request_id);
  end if;
  if exists (
    select 1 from public.deletion_requests
    where deletion_requests.parent_id = current_parent_id and status = 'pending'
  ) then
    raise exception 'deletion_already_pending' using errcode = '23505';
  end if;
  insert into public.deletion_requests (id, parent_id, target, target_id, purge_after)
  values (requested_request_id, current_parent_id, requested_target, target_id, purge_at);
  update public.parents set access_state = 'pending_deletion' where id = current_parent_id;
  return jsonb_build_object('status', 'pending', 'requestId', requested_request_id, 'purgeAfter', purge_at);
end;
$$;

create or replace function private.cancel_deletion_impl(
  requested_request_id uuid,
  requested_event_id text
)
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
  if not private.record_event('cancel_deletion', requested_event_id) then
    return jsonb_build_object('status', 'duplicate_event');
  end if;
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

-- This entry point is deliberately inaccessible to client roles. A scheduled
-- Edge Function invokes it using the service-role key after the 30-day hold.
create or replace function public.purge_due_deletions()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  request_row record;
  purged_count integer := 0;
begin
  for request_row in
    select * from public.deletion_requests
    where status = 'pending' and purge_after <= now()
    order by purge_after
    for update skip locked
  loop
    if request_row.target = 'family' then
      delete from auth.users where id = request_row.parent_id;
    else
      delete from public.learners where id = request_row.target_id;
      update public.deletion_requests
      set status = 'completed', completed_at = now()
      where id = request_row.id;
    end if;
    purged_count := purged_count + 1;
  end loop;
  return purged_count;
end;
$$;

create or replace function public.withdraw_consent(event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.withdraw_consent_impl(event_id); $$;
create or replace function public.schedule_deletion(target text, event_id text, request_id uuid)
returns jsonb language sql security definer set search_path = ''
as $$ select private.schedule_deletion_impl(target, event_id, request_id); $$;
create or replace function public.cancel_deletion(request_id uuid, event_id text)
returns jsonb language sql security definer set search_path = ''
as $$ select private.cancel_deletion_impl(request_id, event_id); $$;

revoke all on function public.withdraw_consent(text) from public, anon, authenticated;
revoke all on function public.schedule_deletion(text, text, uuid) from public, anon, authenticated;
revoke all on function public.cancel_deletion(uuid, text) from public, anon, authenticated;
revoke all on function public.purge_due_deletions() from public, anon, authenticated;
grant execute on function public.withdraw_consent(text) to authenticated;
grant execute on function public.schedule_deletion(text, text, uuid) to authenticated;
grant execute on function public.cancel_deletion(uuid, text) to authenticated;

revoke all on function private.withdraw_consent_impl(text) from public, anon, authenticated;
revoke all on function private.schedule_deletion_impl(text, text, uuid) from public, anon, authenticated;
revoke all on function private.cancel_deletion_impl(uuid, text) from public, anon, authenticated;
