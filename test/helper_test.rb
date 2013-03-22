require 'test_helper'

class HelperTest < ActionView::TestCase

  tests Versapay::Helpers


  test "creating a debit agreement link_to" do
    expected = '<a href="https://demo.versapay.com/authorize?api_token=' + Versapay.token + '&message=Testing+123">test</a>'
    assert_equal expected, debit_agreement_link_to("test", "Testing 123")
  end

  test "creating a debit agreement link_to with extra options" do
    expected = '<a href="https://demo.versapay.com/authorize?api_token=' + Versapay.token + '&message=Testing+123&reference=abc123">test</a>'
    assert_equal expected, debit_agreement_link_to("test", "Testing 123", {:reference => "abc123"})
  end

  test "creating a credit card link_to" do
    expected = '<a href="https://demo.versapay.com/send_money?api_token=' + Versapay.token + '&message=Testing+123&pref=cc">test</a>'
    assert_equal expected, payment_checkout_link_to("test", "Testing 123", {:pref => "cc"})
  end

  test "creating a credit card link" do
    assert_match %r{/send_money\?api_token=#{Versapay.token}&message=Testing\+123&pref=cc}, payment_checkout_link("Testing 123", {:pref => "cc"})
  end

  test "creating a debit agreement link" do
    assert_match %r{/authorize\?api_token=#{Versapay.token}&message=Testing\+123}, debit_agreement_link('Testing 123')
  end

  test 'build an arbitrary link without query params' do
    expected = 'https://demo.versapay.com/authorize'
    assert_equal expected, Versapay.uri('/authorize')
  end

  test 'build an arbitrary link with query params' do
    assert_equal 'https://demo.versapay.com/bacon?hello=world', Versapay.uri('/bacon', :hello => 'world')
  end
end
