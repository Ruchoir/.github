# 0018. Propolis's routes name organisations

- Status: accepted
- Date: 2026-11-07
- Supersedes: ADR 0010, for the routes Propolis serves on organisations

## Context

ADR 0010 keeps every route's path when it moves to its service, so that clients move without
renaming. Propolis's organisation routes would therefore stay `/api/v1/spaces...`. But Propolis's
contract is new, its model and its OpenID Connect claim say organisation (`organizations`), and its
routes will be read by sites that know nothing of Ruchoir's spaces.

## Decision

The routes Propolis serves on organisations are named after them, under `/api/v1/organisations`:

| Monolith | Propolis |
|---|---|
| `/spaces`, `/spaces/{id}` | `/organisations`, `/organisations/{id}` |
| `/spaces/by-slug/{slug}` | `/organisations/by-slug/{slug}` |
| `/spaces/{id}/icon` | `/organisations/{id}/icon` |
| `/spaces/{id}/members...`, `/spaces/{id}/membership` | `/organisations/{id}/members...`, `/organisations/{id}/membership` |
| `/spaces/{id}/roles`, `/spaces/{id}/groups...` | `/organisations/{id}/roles`, `/organisations/{id}/groups...` |
| `/spaces/{id}/audit` | `/organisations/{id}/journal` |
| `/spaces/{id}/invitations...` | `/organisations/{id}/invitations...` |
| Propolis's part of `/me/spaces` | `/me/organisations` |

- `/invitations/{token}` and `/invitations/{token}/accept` keep their paths.
- The routes of the products under a space (`/spaces/{id}/files`, `/spaces/{id}/channels`,
  `/spaces/{id}/calendars`...) keep their paths, as ADR 0010 says: a space is still how a person
  finds an organisation in the products.
- In Propolis's code, contract and documentation, the word is organisation. In the interface, the
  dictionaries keep saying « espace ».

## Consequences

- The interfaces change their calls to these routes when they move to Propolis. They change them in
  one place, the client of Propolis.
- A third-party site reads one vocabulary, from the claims to the routes.
