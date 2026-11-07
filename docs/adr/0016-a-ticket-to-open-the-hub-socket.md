# 0016. A ticket to open the hub's socket

- Status: accepted
- Date: 2026-11-07

## Context

A product page holds no token: each product is a backend-for-frontend with its own host-only cookie
(Propolis design, section 10). The hub, which carries live updates (ADR 0003), is on another host, so
the page cannot prove to it who it is. Native apps hold tokens and are not concerned.

## Decision

- **A product's backend gets the page a ticket.** It asks the hub, with a token obtained by token
  exchange for the signed-in person (RFC 8693), for a ticket to open the socket.
- **A ticket is single use and lives a minute.** The hub stores only its digest. It names the person,
  the product and the session, and nothing else.
- **The page opens the socket with the ticket.** It does this on the hub's own host, over WebSocket, or
  over SSE as a fallback. The ticket is consumed on the first try, and a reconnection asks for a new
  one.
- **The socket follows the session.** When the product's session ends (logout, or a back-channel
  logout from Propolis), the hub closes the sockets opened with that session's tickets.
- **The apps open the same socket with their access token for the hub**, one per instance.

## Consequences

- The connections live in the hub, as ADR 0003 wants, and a product relays nothing.
- A ticket that leaks is worth one connection, for a minute, and nothing once used.
- The hub checks a page's origin against the manifest's hosts before accepting its socket.
