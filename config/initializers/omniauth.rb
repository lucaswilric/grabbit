require 'omniauth-openid'
require 'openid/store/filesystem'

# Initialisation for OmniAuth
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
end
