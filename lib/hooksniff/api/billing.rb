# frozen_string_literal: true

module HookSniff
  class Billing
    def initialize(client)
      @client = client
    end

    def get_subscription
      @client.execute_request("GET", "/v1/billing/subscription")
    end

    def cancel_subscription
      @client.execute_request("DELETE", "/v1/billing/subscription")
      nil
    end

    def upgrade(attrs)
      @client.execute_request("POST", "/v1/billing/upgrade", body: attrs)
    end

    def open_portal
      @client.execute_request("POST", "/v1/billing/portal")
    end

    def get_usage
      @client.execute_request("GET", "/v1/billing/usage")
    end

    def get_invoices
      @client.execute_request("GET", "/v1/billing/invoices")
    end
  end
end
