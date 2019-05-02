# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'VAT number for billing address in checkout step', type: :feature, js: true do
  include_context 'with checkout setup'

  before do
    visit spree.root_path

    click_link 'RoR Mug'
    click_button 'add-to-cart-button'

    click_button 'Checkout'
    fill_in 'order_email', with: 'wafel@example.com'

    click_button 'Continue'
  end

  context 'when customer is a private' do
    let(:address_page) { Checkout::AddressPage.new }

    before do
      address_page.billing_address.private_customer_radio.choose
    end

    it 'does not show vat number field' do
      expect(address_page).to be_displayed
      expect(address_page.billing_address).not_to have_vat_number_field
    end
  end

  context 'when customer is a business' do
    let(:address_page) { Checkout::AddressPage.new }

    before do
      address_page.billing_address.business_customer_radio.choose
    end

    it 'allows user to fill in the vat number field' do
      expect(address_page).to be_displayed
      expect(address_page.billing_address).to have_vat_number_field
      address_page.billing_address.fill_in_as_business(attributes: { vat_number: 'IT02112180688' })
      address_page.continue_button.click

      delivery_page = Checkout::DeliveryPage.new
      expect(delivery_page).to be_displayed

      order = Spree::Order.last
      expect(order.billing_address.vat_number).to eq('IT02112180688')
    end
  end
end
