# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    def self.prepended(base)
      base.validates :vat_number, valvat: true, allow_blank: true
    end

    Spree::Address.prepend self
  end
end
