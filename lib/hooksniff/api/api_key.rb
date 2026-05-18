# frozen_string_literal: true

module HookSniff
  class ApiKey
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/api-keys")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/api-keys", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/api-keys/#{id}")
      nil
    end

    def rotate(id)
      @client.execute_request("POST", "/v1/api-keys/#{id}/rotate")
    end
  end
end
