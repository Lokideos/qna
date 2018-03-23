module OmniauthMacros 

  def mock_auth_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { name: 'facebook_user', image: 'facebok_user_img_url', email: 'userfacebook@test.com'},
      credentials: { token: 'test_facebook_token', secret: 'test_facebook_secret'}
    })
  end
end