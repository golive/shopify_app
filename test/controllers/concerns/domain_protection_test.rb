# frozen_string_literal: true

unless Object.const_defined?('Shop')
  class Shop
  end
end

class DomainProtectionTest < ActionController::TestCase
  class UnauthenticatedTestController < ActionController::Base
    include ShopifyApp::DomainProtection

    def index
      render html: '<h1>Success</ h1>'
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

  test 'redirects to login if the shop is not installed' do
    Shop.expects(:find_by).returns(false)

    shopify_domain = 'shop1.myshopify.com'

    get :index, params: { shop: shopify_domain }

    assert_redirected_to "/login?shop=#{shopify_domain}"
  end

  test 'returns :ok if the shop is installed' do
    Shop.expects(:find_by).returns(true)

    shopify_domain = 'shop1.myshopify.com'

    get :index, params: { shop: shopify_domain }

    assert_response :ok
  end
end
