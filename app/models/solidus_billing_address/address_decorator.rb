# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    BILLING_ONLY_ATTRS = %w[customer_type personal_tax_code vat_number billing_email einvoicing_code].freeze

    def self.prepended(base)
      base.attr_accessor :address_type

      base.validates :last_name, presence: true # NOTE: solidus does not require its presence!

      base.validates :vat_number, valvat: true, allow_blank: true
      base.validates :vat_number, presence: true, if: :vat_number_required?

      base.validates :personal_tax_code, presence: true, if: :personal_tax_code_required?

      base.validates :billing_email, 'spree/email' => true, allow_blank: true
      base.validates :billing_email, presence: true, if: :billing_email_required?

      base.validates :einvoicing_code, presence: true, if: :einvoicing_code_required?
    end

    def shipping?
      address_type == 'shipping'
    end

    def billing?
      address_type == 'billing'
    end

    def private_customer?
      customer_type == 'private'
    end

    def business_customer?
      customer_type == 'business'
    end

    private

    def vat_number_required?
      billing? && business_customer?
    end

    def personal_tax_code_required?
      billing? && private_customer?
    end

    def italian?
      country_iso == 'IT'
    end

    def italian_business_customer?
      italian? && business_customer?
    end

    def italian_business_customer_billing?
      italian_business_customer? && billing?
    end

    def einvoicing_code_required?
      italian_business_customer_billing? && billing_email.blank?
    end

    def billing_email_required?
      italian_business_customer_billing? && einvoicing_code.blank?
    end

    Spree::Address.prepend self
  end
end
