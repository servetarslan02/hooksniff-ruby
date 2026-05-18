# frozen_string_literal: true

module HookSniff
  # Response metadata from the last API request.
  #
  # Access via +client.last_response+ after any API call.
  #
  # @example
  #   endpoints = client.endpoint.list
  #   puts client.last_response.request_id
  #   puts client.last_response.rate_limit_remaining
  class ResponseMetadata
    # @return [Integer] HTTP status code
    attr_reader :status_code

    # @return [String, nil] x-request-id header
    attr_reader :request_id

    # @return [Integer, nil] x-ratelimit-remaining header
    attr_reader :rate_limit_remaining

    # @return [Integer, nil] x-ratelimit-reset header (Unix timestamp)
    attr_reader :rate_limit_reset

    # @return [Hash] All response headers
    attr_reader :headers

    def initialize(status_code:, request_id: nil, rate_limit_remaining: nil, rate_limit_reset: nil, headers: {})
      @status_code = status_code
      @request_id = request_id
      @rate_limit_remaining = rate_limit_remaining
      @rate_limit_reset = rate_limit_reset
      @headers = headers
    end

    # Create from a Net::HTTP response.
    def self.from_http_response(response)
      headers = response.to_hash.transform_values { |v| v.is_a?(Array) ? v.first : v }
      new(
        status_code: response.code.to_i,
        request_id: headers["x-request-id"],
        rate_limit_remaining: headers["x-ratelimit-remaining"]&.to_i,
        rate_limit_reset: headers["x-ratelimit-reset"]&.to_i,
        headers: headers
      )
    end
  end
end
