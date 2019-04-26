# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    # NOTE: e' il modo giusto per definire una constante da usare dentro a Spree::Address ?
    #       sembra funzionare, ma ho dubbi!
    BILLING_ONLY_ATTRS = %w[personal_tax_code vat_number billing_email einvoicing_code].freeze

    def self.prepended(base)
      base.validates :vat_number, valvat: true, allow_blank: true
      base.validates :billing_email, 'spree/email' => true, allow_blank: true
    end

    Spree::Address.prepend self
  end
end
