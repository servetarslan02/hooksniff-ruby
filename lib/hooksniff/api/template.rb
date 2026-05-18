# frozen_string_literal: true

module HookSniff
  class Template
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/templates")
    end

    def get(id)
      @client.execute_request("GET", "/v1/templates/#{id}")
    end

    def apply(id, attrs)
      @client.execute_request("POST", "/v1/templates/#{id}/apply", body: attrs)
    end
  end
end
