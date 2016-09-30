require "json"

module GmailXoauth
  class Xoauth2RefreshableToken
    def initialize client_id, client_secret, refresh_token
      @client_id = client_id
      @client_secret = client_secret
      @refresh_token = refresh_token
      @access_token = nil
    end

    def access_token
      if refresh_required?
        @access_token = refreshed_access_token
      end

      @access_token
    end

    def to_s
      access_token["access_token"]
    end

    private

    def refresh_required?
      @access_token.nil? || (Time.now.to_i > expires_at)
    end

    def refreshed_access_token
      access_token = JSON.parse(Net::HTTP.post_form(uri, refresh_data).body)
      access_token["retrieved_at"] = Time.now.to_i

      access_token
    end

    def retrieved_at
      @access_token["retrieved_at"].to_i
    end

    def expires_at
      @access_token["expires_in"].to_i + retrieved_at
    end

    def uri
      URI.parse "https://accounts.google.com/o/oauth2/token"
    end

    def refresh_data
      {
        client_id: @client_id,
        client_secret: @client_secret,
        refresh_token: @refresh_token,
        grant_type: "refresh_token"
      }
    end
  end
end
