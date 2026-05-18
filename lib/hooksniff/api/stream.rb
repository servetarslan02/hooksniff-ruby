# frozen_string_literal: true

module HookSniff
  class StreamApi
    def initialize(client)
      @client = client
    end

    def list_channels
      @client.request(:get, "/v1/stream/channels")
    end

    def get_channel(id)
      @client.request(:get, "/v1/stream/channels/#{id}")
    end

    def create_channel(attrs)
      @client.request(:post, "/v1/stream/channels", attrs)
    end

    def update_channel(id, attrs)
      @client.request(:put, "/v1/stream/channels/#{id}", attrs)
    end

    def delete_channel(id)
      @client.request(:delete, "/v1/stream/channels/#{id}")
    end

    def list_messages(id, params = {})
      @client.request(:get, "/v1/stream/channels/#{id}/messages", params)
    end

    def list_subscriptions
      @client.request(:get, "/v1/stream/subscriptions")
    end

    def disconnect_subscription(id)
      @client.request(:delete, "/v1/stream/subscriptions/#{id}")
    end

    def publish(body)
      @client.request(:post, "/v1/stream/publish", body)
    end
  end
end

    # Subscribe to real-time events via SSE
    # @param channel_id [String] Channel ID to subscribe to
    # @param block [Block] Callback for each event
    # @return [void]
    def subscribe(channel_id, &block)
      @client.request_stream(:get, "/v1/stream/channels/#{channel_id}/subscribe") do |event|
        block.call(event)
      end
    end

    # Subscribe to delivery events (legacy SSE endpoint)
    # @param block [Block] Callback for each event
    # @return [void]
    def subscribe_deliveries(&block)
      @client.request_stream(:get, "/v1/stream/deliveries") do |event|
        block.call(event)
      end
    end
