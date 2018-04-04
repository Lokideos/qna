module OmniauthMacros
  def mock_auth_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123456',
      info: { name: 'facebook_user', image: 'facebook_user_image_url', email: 'facebookuser@test.com' },
      credentials: { token: 'facebook_token' }
    )
  end

  def mock_auth_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '12345',
      info: { nickname: 'twitter_user', name: 'twitter_user_name', image: 'twitter_user_image_url' },
      credentials: { token: 'twitter_token' }
    )
  end
end