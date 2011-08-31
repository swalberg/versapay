module Versapay
  module Helpers
    # Provides a debit agreement link
    def debit_agreement_link_to(anchor, message = "Debit agreement", opts = {})
      link = "https://" + Versapay::site + "/authorize?api_token=#{Versapay::TOKEN}&message=#{html_escape(message).gsub(/ /, "+")}"
      opts.each do |k, v|
        link += "&#{k}=#{html_escape(v)}"
      end
      "<a href=\"#{link}\">#{anchor}</a>"
    end
  end
end
