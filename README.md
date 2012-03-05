# A gem to help with using VersaPay's API

## Usage

Include it in your app's 'Gemfile':

```Ruby
gem 'versapay'
```

In the controller you can make sure that all the actions are called with a valid Web Hook signature:

```Ruby
class VersapayController < ApplicationController
  check_versapay_signatures "MyKey"
```

There are some Rails view helpers to set up a debit agreement:

```Ruby
# The first you hear of a new debit agreement is when VersaPay sends a callback. So the reference should be
# something you can use to identify your user. For example,
# key = MyApp::Application.config.secret_token
# verifier = ActiveSupport::MessageVerifier.new(key)
# @reference = verifier.generate(@user.id)
= link_to "Setup VersaPay", debit_agreement_link("Set up an agreement", { :reference => @reference, :pref => "ba" })
```

And of course, you can sent transactions:

```Ruby
 Versapay::Transactions.new do |v|
    begin
      result = v.create(:amount_in_cents => 12345,
                        :debit_agreement_token => "RWOCDPSM",
                        :transaction_type => "pre_authorized_debit",
                        :email => "foo@example.com",
                        :message => "A crate of widgets",
                        :transaction_reference => "my reference",
                        :fund_token => "VersaPayBalanceFundingSource"
                       )
    rescue Versapay::VersapayError => e
      logger.error "Transaction failed"
      return false
    end
  end
```

Pretty much all the parameters to the functions match the way the VersaPay developers API works.

See the VersaPay developers API: http://developers.versapay.com
