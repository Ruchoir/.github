# 0007. Licences

- Status: accepted; superseded for `core` by ADR 0014
- Date: 2026-11-06

## Context

Ruchoir is open source under the AGPL-3.0, with a proprietary enterprise edition built on top of it.
Propolis is meant to be integrated by other sites through its SDK: under the AGPL, such a site would
have to publish its own code.

## Decision

| What | Licence |
|---|---|
| Services and apps: `chat`, `drive`, `calendar`, `propolis`, `hub`, `desktop`, `mobile`, `installer` | `AGPL-3.0-only` |
| `core`, and what another developer embeds in their own code (the Propolis SDK, the API clients, the design system) | `MIT OR Apache-2.0` |
| `Ruchoir/.github` | `MIT OR Apache-2.0` |
| The enterprise module | Proprietary: never published, copied or vendored into a public repository |

- Each package declares its licence in its manifest. A repository holding both kinds ships both
  licence texts.
- Fonts keep their own licence (IBM Plex, OFL).

## Consequences

- A third-party site can embed the Propolis SDK and the API clients without taking on the AGPL.
- The products stay protected by the AGPL, and `core` can be permissive because every product that
  embeds it is AGPL.
- How contributions from outside the team are licensed is decided before they are opened.
