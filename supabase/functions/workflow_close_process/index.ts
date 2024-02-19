import { Tracker, addToTracker, jsonResponse } from "../_utils/service.ts";

Deno.serve(async (req) => {
  try {
    // Parse JSON data from the request body
    const model = await req.json();

    const { executionId, documentId } = model;

    // Create a Tracker instance
    const tracker = new Tracker(
      'closed',
      executionId,
      documentId,
    );

    // Save the Tracker instance
    const { error } = await addToTracker(tracker);

    if (error) {
      return jsonResponse(error.message, 400);
    }

    // Return a success response
    return jsonResponse("OK");
  } catch (error) {
    console.error(`Exception caught: ${error}`);
    return jsonResponse("Exception occurred", 400);
  }
});