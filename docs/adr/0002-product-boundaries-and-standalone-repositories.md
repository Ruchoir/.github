# 0002. Product boundaries and standalone repositories

- Status: accepted
- Date: 2026-11-06

## Context

The current code is modular but lives in one repository and one database. Its products import each
other's internals: attachments, event cards in channels, the files of an event, the calendar created
with a space. Eight foreign keys tie two products together directly.

A monorepo was ruled out: it weighs on the CI and does not draw the products' edges clearly enough for
new developers.

## Decision

- **One repository per product and per service.** The products are `chat`, `drive` and `calendar`.
  The services are `propolis` and `hub`. `core` holds the shared libraries, `desktop` and `mobile`
  the apps, `installer` the installation, `.github` the organization's ground.
- **Product boundaries.** A repository never imports another product's internal code. It reaches
  another product only through that product's public API or published events, and shares code only
  through a versioned package of `core`.
- **Every repository stands alone.** It builds, tests and starts without the source of any other
  repository. Other services are replaced by test doubles built from their published contracts.
- **Each product owns its data.** A reference to another product's object is an opaque identifier
  with no database constraint. What a cascade did becomes an event that the product holding the
  reference handles.
- **Optional integrations.** An integration shows only when the other product is installed (ADR 0004).
  The chat is the exception: it requires the drive, which stores its attachments through the drive's
  API. Installing the chat installs the drive.

## Consequences

- Deleting an account, an organisation or a file goes through events. A test proves that every product
  handles them.
- The drive learns to keep a file that belongs to another application, which decides its audience.
- Products are moved one at a time, and the next one starts only once the previous one runs on its own
  from end to end.
