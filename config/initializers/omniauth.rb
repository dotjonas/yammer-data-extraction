#Add the OmniAuth middleware to your Rails app by updating config/initializers/omniauth.rb to include:
   
Rails.application.config.middleware.use OmniAuth::Builder do
   provider :yammer, 'Client Id', 'Client Secret'
   end