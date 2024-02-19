import { createClient } from "https://esm.sh/@supabase/supabase-js@2.31.0";

export const supabaseClient = createClient(
  //Supabase API URL - env var exported by default.
  Deno.env.get("SUPABASE_URL") ?? "",
  //Supabase API ANON KEY - env var exported by default.
  Deno.env.get("SUPABASE_ANON_KEY") ?? "",
);

export const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL") ?? "",
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
);

export function getSupabaseByUser(token: string) {
  return createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    {
      global: {
        headers: { Authorization: token },
      },
    },
  );
}
