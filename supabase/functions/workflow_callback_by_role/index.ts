import { serve } from "deno_server";
import { Tracker, addToTracker, jsonResponse } from "../_utils/service.ts";

serve(async (req) => {
  try {
    // const { type, callbackUrl, roleId, documentId } = await req.json();
    const body = await req.json();
    console.log(body)
    const { type, callbackUrl, documentId, roleId } = body;
    console.log(!type)
    console.log(!callbackUrl)
    

    // Check if required fields are present
    if (!type || !callbackUrl) {
      console.error(`Incorrect data`);
      return jsonResponse("Incorrect data", 400);
    }

    // Parse the URL to extract necessary information
    const pathSegments = callbackUrl.split("/");
    const executionId = pathSegments[11];

    // Create a Tracker instance
    const tracker = new Tracker(
      'confirmation',
      executionId,
      documentId,
      callbackUrl,
      roleId,
    );
    console.log("env", Deno.env.get("SUPABASE_URL"))
    // Save the Tracker instance
    const { error } = await addToTracker(tracker);

    if (error) {
      console.log('Попало вот сюда: ' + error)
      return jsonResponse(error.message, 400);
    }

    // Return a success response
    return jsonResponse("OK");
  } catch (error) {
    console.error(`Exception caught: ${error}`);
    return jsonResponse("Exception occurred", 400);
  }
});