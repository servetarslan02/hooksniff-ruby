# frozen_string_literal: true

module HookSniff
  class CustomDomain
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/custom-domains")
    end

    def add(attrs)
      @client.execute_request("POST", "/v1/custom-domains", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/custom-domains/#{id}")
      nil
    end

    def verify(id)
      @client.execute_request("POST", "/v1/custom-domains/#{id}/verify")
    end
  end
end
