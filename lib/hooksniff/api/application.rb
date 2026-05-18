# frozen_string_literal: true

module HookSniff
  class Application
    def initialize(client)
      @client = client
    end

    def list(params = {})
      @client.execute_request("GET", "/v1/applications", query_params: params)
    end

    def get(id)
      @client.execute_request("GET", "/v1/applications/#{id}")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/applications", body: attrs)
    end

    def update(id, attrs)
      @client.execute_request("PUT", "/v1/applications/#{id}", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/applications/#{id}")
      nil
    end
  end
end
