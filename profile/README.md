# Ruchoir

**A self-hosted collaboration suite, built in Europe.** A chat, a drive for files and live office
documents, and a calendar, with one identity service, installed on your own server, under your own
domain. No cloud provider, no CDN, no analytics and no telemetry at runtime; the few outside services
a feature needs, such as waking a phone, are optional and carry no content.

Ruchoir is open source. The services and the apps are under the `AGPL-3.0-only`; the shared
libraries, which other sites can embed, under the `MPL-2.0`. It is young: nothing has reached a first
stable version yet.

## The repositories

| | |
|---|---|
| [propolis](https://github.com/Ruchoir/propolis) | Identity and organisations: accounts, sign-in, second factors, passkeys, the OpenID Connect provider |
| [hub](https://github.com/Ruchoir/hub) | Notifications and real time: the inbox, push, mail digests, live updates, the instance's manifest |
| [drive](https://github.com/Ruchoir/drive) | Files and folders, shares, versions, and office documents edited together with Euro-Office |
| [calendar](https://github.com/Ruchoir/calendar) | Calendars, recurring events, invitations, reminders, iCal subscriptions |
| [chat](https://github.com/Ruchoir/chat) | Channels and direct conversations, threads, mentions, files, link previews |
| [desktop](https://github.com/Ruchoir/desktop) | The desktop app, for Windows, macOS and Linux |
| [mobile](https://github.com/Ruchoir/mobile) | The phone app, for iOS and Android |
| [installer](https://github.com/Ruchoir/installer) | Sets up an instance à la carte, in production or for development |
| [core](https://github.com/Ruchoir/core) | The shared Rust crates and TypeScript packages |
| [.github](https://github.com/Ruchoir/.github) | The common rules, the decisions that span repositories, the shared CI |

How they fit together: [architecture](https://github.com/Ruchoir/.github/blob/main/docs/architecture.md).

## Getting involved

- **Run it from source and make a first change:**
  [getting started](https://github.com/Ruchoir/.github/blob/main/docs/getting-started.md).
- **Contribute:** [`CONTRIBUTING.md`](https://github.com/Ruchoir/.github/blob/main/CONTRIBUTING.md).
  Your first pull request asks you to sign the
  [contributor licence agreement](https://github.com/Ruchoir/.github/blob/main/CLA.md).
- **Report a bug or ask for a feature:** open an issue in the repository concerned.
- **Report a vulnerability:** privately, never in an issue, as the
  [security policy](https://github.com/Ruchoir/.github/blob/main/SECURITY.md) explains.
