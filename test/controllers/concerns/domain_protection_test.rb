# frozen_string_literal: true

class DomainProtectionTest < ActionController::TestCase

  class UnauthenticatedTestController < ActionController::Base
    include ShopifyApp::DomainProtection

    def index
    end
  end

  tests UnauthenticatedTestController

  setup do
    Rails.application.routes.draw do
      get '/unauthenticated_test', to: 'domain_protection_test/unauthenticated_test#index'
    end
  end

  teardown do
    Rails.application.reload_routes!
  end

  test 'redirects to login if no shop param is present' do
    get :index

    assert_redirected_to ShopifyApp.configuration.login_url
  end

  test 'redirects to login if no shop is not a valid shopify domain' do
    invalid_shop = 'https://shop1.example.com'

    get :index, params: { shop: invalid_shop }

    assert_redirected_to ShopifyApp.configuration.login_url
  end
end
