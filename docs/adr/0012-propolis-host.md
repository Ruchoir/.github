# 0012. Propolis's host

- Status: accepted
- Date: 2026-11-07

## Context

Every product of an instance lives on its own subdomain. Propolis's origin is the OpenID Connect
issuer: products store people as the pair (issuer, subject). Its host is also the WebAuthn relying
party ID, to which every passkey is bound. Neither can change once people have signed in: a new
issuer is a new set of identities, and a new relying party ID loses every passkey.

## Decision

- Propolis answers on the subdomain `id.` of the instance's domain. For an instance at `example.org`,
  the issuer is `https://id.example.org`, and the relying party ID is `id.example.org`.
- The installer proposes `id.` by default. An administrator may pick another host at install time
  only. The installer then refuses to change it on a running instance.
- Products and apps never assume the prefix: they read the issuer from the instance's manifest
  (ADR 0004) and Propolis's discovery document.

## Consequences

- The issuer and the passkeys stay valid for the life of an instance.
- Documentation and examples use `id.example.org`.
- Moving an instance to another domain means new identities. The installer warns about it, and a
  migration tool, if ever needed, is a separate design.
