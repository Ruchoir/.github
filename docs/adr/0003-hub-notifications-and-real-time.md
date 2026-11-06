# 0003. The hub: notifications and real time

- Status: accepted
- Date: 2026-11-06

## Context

Today one module writes a single inbox for messages and calendar events, sends web push, phone push
and email digests, and pushes live updates to open pages over WebSocket and SSE. Once products are
installed à la carte, someone has to own that, and the apps should not open one connection per product.

## Decision

A common service, the **hub**, is part of every installation, next to Propolis. It holds:

- the inbox;
- web push, and phone push through the publisher-run push relay;
- email digests of what is still unread;
- real-time delivery to connected pages and apps (WebSocket, with SSE as a fallback).

Products publish their events to the hub with the audience they computed. **The hub never decides who
may see what**: that stays with the product that owns the object. The apps keep one connection per
instance.

## Consequences

- An inbox entry refers to a product's object by an opaque identifier.
- The privacy rules of web and phone push are unchanged: no content in a push, only a constant marker.
- How products publish to the hub (the contract of those events) is defined with the hub itself.
