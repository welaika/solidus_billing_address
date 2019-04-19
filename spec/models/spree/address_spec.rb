# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Address, type: :model do
  describe 'vat_number' do
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
end
