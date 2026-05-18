# frozen_string_literal: true

module HookSniff
  class Portal
    def initialize(client)
      @client = client
    end

    def get_profile
      @client.execute_request("GET", "/v1/portal/me")
    end

    def update_profile(attrs)
      @client.execute_request("PUT", "/v1/portal/me", body: attrs)
    end

    def get_usage
      @client.execute_request("GET", "/v1/portal/usage")
    end

    def get_plan
      @client.execute_request("GET", "/v1/portal/plan")
    end

    def get_notifications
      @client.execute_request("GET", "/v1/portal/notifications")
    end

    def update_notifications(attrs)
      @client.execute_request("PUT", "/v1/portal/notifications", body: attrs)
    end
  end
end
