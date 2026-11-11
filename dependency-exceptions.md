# Dependency exceptions

Golden rule 2 of every Ruchoir repository: European or neutral dependencies only. This file is the
only list of accepted exceptions. A repository never adds one on its own: an exception is proposed by
a pull request on `Ruchoir/.github`, with its reason, its scope and the decision it rests on.

An exception covers exactly its scope. Using the same dependency elsewhere, or widening what it does,
needs a new entry.

| Dependency | Governance | Scope | Why there is no alternative | Decision |
|---|---|---|---|---|
| Browser push services (Google, Apple, Mozilla) | US | Web Push from the notification service only. Opt-in per browser, can be turned off for the whole instance, carries no content (a constant encrypted marker only). | A browser is woken only by its own vendor's push service. | `hub` ADR 0001 (ADR 0001 of the former monolith) |
| APNs (Apple) and FCM (Google) | US | Phone push, sent only by the publisher-run push relay, without content. | An iPhone app is woken only by APNs, a Google Play app reliably only by FCM. | `hub` ADR 0002 (ADR 0006 of the former monolith) |
| React, Next.js, React Native, Expo | US | Libraries only. No hosted Expo service is used by anything built or shipped (no EAS Build, Update, Submit or push), and the Expo CLI always runs with `EXPO_NO_TELEMETRY=1`. | No equivalent European or neutral stack for the web and native interfaces. | `mobile` ADR 0001 (ADR 0005 of the former monolith); the former monolith's AGENTS.md |
| Expo account | US | Development only: it signs the manifests Expo Go needs on a physical iPhone. The project id stays out of the repositories. | Expo Go on an iPhone refuses an unsigned manifest. | `mobile` ADR 0001 (ADR 0005 of the former monolith) |
| GitHub and GitHub Actions | US | Code hosting, and builds on GitHub's runners (web, native and desktop apps). Nothing at runtime. | To be revisited if a European forge with macOS runners becomes practical. | `mobile` ADR 0001 (amended 2026-10-14), `desktop` ADR 0001 (ADR 0005 and 0008 of the former monolith) |
| Playwright and axe-core | US | Lab's audit runner (responsive and accessibility tests), and the end-to-end tests of `Ruchoir/installer` (a complete instance driven in a browser, in CI). Nothing at runtime. | No European or neutral browser automation drives the three engines; the tests run on CI runners only. | `lab` ADR 0001; extended to the installer on 2026-11-08 |
| Google and Microsoft sign-in (OpenID Connect) | US | Optional upstream identity providers, disabled by default, turned on by an instance's administrator. | People who already sign in there ask for it; nothing is contacted unless an instance opts in. | The former monolith's AGENTS.md (Auth); Propolis's OpenID Connect design |

## To confirm

- **Apple notarisation** of the macOS desktop app: a build-time Apple service, not recorded as an
  exception yet.
