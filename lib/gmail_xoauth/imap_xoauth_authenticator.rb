require 'net/imap'
require 'oauth'

module GmailXoauth
  class ImapXoauthAuthenticator

    def process(data)
      'GET ' + @request_url + ' ' + @oauth_string
    end

    private

    # +user+ is an email address: roger@gmail.com
    # +password+ is a hash of oauth parameters, see +build_oauth_string+
    def initialize(user, password)
      @request_url = "https://mail.google.com/mail/b/#{user}/imap/"
      @oauth_string = build_oauth_string(@request_url, password)
    end

    #
    # Builds the "oauth protocol parameter string". See http://code.google.com/apis/gmail/oauth/protocol.html#sasl
    # 
    #   +request_url+ https://mail.google.com/mail/b/user_name@gmail.com/imap/
    #   +oauth_params+ contains the following keys:
    #     * :consumer_key (default 'anonymous')
    #     * :consumer_secret (default 'anonymous')
    #     * :token (mandatory)
    #     * :token_secret (mandatory)
    def build_oauth_string(request_url, oauth_params = {})
      oauth_params[:consumer_key] ||= 'anonymous'
      oauth_params[:consumer_secret] ||= 'anonymous'
      
      oauth_request_params = {
        "oauth_consumer_key"     => oauth_params[:consumer_key],
        'oauth_nonce'            => OAuth::Helper.generate_key,
        "oauth_signature_method" => 'HMAC-SHA1',
        'oauth_timestamp'        => OAuth::Helper.generate_timestamp,
        "oauth_token"            => oauth_params[:token],
        'oauth_version'          => '1.0'
      }
      
      request = OAuth::RequestProxy.proxy(
         'method'     => 'GET',
         'uri'        => request_url,
         'parameters' => oauth_request_params
      )
      
      oauth_request_params['oauth_signature'] =
        OAuth::Signature.sign(
          request,
          :consumer_secret => oauth_params[:consumer_secret],
          :token_secret    => oauth_params[:token_secret]
        )
      
      # Inspired from oauth_header OAuth::RequestProxy::Base#oauth_header
      oauth_request_params.map { |k,v| "#{k}=\"#{OAuth::Helper.escape(v)}\"" }.sort.join(',')
    end
  end
end

Net::IMAP.add_authenticator('XOAUTH', GmailXoauth::ImapXoauthAuthenticator)