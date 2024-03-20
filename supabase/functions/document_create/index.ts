import { serve } from "deno_server";
import { supabaseAdmin } from "../_utils/supabase.ts";
import { handleOptionsRequest, jsonResponse } from "../_utils/service.ts";

serve(async (req: Request) => {
  const optionsResponse = handleOptionsRequest(req);
  if (optionsResponse) {
    return optionsResponse;
  }


  try {
    const { name } = await req.json();
    console.log('name', name);

    if (!name) {
      return jsonResponse("Missing parameter name", 400);
    }

    const { data: document, error } = await supabaseAdmin
      .from('document')
      .insert({ name })
      .select("*")
      .single()

    if (error) {
      throw new Error(error.message);
    }

    return jsonResponse(document);
  } catch (error) {
    console.log("error: ", error.message);
    return jsonResponse("An error occurred", 400);
  }
});