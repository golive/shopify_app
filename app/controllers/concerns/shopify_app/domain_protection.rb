# frozen_string_literal: true

module ShopifyApp
  module DomainProtection
    extend ActiveSupport::Concern

    included do
      before_action :check_shop_domain
      before_action :check_shop_known
    end

    def current_shopify_domain
      return if params[:shop].blank?
      @shopify_domain ||= ShopifyApp::Utils.sanitize_shop_domain(params[:shop])
    end

    private

    def check_shop_domain
      redirect_to(ShopifyApp.configuration.login_url) unless current_shopify_domain
    end

    def check_shop_known
      shop = Shop.find_by(shopify_domain: current_shopify_domain)
      redirect_to("#{ShopifyApp.configuration.login_url}?shop=#{current_shopify_domain}") unless shop
    end
  end
end
