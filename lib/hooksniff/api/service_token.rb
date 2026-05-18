# frozen_string_literal: true

module HookSniff
  class ServiceToken
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/service-tokens")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/service-tokens", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/service-tokens/#{id}")
      nil
    end
  end
end
