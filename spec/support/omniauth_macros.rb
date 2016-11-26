module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: 'abcd',
      info: { email: 'email@mail.com', name: 'Name' }
    )
  end

  def mock_auth_invalid(provider)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = {}
  end
end
