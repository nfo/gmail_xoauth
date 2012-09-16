require 'helper'

class TestSmtpXoauthAuthenticator < Test::Unit::TestCase
  
  def setup
  end
  
  def test_smtp_authenticator_is_enabled
    assert Net::SMTP.new(nil).respond_to?(:auth_xoauth2), 'The Net::SMTP class should define the method :auth_xoauth2'
  end
  
  def test_authenticate_with_invalid_credentials
    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls_auto
    assert_raise(Net::SMTPAuthenticationError) do
      smtp.start('gmail.com', 'roger@moore.com', 'a', :xoauth2)
    end
  end
  
  def test_authenticate_with_valid_credentials
    return unless VALID_CREDENTIALS
    
    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls_auto
    
    assert_nothing_raised do
      smtp.start('gmail.com', VALID_CREDENTIALS[:email], VALID_CREDENTIALS[:oauth2_token], :xoauth2)
    end
  ensure
    smtp.finish if smtp && smtp.started?
  end
end
