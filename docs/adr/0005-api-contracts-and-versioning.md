# 0005. API contracts and versioning

- Status: accepted
- Date: 2026-11-06

## Context

The current API generates its OpenAPI document from the code (utoipa), commits it, and a test refuses
any change that would break an app that was not updated: the contract only grows. Splitting the API
breaks that contract once. After the split, an instance may combine products of different versions,
so each contract matters more than before.

## Decision

- **Code first.** Each service generates its OpenAPI contract from its code with utoipa. The file is
  committed in the service's repository and reviewed in pull requests like any other file.
- **The contract only grows inside a major version.** The CI refuses a route, field, event or value that
  is removed, renamed or retyped, and a request field that becomes required. A shared test crate of
  `core` generalises today's check.
- **Versions.** The major version is in the URL, per service (`/api/v1/...` on each subdomain). A service
  is versioned with SemVer, independently of its API's major version.
- **Retiring.** Something is withdrawn by announcing it with the `Deprecation` header (RFC 9745), then
  `Sunset` (RFC 8594), and in the release notes.
- **Errors** use Problem Details (RFC 9457), with a shared catalogue of stable codes.
- **Documentation and clients.** Readable documentation is rendered from each contract, and TypeScript
  clients are generated from it.
- **Events between services** are described in AsyncAPI and versioned the same way.
- **Contract tests between products.** Each product lists the operations it calls on others, and the CI
  checks them against the published contract of the product it calls.
- **During the restructuring**, the "only grows" rule is suspended. It comes back service by service,
  as soon as each one runs on its own.

## Consequences

- The current contract, split by service and reviewed, is the target contract written before the split.
- The hand-written API client of the current repository gives way to generated clients.
- How every API looks is described in `docs/api-style-guide.md`.
