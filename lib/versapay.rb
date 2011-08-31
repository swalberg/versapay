require "versapay/version"

require "versapay/rails_helpers"
require "versapay/webhooks"

module Versapay

  class InvalidWebhookSignature < Exception; end

  class << self
    attr_accessor :token, :key
  end

  @@token = "PleaseOverrideYourToken"
  @@key = "PleaseOverriedYourKey"

  def self.site
    Rails.env.production? ? "secure.versapay.com" : "demo.versapay.com"
  end
end
