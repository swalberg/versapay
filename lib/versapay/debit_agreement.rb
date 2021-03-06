require 'rest_client'

module Versapay
  class DebitAgreement

    def initialize(&block)
      yield self if block_given?
    end

    def create(email, reference = nil, message = nil)
      args = { "email" => email, "reference" => email, "message" => message }
      Versapay::make_request(:post, "/api/debit_agreements.json", args)
    end

    def list_sent(page = nil)
      args = page.nil? ? {} : { :page => page }
      Versapay::make_request(:get, "/api/debit_agreements/sent.json", args)
    end

    def list_received(page = nil)
      args = page.nil? ? {} : { :page => page }
      Versapay::make_request(:get, "/api/debit_agreements/received.json", args)
    end

    def view(token)
      Versapay::make_request(:get, "/api/debit_agreements/#{token}.json")
    end

    def approve(token, fund_token = nil)
      args = fund_token.nil? ? {} : { :fund_token => fund_token }
      Versapay::make_request(:post, "/api/debit_agreements/#{token}/approve.json", args)
    end

    def reject(reason)
      ags = { "rejection_reason" => reason }
      Versapay::make_request(:post, "/api/debit_agreements/#{token}/reject.json", args)
    end

    def cancel
      Versapay::make_request(:post, "/api/debit_agreements/#{token}/reject.json", {})
    end

    def revoke
      Versapay::make_request(:post, "/api/debit_agreements/#{token}/reject.json", {})
    end

  end
end
