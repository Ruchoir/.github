# Decisions that touch several repositories

Each repository keeps its own ADRs in its `docs/adr/`. The ones here apply to more than one. An
accepted ADR is never rewritten: a later one supersedes it, and both say so.

| ADR | Decision |
|---|---|
| [0001](0001-propolis-identity-and-organisations.md) | Propolis holds identity and generic organisations; Ruchoir's own permissions stay out |
| [0002](0002-product-boundaries-and-standalone-repositories.md) | One repository per product, no internal imports, every repository stands alone |
| [0003](0003-hub-notifications-and-real-time.md) | One common hub for notifications and real time |
| [0004](0004-installer-and-product-manifest.md) | An installer sets up instances à la carte and keeps the product manifest |
| [0005](0005-api-contracts-and-versioning.md) | Code-first contracts that only grow, major version in the URL |
| [0006](0006-service-to-service-authentication.md) | Services call each other with Propolis tokens, never a shared secret |
| [0007](0007-licences.md) | AGPL for services and apps, MIT OR Apache-2.0 for what others embed |
| [0008](0008-repository-rules-and-releases.md) | Common rules, pull requests, squash merges, tags that publish without deploying |
| [0009](0009-moving-code-with-its-history.md) | Code moves with its history, cleaned messages, merged with a merge commit |
| [0010](0010-which-service-owns-which-route.md) | Which service owns each family of routes of today's API |
| [0011](0011-server-events-and-security-events.md) | `ruchoir-events` between services, Security Event Tokens for OpenID Connect security events |
| [0012](0012-propolis-host.md) | Propolis answers on `id.` of the instance's domain, fixed at install time |
| [0013](0013-one-version-for-core.md) | `Ruchoir/core` is released as one version; npm packages on GitHub Packages, crates from the tag |
| [0014](0014-core-under-the-mpl.md) | `Ruchoir/core` is public, under the MPL-2.0 (supersedes 0007 for `core`) |
| [0015](0015-server-events-travel-through-the-hub.md) | Server events travel through the hub, which forwards them signed and retries |
| [0016](0016-a-ticket-to-open-the-hub-socket.md) | A page opens the hub's socket with a single-use ticket from its product |
| [0017](0017-a-roles-permissions-live-in-each-product.md) | Propolis holds a role's identity; each product holds what the role may do in it |
| [0018](0018-propolis-routes-name-organisations.md) | Propolis's organisation routes live under `/api/v1/organisations` (supersedes 0010 for them) |
| [0019](0019-contributions-under-a-cla-and-private-vulnerability-reports.md) | Outside pull requests under a contributor licence agreement; vulnerabilities through GitHub's private reporting only |
