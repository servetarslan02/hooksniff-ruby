# frozen_string_literal: true

require "net/http"

module HookSniff
  class Authentication
    def initialize(client)
      @client = client
    end

    def logout(options = {})
      options = options.transform_keys(&:to_s)
      @client.execute_request(
        "POST",
        "/v1/auth/logout",
        headers: {
          "idempotency-key" => options["idempotency-key"]
        }
      )
      nil
    end
  end
end
