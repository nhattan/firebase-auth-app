Rails.application.config.middleware.use OmniAuth::Builder do
  provider OmniAuth::Strategies::FirebaseToken, 'rails-integration-test'
end
