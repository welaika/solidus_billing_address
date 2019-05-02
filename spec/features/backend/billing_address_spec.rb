# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Billing address in the backend', type: :feature, js: true do
  stub_authorization!

  it 'shows billing only attrs in the order/customer tab' do
    order = create(:completed_order_with_totals)

    visit spree.edit_admin_order_customer_path(order_id: order.number)

    Spree::Address::BILLING_ONLY_ATTRS.each do |attr|
      expect(page).to have_field("order[bill_address_attributes][#{attr}]")
    end
  end
end
