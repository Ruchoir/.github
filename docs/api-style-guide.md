# API style guide

How the HTTP API of every Ruchoir service looks. It applies to `propolis`, `hub`, `drive`, `calendar`
and `chat`. The reasons are in ADR 0005 (contracts and versions) and ADR 0006 (calls between
services). What is not written here yet is decided with the first service that needs it, then added.

## Addresses and versions

- Each service has its own subdomain, and its API lives under `/api/v<major>/`.
- Inside a major version the contract only grows. Nothing is removed, renamed or retyped, and no
  request field becomes required.
- A service describes itself at `/.well-known/ruchoir-product` (name, version, features). A client checks
  a feature before using it, never a version number.
- Something being withdrawn answers with a `Deprecation` header (RFC 9745), then `Sunset` (RFC 8594),
  and appears in the release notes.

## Contract

- Generated from the code with utoipa, committed as `contract/openapi-v<major>.json`, reviewed in pull
  requests.
- Every route is documented with its success and error responses and at least one example.

## Data

- JSON in `snake_case`.
- Identifiers are UUIDs.
- Dates and times are RFC 3339 strings, in UTC unless the field is about a local time.
- An unknown field in a request is refused, never ignored.

## Errors

Problem Details (RFC 9457), with `Content-Type: application/problem+json`:

```json
{
  "type": "about:blank",
  "title": "A licence is required",
  "status": 402,
  "code": "licence_required"
}
```

- `type` will point to the error's page once the API documentation is published; until then it is
  `about:blank`.
- `code` is stable and listed in the shared catalogue of `core`. A client decides on `code`, never on
  `title` or `detail`.
- When one of several rules refused a request, the extension `reason` says which one, as the current
  API does.
- Words for people come from the clients' dictionaries, never from the server.

## Lists

- Pagination by opaque cursor: the request sends `cursor`, the response returns `next_cursor` (absent on
  the last page).
- A client never builds or reads a cursor.

## Writes

- A request that creates something accepts an `Idempotency-Key` header. Sent again with the same key, it
  creates nothing new and answers as the first time.
- A resource that several people may change carries an `ETag`. A change sends `If-Match`, and a stale
  one is refused with `412`.
