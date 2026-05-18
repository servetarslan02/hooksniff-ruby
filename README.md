# HookSniff Ruby SDK

<p align="center">
  <a href="https://rubygems.org/gems/hooksniff"><img src="https://img.shields.io/gem/v/hooksniff.svg" alt="Gem"></a>
  <a href="https://github.com/servetarslan02/hooksniff-ruby"><img src="https://img.shields.io/github/license/servetarslan02/hooksniff-ruby" alt="License"></a>
</p>

Ruby SDK for the [HookSniff](https://hooksniff.vercel.app) webhook delivery platform.

## Installation

```ruby
gem 'hooksniff'
```

```bash
gem install hooksniff
```

## Quick Start

```ruby
require 'hooksniff'

hs = HookSniff::Client.new('hooksniff_xxx')

# List endpoints
endpoints = hs.endpoints.list

# Send a webhook
delivery = hs.messages.create(
  endpoint_id: 'ep_xxx',
  event: 'order.created',
  data: { order_id: '123', amount: 99.99 }
)
```

## Webhook Verification

```ruby
wh = HookSniff::Webhook.new('whsec_xxx')
payload = wh.verify(body, headers)
```

## API Resources

| Resource | Methods |
|----------|---------|
| Endpoints | list, create, get, update, delete, rotate_secret |
| Messages | create, list, get |
| MessageAttempts | list, get, resend, list_by_msg |
| EventTypes | list, create, get, update, delete |
| Stream | list_channels, get_channel, create_channel, subscribe, publish |
| Authentication | login, register, logout |
| BackgroundTasks | list, get |
| Connectors | list, get |
| Integrations | list, get, create, update, delete |
| Inbound | list, create, get, delete |

## Features

- ✅ HMAC-SHA256 webhook verification
- ✅ Typed webhook events
- ✅ Automatic retry with exponential backoff
- ✅ Pagination helpers
- ✅ Rate limit header parsing
- ✅ SSE streaming
- ✅ Idempotency keys

## License

MIT
