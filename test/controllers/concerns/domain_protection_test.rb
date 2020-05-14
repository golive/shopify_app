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

  test 'renders invalid_shop if shop parameter is missing' do
    get :index

    assert_template :invalid_shop
  end

  test 'renders invalid_shop if shop is on an invalid domain' do
    invalid_shop = 'https://shop1.example.com'

    get :index, params: { shop: invalid_shop }

    assert_template :invalid_shop
  end
end
