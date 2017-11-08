if Rails.env.production?
  Rails.configuration.stripe = {
    # publishable_key: ENV['STRIPE_PUBLISHABLE_PRODUCTION_KEY'],
    # secret_key: ENV['STRIPE_SECRET_PRODUCTION_KEY']
    publishable_key: ENV['STRIPE_PUBLISHABLE_TEST_KEY'],
    secret_key: ENV['STRIPE_SECRET_TEST_KEY']
  }
else
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_gn26vmKeDZgfI3te2sTpF4X7',
    secret_key: 'sk_test_3S6jtepB5blpy4Dpoqh45K6H'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
