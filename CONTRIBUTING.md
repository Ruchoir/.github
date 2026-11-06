# Contributing to Ruchoir

This guide applies to every repository of the Ruchoir organization, unless a repository has its own
`CONTRIBUTING.md`. Each repository's `AGENTS.md` opens with the common rules: read them first. They
win over anything in this guide.

## Before you start

- The repository's `README.md` says how to set it up, run it and test it on its own.
- Running several products together will go through the development mode of `Ruchoir/installer`:
  Propolis, the notification and real-time service, the reverse proxy and the products you choose,
  with demo data.

## Making a change

1. Branch from `main`: `feat/`, `fix/`, `refactor/`, `perf/`, `docs/`, `test/`, `build/`, `ci/` or
   `chore/`, then a short English name in kebab case (`fix/upload-folder-ignored`).
2. Commit with Conventional Commits in English: `type(scope): what the change does`. Add `!` after
   the type or scope for a breaking change, and say what breaks in the body.
3. Open a pull request. Its title is a Conventional Commit too, because it becomes the commit on
   `main`. Fill in the template.
4. Wait for the required checks to pass. A review is welcome, not required.
5. Squash-merge, then delete the branch (GitHub does it on merge).

Never put ticket identifiers, lot names or code names in a branch, a commit or a pull request: say
what the change does. The `conventions` check refuses them.

## What a pull request carries

- **The docs, in the same change.** If it alters a decision, the stack, the scope or a convention, it
  updates `README.md`, `AGENTS.md` and the relevant docs.
- **The contract, on purpose.** If it changes the public API or the published events, it updates the
  committed contract files. The CI refuses a removal, a rename or a retype inside a major version.
- **An ADR** for a structural decision, in `docs/adr/` (or in `Ruchoir/.github` when it touches
  several repositories).
- **Tests** for what it changes. For a permission, test the refused side as well as the allowed one.

## Checking your work locally

From the root of any repository, with a clone of `Ruchoir/.github` next to it:

```bash
bash ../.github/scripts/check-conventions.sh ../.github/common-rules.md
```

Each repository's `README.md` lists its own build, lint and test commands.

## Releases

A tag `vX.Y.Z` on `main` publishes a signed image and its release notes. It deploys nothing: every
instance is updated through the installer. Only maintainers tag.

## Licences

| What | Licence |
|---|---|
| Services and apps (`chat`, `drive`, `calendar`, `propolis`, `hub`, `desktop`, `mobile`, `installer`) | AGPL-3.0-only |
| `core`, and what another developer embeds (Propolis SDK, API clients, design system) | MIT OR Apache-2.0 |
| This repository | MIT OR Apache-2.0 |

Contributions from outside the team are not open yet.

## Reporting a security issue

Never in a public issue or pull request. Write privately to a maintainer (`@theovil1` or
`@Glouna1117` on GitHub). A security policy with a dedicated contact will follow.
