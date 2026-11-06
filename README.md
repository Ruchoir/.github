# Ruchoir/.github

The shared ground of the Ruchoir organization: the rules every repository follows, the decisions
that span several repositories, and the CI they all call. Nothing here runs in production.

| Path | What it is |
|---|---|
| `common-rules.md` | The common rules block, copied unchanged at the top of every repository's `AGENTS.md` |
| `CONTRIBUTING.md`, `pull_request_template.md` | Shown by GitHub in every repository of the organization that has none of its own |
| `dependency-exceptions.md` | The only list of accepted exceptions to the dependency rule |
| `docs/adr/` | Decisions that touch several repositories |
| `docs/api-style-guide.md` | How the API of every Ruchoir service looks |
| `.github/workflows/conventions.yml`, `rust.yml`, `node.yml` | Reusable workflows the other repositories call |
| `scripts/check-conventions.sh` | The conventions check, also runnable locally |
| `scripts/configure-repo.sh` | Applies the organization's settings to a repository |
| `deny.toml` | The cargo-deny configuration of the Rust workflow |

## Using the shared CI

In a repository's `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  conventions:
    uses: Ruchoir/.github/.github/workflows/conventions.yml@v1
```

Once the repository holds code, add the language jobs the same way:

```yaml
  rust:
    uses: Ruchoir/.github/.github/workflows/rust.yml@v1
  node:
    uses: Ruchoir/.github/.github/workflows/node.yml@v1
    with:
      scripts: lint typecheck test i18n:check
```

The `conventions` check fails when:

- a tracked text file holds an em dash;
- the tree or the history attributes work to an AI tool;
- `AGENTS.md` is missing, or its common rules block differs from `common-rules.md` at the pinned tag;
- on a pull request, a commit subject or the title is not a Conventional Commit, or names a ticket, or
  the branch name does not follow the convention.

## Versions

Callers pin a major tag (`@v1`). A change that keeps every caller passing moves `v1` forward once
the CI passes on `main`. A change that would fail a caller (a new rule, a changed block) gets a new
major tag; each repository then moves to it in its own pull request, copying the new block.

## Licence

`MIT OR Apache-2.0`, at your option (`LICENSE-MIT`, `LICENSE-APACHE`).
