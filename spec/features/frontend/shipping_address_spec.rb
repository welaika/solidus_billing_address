# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Shipping address', type: :feature, js: true do
  include_context 'with checkout setup'

  before do
    visit spree.root_path

    click_link 'RoR Mug'
    click_button 'add-to-cart-button'

    click_button 'Checkout'
    fill_in 'order_email', with: 'wafel@example.com'
  end

  it 'does not show billing specific attributes for shipping address', aggregate_failures: true do
    click_button 'Continue'

    address_page = Checkout::AddressPage.new
    expect(address_page).to be_displayed

    address_page.use_billing_as_shipping_check.uncheck

    Spree::Address::BILLING_ONLY_ATTRS.each do |attr|
      expect(address_page.shipping_address).not_to(
        have_field("order[ship_address_attributes][#{attr}]")
      )
    end
  end
end
