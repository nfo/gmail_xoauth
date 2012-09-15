require 'net/imap'

module GmailXoauth
  class ImapXoauth2Authenticator
    
    def process(data)
      build_oauth2_string(@user, @password)
    end
    
  private
    
    # +user+ is an email address: roger@gmail.com
    # +password+ is a hash of oauth parameters, see +build_oauth_string+
    def initialize(user, password)
      @user = user
      @password = password
    end
    
    include OauthString
    
  end
end

Net::IMAP.add_authenticator('XOAUTH2', GmailXoauth::ImapXoauth2Authenticator)
