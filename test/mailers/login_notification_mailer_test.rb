require "test_helper"

class LoginNotificationMailerTest < ActionMailer::TestCase
  test "notify_login" do
    mail = LoginNotificationMailer.notify_login
    assert_equal "Notify login", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
