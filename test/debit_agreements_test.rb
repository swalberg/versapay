require 'test_helper'

class DebitAgreementsTest < ActionView::TestCase

  def setup
    Versapay.key = "mykey"
    Versapay.token = "mytoken"
    @v = Versapay::DebitAgreement.new
    FakeWeb.register_uri(:any, "https://demo.versapay.com", :body => "response for any HTTP method", :status => ["500", "bad test"])
  end

  test "viewing a transaction's details" do
    body = "{\"type\":\"debit_agreement\",\"state\":\"approved\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"83F2W2K2FJFV\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":\"BAhpBg==--7e0a441bda1b04f5b985fa654d357071bb9b32d1\",\"email\":\"jimbob@smallpayroll.ca\",\"name\":\"Jim Bob\"}" 
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/debit_agreements/83F2W2K2FJFV.json", :body => body)
    results = @v.view("83F2W2K2FJFV")

    assert_equal Hash, results.class
    assert_equal "debit_agreement", results["type"]
  end
  
  test "viewing an invalid transaction's details" do
    body = "Not found"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/debit_agreements/83F2W2K2FXXX.json", :body => body, :status => ["500", "Not found"])
    assert_raises Versapay::NotFound do
      @v.view("83F2W2K2FXXX")
    end
  end
  
  test "listing sent transactions when there are none" do
    body = "[]"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/debit_agreements/sent.json", :body => body)
    results = @v.list_sent
    assert_equal Array, results.class
    assert_equal 0, results.size

  end

  test "listing sent transactions when there are some" do
    body = "[{\"type\":\"debit_agreement\",\"state\":\"approved\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"83F2W2K2FJFV\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":\"BAhpBg==--7e0a441bda1b04f5b985fa654d357071bb9b32d1\",\"email\":\"jimbob@smallpayroll.ca\",\"name\":\"Jim Bob\"},{\"type\":\"debit_agreement\",\"state\":\"approved\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"6DCKWXXF1A51\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":\"BAhpBg==--7e0a441bda1b04f5b985fa654d357071bb9b32d1\",\"email\":\"jimbob@smallpayroll.ca\",\"name\":\"Jim Bob\"},{\"type\":\"debit_agreement\",\"state\":\"revoked\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"7VBJRS7TKLIL\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":\"BAhpBg==--7e0a441bda1b04f5b985fa654d357071bb9b32d1\",\"email\":\"fredsmith@smallpayroll.ca\",\"name\":\"Fred Smith\"},{\"type\":\"debit_agreement\",\"state\":\"revoked\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"6YI3MTVMY918\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":null,\"email\":\"fredsmith@smallpayroll.ca\",\"name\":\"Fred Smith\"},{\"type\":\"debit_agreement\",\"state\":\"revoked\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"1AYAG5T762TJ\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":null,\"email\":\"fredsmith@smallpayroll.ca\",\"name\":\"Fred Smith\"},{\"type\":\"debit_agreement\",\"state\":\"cancelled\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"7IN4ALWCXKJG\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":null,\"email\":\"fredsmith@smallpayroll.ca\",\"name\":\"Fred Smith\"},{\"type\":\"debit_agreement\",\"state\":\"revoked\",\"created_by_account\":\"wavepayrolltest\",\"token\":\"4RQ58W5B4M1W\",\"message\":\"blah\",\"created_by_user\":\"1kkOYn_uA6KWNjejFka1\",\"reference\":null,\"email\":\"fredsmith@smallpayroll.ca\",\"name\":\"Fred Smith\"}]"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/debit_agreements/sent.json", :body => body)
    results = @v.list_sent
    assert_equal Array, results.class
    assert_equal 7, results.size
  end

end
