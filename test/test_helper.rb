require 'test/unit'
require 'rubygems'
require 'action_controller'
require 'active_support'
require 'active_support/test_case'
require 'action_view'
require 'action_view/test_case'

require 'versapay'

Versapay::TOKEN = "abc"

module Rails
  class << self
    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "test")
    end
  end
end
