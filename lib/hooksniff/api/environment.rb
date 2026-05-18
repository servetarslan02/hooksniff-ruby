# frozen_string_literal: true

module HookSniff
  class Environment
    def initialize(client)
      @client = client
    end

    def list(params = {})
      @client.execute_request("GET", "/v1/environments", query_params: params)
    end

    def get(id)
      @client.execute_request("GET", "/v1/environments/#{id}")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/environments", body: attrs)
    end

    def update(id, attrs)
      @client.execute_request("PUT", "/v1/environments/#{id}", body: attrs)
    end

    def delete(id)
      @client.execute_request("DELETE", "/v1/environments/#{id}")
      nil
    end

    def list_variables(env_id)
      @client.execute_request("GET", "/v1/environments/#{env_id}/variables")
    end

    def create_variable(env_id, attrs)
      @client.execute_request("POST", "/v1/environments/#{env_id}/variables", body: attrs)
    end

    def update_variable(env_id, var_id, attrs)
      @client.execute_request("PUT", "/v1/environments/#{env_id}/variables/#{var_id}", body: attrs)
    end

    def delete_variable(env_id, var_id)
      @client.execute_request("DELETE", "/v1/environments/#{env_id}/variables/#{var_id}")
      nil
    end
  end
end
