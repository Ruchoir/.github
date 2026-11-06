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
