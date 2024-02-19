import { auth } from "https://googleapis.deno.dev/v1/workflows:v1.ts";
import { WorkflowExecutions } from "https://googleapis.deno.dev/v1/workflowexecutions:v1.ts";

import { handleOptionsRequest, jsonResponseUnauthorized, jsonResponse, Tracker, addToTracker } from '../_utils/service.ts';
import googleServiceAccountKey from "../google-service-account.json" assert {
  type: "json",
};

Deno.serve(async (req) => {
  const optionsResponse = handleOptionsRequest(req);
  if (optionsResponse) {
    return optionsResponse;
  }

  try {
    const { workflowName, body, documentId } = await req.json();

    const authToken = req.headers.get("Authorization");
    if (!authToken) {
      return jsonResponseUnauthorized();
    }

    const authClient = auth.fromJSON(googleServiceAccountKey);

    const client = new WorkflowExecutions(authClient);
    const response = await client.projectsLocationsWorkflowsExecutionsCreate(
      `projects/${googleServiceAccountKey.project_id}/locations/europe-west4/workflows/${workflowName}`,
      { argument: JSON.stringify(body) },
    );

    if (response.error) {
      console.error(
        `Failed to run workflow: ${response.error}`
      );
      return jsonResponse(response.error, 400);
    }

    const pathSegments = response.name?.split("/") as string[];
    const executionId = pathSegments[7];
    console.log(`Execution Id: ${executionId}`);

    // Create a Tracker instance
    const tracker = new Tracker(
      'init',
      executionId,
      documentId,
    );

    // Save the Tracker instance
    const { error } = await addToTracker(tracker);

    if (error) {
      return jsonResponse(error.message, 400);
    }

    return jsonResponse(response.state);
  } catch (error) {
    console.error(`Exception caught: ${error}`);
    return jsonResponse("Exception occurred", 400);
  }
});
