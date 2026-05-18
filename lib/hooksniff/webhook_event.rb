# frozen_string_literal: true

module HookSniff
  # ─── Event Data Classes ─────────────────────────────────────────

  # Data payload for endpoint.created events.
  class EndpointCreatedEventData
    attr_reader :app_id, :endpoint_id, :app_uid

    def initialize(app_id:, endpoint_id:, app_uid: nil)
      @app_id = app_id
      @endpoint_id = endpoint_id
      @app_uid = app_uid
    end
  end

  # Data payload for endpoint.updated events.
  class EndpointUpdatedEventData
    attr_reader :app_id, :endpoint_id, :app_uid

    def initialize(app_id:, endpoint_id:, app_uid: nil)
      @app_id = app_id
      @endpoint_id = endpoint_id
      @app_uid = app_uid
    end
  end

  # Data payload for endpoint.deleted events.
  class EndpointDeletedEventData
    attr_reader :app_id, :endpoint_id, :app_uid

    def initialize(app_id:, endpoint_id:, app_uid: nil)
      @app_id = app_id
      @endpoint_id = endpoint_id
      @app_uid = app_uid
    end
  end

  # Data payload for endpoint.enabled events.
  class EndpointEnabledEventData
    attr_reader :app_id, :endpoint_id, :app_uid

    def initialize(app_id:, endpoint_id:, app_uid: nil)
      @app_id = app_id
      @endpoint_id = endpoint_id
      @app_uid = app_uid
    end
  end

  # Data payload for endpoint.disabled events.
  class EndpointDisabledEventData
    attr_reader :app_id, :endpoint_id, :app_uid, :fail_since, :trigger

    def initialize(app_id:, endpoint_id:, app_uid: nil, fail_since: nil, trigger: nil)
      @app_id = app_id
      @endpoint_id = endpoint_id
      @app_uid = app_uid
      @fail_since = fail_since
      @trigger = trigger
    end
  end

  # Info about the last delivery attempt.
  class LastAttemptInfo
    attr_reader :id, :timestamp, :response_status_code

    def initialize(id:, timestamp:, response_status_code:)
      @id = id
      @timestamp = timestamp
      @response_status_code = response_status_code
    end
  end

  # Info about a delivery attempt.
  class AttemptInfo
    attr_reader :id, :timestamp, :response_status_code

    def initialize(id:, timestamp:, response_status_code:)
      @id = id
      @timestamp = timestamp
      @response_status_code = response_status_code
    end
  end

  # Data payload for message.attempt.exhausted events.
  class MessageAttemptExhaustedEventData
    attr_reader :app_id, :msg_id, :last_attempt, :app_uid

    def initialize(app_id:, msg_id:, last_attempt:, app_uid: nil)
      @app_id = app_id
      @msg_id = msg_id
      @last_attempt = last_attempt
      @app_uid = app_uid
    end
  end

  # Data payload for message.attempt.failing events.
  class MessageAttemptFailingEventData
    attr_reader :app_id, :msg_id, :attempt, :app_uid

    def initialize(app_id:, msg_id:, attempt:, app_uid: nil)
      @app_id = app_id
      @msg_id = msg_id
      @attempt = attempt
      @app_uid = app_uid
    end
  end

  # Data payload for message.attempt.recovered events.
  class MessageAttemptRecoveredEventData
    attr_reader :app_id, :msg_id, :attempt, :app_uid

    def initialize(app_id:, msg_id:, attempt:, app_uid: nil)
      @app_id = app_id
      @msg_id = msg_id
      @attempt = attempt
      @app_uid = app_uid
    end
  end

  # ─── WebhookEvent (base class — must come before subclasses) ────

  # Represents a parsed webhook event from HookSniff.
  class WebhookEvent
    # @return [String] event type name (e.g., "endpoint.created")
    attr_reader :event

    # @return [Object] event payload data (typed data class or Hash)
    attr_reader :data

    # @return [String] ISO 8601 timestamp string
    attr_reader :timestamp

    def initialize(event:, data:, timestamp:)
      @event = event
      @data = data
      @timestamp = timestamp
    end

    # Alias for +event+ — the event type name.
    def event_type
      @event
    end

    # Get a value from the data (Hash or typed object).
    def get(key)
      if @data.is_a?(Hash)
        @data[key.to_s] || @data[key.to_sym]
      else
        @data.respond_to?(key.to_sym) ? @data.send(key.to_sym) : nil
      end
    end

    # Access data values with bracket notation (backward compat).
    def [](key)
      get(key)
    end

    # Check if key exists in data.
    def key?(key)
      if @data.is_a?(Hash)
        @data.key?(key.to_s) || @data.key?(key.to_sym)
      else
        @data.respond_to?(key.to_sym)
      end
    end

    def to_s
      "#<#{self.class.name} event=#{@event} timestamp=#{@timestamp}>"
    end

    def inspect
      to_s
    end

    # Map of known event types to their classes
    EVENT_TYPE_MAP = {
      "endpoint.created" => "EndpointCreatedEvent",
      "endpoint.updated" => "EndpointUpdatedEvent",
      "endpoint.deleted" => "EndpointDeletedEvent",
      "endpoint.enabled" => "EndpointEnabledEvent",
      "endpoint.disabled" => "EndpointDisabledEvent",
      "message.attempt.exhausted" => "MessageAttemptExhaustedEvent",
      "message.attempt.failing" => "MessageAttemptFailingEvent",
      "message.atattempt.failing" => "MessageAttemptFailingEvent",
      "message.attempt.recovered" => "MessageAttemptRecoveredEvent",
      "message.atattempt.recovered" => "MessageAttemptRecoveredEvent",
    }.freeze

    # Parse a webhook payload hash into a typed WebhookEvent.
    def self.parse(data)
      event_type = data[:event] || data["event"] || data[:eventType] || data["eventType"] || ""
      raw_data = data[:data] || data["data"] || {}
      timestamp = data[:timestamp] || data["timestamp"] || ""

      parsed_data = parse_event_data(event_type, raw_data)
      class_name = EVENT_TYPE_MAP[event_type]
      event_class = class_name ? const_get(class_name) : WebhookEvent

      event_class.new(event: event_type, data: parsed_data, timestamp: timestamp)
    end

    private

    def self.parse_event_data(event_type, raw)
      case event_type
      when "endpoint.created"
        EndpointCreatedEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          endpoint_id: raw[:endpointId] || raw["endpointId"] || raw[:endpoint_id] || raw["endpoint_id"] || "",
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "endpoint.updated"
        EndpointUpdatedEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          endpoint_id: raw[:endpointId] || raw["endpointId"] || raw[:endpoint_id] || raw["endpoint_id"] || "",
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "endpoint.deleted"
        EndpointDeletedEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          endpoint_id: raw[:endpointId] || raw["endpointId"] || raw[:endpoint_id] || raw["endpoint_id"] || "",
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "endpoint.enabled"
        EndpointEnabledEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          endpoint_id: raw[:endpointId] || raw["endpointId"] || raw[:endpoint_id] || raw["endpoint_id"] || "",
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "endpoint.disabled"
        EndpointDisabledEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          endpoint_id: raw[:endpointId] || raw["endpointId"] || raw[:endpoint_id] || raw["endpoint_id"] || "",
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"],
          fail_since: raw[:failSince] || raw["failSince"] || raw[:fail_since] || raw["fail_since"],
          trigger: raw[:trigger] || raw["trigger"]
        )
      when "message.attempt.exhausted"
        last_raw = raw[:lastAttempt] || raw["lastAttempt"] || raw[:last_attempt] || raw["last_attempt"] || {}
        MessageAttemptExhaustedEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          msg_id: raw[:msgId] || raw["msgId"] || raw[:msg_id] || raw["msg_id"] || "",
          last_attempt: parse_last_attempt(last_raw),
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "message.attempt.failing", "message.atattempt.failing"
        attempt_raw = raw[:attempt] || raw["attempt"] || {}
        MessageAttemptFailingEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          msg_id: raw[:msgId] || raw["msgId"] || raw[:msg_id] || raw["msg_id"] || "",
          attempt: parse_attempt(attempt_raw),
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      when "message.atattempt.recovered", "message.attempt.recovered"
        attempt_raw = raw[:attempt] || raw["attempt"] || {}
        MessageAttemptRecoveredEventData.new(
          app_id: raw[:appId] || raw["appId"] || raw[:app_id] || raw["app_id"] || "",
          msg_id: raw[:msgId] || raw["msgId"] || raw[:msg_id] || raw["msg_id"] || "",
          attempt: parse_attempt(attempt_raw),
          app_uid: raw[:appUid] || raw["appUid"] || raw[:app_uid] || raw["app_uid"]
        )
      else
        raw
      end
    end

    def self.parse_last_attempt(raw)
      LastAttemptInfo.new(
        id: raw[:id] || raw["id"] || "",
        timestamp: raw[:timestamp] || raw["timestamp"] || "",
        response_status_code: raw[:responseStatusCode] || raw["responseStatusCode"] || raw[:response_status_code] || raw["response_status_code"] || 0
      )
    end

    def self.parse_attempt(raw)
      AttemptInfo.new(
        id: raw[:id] || raw["id"] || "",
        timestamp: raw[:timestamp] || raw["timestamp"] || "",
        response_status_code: raw[:responseStatusCode] || raw["responseStatusCode"] || raw[:response_status_code] || raw["response_status_code"] || 0
      )
    end
  end

  # ─── Typed Event Subclasses ─────────────────────────────────────

  class EndpointCreatedEvent < WebhookEvent; end
  class EndpointUpdatedEvent < WebhookEvent; end
  class EndpointDeletedEvent < WebhookEvent; end
  class EndpointEnabledEvent < WebhookEvent; end
  class EndpointDisabledEvent < WebhookEvent; end
  class MessageAttemptExhaustedEvent < WebhookEvent; end
  class MessageAttemptFailingEvent < WebhookEvent; end
  class MessageAttemptRecoveredEvent < WebhookEvent; end
end
