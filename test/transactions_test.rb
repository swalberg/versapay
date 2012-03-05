require 'test_helper'

class TransactionsTest < ActionView::TestCase

  def setup
    Versapay.key = "mykey"
    Versapay.token = "mytoken"
    @v = Versapay::Transactions.new
    FakeWeb.allow_net_connect = false
  end

  test "submitting a duplicate transaction" do
    body = '{"unique_reference":"Already created transaction for supplied unique reference"}'
    FakeWeb.register_uri(:post, "https://mytoken:mykey@demo.versapay.com/api/transactions.json", :body => body, :status => ["412", "Invalid input"])
    assert_raises Versapay::DuplicateTransaction do
      @v.create(:amount_in_cents => 12345,
                :transaction_type => "direct_credit",
                :message => "Have some cash!",
                :transaction_reference => "Hello",
                :unique_reference => 42,
                :first_name => "Joe",
                :last_name => "Blow",
                :institution_number => "004",
                :branch_number => "96610",
                :account_number => "12345",
                :fund_token => "123"
                )
    end

  end

  test "viewing a transaction's details" do
    body = '{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"Mitch G.","unique_reference":null,"transaction_reference":"myreference","state":"completed","token":"83F2W2K2FJFV","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"11111","amount_in_cents":128105}'
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/transactions/83F2W2K2FJFV.json", :body => body)
    results = @v.view("83F2W2K2FJFV")

    assert_equal Hash, results.class
    assert_equal "transaction", results["type"]
    assert_equal "VersaPay Balance", results["from_fund"]
  end
  
  test "viewing an invalid transaction's details" do
    body = "Not found"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/transactions/83F2W2K2FXXX.json", :body => body, :status => ["500", "Not found"])
    assert_raises Versapay::NotFound do
      @v.view("83F2W2K2FXXX")
    end
  end
  
  test "listing transactions when there are none" do
    body = "[]"
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/transactions.json", :body => body)
    results = @v.list
    assert_equal Array, results.class
    assert_equal 0, results.size

  end

  test "listing sent transactions when there are some" do
    body = '[{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"Sean Walberg","unique_reference":"2","transaction_reference":"BAhpBw==--31ff18bce30e92ef2d9d4753a2c3c748e1fb8544","state":"completed","token":"8UB8QUMRJA8M","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":100},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"Leia Organa","unique_reference":null,"transaction_reference":"BAhpAdA=--193ef4be953db212508b80802511ef21319c293b","state":"completed","token":"3FJRHSUKP4N2","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":15645},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"J.T. Hutt","unique_reference":null,"transaction_reference":"BAhpAc8=--75cb17f2a52ab3518123ed091343d67104c0a929","state":"completed","token":"2RUPSUBFLH3G","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":131984},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"Leia Organa","unique_reference":null,"transaction_reference":"BAhpAc0=--ab5d0a1b7976cd482f99dc708bee45ecc546d267","state":"completed","token":"5BV48XZ4CEHC","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":86087},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"J.T. Hutt","unique_reference":null,"transaction_reference":"BAhpAcw=--0b2dabdaf965b6edbd4cf91ff2bb41724faa4822","state":"completed","token":"9TUHM13V1K4K","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":131895},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"Leia Organa","unique_reference":null,"transaction_reference":"BAhpAco=--07bb3b7ae35affc7b6210daed6a0747318e4bfd3","state":"completed","token":"21WREVF394XH","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":45492},{"from_account":"wavepayrolltest","type":"transaction","transaction_type":"direct_credit","to_account":"J.T. Hutt","unique_reference":null,"transaction_reference":"BAhpAck=--bc8994974fc1ca3295c455800855e6df7cfb8504","state":"completed","token":"3AMV3SIL5UKF","link_url":null,"message":null,"from_fund":"VersaPay Balance","email":null,"created_by_user":"1kkOYn_uA6KWNjejFka1","amount_in_cents":131808}]'
    FakeWeb.register_uri(:get, "https://mytoken:mykey@demo.versapay.com/api/transactions.json", :body => body)
    results = @v.list
    assert_equal Array, results.class
    assert_equal 7, results.size
  end

end
