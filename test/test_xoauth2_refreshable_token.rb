require 'helper'
require 'timecop'

class TestXoauth2RefreshableToken < Test::Unit::TestCase
  def setup
  end

  def test_get_access_token_with_valid_credentials
    return unless VALID_CREDENTIALS

    oauth2_refreshable_token = built_token
    assert_instance_of String, oauth2_refreshable_token.access_token["access_token"]
  end

  def test_access_token_reused_when_unexpired
    return unless VALID_CREDENTIALS

    oauth2_refreshable_token = built_token
    original = oauth2_refreshable_token.access_token["access_token"]

    sleep 1

    assert_equal original, oauth2_refreshable_token.access_token["access_token"]
  end

  def test_refresh_access_token_after_expiration
    return unless VALID_CREDENTIALS

    oauth2_refreshable_token = built_token
    original = oauth2_refreshable_token.access_token["access_token"]

    sleep 1
    Timecop.travel(Time.now.to_i + 4000) do
      assert_not_equal original, oauth2_refreshable_token.access_token["access_token"]
    end
  end

  def test_to_s_returns_just_the_access_token_for_compatibility
    return unless VALID_CREDENTIALS
    oauth2_refreshable_token = built_token

    assert_equal oauth2_refreshable_token.to_s, oauth2_refreshable_token.access_token["access_token"]
  end

  private

  def built_token
    GmailXoauth::Xoauth2RefreshableToken.new(
      VALID_CREDENTIALS[:client_id],
      VALID_CREDENTIALS[:client_secret],
      VALID_CREDENTIALS[:refresh_token]
    )
  end
end
