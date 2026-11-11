# Apps and instances that were not updated

The phone and desktop apps update when their stores or their users say so. Each instance updates
when its administrator does, and one instance may run its products at different versions. So any
version of an app meets any version of each service, both ways, and a service meets other services
of other versions. Three promises make that work; the code holds each service to them.

```
older app or service  ──▶ newer service   works: /api/v1 only grows, the caller ignores what it does not know
newer app or service  ──▶ older service   works: the caller asks what the service can do, and does without
any app               ──▶ any instance    works: the manifest says which services are installed
```

This page carries over, for the separate services, the rules the former monolith kept for its single
API. The reasons are in [ADR 0005](adr/0005-api-contracts-and-versioning.md); how every API looks is
in the [API style guide](api-style-guide.md).

## 1. `/api/v1` only grows

Within a major version of a service's API, nothing a client may rely on is removed, renamed, or given
another type or meaning:

- a route, a method, a query parameter, a field of an answer, a value a client compares against (an
  error `code`, a notification `kind`), an event or its fields;
- a field of an answer that was always present stays always present, and never becomes `null`;
- no request field and no query parameter becomes required.

What is new is added beside the old: a new field, a new route, a new event, a new optional
parameter. A client ignores the fields and the events it does not know.

A service refuses an unknown field in a request (API style guide). So a newer client never sends a
new field to a service without first checking that the service has the feature that reads it (see 2).

**Checked by each service's CI.** Each service records its contract, generated from the code, in
`contract/openapi-v1.json`, and a test (`tests/contract.rs`, built on `ruchoir-contract` of `core`)
compares it with what the code serves. It fails on a route or method gone, a field gone or retyped
(nullable included), a field no longer always present, or a request field newly required. When the
API grows, the test fails too, until the addition is recorded in the same pull request:

```bash
RUCHOIR_UPDATE_CONTRACT=1 cargo test --test contract
```

which refuses to write while something breaks.

**A change that `/api/v1` cannot take** goes to a new route beside the old one, or, for the whole
API, to `/api/v2`, served next to `/api/v1` for as long as the apps in use call it: at least a year
after the last app release that used it. What is withdrawn is announced first with the `Deprecation`
header, then `Sunset`, and in the release notes. Editing the recorded contract by hand to let a
removal through is that decision, made visibly in the pull request.

## 2. Each service says what it can do

`GET /.well-known/ruchoir-product`, on every service, with no session:

| Field | What |
|---|---|
| `name` | the service, as the manifest names it (`drive`) |
| `version` | the version of the running build |
| `api` | the major versions it serves, each under `/api/<major>/` (`["v1"]`) |
| `features` | what it can do beyond every service of the same API major, by name (`snake_case`) |

A client checks a feature before using it, and does without on a service that does not list it: a
button hidden, the older way taken. It never decides from `version`. A feature name is announced
once it works, and is never withdrawn nor reused within a major version.

Adding one: the name in the service's `FEATURES` (`src/product.rs`), its line in that list's doc
comment, and the clients' check before they use it.

## 3. The instance says what is installed

`GET https://hub.<domain>/.well-known/ruchoir-manifest` lists the services an instance runs, each
with its address ([ADR 0004](adr/0004-installer-and-product-manifest.md)). An app shows a product
only when the manifest lists it, and an integration between two products only when both are there.
Propolis and the hub are on every instance.

## The push relay

The relay, run by the publisher of the apps, serves every instance, whatever version each runs: its
routes only grow too. An instance newer than the relay (a `404` on a newer route) carries on without
what is missing. Its routes are described in the hub's
[`docs/push-relay.md`](https://github.com/Ruchoir/hub/blob/main/docs/push-relay.md).
