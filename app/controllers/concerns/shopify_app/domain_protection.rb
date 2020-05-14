# frozen_string_literal: true

module ShopifyApp
  module DomainProtection
    extend ActiveSupport::Concern

    included do
      before_action :check_shop_domain
    end

    def current_shopify_domain
      return if params[:shop].blank?
      @shopify_domain ||= ShopifyApp::Utils.sanitize_shop_domain(params[:shop])
    end

    private

    def check_shop_domain
     if current_shopify_domain.nil?
       render(template: 'shopify_app/invalid_shop') && return
     end
    end
  end
end
