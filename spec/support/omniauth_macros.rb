module OmniauthMacros 

  def mock_auth_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { name: 'facebook_user', image: 'facebok_user_img_url', email: 'userfacebook@test.com'},
      credentials: { token: 'test_facebook_token', secret: 'test_facebook_secret'}
    })
  end

  def mock_auth_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '1234567',
      info: { name: 'twitter_user', image: 'twitter_user_img_url' },
      credentials: { token: 'test_twitter_token', secret: 'test_twitter_secret' }
    })
  end
end