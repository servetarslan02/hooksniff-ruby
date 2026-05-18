# frozen_string_literal: true

module HookSniff
  class Search
    def initialize(client)
      @client = client
    end

    def search(params = {})
      @client.execute_request("GET", "/v1/search", query_params: params)
    end
  end
end
