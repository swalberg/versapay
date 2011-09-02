require 'rest_client'

module Versapay
  class FundSources

    def initialize(&block)
      yield self if block_given?
    end

    def list
      make_request(:get, "/api/funds.json")
    end
  end
end
