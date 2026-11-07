# 0015. Server events travel through the hub

- Status: accepted
- Date: 2026-11-07

## Context

ADR 0006 and ADR 0011 fix how server events are signed, but leave open how they travel. Examples: an
organisation created in Propolis creates its default calendar, and a file deleted in the drive clears
its references in the chat and the calendar. Either each service posts its events to the services that
subscribed (webhooks), or one service relays them.

## Decision

- **Every server event goes through the hub.** A service hands the hub each event, signed by itself
  (ADR 0011). The hub delivers it to every service that subscribed to its `kind`.
- **The hub never signs or changes an event.** It forwards the exact bytes and the
  `Ruchoir-Signature` header. The consumer checks the signature against the keys Propolis publishes, as
  if the emitter had called it directly.
- **Delivery is at least once.** The hub retries with backoff, for a window long enough to outlast a
  service's restart or upgrade. The event `id` makes a second delivery harmless.
- **Subscriptions are declared** by each service, by event kind, and installed with it. The hub keeps
  them and refuses a delivery address outside the instance.
- **A hub that is down loses nothing.** An emitter keeps an event until the hub has accepted it.

## Consequences

- A product exposes one endpoint for every event it consumes, and keeps no delivery queue of its own.
- The hub becomes needed for these consequences too, not only for notifications. It is in every
  installation already (ADR 0003).
- The contract of event delivery (subscriptions, the delivery endpoint, retries) is written with the
  hub, in AsyncAPI.
