# frozen_string_literal: true

module HookSniff
  class Playground
    def initialize(client)
      @client = client
    end

    def get
      @client.execute_request("GET", "/v1/playground")
    end

    def test(attrs)
      @client.execute_request("POST", "/v1/playground/test", body: attrs)
    end
  end
end
