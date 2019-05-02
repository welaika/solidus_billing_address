# frozen_string_literal: true

module Checkout
  class PaymentPage < SitePrism::Page
    set_url '/checkout/payment'

    element :continue_button, '.form-buttons input[type="submit"][value="Save and Continue"]'
  end
end
