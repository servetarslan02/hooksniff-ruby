# frozen_string_literal: true

module HookSniff
  class Schema
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/schemas")
    end

    def get(id)
      @client.execute_request("GET", "/v1/schemas/#{id}")
    end

    def register(attrs)
      @client.execute_request("POST", "/v1/schemas", body: attrs)
    end

    def validate(id, attrs)
      @client.execute_request("POST", "/v1/schemas/#{id}/validate", body: attrs)
    end
  end
end
