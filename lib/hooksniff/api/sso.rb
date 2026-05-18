# frozen_string_literal: true

module HookSniff
  class Sso
    def initialize(client)
      @client = client
    end

    def get_config
      @client.execute_request("GET", "/v1/sso/config")
    end

    def upsert_config(attrs)
      @client.execute_request("POST", "/v1/sso/config", body: attrs)
    end

    def delete_config
      @client.execute_request("DELETE", "/v1/sso/config")
      nil
    end

    def test
      @client.execute_request("POST", "/v1/sso/test")
    end
  end
end
