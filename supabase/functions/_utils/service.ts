import { supabaseAdmin } from "../_utils/supabase.ts";

export const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
  };

export function handleOptionsRequest(req: Request) {
    if (req.method === "OPTIONS") {
      return new Response("OK", { headers: corsHeaders });
    }
  }

export const jsonResponseUnauthorized = () =>
  new Response(JSON.stringify("Unauthorized"), {
    status: 401,
    headers: {
      ...corsHeaders,
      "Content-type": "application/json; charset=utf-8",
    },
  });

export const jsonResponse = (body: any, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-type": "application/json; charset=utf-8",
    },
  });

export const addToTracker = async (tracker: Tracker) => {
    return await supabaseAdmin
      .from('tracker')
      .insert(tracker.saveNew());
  };

export class Tracker {
    constructor(
      public type: string,
      public executionId: string,
      public documentId: string,
      public callbackUrl: string | null = null,
      public roleId: string | null = null,
    ) {
    }
  
    saveNew() {
      return {
        type: this.type,
        executionId: this.executionId,
        callbackUrl: this.callbackUrl,
        documentId: this.documentId,
        roleId: this.roleId,
      };
    }
  }