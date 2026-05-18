# frozen_string_literal: true

module HookSniff
  class Alert
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/alerts")
    end

    def get(id)
      @client.execute_request("GET", "/v1/alerts/#{id}")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/alerts", body: attrs)
    end

    def update(id, attrs)
      @client.execute_request("PUT", "/v1/alerts/#{id}", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/alerts/#{id}")
      nil
    end

    def test(id)
      @client.execute_request("POST", "/v1/alerts/#{id}/test")
    end
  end
end
