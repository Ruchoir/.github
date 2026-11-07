# 0013. One version for Ruchoir/core

- Status: accepted
- Date: 2026-11-07

## Context

`Ruchoir/core` holds the Rust crates and TypeScript packages that several products share. The common
rules say its packages are published "with their own versions". Versioning each one apart would
mean a tag per crate and per package, a bump to follow for each, and products holding combinations
of versions that were never tested together.

## Decision

- `Ruchoir/core` is released as one version, `vX.Y.Z`. Every crate and every package carries it, and a
  check in its CI refuses one that disagrees.
- A breaking change to any crate or package makes a new major version of the whole repository.
- The tag publishes and deploys nothing:
  - the npm packages go to GitHub Packages (`npm.pkg.github.com`, scope `@ruchoir`);
  - products read the crates from the tag with Cargo (`git` and `tag`), with no Rust registry to run;
  - a GitHub release carries notes drawn from the commits.
- A product pins one version of `core`, and all its crates and packages name the same tag.
- On this point this record supersedes the line of the common rules that gives each package its own
  version. The next major version of the common block will word it this way.

## Consequences

- One number tells which shared code a product was built and tested with.
- A product that only needs a fix to one package still moves its whole `core` version. Within a major
  version, that move is safe by definition.
- Reading the packages and crates from another private repository needs credentials in that
  repository's CI. Which ones depends on whether `Ruchoir/core` stays private, which is still to
  decide.
