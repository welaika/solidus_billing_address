# frozen_string_literal: true

module Checkout
  class AddressPage < SitePrism::Page
    set_url '/checkout'

    section :billing_address, ::Checkout::BillingAddressSection, '#checkout_form_address #billing'
    element :continue_button, '.form-buttons input[type="submit"][value="Save and Continue"]'
  end
end
