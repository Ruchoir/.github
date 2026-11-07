# 0014. Ruchoir/core is public, under the MPL-2.0

- Status: accepted
- Date: 2026-11-07
- Supersedes: ADR 0007, for `core` and for what another developer embeds

## Context

ADR 0007 put `core`, and what another developer embeds (the Propolis SDK, the API clients, the design
system), under `MIT OR Apache-2.0`. The products are private repositories that must read `core`'s
crates and packages from their CI, and a CI token cannot read another private repository. Making
`core` public solves that. A permissive licence would then let anyone ship a changed copy of `core`
without sharing the change.

## Decision

- `Ruchoir/core` is a public repository under the **Mozilla Public License 2.0** (`MPL-2.0`). This
  covers every crate and package in it: the Propolis SDK, the API clients and the design system
  included.
- The MPL is a copyleft per file. Whoever changes a file of `core` and ships it shares that file under
  the MPL. `core` can still be combined with code under any other licence:
  - the AGPL products;
  - the proprietary enterprise module;
  - a third-party site that embeds the SDK.
- Fonts keep their own licence (IBM Plex and OpenDyslexic, OFL).
- Versions released before this change (`v0.1.0`) stay under `MIT OR Apache-2.0`.
- The services, the apps and `Ruchoir/.github` keep the licences of ADR 0007.

## Consequences

- Products read `core`'s crates from a public tag, with no credentials. The npm packages of GitHub
  Packages still need a token, and each repository's own CI token reads them.
- Improvements to `core` made by others come back to it, file by file.
- The licence line of the common rules about what others embed changes with the next major version of
  the common block. Until then, this record supersedes it for `core`.
