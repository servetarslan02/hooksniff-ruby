# frozen_string_literal: true

module HookSniff
  # Base error class for all HookSniff API errors
  class ApiError < StandardError
    attr_reader :code, :response_headers, :response_body

    def initialize(code:, response_headers: {}, response_body: nil)
      @code = code
      @response_headers = response_headers
      @response_body = response_body
      super("HookSniff API error #{code}")
    end
  end

  # 400 Bad Request
  class BadRequestError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 400, response_headers: response_headers, response_body: response_body)
    end
  end

  # 401 Unauthorized
  class UnauthorizedError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 401, response_headers: response_headers, response_body: response_body)
    end
  end

  # 403 Forbidden
  class ForbiddenError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 403, response_headers: response_headers, response_body: response_body)
    end
  end

  # 404 Not Found
  class NotFoundError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 404, response_headers: response_headers, response_body: response_body)
    end
  end

  # 408 Request Timeout
  class RequestTimeoutError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 408, response_headers: response_headers, response_body: response_body)
    end
  end

  # 409 Conflict
  class ConflictError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 409, response_headers: response_headers, response_body: response_body)
    end
  end

  # 410 Gone
  class GoneError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 410, response_headers: response_headers, response_body: response_body)
    end
  end

  # 413 Payload Too Large
  class PayloadTooLargeError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 413, response_headers: response_headers, response_body: response_body)
    end
  end

  # 422 Unprocessable Entity
  class UnprocessableEntityError < ApiError
    attr_reader :validation_errors

    def initialize(validation_errors: [], response_headers: {}, response_body: nil)
      super(code: 422, response_headers: response_headers, response_body: response_body)
      @validation_errors = validation_errors
    end
  end

  # 429 Rate Limited
  class RateLimitError < ApiError
    attr_reader :retry_after

    def initialize(retry_after: nil, response_headers: {}, response_body: nil)
      super(code: 429, response_headers: response_headers, response_body: response_body)
      @retry_after = retry_after
    end
  end

  # 500 Internal Server Error
  class InternalServerError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 500, response_headers: response_headers, response_body: response_body)
    end
  end

  # 501 Not Implemented
  class NotImplementedError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 501, response_headers: response_headers, response_body: response_body)
    end
  end

  # 502 Bad Gateway
  class BadGatewayError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 502, response_headers: response_headers, response_body: response_body)
    end
  end

  # 503 Service Unavailable
  class ServiceUnavailableError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 503, response_headers: response_headers, response_body: response_body)
    end
  end

  # 504 Gateway Timeout
  class GatewayTimeoutError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 504, response_headers: response_headers, response_body: response_body)
    end
  end

  # 507 Insufficient Storage
  class InsufficientStorageError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 507, response_headers: response_headers, response_body: response_body)
    end
  end

  # 508 Loop Detected
  class LoopDetectedError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 508, response_headers: response_headers, response_body: response_body)
    end
  end

  # Timeout — request exceeded the configured timeout
  class TimeoutError < StandardError
    attr_reader :code
    def initialize(message = "Request timeout")
      @code = 0
      super(message)
    end
  end

  # Network error — connection failed
  class NetworkError < StandardError
    attr_reader :code
    def initialize(message = "Network error")
      @code = 0
      super(message)
    end
  end

  # Authentication error — token invalid, expired, or missing
  class AuthenticationError < ApiError
    def initialize(response_headers: {}, response_body: nil)
      super(code: 401, response_headers: response_headers, response_body: response_body)
    end
  end

  # Create the appropriate error from a status code
  def self.create_error_from_status(status_code, response_headers: {}, response_body: nil)
    case status_code
    when 400
      BadRequestError.new(response_headers: response_headers, response_body: response_body)
    when 401
      UnauthorizedError.new(response_headers: response_headers, response_body: response_body)
    when 403
      ForbiddenError.new(response_headers: response_headers, response_body: response_body)
    when 404
      NotFoundError.new(response_headers: response_headers, response_body: response_body)
    when 408
      RequestTimeoutError.new(response_headers: response_headers, response_body: response_body)
    when 409
      ConflictError.new(response_headers: response_headers, response_body: response_body)
    when 410
      GoneError.new(response_headers: response_headers, response_body: response_body)
    when 413
      PayloadTooLargeError.new(response_headers: response_headers, response_body: response_body)
    when 422
      UnprocessableEntityError.new(response_headers: response_headers, response_body: response_body)
    when 429
      retry_after = response_headers["retry-after"]&.to_i
      RateLimitError.new(retry_after: retry_after, response_headers: response_headers, response_body: response_body)
    when 500
      InternalServerError.new(response_headers: response_headers, response_body: response_body)
    when 501
      NotImplementedError.new(response_headers: response_headers, response_body: response_body)
    when 502
      BadGatewayError.new(response_headers: response_headers, response_body: response_body)
    when 503
      ServiceUnavailableError.new(response_headers: response_headers, response_body: response_body)
    when 504
      GatewayTimeoutError.new(response_headers: response_headers, response_body: response_body)
    when 507
      InsufficientStorageError.new(response_headers: response_headers, response_body: response_body)
    when 508
      LoopDetectedError.new(response_headers: response_headers, response_body: response_body)
    else
      ApiError.new(code: status_code, response_headers: response_headers, response_body: response_body)
    end
  end
end
