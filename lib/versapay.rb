require "versapay/version"

require "versapay/rails_helpers"

module Versapay
  TOKEN = "PleaseOverrideYourToken"
  KEY = "PleaseOverriedYourKey"


  def self.site
    Rails.env.production? ? "secure.versapay.com" : "demo.versapay.com"
  end
end
