module OmniauthMacros
  def mock_auth_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123456',
      info: { name: 'facebook_user', image: 'facebook_user_image_url', email: 'facebookuser@test.com' },
      credentials: { token: 'facebook_token' }
    )
  end
end