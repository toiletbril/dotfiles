import type { Plugin } from "@opencode-ai/plugin"

export const ContinueTasksPlugin: Plugin = async ({ client }) => {
  const pendingBySession = new Map<string, number>()
  const iterationsBySession = new Map<string, number>()
  const MAX_ITERATIONS = 20

  return {
    event: async ({ event }) => {
      if (event.type === "todo.updated") {
        const { sessionID, todos } = event.properties as {
          sessionID: string
          todos: Array<{ status: string }>
        }
        const pending = todos.filter(t => t.status !== "completed" && t.status !== "cancelled").length
        pendingBySession.set(sessionID, pending)
      }

      if (event.type === "session.idle") {
        const { sessionID } = event.properties as { sessionID: string }
        const session = await client.session.get({ path: { id: sessionID } })
        if (session.data?.parentID !== undefined) return

        const pending = pendingBySession.get(sessionID) ?? 0
        const iterations = iterationsBySession.get(sessionID) ?? 0
        if (pending > 0 && iterations < MAX_ITERATIONS) {
          iterationsBySession.set(sessionID, iterations + 1)
          await client.session.prompt({
            path: { id: sessionID },
            body: {
              parts: [{ type: "text", text:
                "Classify what is not done. Remind yourself that not all tasks are finished. Do best effort on the remaining work, and surface the discussible points to the user in the final summary." }],
            },
          })
        }
      }
    },
  }
}
