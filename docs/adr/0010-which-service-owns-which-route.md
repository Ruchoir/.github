# 0010. Which service owns which route

- Status: accepted
- Date: 2026-11-06

## Context

The single API of `Ruchoir/ruchoir` serves 167 routes under `/api/v1`. ADR 0005 asks for one contract
per service, written before the split. This record says where each family of routes goes. The
contract files themselves are generated from each service's code when that service is taken up.

## Decision

| Service | Families of routes (after `/api/v1`) |
|---|---|
| `propolis` | `auth/*`; `spaces`, `spaces/{slug}`, `spaces/{space_id}`, `spaces/{id}/icon`, `members`, `membership`, `groups`, `roles`, `audit`, `invitations`; `invitations`, `public/invitation`; `users`; `admin/users` |
| `hub` | `notifications`, `push`, `realtime`, `me/notification-preferences`, `spaces/{id}/notification-preference`, `me/presence`, `spaces/{id}/presence` |
| `drive` | `files`, `spaces/{id}/files`, `spaces/{id}/folders`, `spaces/{id}/trash`, `public/links` |
| `calendar` | `calendar`, `calendars`, `events`, `spaces/{id}/calendars` |
| `chat` | `channels`, `conversations`, `messages`, `spaces/{id}/channels`, `channel-order`, `default-channel`, `dm`, `dms`, `changes`; `me/dms`, `me/saved`, `me/recent-reactions`; `link-previews` |
| every service | `health`, `healthz` |

Families that span several services:

1. **Access rules** (`spaces/{id}/access/{kind}/{resource_id}`, its `entries` and `why`). Each product
   serves the rules of its own resources. Propolis keeps what targets the organisation itself.
2. **Account preferences** (`me/preferences`). Propolis keeps the account's keys; each product serves
   its own keys.
3. **A person's spaces** (`me/spaces`). Propolis serves the list of organisations, the hub the unread
   and mention counters, and the interface puts them together.
4. **Search** (`search`). Each product searches its own objects; the interface's global search merges
   the results.
5. **A channel's events** (`channels/{id}/events`). The route moves to the calendar, as a filter on
   its events. The chat calls it only when the calendar is installed.
6. **An invitation to a single channel** (`channels/{id}/invitations`). Propolis creates the
   invitation to the organisation, with the guest standing. The chat adds the person to the channel
   when Propolis announces the invitation was accepted.
7. **Instance settings** (`admin/settings`). Each service has its own administration settings. The
   web push key pair goes to the hub.
8. **What the instance can do** (`instance`). Replaced by the installer's manifest and each service's
   `/.well-known/ruchoir-product` (ADR 0004).
9. **Imports** (`imports`). Undecided, with the importer.

## Consequences

- A route keeps its path under `/api/v1/`, on its service's subdomain. Each contract starts from
  today's schemas, without renaming them.
- A schema used by several families follows the service that produces it. The others refer to its
  published contract, never to a copy.
