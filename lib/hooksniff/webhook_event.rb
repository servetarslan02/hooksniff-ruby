# frozen_string_literal: true

module HookSniff
  # Represents a parsed webhook event from HookSniff.
  #
  # @example
  #   event = wh.verify(raw_body, headers)
  #   puts event.event        # "endpoint.created"
  #   puts event.data         # {"endpoint_id" => "ep_123", ...}
  #   puts event.timestamp    # "2026-05-19T02:33:00Z"
  class WebhookEvent
    # @return [String] event type name (e.g., "endpoint.created")
    attr_reader :event

    # @return [Hash] event payload data
    attr_reader :data

    # @return [String] ISO 8601 timestamp string
    attr_reader :timestamp

    def initialize(event:, data:, timestamp:)
      @event = event
      @data = data
      @timestamp = timestamp
    end

    # Alias for +event+ — the event type name.
    # @return [String]
    def event_type
      @event
    end

    # Get a value from the data hash.
    # @param key [String, Symbol]
    # @return [Object, nil]
    def get(key)
      @data[key.to_s] || @data[key.to_sym]
    end

    # Access data hash values with bracket notation.
    # @param key [String, Symbol]
    # @return [Object]
    def [](key)
      @data[key.to_s] || @data[key.to_sym]
    end

    # Check if key exists in data hash.
    # @param key [String, Symbol]
    # @return [Boolean]
    def key?(key)
      @data.key?(key.to_s) || @data.key?(key.to_sym)
    end

    def to_s
      "#<WebhookEvent event=#{@event} timestamp=#{@timestamp}>"
    end

    def inspect
      to_s
    end

    # Map of known event types to their classes
    EVENT_TYPE_MAP = {
      "endpoint.created" => WebhookEvent,
      "endpoint.updated" => WebhookEvent,
      "endpoint.deleted" => WebhookEvent,
      "endpoint.enabled" => WebhookEvent,
      "endpoint.disabled" => WebhookEvent,
      "message.attempt.exhausted" => WebhookEvent,
      "message.attempt.failing" => WebhookEvent,
      "message.attempt.recovered" => WebhookEvent,
    }.freeze

    # Parse a webhook payload hash into a WebhookEvent.
    # @param data [Hash] parsed JSON payload with 'event', 'data', 'timestamp' keys
    # @return [WebhookEvent]
    def self.parse(data)
      event_type = data[:event] || data["event"] || data[:eventType] || data["eventType"] || ""
      event_data = data[:data] || data["data"] || {}
      timestamp = data[:timestamp] || data["timestamp"] || ""

      new(event: event_type, data: event_data, timestamp: timestamp)
    end
  end
end
