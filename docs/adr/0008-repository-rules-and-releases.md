# 0008. Repository rules and releases

- Status: accepted
- Date: 2026-11-06

## Context

The four repositories that existed before the restructuring each wrote the same golden rules, with
small differences that had already drifted apart. In the main repository, a version tag built the
image and also deployed production. With self-hosted instances installed à la carte, that no longer
fits.

## Decision

- **One set of common rules.** `common-rules.md`, in this repository, is copied unchanged at the top of
  every repository's `AGENTS.md`. The `conventions` check fails when a copy differs.
- **Visibility.** This repository is public, so GitHub applies its community files to every repository
  and the private repositories can call its workflows.
- **Pull requests.** Every change goes through a pull request with green checks. A review is welcome but
  not required while the team is two developers.
- **Merging.** Squash merge, with a Conventional Commit title. No ticket identifier in a branch, commit
  or pull request.
- **Releases.** A tag `vX.Y.Z` builds and publishes a signed image, with release notes drawn from the
  commits. It deploys nothing. Every instance, the testers' included, is updated through the installer.
- **Decisions.** Each repository keeps its own ADR series. A decision that touches several repositories
  lives here.
- **Dependency exceptions.** They are listed in one register here (`dependency-exceptions.md`). A
  repository never adds one on its own.
- **Interface text.** Each repository with an interface keeps its six dictionaries, with French as the
  source. Shared strings come from a package of `core`.
- **Moving code keeps its history.** When code moves from the current repository to a new one, it keeps
  the history of the files it takes, through `git filter-repo`.

## Consequences

- GitHub Free protects `main` on public repositories only. Private repositories rely on the convention
  until they are public.
- Changing a common rule is a new major tag of this repository, then one pull request per repository.
