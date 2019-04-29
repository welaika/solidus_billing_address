# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Address, type: :model do
  describe '#vat_number' do
    let(:address) { build(:address) }

    it 'can be empty' do
      address.vat_number = ''
      address.validate
      expect(address.errors[:vat_number]).to be_empty
    end

    it 'adds an error if the vat number is not syntactically valid' do
      address.vat_number = 'not a vat number'
      address.validate
      expect(address.errors[:vat_number]).to be_present
    end

    it 'does not add an error if the vat number is syntactically valid' do
      address.vat_number = 'IT10300060018'
      address.validate
      expect(address.errors[:vat_number]).to be_blank
    end
  end

  describe '#billing_email' do
    let(:address) { build(:address) }

    it 'can be empty' do
      address.billing_email = ''
      address.validate
      expect(address.errors[:billing_email]).to be_empty
    end

    it 'adds an error if the billing email is not a valid email' do
      address.billing_email = 'not an email'
      address.validate
      expect(address.errors[:billing_email]).to be_present
    end

    it 'does not add an error if the billign email is a valid email' do
      address.billing_email = 'example@pec.it'
      address.validate
      expect(address.errors[:billing_email]).to be_blank
    end
  end

  describe '::BILLING_ONLY_ATTRS' do
    it 'defines a list of attributes that are relevant for billing address only' do
      expect(described_class::BILLING_ONLY_ATTRS).to match_array(
        %w[personal_tax_code vat_number billing_email einvoicing_code]
      )
    end
  end

  describe '==' do
    context 'when matching a billing vs a billing address' do
      context 'when addresses have the same attributes (both geographic and billing codes (vat, etc..))' do
        let(:address) { create(:bill_address, :susan, vat_number: 'IT10300060018') }
        let(:another_address) { create(:bill_address, :susan, vat_number: 'IT10300060018') }

        it 'returns true' do
          expect(address).to eq(another_address)
        end
      end

      context 'when addresses have the same geographic attributes, but different billing codes (vat, etc..))' do
        let(:address) { create(:bill_address, :susan, vat_number: 'IT10300060018') }
        let(:another_address) { create(:bill_address, :susan, vat_number: 'IT02112180688') }

        it 'returns false' do
          expect(address).not_to eq(another_address)
        end
      end

      context 'when addresses have the same billing codes (vat, etc..), but different geographic attributes' do
        let(:address) { create(:bill_address, firstname: 'Sarah', vat_number: 'IT10300060018') }
        let(:another_address) { create(:bill_address, firstname: 'Marioh', vat_number: 'IT10300060018') }

        it 'retruns false' do
          expect(address).not_to eq(another_address)
        end
      end
    end

    context 'when matching a shipping vs a shipping address' do
      context 'when address have the same geographic attributes' do
        let(:address) { create(:ship_address, :susan) }
        let(:another_address) { create(:ship_address, :susan) }

        it 'returns true' do
          expect(address).to eq(another_address)
        end
      end

      context 'when address have **not** the same geographic attributes' do
        let(:address) { create(:ship_address, firstname: 'Sarah') }
        let(:another_address) { create(:ship_address, firstname: 'Marioh') }

        it 'returns false' do
          expect(address).not_to eq(another_address)
        end
      end
    end

    context 'when matching a billing vs a shipping address' do
      context 'when addresses have the same geographic attributes' do
        let(:address) { create(:bill_address, :susan, vat_number: 'IT10300060018') }
        let(:another_address) { create(:ship_address, :susan) }

        it 'returns true' do
          expect(address).to eq(another_address)
        end
      end

      context 'when addresses have **not** the same geographic attributes' do
        let(:address) { create(:bill_address, firstname: 'Sarah', vat_number: 'IT10300060018') }
        let(:another_address) { create(:ship_address, firstname: 'Marioh') }

        it 'returns false' do
          expect(address).not_to eq(another_address)
        end
      end
    end
  end

  describe '.shipping_default_attributes' do
    it 'returns an hash of attributes with default values for shipping address' do
      expect(described_class.shipping_default_attributes).to eq(
        address_type: 'shipping',
        personal_tax_code: nil,
        vat_number: nil,
        billing_email: nil,
        einvoicing_code: nil
      )
    end
  end
end
