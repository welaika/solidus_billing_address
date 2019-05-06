# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    # NOTE: e' il modo giusto per definire una constante da usare dentro a Spree::Address ?
    #       sembra funzionare, ma ho dubbi!
    BILLING_ONLY_ATTRS = %w[customer_type personal_tax_code vat_number billing_email einvoicing_code].freeze

    def self.prepended(base)
      base.extend(ClassMethods)
      base.validates :last_name, presence: true
      base.validates :vat_number, valvat: true, allow_blank: true
      base.validates :billing_email, 'spree/email' => true, allow_blank: true

      base.validates :vat_number, presence: true, if: :vat_number_required?
      base.validates :personal_tax_code, presence: true, if: :personal_tax_code_required?
    end

    # NOTE: This method overrides the one in `Spree::Address` class.
    #       When address type are the same, we match against all value attributes.
    #       When we match different address types (billing vs shipping), we care only
    #       about the base address fields (we remove the billing only attributes). This is
    #       useful when we want to know that a package should be shipped to the same location
    #       of a billing address.
    def ==(other_address) # rubocop:disable Naming/BinaryOperatorParameterName
      return false unless other_address&.respond_to?(:value_attributes)

      if address_type == other_address.address_type
        value_attributes == other_address.value_attributes
      else
        excluded_attributes = BILLING_ONLY_ATTRS + %w[address_type]
        value_attributes.except(*excluded_attributes) ==
          other_address.value_attributes.except(*excluded_attributes)
      end
    end

    def shipping?
      address_type == 'shipping'
    end

    def billing?
      address_type == 'billing'
    end

    def private_customer?
      # FIXME: test...
      customer_type == 'private'
    end

    def business_customer?
      # FIXME: test...
      customer_type == 'business'
    end

    private # NOTE: is this valid??

    def vat_number_required?
      billing? && business_customer?
    end

    def personal_tax_code_required?
      billing? && private_customer?
    end

    module ClassMethods
      def shipping_default_attributes
        {
          address_type: 'shipping',
          personal_tax_code: nil,
          vat_number: nil,
          billing_email: nil,
          einvoicing_code: nil
        }
      end
    end

    Spree::Address.prepend self
  end
end
