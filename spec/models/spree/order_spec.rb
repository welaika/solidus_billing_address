# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Order, type: :model do
  describe '#assign_billing_to_shipping_address' do
    let(:bill_address) { nil }
    let(:ship_address) { nil }
    let(:order) { create(:order, bill_address: bill_address, ship_address: ship_address) }

    context 'when `use_billing` is true' do
      before do
        # NOTE: use_billing is an attr_accessor; it's not a real attribute
        order.use_billing = true
      end

      context 'when both billing and shipping address do not exist' do
        let(:bill_address) { nil }
        let(:ship_address) { nil }

        it 'does not create a shipping address from nowhere!' do
          order.save!
          expect(order.ship_address).to be_blank
        end
      end

      context 'when shipping address does not exist' do
        let(:bill_address) { create(:bill_address) }
        let(:ship_address) { nil }

        it 'clones the billing address into a **new** shipping address' do
          order.save!
          expect(order.ship_address).to be_present
          expect(order.bill_address.id).not_to eq(order.ship_address.id)
        end
      end

      context 'when shipping address already exists, and it differs from billing address' do
        let(:bill_address) { create(:bill_address, city: 'New York') }
        let(:ship_address) { create(:ship_address, city: 'Springfield') }

        it 'clones the billing address into a **new** shipping address' do
          previous_ship_address_id = ship_address.id
          order.save!
          expect(order.bill_address.id).not_to eq(order.ship_address.id)
          expect(order.ship_address.id).not_to eq(previous_ship_address_id)
        end
      end

      context 'when shipping address already exists, and it is "the same" as the billing address' do
        let(:bill_address) { create(:bill_address, :susan) }
        let(:ship_address) { create(:ship_address, :susan) }

        it 'does not clone again the billing address into a **new** shipping address' do
          previous_ship_address_id = order.ship_address.id
          order.save!
          expect(order.ship_address.id == previous_ship_address_id).to be(true)
        end
      end
    end

    context 'when `use_billing` is false' do
      let(:bill_address) { create(:bill_address) }
      let(:ship_address) { create(:ship_address) }

      before do
        order.use_billing = false
        allow(order).to receive(:assign_billing_to_ship_address)
      end

      it 'does not call the method at all' do
        order.save!
        expect(order).not_to have_received(:assign_billing_to_ship_address)
      end
    end
  end
end
