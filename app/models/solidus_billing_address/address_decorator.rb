# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    BILLING_ONLY_ATTRS = %w[customer_type personal_tax_code vat_number billing_email einvoicing_code].freeze

    def self.prepended(base) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      base.before_validation :normalize_vat_number
      base.before_validation :normalize_personal_tax_code
      base.before_validation :normalize_einvoicing_code
      base.before_validation :normalize_billing_email

      base.validates :lastname, presence: true # NOTE: solidus does not require its presence, but we do!
      base.validates :company, presence: true, if: :company_required?

      base.validates :vat_number, valvat: true, allow_blank: true
      base.validates :vat_number, presence: true, if: :vat_number_required?

      base.validates :personal_tax_code, italian_personal_tax_code: { allow_vat_numbers: ->(a) { a.business_customer? } },
                                         allow_blank: true,
                                         if: :italian_personal_tax_code_format_required?
      base.validates :personal_tax_code, presence: true, if: :personal_tax_code_required?

      base.validates :billing_email, 'spree/email' => true, allow_blank: true
      base.validates :billing_email, presence: true, if: :billing_email_required?

      base.validates :einvoicing_code, italian_einvoicing_code: true,
                                       allow_blank: true,
                                       if: :italian_einvoicing_code_format_required?
      base.validates :einvoicing_code, presence: true, if: :einvoicing_code_required?
    end

    def shipping?
      address_type == 'shipping'
    end

    # NOTE: actually, a billing address can be also a shipping address because
    # solidus does not duplicate the records, but it will be ok :)
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

    def company_required?
      billing? && business_customer?
    end

    def vat_number_required?
      billing? && business_customer?
    end

    def personal_tax_code_required?
      billing?
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

    def italian_personal_tax_code_format_required?
      personal_tax_code_required? && italian?
    end

    def italian_einvoicing_code_format_required?
      einvoicing_code_required? && italian?
    end

    def normalize_vat_number
      return if vat_number.blank?

      self.vat_number = vat_number.tr(' ', '').upcase
      self.vat_number = "IT#{vat_number}" if italian? && vat_number.match?(/\A[0-9]{11}\z/)
    end

    def normalize_personal_tax_code
      return if personal_tax_code.blank?

      self.personal_tax_code = personal_tax_code.tr(' ', '').upcase
    end

    def normalize_einvoicing_code
      return if einvoicing_code.blank?

      self.einvoicing_code = einvoicing_code.tr(' ', '').upcase
    end

    def normalize_billing_email
      return if billing_email.blank?

      self.billing_email = billing_email.tr(' ', '').downcase
    end

    Spree::Address.prepend self
  end
end
