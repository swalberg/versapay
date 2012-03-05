require 'rest_client'

module Versapay
  class Transactions

    def initialize(&block)
      yield self if block_given?
    end

    def create(args)
      Versapay::make_request(:post, "/api/transactions.json", args)
    end

    def list(page = nil)
      args = page.nil? ? {} : { :page => page }
      Versapay::make_request(:get, "/api/transactions.json", args)
    end

    def view(token)
      Versapay::make_request(:get, "/api/transactions/#{token}.json")
    end

    def approve(token)
      Versapay::make_request(:post, "/api/transactions/#{token}/approve.json")
    end

    def cancel(token)
      Versapay::make_request(:post, "/api/transactions/#{token}/cancel.json")
    end

  end
end
