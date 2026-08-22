import { createClient } from 'jsr:@supabase/supabase-js@2'

const required = (name: string): string => {
  const value = Deno.env.get(name)
  if (!value) throw new Error(`Missing ${name}`)
  return value
}

/**
 * Invoked by a scheduled Supabase Edge Function job. This endpoint accepts
 * only the service-role bearer token; it is never called by the Flutter app.
 */
Deno.serve(async (request) => {
  const serviceRoleKey = required('SUPABASE_SERVICE_ROLE_KEY')
  if (request.headers.get('authorization') !== `Bearer ${serviceRoleKey}`) {
    return new Response('Unauthorized', { status: 401 })
  }

  const client = createClient(required('SUPABASE_URL'), serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
  const { data, error } = await client.rpc('purge_due_deletions')
  if (error) {
    console.error('purge_due_deletions failed', error.code)
    return new Response('Purge failed', { status: 500 })
  }

  return Response.json({ purged: data })
})
