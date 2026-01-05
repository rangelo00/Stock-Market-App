require "test_helper"

class TraderMailerTest < ActionMailer::TestCase
  test "account_approved" do
    mail = TraderMailer.account_approved
    assert_equal "Account approved", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "account_rejected" do
    mail = TraderMailer.account_rejected
    assert_equal "Account rejected", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
