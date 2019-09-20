# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Customer type for billing address in checkout step', type: :feature, js: true do
  include_context 'with checkout setup'

  before do
    visit spree.root_path

    click_link 'RoR Mug'
    click_button 'add-to-cart-button'

    click_button 'Checkout'
    fill_in 'order_email', with: 'wafel@example.com'

    click_button 'Continue'
  end

  it 'allows user to choose between personal and business billing address' do
    address_page = Checkout::AddressPage.new
    expect(address_page).to be_displayed

    expect(address_page.billing_address).to have_business_customer_radio
    expect(address_page.billing_address).to have_private_customer_radio
  end

  context 'when customer selects "private"' do
    let(:address_page) { Checkout::AddressPage.new }

    before do
      address_page.billing_address.private_customer_radio.choose
    end

    it 'shows only fields for private billing address', aggregate_failures: true do
      address_section = address_page.billing_address

      expect(address_section).to have_personal_tax_code_field
      expect(address_section).not_to have_company_field
      expect(address_section).not_to have_vat_number_field
      expect(address_section).not_to have_billing_email_field
      expect(address_section).not_to have_einvoicing_code_field
    end
  end

  context 'when customer selects "business"' do
    let(:address_page) { Checkout::AddressPage.new }

    before do
      address_page.billing_address.business_customer_radio.choose
    end

    it 'shows only fields for business billing address', aggregate_failures: true do
      address_section = address_page.billing_address

      expect(address_section).to have_personal_tax_code_field
      expect(address_section).to have_company_field
      expect(address_section).to have_vat_number_field
      expect(address_section).to have_billing_email_field
      expect(address_section).to have_einvoicing_code_field
    end
  end
end
