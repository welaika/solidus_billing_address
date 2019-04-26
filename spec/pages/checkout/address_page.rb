# frozen_string_literal: true

module Checkout
  class AddressPage < SitePrism::Page
    set_url '/checkout'

    section :billing_address, ::Checkout::BillingAddressSection, '#checkout_form_address #billing'
    section :shipping_address, ::Checkout::ShippingAddressSection, '#checkout_form_address #shipping'
    element :continue_button, '.form-buttons input[type="submit"][value="Save and Continue"]'
    element :use_billing_as_shipping_check, '#order_use_billing'
  end
end
