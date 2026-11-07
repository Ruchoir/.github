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
    uses: Ruchoir/.github/.github/workflows/conventions.yml@v1.0.1
    with:
      rules-ref: v1.0.1
```

Once the repository holds code, add the language jobs the same way:

```yaml
  rust:
    uses: Ruchoir/.github/.github/workflows/rust.yml@v1.0.1
    with:
      rules-ref: v1.0.1
  node:
    uses: Ruchoir/.github/.github/workflows/node.yml@v1.0.1
    with:
      scripts: lint typecheck test i18n:check
```

A service whose tests need its stores adds `postgres: true` and `valkey: true` to the `rust` job (from
`v1.6.0`). They then find them in `RUCHOIR_TEST_DATABASE_URL` and `RUCHOIR_TEST_VALKEY_URL`, and
`RUCHOIR_TEST_STORES=required` tells them not to skip.

The `conventions` check fails when:

- a tracked text file holds an em dash;
- the tree or the history attributes work to an AI tool;
- `AGENTS.md` is missing, or its common rules block differs from `common-rules.md` at the pinned tag;
- on a pull request, a commit subject or the title is not a Conventional Commit, or names a ticket, or
  the branch name does not follow the convention.

## Versions

Every version of this repository is an immutable tag, `vX.Y.Z`, never moved. Callers pin the exact
tag in `uses` and pass the same one as `rules-ref`:

```yaml
  rust:
    uses: Ruchoir/.github/.github/workflows/rust.yml@v1.0.1
    with:
      rules-ref: v1.0.1
```

- A fix or an addition that keeps every caller passing is a new patch or minor tag. Each repository
  moves to it in its own pull request, when it needs it.
- A change that would fail a caller (a new rule, any change to the common block) is a new major tag.
  Each repository then moves to it in its own pull request, copying the new block.

| Tag | What changed |
|---|---|
| `v1` | First version |
| `v1.0.1` | The Rust workflow's cargo-deny step reads `deny.toml` at the workspace root |
| `v1.1.0` | Immutable tags; moving code with its history (ADR 0009) |
| `v1.2.0` | Which service owns which route (ADR 0010) |
| `v1.3.0` | Server events and security events (ADR 0011); Propolis's host (ADR 0012) |
| `v1.4.0` | One version for `Ruchoir/core` (ADR 0013) |
| `v1.5.0` | `core` under the MPL-2.0 (ADR 0014); events through the hub (ADR 0015); the hub's socket ticket (ADR 0016); a role's permissions (ADR 0017) |
| `v1.6.0` | The `rust` workflow can run the tests next to PostgreSQL and Valkey (`postgres`, `valkey`) |

## Licence

`MIT OR Apache-2.0`, at your option (`LICENSE-MIT`, `LICENSE-APACHE`).
