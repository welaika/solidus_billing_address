# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Address, type: :model do
  describe 'validations' do
    subject(:address) { build(:address) }

    it { is_expected.to validate_presence_of(:last_name) }

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
end
