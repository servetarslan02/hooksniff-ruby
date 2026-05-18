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
end
