require 'active_support/core_ext/hash/reverse_merge'

module Versapay
  module Helpers
    # Provides a debit agreement link
    def debit_agreement_link_to(inner_text, message = "Debit agreement", opts = {})
      build_anchor_tag(inner_text, debit_agreement_link(message, opts))
    end

    def payment_checkout_link_to(inner_text, message = "Credit Card payment", opts = {})
      build_anchor_tag(inner_text, payment_checkout_link(message, opts))
    end

    def debit_agreement_link(message = "Debit agreement", opts = {})
      default_options = {
        :message => message,
        :api_token => Versapay.token
      }

      options = default_options.reverse_merge(opts)

      Versapay.uri('/authorize', options)
    end

    def payment_checkout_link(message = "Credit Card payment", opts = {})
      default_options = {
        :message => message,
        :api_token => Versapay.token
      }

      options = default_options.reverse_merge(opts)

      Versapay.uri('/send_money', options)
    end

    private

    def build_anchor_tag(inner_text, uri)
      %{<a href="#{uri}">#{inner_text}</a>}
    end
  end
end
