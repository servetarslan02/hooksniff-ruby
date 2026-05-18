# frozen_string_literal: true

require "hooksniff/version"
require "hooksniff/hooksniff_http_client"
require "hooksniff/api_error"
require "hooksniff/errors"
require "hooksniff/util"
require "hooksniff/webhook_event"
require "hooksniff/webhook"

# Original resources
require "hooksniff/api/authentication"
require "hooksniff/api/endpoint"
require "hooksniff/api/event_type"
require "hooksniff/api/health"
require "hooksniff/api/message"
require "hooksniff/api/message_attempt"
require "hooksniff/api/statistics"

# Faz 8-15 resources
require "hooksniff/api/environment"
require "hooksniff/api/background_task"
require "hooksniff/api/operational_webhook"
require "hooksniff/api/message_poller"
require "hooksniff/api/inbound"
require "hooksniff/api/connector"
require "hooksniff/api/integration"
require "hooksniff/api/stream"

# Additional resources
require "hooksniff/api/application"
require "hooksniff/api/api_key"
require "hooksniff/api/search"
require "hooksniff/api/alert"
require "hooksniff/api/analytics"
require "hooksniff/api/billing"
require "hooksniff/api/portal"
require "hooksniff/api/team"
require "hooksniff/api/notification"
require "hooksniff/api/sso"
require "hooksniff/api/audit_log"
require "hooksniff/api/custom_domain"
require "hooksniff/api/rate_limit"
require "hooksniff/api/routing"
require "hooksniff/api/template"
require "hooksniff/api/schema"
require "hooksniff/api/playground"
require "hooksniff/api/service_token"

module HookSniff
  class HookSniffOptions
    attr_accessor :debug
    attr_accessor :server_url

    def initialize(debug = false, server_url = nil)
      @debug = debug
      @server_url = server_url
    end
  end

  class Client
    # Original resources
    attr_accessor :authentication
    attr_accessor :endpoint
    attr_accessor :event_type
    attr_accessor :health
    attr_accessor :message
    attr_accessor :message_attempt
    attr_accessor :statistics

    # Faz 8-15 resources
    attr_accessor :environment
    attr_accessor :background_task
    attr_accessor :operational_webhook
    attr_accessor :message_poller
    attr_accessor :inbound
    attr_accessor :connector
    attr_accessor :integration
    attr_accessor :stream

    # Additional resources
    attr_accessor :application
    attr_accessor :api_key
    attr_accessor :search
    attr_accessor :alert
    attr_accessor :analytics
    attr_accessor :billing
    attr_accessor :portal
    attr_accessor :team
    attr_accessor :notification
    attr_accessor :sso
    attr_accessor :audit_log
    attr_accessor :custom_domain
    attr_accessor :rate_limit
    attr_accessor :routing
    attr_accessor :template
    attr_accessor :schema
    attr_accessor :playground
    attr_accessor :service_token

    def initialize(auth_token, options = HookSniffOptions.new)
      uri = URI(options.server_url || "https://hooksniff-api-1046140057667.europe-west1.run.app")
      api_client = HookSniffHttpClient.new(auth_token, uri)

      # Original
      @authentication = Authentication.new(api_client)
      @endpoint = Endpoint.new(api_client)
      @event_type = EventType.new(api_client)
      @health = Health.new(api_client)
      @message = Message.new(api_client)
      @message_attempt = MessageAttempt.new(api_client)
      @statistics = Statistics.new(api_client)

      # Faz 8-15
      @environment = Environment.new(api_client)
      @background_task = BackgroundTask.new(api_client)
      @operational_webhook = OperationalWebhook.new(api_client)
      @message_poller = MessagePoller.new(api_client)
      @inbound = Inbound.new(api_client)
      @connector = Connector.new(api_client)
      @integration = IntegrationApi.new(api_client)
      @stream = StreamApi.new(api_client)

      # Additional
      @application = Application.new(api_client)
      @api_key = ApiKey.new(api_client)
      @search = Search.new(api_client)
      @alert = Alert.new(api_client)
      @analytics = Analytics.new(api_client)
      @billing = Billing.new(api_client)
      @portal = Portal.new(api_client)
      @team = Team.new(api_client)
      @notification = Notification.new(api_client)
      @sso = Sso.new(api_client)
      @audit_log = AuditLog.new(api_client)
      @custom_domain = CustomDomain.new(api_client)
      @rate_limit = RateLimit.new(api_client)
      @routing = Routing.new(api_client)
      @template = Template.new(api_client)
      @schema = Schema.new(api_client)
      @playground = Playground.new(api_client)
      @service_token = ServiceToken.new(api_client)
    end
  end
end
