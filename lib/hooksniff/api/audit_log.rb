# frozen_string_literal: true

module HookSniff
  class AuditLog
    def initialize(client)
      @client = client
    end

    def list(params = {})
      @client.execute_request("GET", "/v1/audit-log", query_params: params)
    end

    def get(id)
      @client.execute_request("GET", "/v1/audit-log/#{id}")
    end
  end
end
