require 'test_helper'

class FundSourcesTest < ActionView::TestCase

  def setup
    Versapay.key = "mykey"
    Versapay.token = "mytoken"
    
    @v = Versapay::FundSources.new
    FakeWeb.register_uri(:any, "https://demo.versapay.com", :body => "response for any HTTP method", :status => ["500", "bad test"])
  end

  test "viewing a list of fund sources" do
    body = "[{\"type\":\"bank_account\",\"state\":\"verified\",\"token\":\"BA8SWGUV931J\",\"name\":\"THE TORONTO-DOMINION BANK (9012)\"},{\"type\":\"balance\",\"token\":\"VPB3IRX9AZYA\",\"name\":\"VersaPay Account\"}]"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/funds.json", :body => body)
    results = @v.list

    assert_equal Array, results.class
    assert_equal "verified", results[0]["state"]
    assert_equal "VersaPay Account", results[1]["name"]
  end
  
end

