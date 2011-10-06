require 'test_helper'

class HelperTest < ActionView::TestCase

  tests Versapay::Helpers


  test "creating a debit agreement link" do
    expected = '<a href="https://demo.versapay.com/authorize?api_token=' + Versapay::token + '&message=Testing+123">test</a>'
    assert_equal expected, debit_agreement_link_to("test", "Testing 123")
  end

  test "creating a debit agreement link with extra options" do
    expected = '<a href="https://demo.versapay.com/authorize?api_token=' + Versapay::token + '&message=Testing+123&reference=abc123">test</a>'
    assert_equal expected, debit_agreement_link_to("test", "Testing 123", {:reference => "abc123"})
  end

  test "creating a credit card link" do
    expected = '<a href="https://demo.versapay.com/send_money?api_token=' + Versapay::token + '&message=Testing+123&pref=cc">test</a>'
    assert_equal expected, payment_checkout_link_to("test", "Testing 123", {:pref => "cc"})
  end

end
