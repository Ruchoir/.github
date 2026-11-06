# 0001. Propolis: identity and organisations

- Status: accepted
- Date: 2026-11-06

## Context

Ruchoir is being split into products installed à la carte (`chat`, `drive`, `calendar`). Today
authentication lives inside the single API, and the shared notion of a *space* (members, invitations,
roles, groups, access rules, licences, audit) is spread between its permission module and its
messaging module. Every product's data points at spaces and users.

Propolis is the one service present in every installation ("Sign in with Ruchoir"). It is also meant
to be used by other sites and developers, so it has to stay a clean, standard identity provider.

## Decision

Propolis holds:

- **identity**: accounts, sign-in, multi-factor authentication, passkeys, and an OpenID Connect
  provider with its registered clients;
- **generic organisations**: members, invitations, groups and organisation roles. They are exposed as
  standard OpenID Connect claims, through an administration API and an SDK.

A Ruchoir space is a Propolis organisation.

These stay **out of Propolis**:

- Ruchoir's permission catalogue;
- the access rules on channels, files and calendars;
- what a guest may do inside a product.

The resolution engine is a crate of `Ruchoir/core`, and each product keeps the rules on its own
resources.

Licences and seats are an enterprise module attached to Propolis, outside the open-source core.

## Consequences

- The smallest installation is Propolis and one product.
- A third-party site can read a person's organisations without knowing anything about Ruchoir.
- The OpenID Connect provider is new code: it gets its own design (library, flows, organisation
  claims) before it is written.
- The enterprise edition, which today only concerns spaces, follows Propolis rather than a product.
