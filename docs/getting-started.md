# Getting started

From a fresh machine to a Ruchoir instance running from source, then a change to one product, its
tests and a pull request. Read [the architecture](architecture.md) first if you want the map; this
page is the path.

## 1. What you need

- **Git.**
- **Docker**, with its Compose plugin (`docker compose`): Docker Desktop on Windows and macOS,
  Docker Engine on Linux. With the drive, its office engine alone takes about 2 GB of memory and
  7 GB of disk for its image.
- **Rust, through [rustup](https://rustup.rs).** Each repository pins its version in
  `rust-toolchain.toml`, and rustup installs it on first use.
- **Node 24 and pnpm 11**, for the pages and the apps: install Node 24, then `corepack enable`, which
  gives each repository the pnpm version its `package.json` names.
- **OpenSSL's headers**, to build Propolis (for passkeys): `libssl-dev` on Debian and Ubuntu,
  `openssl` from Homebrew on macOS; on Windows, an OpenSSL install with `OPENSSL_DIR` pointing at it.
- **A GitHub token for the `@ruchoir` packages.** The shared npm packages of
  [`core`](https://github.com/Ruchoir/core) are on GitHub Packages, which asks for a token even to
  read a public package. Create a personal access token (classic) with the `read:packages` scope
  only, then:
  - add it to your user `~/.npmrc` (never to a repository), for `pnpm install`:

    ```
    //npm.pkg.github.com/:_authToken=<your token>
    ```

  - and keep it at hand as `NODE_AUTH_TOKEN`, which the installer passes to the image builds.

On Windows, run the commands below in Git Bash.

## 2. Check out the repositories side by side

```bash
mkdir ruchoir && cd ruchoir
for repo in propolis hub drive calendar chat installer .github; do
  git clone "https://github.com/Ruchoir/$repo.git"
done
```

Propolis and the hub are needed for any instance; take only the products you want among `drive`,
`calendar` and `chat` (the chat needs the drive). Until every service is published, some of these
repositories may still be private: a clone that fails with `Repository not found` needs access from
the team. Propolis is required; a product you cannot clone is left out of `--products`. `.github`
holds the conventions check you run before a pull request. The apps,
[`desktop`](https://github.com/Ruchoir/desktop) and [`mobile`](https://github.com/Ruchoir/mobile),
connect to an instance like this one; their READMEs say how to run them.

## 3. Install the installer

```bash
cargo install --path installer
```

This builds `ruchoir-install` into Cargo's `bin` directory (`~/.cargo/bin`, on your `PATH` once rustup
is installed).

## 4. Start a development instance

From the `ruchoir` directory that holds the checkouts:

```bash
NODE_AUTH_TOKEN=<your token> ruchoir-install dev --source . --products drive,calendar,chat
```

Name only the products you checked out; without `--products`, the instance runs Propolis and the
hub alone, which is enough to work on the hub.

The installer writes the instance to `ruchoir-dev/`, builds the image of each service from its
checkout, and starts everything with Docker Compose: Propolis, the hub, the reverse proxy, the
products asked, their stores, and a mail catcher. The first run takes a while (every image is built,
and the office engine takes a minute or two to start). Then:

- **Trust the local certificate authority**, `ruchoir-dev/dev-ca/ca.pem`, in your browser (in its
  certificate settings, as an authority for websites). Every service is served over HTTPS with a
  certificate it signed.
- The instance answers on `*.localhost`: Propolis at `https://id.localhost`, the hub at
  `https://hub.localhost`, the products at `https://drive.localhost`, `https://calendar.localhost`
  and `https://chat.localhost`. Chrome and Firefox send `*.localhost` to your machine on their own;
  another browser may need these names in your hosts file.
- **Every mail** the instance sends (address confirmations, invitations) is caught at
  `http://localhost:8025`.
- **Outside a browser** (curl, a script, the desktop app), Windows does not resolve `*.localhost`:
  `ruchoir-install hosts --dir ruchoir-dev --write`, from a terminal run as administrator, adds the
  names to its hosts file. Those programs must trust the authority too: `curl --cacert
  ruchoir-dev/dev-ca/ca.pem`, plus `--ssl-no-revoke` with the curl of Windows, which otherwise
  refuses a certificate whose revocation it cannot check.

The instance takes ports 443 and 8025, and is its own Compose project, named after its directory and
its path: two instances in different directories never share data, but only one runs at a time.

`ruchoir-install down --dir ruchoir-dev` stops the instance, and its data stays. Running the same
`dev` command again rebuilds the images and starts it; the products installed before are kept.

## 5. Sign in and create an organisation

1. Open `https://id.localhost`, create an account, and confirm your address with the link or the code
   of the mail caught at `http://localhost:8025`.
2. Propolis has no page to create an organisation yet. Signed in at `https://id.localhost`, open the
   browser's console and call its API:

   ```js
   await fetch("/api/v1/organisations", {
     method: "POST",
     headers: { "content-type": "application/json" },
     body: JSON.stringify({ name: "Demo" }),
   }).then((response) => response.json());
   ```

   You own the new organisation. Its members, invitations, groups and roles have routes of their own
   (Propolis's contract, `contract/openapi-v1.json`).
3. Open `https://chat.localhost`, `https://drive.localhost` or `https://calendar.localhost`: each signs
   you in through Propolis and shows your organisation.

Invite a second account (in another browser profile) to see live updates and notifications travel
through the hub.

## 6. Work on one product

Each repository runs and tests on its own, without the others: its `README.md` gives the exact
commands (they differ a little: the hub, for one, tests with `--all-features`), and its `AGENTS.md`
the settings, the layout and the gotchas. The drive, for example:

```bash
cd drive
docker compose up -d            # its own throwaway PostgreSQL and Valkey
cargo fmt --check
cargo clippy --all-targets -- -D warnings
RUCHOIR_TEST_DATABASE_URL=postgres://drive:drive@localhost:5432/drive \
RUCHOIR_TEST_VALKEY_URL=redis://localhost:6379 \
cargo test
cd web && pnpm install --frozen-lockfile && pnpm typecheck && pnpm test && pnpm i18n:check
```

The other services are replaced in the tests by stand-ins built from their contracts, so no other
repository needs to be checked out. A repository's `compose.yaml` publishes its stores on
`127.0.0.1:5432` and `127.0.0.1:6379`: if a PostgreSQL or Valkey of your own already holds a port,
move it in a `compose.override.yaml` beside it (yours alone: never commit it) and point the test
URL at the new port:

```yaml
services:
  postgres:
    ports: !override
      - "127.0.0.1:55432:5432"
```

To see a change in the whole instance, run the `dev` command of step 4 again: it rebuilds the images
from your checkouts.

## 7. Open a pull request

1. Branch from `main` with a conventional name (`fix/upload-folder-ignored`), and commit with
   Conventional Commits in English.
2. Run the conventions check from the repository's root:

   ```bash
   bash ../.github/scripts/check-conventions.sh ../.github/common-rules.md
   ```

3. Fork the repository (`gh repo fork --remote`, or the Fork button), push your branch to the fork
   and open the pull request against `main`. The first time, sign the
   [contributor licence agreement](../CLA.md) with a comment, as the `CLA` check asks.

The whole process, and what a pull request carries: [`CONTRIBUTING.md`](../CONTRIBUTING.md).

## When something goes wrong

- **`pnpm install` answers 401 or 403** for an `@ruchoir` package: the token is missing from your user
  `~/.npmrc`, or lacks `read:packages`.
- **An image fails to build** at the pages' step with the same error: `NODE_AUTH_TOKEN` was not set
  for the `dev` command.
- **The browser warns about the certificate**: the local authority, `ruchoir-dev/dev-ca/ca.pem`, is
  not trusted yet in that browser (some browsers keep their own list, apart from the system's).
- **Propolis stops on `password authentication failed`**: the instance found the database of
  another one. An installer older than the per-directory Compose projects ran every development
  instance as `ruchoir`: update the installer (step 3) and run `dev` again.
- **A product added to an instance that already ran has no database**: the database is created on
  the first start only. The installer's `AGENTS.md` (section "Gotchas") gives the statements to run.
