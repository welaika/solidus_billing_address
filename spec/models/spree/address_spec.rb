# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Address, type: :model do
  describe 'validations' do
    subject(:address) { build(:address) }

    it { is_expected.not_to allow_value('NOT A VAT').for(:vat_number) }
    it { is_expected.to allow_values('IT10300060018', '', nil).for(:vat_number) }

    it { is_expected.not_to allow_value('NOT AN EMAIL').for(:billing_email) }
    it { is_expected.to allow_value('giuseppe@pec.it', '', nil).for(:billing_email) }

    context 'with a billing address' do
      context 'when address is a business one' do
        subject(:address) { build(:bill_address, :business_customer) }

        it { is_expected.to validate_presence_of(:vat_number) }
        it { is_expected.not_to validate_presence_of(:personal_tax_code) }
      end

      context 'when address ia a private one' do
        subject(:address) { build(:bill_address, :private_customer) }

        it { is_expected.not_to validate_presence_of(:vat_number) }
        it { is_expected.to validate_presence_of(:personal_tax_code) }
      end
    end

    context 'with a shipping address' do
      subject(:address) { build(:ship_address) }

      it { is_expected.not_to validate_presence_of(:vat_number) }
      it { is_expected.not_to validate_presence_of(:personal_tax_code) }
    end
  end

  describe '::BILLING_ONLY_ATTRS' do
    it 'defines a list of attributes that are relevant for billing address only' do
      expect(described_class::BILLING_ONLY_ATTRS).to match_array(
        %w[customer_type personal_tax_code vat_number billing_email einvoicing_code]
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

  describe '#shipping?' do
    context 'when `address_type` is "shipping"' do
      subject { build(:address, address_type: 'shipping').shipping? }

      it { is_expected.to be(true) }
    end

    context 'when `address_type` is "billing"' do
      subject { build(:address, address_type: 'billing').shipping? }

      it { is_expected.not_to be(true) }
    end
  end

  describe '#billing?' do
    context 'when `address_type` is "shipping"' do
      subject { build(:address, address_type: 'shipping').billing? }

      it { is_expected.not_to be(true) }
    end

    context 'when `address_type` is "billing"' do
      subject { build(:address, address_type: 'billing').billing? }

      it { is_expected.to be(true) }
    end
  end

  describe '#private_customer?' do
    context 'when `customer_type` is "private"' do
      subject { build(:address, customer_type: 'private').private_customer? }

      it { is_expected.to be(true) }
    end

    context 'when `customer_type` is "business"' do
      subject { build(:address, customer_type: 'business').private_customer? }

      it { is_expected.to be(false) }
    end
  end

  describe '#business_customer?' do
    context 'when `customer_type` is "private"' do
      subject { build(:address, customer_type: 'private').business_customer? }

      it { is_expected.to be(false) }
    end

    context 'when `customer_type` is "business"' do
      subject { build(:address, customer_type: 'business').business_customer? }

      it { is_expected.to be(true) }
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
