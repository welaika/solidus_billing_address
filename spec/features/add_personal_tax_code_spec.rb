# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Personal tax code for billing address in checkout step', type: :feature, js: true do
  include_context 'with checkout setup'

  before do
    visit spree.root_path

    click_link 'RoR Mug'
    click_button 'add-to-cart-button'

    click_button 'Checkout'
    fill_in 'order_email', with: 'wafel@example.com'
  end

  it 'allows user to fill in the personal tax code field', aggregate_failures: true do
    click_button 'Continue'

    address_page = Checkout::AddressPage.new
    expect(address_page).to be_displayed

    expect(address_page.billing_address).to have_personal_tax_code_field
    address_page.billing_address.fill_in(attributes: { personal_tax_code: 'RSSMRA00A01F839E' })
    address_page.continue_button.click

    delivery_page = Checkout::DeliveryPage.new
    expect(delivery_page).to be_displayed

    order = Spree::Order.last
    expect(order.billing_address.personal_tax_code).to eq('RSSMRA00A01F839E')
  end
end
