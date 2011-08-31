require 'test_helper'

class WebhookTest < ActionView::TestCase

  test "signature generation" do
    params = {
                "created_by_user" => "699cMPe6BAyqvVsZA5mo",
                "email" => "user@example.com",
                "from_fund" => "THE TORONTO-DOMINION BANK",
                "link_url" => "",
                "message" => "",
                "type" => "transaction",
                "state" => "completed",
                "to_account" => "Example user",
                "amount_in_cents" => "500",
                "token" => "5TH3ACC3AU21",
                "from_account" => "First1 Last1",
                "transaction_type" => "send_money",
                "transaction_reference" => "",
    }

    method = :post
    url = "http://example.com/versapay"
    key = "v7aJHjbbxASKiwDW5wq6"

    assert_equal "w17XQBan8r%2BdtdvGQpa5HRAF8fRXJwKV9yUo4KXLl8E%3D%0A", Versapay::WebhookSignature.hmac(method, url, key, params)
    assert_equal "w17XQBan8r%2BdtdvGQpa5HRAF8fRXJwKV9yUo4KXLl8E%3D%0A", Versapay::WebhookSignature.new(method, url, key, params).signature
  end

  test "signature generation 2" do
    params = {
      "name"  =>  "Fred Smith",
      "reference" => "",
      "token" => "7IN4ALWCXKJG",
      "created_by_account"  => "wavepayrolltest",
      "type"  => "debit_agreement",
      "created_by_user" => "1kkOYn_uA6KWNjejFka1",
      "message" => "blah",
      "state" => "cancelled",
      "email" => "fredsmith@smallpayroll.ca"
      
    }

    method = :post
    url = "http://home.ertw.com:3434/webhooks/versapay"
    key = "76pppukB4HHkWt1U_V4-"
    assert_equal "qL2vrB4nva8E1xh%2FDe83yCvXBNpQqoRTOi0p4gVI9xo%3D%0A", Versapay::WebhookSignature.hmac(method, url, key, params)
  end

  class TestController < ActionController::Base
    check_versapay_signatures "v7aJHjbbxASKiwDW5wq6"

    def index
      render :text => "success"
    end
  end

  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionController::Routing::Routes.add_named_route :foo, '/foo', :controller => 'webhook_test/test', :action => 'index'
  end

  test "a valid webhook signature" do
    post :index, { "blah" => "aaa", "signature" => "1Sz%2BgPS%2FO8%2BjwyBm7XQbNJ5f2DxHc3Qliysa8BKJ7aE%3D%0A" }
    assert_equal "success", @response.body
  end
  
  test "an invalid webhook signature" do
    post :index, { "blah" => "aab", "signature" => "1Sz%2BgPS%2FO8%2BjwyBm7XQbNJ5f2DxHc3Qliysa8BKJ7aE%3D%0A" }
    assert_not_equal "success", @response.body
  end

end
