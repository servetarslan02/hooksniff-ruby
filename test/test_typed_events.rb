# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/hooksniff/webhook_event"

class TypedWebhookEventTest < Minitest::Test
  def test_endpoint_created
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a1", endpointId: "e1", appUid: "u1" },
      timestamp: "2026-05-19"
    )
    assert_instance_of HookSniff::EndpointCreatedEvent, event
    assert_instance_of HookSniff::EndpointCreatedEventData, event.data
    assert_equal "a1", event.data.app_id
    assert_equal "e1", event.data.endpoint_id
    assert_equal "u1", event.data.app_uid
  end

  def test_endpoint_disabled
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.disabled",
      data: { appId: "a1", endpointId: "e1", failSince: "2026-01", trigger: "repeated-failure" },
      timestamp: ""
    )
    assert_instance_of HookSniff::EndpointDisabledEvent, event
    assert_equal "2026-01", event.data.fail_since
    assert_equal "repeated-failure", event.data.trigger
  end

  def test_message_attempt_exhausted
    event = HookSniff::WebhookEvent.parse(
      event: "message.attempt.exhausted",
      data: { appId: "a1", msgId: "m1", lastAttempt: { id: "att", timestamp: "t", responseStatusCode: 500 } },
      timestamp: ""
    )
    assert_instance_of HookSniff::MessageAttemptExhaustedEvent, event
    assert_equal "m1", event.data.msg_id
    assert_equal 500, event.data.last_attempt.response_status_code
  end

  def test_message_attempt_failing
    event = HookSniff::WebhookEvent.parse(
      event: "message.attempt.failing",
      data: { appId: "a1", msgId: "m1", attempt: { id: "att", timestamp: "t", responseStatusCode: 429 } },
      timestamp: ""
    )
    assert_instance_of HookSniff::MessageAttemptFailingEvent, event
    assert_equal 429, event.data.attempt.response_status_code
  end

  def test_message_attempt_recovered
    event = HookSniff::WebhookEvent.parse(
      event: "message.attempt.recovered",
      data: { appId: "a1", msgId: "m1", attempt: { id: "att", timestamp: "t", responseStatusCode: 200 } },
      timestamp: ""
    )
    assert_instance_of HookSniff::MessageAttemptRecoveredEvent, event
  end

  def test_unknown_event_fallback
    event = HookSniff::WebhookEvent.parse(
      event: "custom.unknown",
      data: { x: 1 },
      timestamp: ""
    )
    assert_instance_of HookSniff::WebhookEvent, event
    assert_equal 1, event.data[:x]
  end

  def test_backward_compat_get
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a1", endpointId: "e1" },
      timestamp: "t"
    )
    assert_equal "a1", event.get("app_id")
    assert_equal "a1", event["app_id"]
    assert event.key?("app_id")
    assert_equal "endpoint.created", event.event_type
  end

  def test_snake_case_fields
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { app_id: "a1", endpoint_id: "e1" },
      timestamp: ""
    )
    assert_equal "a1", event.data.app_id
    assert_equal "e1", event.data.endpoint_id
  end

  def test_empty_data
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: {},
      timestamp: ""
    )
    assert_equal "", event.data.app_id
  end

  def test_missing_data
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      timestamp: ""
    )
    assert_equal "", event.data.app_id
  end

  def test_unknown_event_keeps_raw_data
    event = HookSniff::WebhookEvent.parse(
      event: "custom.unknown",
      data: { "x" => 1 },
      timestamp: ""
    )
    assert_instance_of HookSniff::WebhookEvent, event
    assert_equal 1, event.get("x")
  end

  def test_unicode_data
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "ünïcödé", endpointId: "日本語" },
      timestamp: ""
    )
    assert_equal "ünïcödé", event.data.app_id
    assert_equal "日本語", event.data.endpoint_id
  end

  def test_event_type_map_count
    assert_equal 10, HookSniff::WebhookEvent::EVENT_TYPE_MAP.size
  end

  def test_endpoint_updated
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.updated",
      data: { appId: "a1", endpointId: "e1" },
      timestamp: ""
    )
    assert_instance_of HookSniff::EndpointUpdatedEvent, event
  end

  def test_endpoint_deleted
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.deleted",
      data: { appId: "a1", endpointId: "e1" },
      timestamp: ""
    )
    assert_instance_of HookSniff::EndpointDeletedEvent, event
  end

  def test_endpoint_enabled
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.enabled",
      data: { appId: "a1", endpointId: "e1" },
      timestamp: ""
    )
    assert_instance_of HookSniff::EndpointEnabledEvent, event
  end

  def test_unicode_data
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "ünïcödé", endpointId: "日本語" },
      timestamp: ""
    )
    assert_equal "ünïcödé", event.data.app_id
    assert_equal "日本語", event.data.endpoint_id
  end

  def test_large_data
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a" * 10000, endpointId: "e" * 10000 },
      timestamp: ""
    )
    assert_equal 10000, event.data.app_id.length
  end

  def test_special_characters
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a@b.c", endpointId: "e#1" },
      timestamp: ""
    )
    assert_equal "a@b.c", event.data.app_id
  end

  def test_trigger_none
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.disabled",
      data: { appId: "a", endpointId: "e", trigger: "none" },
      timestamp: ""
    )
    assert_equal "none", event.data.trigger
  end

  def test_trigger_first_failure
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.disabled",
      data: { appId: "a", endpointId: "e", trigger: "first-failure" },
      timestamp: ""
    )
    assert_equal "first-failure", event.data.trigger
  end

  def test_all_event_types
    %w[endpoint.created endpoint.updated endpoint.deleted endpoint.enabled endpoint.disabled
       message.attempt.exhausted message.attempt.failing message.attempt.recovered].each do |et|
      event = HookSniff::WebhookEvent.parse(event: et, data: { appId: "a" }, timestamp: "")
      assert_equal et, event.event
    end
  end

  def test_get_with_symbol_key
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a1" },
      timestamp: ""
    )
    assert_equal "a1", event.get(:appId)
  end

  def test_bracket_with_symbol
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a1" },
      timestamp: ""
    )
    assert_equal "a1", event[:appId]
  end

  def test_key_with_symbol
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: { appId: "a1" },
      timestamp: ""
    )
    assert event.key?(:appId)
  end

  def test_to_s
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: {},
      timestamp: "2026-05-19"
    )
    assert_match(/EndpointCreatedEvent/, event.to_s)
    assert_match(/2026-05-19/, event.to_s)
  end

  def test_inspect
    event = HookSniff::WebhookEvent.parse(
      event: "endpoint.created",
      data: {},
      timestamp: "2026-05-19"
    )
    assert_equal event.to_s, event.inspect
  end
end
