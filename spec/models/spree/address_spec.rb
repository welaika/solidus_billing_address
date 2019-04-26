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
end
