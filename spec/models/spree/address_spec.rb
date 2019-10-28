# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Address, type: :model do
  # rubocop:disable RSpec/NestedGroups
  describe 'validations' do
    subject(:address) { build(:address) }

    it { is_expected.to validate_presence_of(:lastname) }

    it { is_expected.not_to allow_value('NOT A VAT').for(:vat_number) }
    it { is_expected.to allow_values('IT10300060018', '', nil).for(:vat_number) }

    it { is_expected.not_to allow_value('NOT AN EMAIL').for(:billing_email) }
    it { is_expected.to allow_value('giuseppe@pec.it', '', nil).for(:billing_email) }

    context 'with a billing address' do
      context 'when address is a business one' do
        subject(:address) { build(:bill_address, :business_customer) }

        it { is_expected.to validate_presence_of(:vat_number) }
        it { is_expected.to validate_presence_of(:personal_tax_code) }
        it { is_expected.to allow_value('whatever').for(:personal_tax_code) }
        it { is_expected.to allow_value('whatever').for(:einvoicing_code) }

        context 'when the business is in italy' do
          subject(:address) { build(:bill_address, :business_customer, country: create(:country_it)) }

          it { is_expected.to allow_values('IT10300060018', '10300060018', 'RSSVSC52B07M183C').for(:personal_tax_code) }
          it { is_expected.to allow_values('SZLUBAI', '0000000', 'FOO1234').for(:einvoicing_code) }

          context 'when billing_email and einvoicing_code are both blank' do
            before do
              address.billing_email = nil
              address.einvoicing_code = nil
            end

            it { is_expected.to validate_presence_of(:billing_email) }
            it { is_expected.to validate_presence_of(:einvoicing_code) }
          end

          context 'when billing_email is present, but einvoicing_code not' do
            before do
              address.billing_email = 'foo@pec.example.com'
              address.einvoicing_code = nil
            end

            it { is_expected.to validate_presence_of(:billing_email) }
            it { is_expected.not_to validate_presence_of(:einvoicing_code) }
          end

          context 'when einvoicing_code is present, but billing_email not' do
            before do
              address.billing_email = nil
              address.einvoicing_code = 'SZZZXXX'
            end

            it { is_expected.not_to validate_presence_of(:billing_email) }
            it { is_expected.to validate_presence_of(:einvoicing_code) }
          end
        end

        context 'when business is not in italy' do
          subject(:address) { build(:bill_address, :business_customer, country: create(:country)) }

          it { is_expected.not_to validate_presence_of(:billing_email) }
          it { is_expected.not_to validate_presence_of(:einvoicing_code) }
        end
      end

      context 'when address ia a private one' do
        subject(:address) { build(:bill_address, :private_customer) }

        it { is_expected.not_to validate_presence_of(:vat_number) }
        it { is_expected.to validate_presence_of(:personal_tax_code) }
        it { is_expected.to allow_value('whatever').for(:personal_tax_code) }

        context 'when private is in italy' do
          subject(:address) { build(:bill_address, :private_customer, country: create(:country_it)) }

          it { is_expected.to allow_value('RSSVSC52B07M183C').for(:personal_tax_code) }
          it { is_expected.not_to allow_values('IT10300060018', '10300060018').for(:personal_tax_code) }
          it { is_expected.not_to validate_presence_of(:billing_email) }
          it { is_expected.not_to validate_presence_of(:einvoicing_code) }
        end
      end
    end

    context 'with a shipping address' do
      subject(:address) { build(:ship_address) }

      it { is_expected.not_to validate_presence_of(:vat_number) }
      it { is_expected.not_to validate_presence_of(:personal_tax_code) }
      it { is_expected.not_to validate_presence_of(:billing_email) }
      it { is_expected.not_to validate_presence_of(:einvoicing_code) }
    end
  end
  # rubocop:enable RSpec/NestedGroups

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
