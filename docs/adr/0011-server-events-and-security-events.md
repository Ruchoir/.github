# 0011. Server events and security events

- Status: accepted
- Date: 2026-11-07

## Context

ADR 0006 asks for signed server-to-server events, each with an identifier. Two formats were on the
table:

- the event crate of `Ruchoir/core` (`ruchoir-events`): a JSON `Event` (`id`, `kind`, `version`,
  `occurred_at`, `source`, `organisation`, `payload`) whose exact bytes are signed with the emitter's
  Ed25519 key, the signature travelling in a `Ruchoir-Signature: keyid=…, sig=…` header;
- Security Event Tokens (RFC 8417), signed JWTs, which the OpenID Connect design of Propolis
  recommended so that one verifier would serve both events and Back-Channel Logout tokens.

Most events between Ruchoir services are product events (a file deleted, a channel archived, a
member added) that no outside standard describes. A few are security events that OpenID Connect
already defines, and that a third-party site must be able to read with an ordinary OpenID library.

## Decision

Each format has its own role.

| | Format | Signed with | Keys published at |
|---|---|---|---|
| **Events between Ruchoir services** (product events, and Propolis's events about accounts and organisations) | `ruchoir-events` | The emitter's own Ed25519 event key | Propolis, `/.well-known/ruchoir-event-keys` |
| **Security events defined by OpenID Connect** (Back-Channel Logout tokens today, and any later shared signal sent to clients) | Security Event Tokens (RFC 8417), as the specification of each event requires | Propolis's token signing key | Propolis's JWK set, `jwks_uri` |

- A key published in `/.well-known/ruchoir-event-keys` names the service that owns it. A consumer
  accepts an event only if the key that signed it belongs to the service named in its `source`.
- A Ruchoir service that also needs a security event (a product dropping a session on logout) reads it
  as any OpenID client does. It is never re-sent as a `ruchoir-events` event.

## Consequences

- Product events stay small and need no JWT library. Third-party sites only meet the standard
  formats.
- Two verifiers exist instead of one. Each is small, and each has its own published keys.
- The transport of events (through the hub or by webhooks) is still open, as in ADR 0006.
