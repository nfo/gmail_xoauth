require 'net/smtp'
require 'base64'

module GmailXoauth
  module SmtpXoauth2Authenticator
    
    def auth_xoauth2(user, oauth2_token)
      check_auth_args user, oauth2_token

      auth_string = build_oauth2_string(user, oauth2_token)
      res = critical {
        get_response("AUTH XOAUTH2 #{base64_encode(auth_string)}")
      }
      
      check_auth_response res
      res
    end
    
    include OauthString
    
  end
end

# Not pretty, right ?
Net::SMTP.__send__('include', GmailXoauth::SmtpXoauth2Authenticator)
