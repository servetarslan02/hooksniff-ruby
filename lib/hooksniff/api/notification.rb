# frozen_string_literal: true

module HookSniff
  class Notification
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/notifications")
    end

    def unread_count
      @client.execute_request("GET", "/v1/notifications/unread-count")
    end

    def mark_all_read
      @client.execute_request("PUT", "/v1/notifications/read-all")
    end

    def mark_read(id)
      @client.execute_request("PUT", "/v1/notifications/#{id}/read")
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/notifications/#{id}")
      nil
    end
  end
end
