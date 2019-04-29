# frozen_string_literal: true

Spree.config do |config|
  config.company = true # solidus defaults: false
end

Spree::PermittedAttributes.address_attributes.push :address_type,
                                                   :customer_type,
                                                   :personal_tax_code,
                                                   :vat_number,
                                                   :billing_email,
                                                   :einvoicing_code
