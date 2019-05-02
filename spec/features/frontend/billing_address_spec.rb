# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Billing address', type: :feature, js: true do
  include_context 'with checkout setup'

  context 'when the user is in the confirm checkout step' do
    before do
      visit spree.root_path

      click_link 'RoR Mug'
      click_button 'add-to-cart-button'

      click_button 'Checkout'
      fill_in 'order_email', with: 'wafel@example.com'

      click_button 'Continue'
      address_page = Checkout::AddressPage.new
      address_page.billing_address.fill_in_as_business(attributes: { vat_number: 'IT02112180688' })
      address_page.continue_button.click

      click_button 'Save and Continue'
      click_button 'Save and Continue'
    end

    it 'shows the billing address attributes like vat_number, etc...', aggregate_failures: true do
      confirm_page = Checkout::ConfirmPage.new
      expect(confirm_page).to be_displayed
      expect(confirm_page.bill_address).to have_content('IT02112180688')
    end
  end
end
