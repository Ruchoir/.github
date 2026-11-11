# Contributing to Ruchoir

This guide applies to every repository of the Ruchoir organization, unless a repository has its own
`CONTRIBUTING.md`. Each repository's `AGENTS.md` opens with the common rules: read them first. They
win over anything in this guide.

Contributions are welcome: bug reports, fixes, translations, documentation, features. For anything
bigger than a fix, open an issue first so we can agree on the approach before you write the code.

## Before you start

- [The getting-started guide](https://github.com/Ruchoir/.github/blob/main/docs/getting-started.md) takes you from a fresh
  machine to a running instance and your first pull request.
  [The architecture](https://github.com/Ruchoir/.github/blob/main/docs/architecture.md) shows how the repositories fit
  together.
- Each repository's `README.md` says how to set it up, run it and test it on its own.
- What you need, depending on the repository:
  - Rust, through rustup: each repository pins its version in `rust-toolchain.toml`;
  - Node 24 and pnpm 11 (`corepack enable` picks the version a `package.json` names);
  - Docker, for the stores the services test against (PostgreSQL, Valkey) and for a whole instance.
- **A GitHub token for the `@ruchoir` npm packages.** They are published on GitHub Packages, which asks
  for a token even to read a public package. Create a personal access token (classic) with the
  `read:packages` scope only, and add this line to your user `~/.npmrc` (never to a repository):

  ```
  //npm.pkg.github.com/:_authToken=<your token>
  ```

- **Running several products together** goes through the development mode of
  [`Ruchoir/installer`](https://github.com/Ruchoir/installer): with the repositories checked out side
  by side, `NODE_AUTH_TOKEN=<your token> ruchoir-install dev --source .. --products calendar,chat`
  builds their images and starts Propolis, the hub, the reverse proxy and the products you chose, at
  `https://id.localhost`, with a mail catcher. The installer's README has the details.

## The contributor licence agreement

Before your first pull request is merged, you sign the
[Ruchoir Contributor Licence Agreement](https://github.com/Ruchoir/.github/blob/main/CLA.md) (ADR 0019). It is a
licence, not a transfer of your copyright: you keep your rights, and you allow Ruchoir to ship your
contribution under the project's licence and under other licences, the enterprise edition's included.

1. Open your pull request. A check named `CLA` comments on it and stays red.
2. Read [`CLA.md`](https://github.com/Ruchoir/.github/blob/main/CLA.md), then post this exact
   comment on the pull request: `I have read the Ruchoir CLA and I hereby sign it.`
3. The check records your GitHub account and turns green. You never sign again, in any repository of
   the organization, unless the agreement gets a new version.

If you contribute as part of your job, make sure your employer agrees. A company that wants to cover
several of its employees with one agreement opens an issue here titled "Corporate contributor licence
agreement".

## Making a change

1. Fork the repository (or branch, for the team) from `main`: `feat/`, `fix/`, `refactor/`, `perf/`,
   `docs/`, `test/`, `build/`, `ci/` or `chore/`, then a short English name in kebab case
   (`fix/upload-folder-ignored`).
2. Commit with Conventional Commits in English: `type(scope): what the change does`. Add `!` after
   the type or scope for a breaking change, and say what breaks in the body.
3. Open a pull request. Its title is a Conventional Commit too, because it becomes the commit on
   `main`. Fill in the template.
4. Wait for the required checks to pass. A maintainer reviews a pull request from outside the team.
5. It is squash-merged, and the branch is deleted.

**One exception: code moved with its history** from another repository (`git filter-repo`). Squashing
would fold that history into one commit, so such a pull request is merged with a merge commit,
allowed on the repository for that merge only. Before it is pushed, the imported commit messages lose
their ticket references, and a subject that is not a Conventional Commit gets `chore: ` in front, so
the `conventions` check passes on the whole range. See ADR 0009.

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
- **Interface text in French first**, then the five other languages, in the repository's dictionaries.

## Checking your work locally

From the root of any repository, with a clone of `Ruchoir/.github` next to it:

```bash
bash ../.github/scripts/check-conventions.sh ../.github/common-rules.md
```

Each repository's `README.md` lists its own build, lint and test commands.

## Issues

Use the templates: a bug report or a feature request. The team tracks its own work in an internal
tool, so an issue is the way to reach it. Never report a vulnerability in an issue: see below.

## Releases

A service's tag `vX.Y.Z` on `main` publishes a signed image and its release notes. It deploys
nothing: every instance is updated through the installer. The apps and `core` say in their
`AGENTS.md` what their tags publish. Only maintainers tag.

## Licences

| What | Licence |
|---|---|
| Services, apps and the installer (`propolis`, `hub`, `drive`, `calendar`, `chat`, `desktop`, `mobile`, `installer`) | `AGPL-3.0-only` |
| `core`: the shared crates and packages, and what another developer embeds (Propolis SDK, API clients, design system) | `MPL-2.0` (ADR 0014; versions up to `v0.1.0` were `MIT OR Apache-2.0`) |
| This repository | `MIT OR Apache-2.0` |

Fonts keep their own licence (IBM Plex, OpenDyslexic: OFL). Your contribution is shipped under the
licence of the repository you send it to, and the contributor licence agreement lets Ruchoir ship it
under other licences too.

## Reporting a security issue

Never in a public issue or pull request. Use GitHub's private vulnerability reporting, on the
repository concerned: [`SECURITY.md`](https://github.com/Ruchoir/.github/blob/main/SECURITY.md) says
how.
