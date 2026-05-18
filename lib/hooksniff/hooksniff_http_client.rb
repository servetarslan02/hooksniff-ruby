# frozen_string_literal: true
require "cgi"
require "uri"
require "net/http"
require "securerandom"


module HookSniff
  class HookSniffHttpClient
    def initialize(token, base_url)
      @token = token
      @base_url = base_url
    end

    def execute_request(method, path, **kwargs)
      query_params = kwargs[:query_params] || {}
      headers = kwargs[:headers] || {}
      body = kwargs[:body] || {}

      uri = URI("#{@base_url}#{path}")
      encoded_query = encode_query_params(query_params)
      if encoded_query != ""
        uri.query = encoded_query
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")

      # Dynamically select the request class based on method
      request_class = case method.to_s.upcase
      when "GET"
        Net::HTTP::Get
      when "POST"
        Net::HTTP::Post
      when "PUT"
        Net::HTTP::Put
      when "DELETE"
        Net::HTTP::Delete
      when "PATCH"
        Net::HTTP::Patch
      when "HEAD"
        Net::HTTP::Head
      else
        raise ArgumentError, "Unsupported HTTP method: #{method}"
      end

      # Create request object
      request = request_class.new(uri.request_uri)
      request["Authorization"] = "Bearer #{@token}"
      request["User-Agent"] = "hooksniff-libs/#{VERSION}/ruby"
      request["hooksniff-req-id"] = rand(0...(2 ** 64))

      # Add headers
      headers.each { |key, value| request[key] = value }

      # Check if idempotency-key header already exists
      if !request.key?("idempotency-key") && method.to_s.upcase == "POST"
        request["idempotency-key"] = "auto_" + SecureRandom.uuid.to_s
      end

      # Add body for non-GET requests
      if %w[POST PUT PATCH].include?(method.to_s.upcase) && !body.nil?
        request.body = body.to_json
        request["Content-Type"] = "application/json"
      end

      res = execute_request_with_retries(request, http)

      # Execute request
      if Integer(res.code) == 204
        nil
      elsif Integer(res.code) >= 200 && Integer(res.code) <= 299
        JSON.parse(res.body)
      else
        fail(
          ApiError.new(
            :code => Integer(res.code),
            :response_headers => res.each_header.to_h,
            :response_body => res.body
          )
        )
      end
    end

    private def execute_request_with_retries(request, http)
      res = nil
      retries = [1, 2, 4] # seconds: 1s, 2s, 4s exponential backoff
      max_retries = retries.length

      retries.each_with_index do |sleep_duration, index|
        begin
          res = http.request(request)
        rescue Net::OpenTimeout, Net::ReadTimeout, Net::WriteTimeout, Timeout::Error, Errno::ETIMEDOUT, IOError => _e
          # Timeout — retry
          if index < max_retries - 1
            sleep(sleep_duration)
            request["hooksniff-retry-count"] = index + 1
            next
          else
            raise
          end
        end

        # 429 Rate Limit — respect Retry-After header
        if Integer(res.code) == 429
          retry_after = res["Retry-After"]
          delay = retry_after ? retry_after.to_f : sleep_duration
          sleep(delay)
          request["hooksniff-retry-count"] = index + 1
          next
        end

        # 5xx Server Error — exponential backoff
        if Integer(res.code) >= 500 && index < max_retries - 1
          sleep(sleep_duration)
          request["hooksniff-retry-count"] = index + 1
          next
        end

        break
      end

      res
    end

    private def encode_query_params(query_params = {})
      encoded_query_pairs = []
      query_params.each do |k, v|
        unless v.nil?
          if v.kind_of?(Array)
            encoded_query_pairs.append("#{k}=" + CGI::escape(v.sort.join(",")))
          elsif v.kind_of?(Time)
            encoded_query_pairs.append("#{k}=#{CGI::escape(v.utc.to_datetime.rfc3339)}")
          else
            encoded_query_pairs.append("#{k}=#{CGI::escape(v)}")
          end
        end
      end

      encoded_query_pairs.join("&")
    end
  end
end
