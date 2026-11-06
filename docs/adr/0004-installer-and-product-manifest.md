# 0004. The installer and the product manifest

- Status: accepted
- Date: 2026-11-06

## Context

Ruchoir is self-hosted, and each organisation should install only what it needs. Integrations between
products (an event card in a channel, files of the drive in an event) must appear only when both
products are present. Propolis must stay a clean identity provider, so it is not the place to track
what is installed.

## Decision

- **An installer** sets up an instance à la carte. Propolis, the hub and a reverse proxy are always
  installed, with one subdomain per product. The person installing chooses the products; choosing the
  chat also installs the drive.
- **A manifest** lists the installed products and their addresses. The installer keeps it, and the
  reverse proxy publishes it at a `.well-known` address.
- **Each product describes itself** at `/.well-known/ruchoir-product`: name, version and features. This
  takes over from the feature list the current API announces.
- **An integration appears** only when the manifest lists the other product and that product announces
  the feature it relies on. Integrations test features, never version numbers.

## Consequences

- Adding a product later updates the manifest; the others pick it up without being reconfigured.
- An instance may run products of different versions, which is why features, not versions, decide.
- The installer also gets a development mode that runs the suite locally with demo data, and it hosts
  the end-to-end tests of a complete instance.
