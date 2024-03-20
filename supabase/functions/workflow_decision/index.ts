import { serve } from "deno_server";
import { auth } from "workflow";
import { WorkflowExecutions } from "workflowexecution";
import googleServiceAccountKey from "../google-service-account.json" assert {
  type: "json",
};
import { supabaseAdmin } from "../_utils/supabase.ts";
import { handleOptionsRequest, jsonResponse } from "../_utils/service.ts";

serve(async (req: Request) => {
  const optionsResponse = handleOptionsRequest(req);
  if (optionsResponse) return optionsResponse;

  const { documentId, decision } = await req.json();

  try {
    const { data: tracker, error } = await supabaseAdmin
      .from("tracker")
      .select("*")
      .eq("documentId", documentId)
      .order("createdAt", { ascending: false })
      .limit(1)
      .single();

    if (error) {
      throw new Error(error.message);
    }

    if (!tracker || !tracker.callbackUrl) return jsonResponse("An error occurred", 400);

    const authClient = auth.fromJSON(googleServiceAccountKey);
    const client = new WorkflowExecutions(authClient);
    const token = await authClient.getRequestHeaders(tracker.callbackUrl);

    //POST callback url
    const data = {
      status: decision,
    };

    fetch(tracker.callbackUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": token["Authorization"],
      },
      body: JSON.stringify(data),
    });

    return jsonResponse({ message: "Decision processed successfully" });
  } catch (error) {
    return jsonResponse("An error occurred", 400);
  }
});