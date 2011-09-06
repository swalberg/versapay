require "versapay/version"

require "versapay/rails_helpers"
require "versapay/webhooks"
require "versapay/debit_agreement"
require "versapay/fund_sources"
require "versapay/transactions"

module Versapay

  class InvalidInput < Exception; end
  class InvalidWebhookSignature < Exception; end
  class Unprocessable < Exception; end
  class NotFound < Exception; end

  class << self
    attr_accessor :token, :key
  end

  @@token = "PleaseOverrideYourToken"
  @@key = "PleaseOverriedYourKey"

  def self.site
    Rails.env.production? ? "secure.versapay.com" : "demo.versapay.com"
  end


  def self.make_request(method, url, args = {})
    if method == :get then
      RestClient.get("https://#{Versapay.token}:#{Versapay.key}@" + Versapay::site + url, {:params => args}) do |response, request, result, &block|
        case response.code
        when 200
          return JSON.parse(response)
        when 422
          raise Versapay::Unprocessable
        when 500
          raise Versapay::NotFound
        end
      end
    end

    if method == :post then
      RestClient.post("https://#{Versapay.token}:#{Versapay.key}@" + Versapay::site + url, args.to_json, :content_type => :json, :accept => :json) do |response, request, result, &block|
        case response.code
        when 200,201
          return JSON.parse(response)
        when 412
          raise Versapay::InvalidInput #(JSON.parse(response))
        when 422
          raise Versapay::Unprocessable
        when 500
          raise Versapay::NotFound
        end
      end
    end


  end
end
