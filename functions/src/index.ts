import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

admin.initializeApp();

/**
 * Callable Function: healthCheck
 * Allows clients to verify connectivity with backend cloud functions.
 */
export const healthCheck = onCall(async (request) => {
  return {
    status: "ok",
    timestamp: new Date().toISOString(),
    authUid: request.auth?.uid ?? null,
  };
});

/**
 * Callable Function: echoService
 * Reusable callable function sample for multi-app requests.
 */
export const echoService = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  const { message, appId } = request.data as { message: string; appId?: string };

  return {
    success: true,
    echo: message,
    processedForApp: appId || "default",
    userId: request.auth.uid,
    timestamp: new Date().toISOString(),
  };
});

/**
 * Firestore Trigger: onUserCreated
 * Automatically provisions initial user metadata when a profile doc is written.
 */
export const onUserCreated = onDocumentCreated("users/{userId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) return;

  const data = snapshot.data();
  const userId = event.params.userId;

  // Set default settings/roles on user creation
  return snapshot.ref.set(
    {
      uid: userId,
      role: data.role || "standard_user",
      initializedAt: admin.firestore.FieldValue.serverTimestamp(),
      appPermissions: ["basic_access"],
    },
    { merge: true }
  );
});
