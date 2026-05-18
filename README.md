# HookSniff Ruby SDK

<p align="center">
  <a href="https://github.com/servetarslan02/HookSniff"><img src="https://img.shields.io/github/license/servetarslan02/HookSniff" alt="License"></a>
  <a href="https://rubygems.org/gems/hooksniff"><img src="https://img.shields.io/gems/v/hooksniff" alt="Gem"></a>
</p>

Ruby SDK for the [HookSniff](https://hooksniff.vercel.app) webhook delivery platform.

## Installation

```bash
gem install hooksniff
```

## Quick Start

```ruby
require "hooksniff"

client = HookSniff::Client.new("hs_xxx")

# List endpoints
endpoints = client.endpoint.list

# Create a message
msg = client.message.create(event_type: "order.created", payload: { order_id: "123" })

# Verify webhook signature
wh = HookSniff::Webhook.new("whsec_xxx")
payload = wh.verify(body, headers)
```

## Resources (30+)

| Resource | Description |
|----------|-------------|
| **Endpoint** | CRUD, secret rotation, headers |
| **Message** | Create, list, get |
| **MessageAttempt** | List by endpoint/msg, get, resend |
| **Authentication** | Logout |
| **EventType** | CRUD |
| **Statistics** | Aggregate stats |
| **Health** | API health check |
| **Environment** | Environment & variable management (Faz 8) |
| **BackgroundTask** | List, get, cancel (Faz 9) |
| **OperationalWebhook** | Endpoint & delivery management (Faz 10) |
| **MessagePoller** | Poll, seek, commit (Faz 11) |
| **Inbound** | Inbound webhook configs (Faz 12) |
| **Connector** | Connector & config management (Faz 13) |
| **Integration** | CRUD, test, events, stats (Faz 14) |
| **Stream** | Channels, subscriptions, publish (Faz 15) |
| **Application** | Application management |
| **ApiKey** | API key CRUD, rotate |
| **Search** | Full-text delivery search |
| **Alert** | Alert rule CRUD, test |
| **Analytics** | Delivery trends, success rate, latency |
| **Billing** | Subscription, usage, invoices, portal |
| **Portal** | Profile, plan, notifications |
| **Team** | Teams, invites, members, roles |
| **Notification** | List, read, unread count |
| **Sso** | SSO config management |
| **AuditLog** | Audit entry listing |
| **CustomDomain** | Domain management, verification |
| **RateLimit** | Per-endpoint rate limits |
| **Routing** | Routing rules, endpoint health |
| **Template** | Template listing, apply |
| **Schema** | Schema registry, validation |
| **Playground** | Test webhooks |
| **ServiceToken** | Service token management |

## Links

- [Documentation](https://hooksniff.vercel.app/docs)
- [API Reference](https://hooksniff-api-1046140057667.europe-west1.run.app)
- [GitHub](https://github.com/servetarslan02/HookSniff)
