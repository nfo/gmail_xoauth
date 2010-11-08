require 'net/smtp'
require 'oauth'

module GmailXoauth
  module SmtpXoauthAuthenticator
    
    def auth_xoauth(user, secret)
      check_auth_args user, secret
      
      request_url, oauth_string = nil
      if secret[:two_legged]
        request_url = "https://mail.google.com/mail/b/#{user}/smtp/?xoauth_requestor_id=#{CGI.escape(user)}";
        secret[:xoauth_requestor_id] = user
        oauth_string = build_2_legged_oauth_string(request_url, secret)
      else
        request_url  = "https://mail.google.com/mail/b/#{user}/smtp/"
        oauth_string = build_oauth_string(request_url, secret)
      end

      sasl_client_request = build_sasl_client_request(request_url, oauth_string)
      
      res = critical {
        get_response("AUTH XOAUTH #{base64_encode(sasl_client_request)}")
      }
      
      check_auth_response res
      res
    end
    
    include OauthString
    
  end
end

# Not pretty, right ?
Net::SMTP.__send__('include', GmailXoauth::SmtpXoauthAuthenticator)
