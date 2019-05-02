# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Save address_type into database', type: :feature, js: true do
  include_context 'with checkout setup'

  before do
    visit spree.root_path

    click_link 'RoR Mug'
    click_button 'add-to-cart-button'

    click_button 'Checkout'
    fill_in 'order_email', with: 'wafel@example.com'

    click_button 'Continue'
  end

  context 'when billing and shipping addresses are the same' do
    let(:address_page) { Checkout::AddressPage.new }

    it 'saves the correct address type attribute inside two different Spree::Address' do
      address_page.billing_address.fill_in_as_private
      address_page.use_billing_as_shipping_check.check
      address_page.continue_button.click

      delivery_page = Checkout::DeliveryPage.new
      expect(delivery_page).to be_displayed

      order = Spree::Order.last
      expect(order.billing_address.address_type).to eq('billing')
      expect(order.shipping_address.address_type).to eq('shipping')
      expect(order.billing_address.id).not_to eq(order.shipping_address.id)
    end
  end

  context 'when billing and shipping addresses are not the same' do
    let(:address_page) { Checkout::AddressPage.new }

    it 'saves the correct address type attribute inside two different Spree::Address' do
      address_page.billing_address.fill_in_as_private
      address_page.use_billing_as_shipping_check.uncheck
      address_page.shipping_address.fill_in
      address_page.continue_button.click

      delivery_page = Checkout::DeliveryPage.new
      expect(delivery_page).to be_displayed

      order = Spree::Order.last
      expect(order.billing_address.address_type).to eq('billing')
      expect(order.shipping_address.address_type).to eq('shipping')
      expect(order.billing_address.id).not_to eq(order.shipping_address.id)
    end
  end
end
