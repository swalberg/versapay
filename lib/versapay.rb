require "versapay/version"

require "uri"
require "versapay/rails_helpers"
require "versapay/webhooks"
require "versapay/debit_agreement"
require "versapay/fund_sources"
require "versapay/transactions"
require "active_support/core_ext/object/to_query"

module Versapay

  class VersapayError < RuntimeError; end

  class InvalidInput < VersapayError; end
  class DuplicateTransaction < InvalidInput; end

  class InvalidWebhookSignature < VersapayError; end
  class Unprocessable < VersapayError; end
  class NotFound < VersapayError; end

  class << self
    attr_accessor :token, :key
  end

  @@token = "PleaseOverrideYourToken"
  @@key = "PleaseOverriedYourKey"

  def self.site
    Rails.env.production? ? "secure.versapay.com" : "demo.versapay.com"
  end

  def self.uri(path, params={})
    options = { :host => site, :path => path }

    options = options.merge(:query => params.to_query) unless params.empty?

    URI::HTTPS.build(options).to_s
  end

  def self.make_request(method, url, args = {})
    if method == :get then
      RestClient.get("https://#{Versapay.token}:#{Versapay.key}@" + Versapay::site + url, {:params => args}) do |response, request, result, &block|
        case response.code
        when 200
          return JSON.parse(response)
        when 422
          raise Versapay::Unprocessable, response
        when 500
          raise Versapay::NotFound, response
        end
      end
    end

    if method == :post then
      RestClient.post("https://#{Versapay.token}:#{Versapay.key}@" + Versapay::site + url, args.to_json, :content_type => :json, :accept => :json) do |response, request, result, &block|
        case response.code
        when 200,201
          return JSON.parse(response)
        when 412
          result = JSON.parse(response)
          if result.key? "unique_reference"
            raise Versapay::DuplicateTransaction, response
          else
            raise Versapay::InvalidInput, response
          end
        when 422
          raise Versapay::Unprocessable, response
        when 500
          raise Versapay::NotFound, response
        end
      end
    end


  end
end
