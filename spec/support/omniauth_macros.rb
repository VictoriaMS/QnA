module OmniauthMacros
  def facebook_mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { email: 'test@qna.com' },
      credentials: { token: 'mock_token', secret: 'mock_secret' }
    })
  end
end
