# 0017. A role's permissions live in each product

- Status: accepted
- Date: 2026-11-07

## Context

ADR 0001 gives Propolis generic organisations, with roles and groups, and keeps Ruchoir's own
permissions out of it. A role still has to say what its holders may do in each product: whether a
"Member" may create a channel or write in the drive. Those permissions can live with each product, or
in Propolis as an attribute per application that it stores and never reads.

## Decision

- **Propolis holds a role's identity.** That is its name, its position and who holds it, directly or
  through a group.
- **Each product holds what a role may do in it.** It keeps its part of the permission catalogue for
  every role of every organisation. It resolves them with the engine of `core` (`ruchoir-permissions`),
  and keeps its rules on its own resources.
- **A new role starts with each product's defaults.** A product learns of a role from Propolis's
  events (created, renamed, reordered, deleted), and gives a new role its default permissions. When the
  role is deleted, the product forgets them.
- **Settings stay in one place for the person.** An organisation's settings screen gathers each
  installed product's section for a role, through that product's API. Propolis has no part in it.

## Consequences

- Propolis stays usable by a site that knows nothing of Ruchoir.
- A product installed later starts every existing role with its defaults.
- The permission catalogue is split by product. Each product's contract lists its own permissions.
