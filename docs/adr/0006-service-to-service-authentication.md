# 0006. Service-to-service authentication

- Status: accepted
- Date: 2026-11-06

## Context

Products call each other on the server side: the chat stores an attachment in the drive on behalf of
a person, and the calendar publishes an event card in a channel. They also exchange events (an account
or a file deleted). Today none of this crosses a network boundary, because it all happens inside one
process.

## Decision

- **Every service is an OpenID Connect client of Propolis.** No secret is shared between services.
- **On behalf of a person:** token exchange (RFC 8693). The service called applies that person's rights,
  exactly as if they had called it themselves.
- **On its own behalf:** `client_credentials`, with scopes limited to what the call needs.
- **Server-to-server events** are signed. Each carries an identifier, so handling one twice changes
  nothing.
- **Tracing.** The W3C trace context (`traceparent`) is propagated on every call by the shared HTTP
  middleware of `core`. Structured logs are common to all services, and never hold a secret or private
  content.

## Consequences

- A compromised product cannot act on behalf of someone who did not call it.
- The same mechanism lets third-party services integrate through Propolis.
- How events travel between services (through the hub or by webhooks) is still to decide.
