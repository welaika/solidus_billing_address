# frozen_string_literal: true

module Checkout
  class ConfirmPage < SitePrism::Page
    set_url '/checkout/confirm'

    element :bill_address, '#order_details div[data-hook="order-bill-address"]'
    element :ship_address, '#order_details div[data-hook="order-ship-address"]'
    element :continue_button, '.form-buttons input[type="submit"][value="Save and Continue"]'
  end
end
