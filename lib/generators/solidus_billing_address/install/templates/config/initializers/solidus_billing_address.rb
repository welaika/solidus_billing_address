# frozen_string_literal: true

Spree.config do |config|
  config.company = true # solidus defaults: false
end

Spree::PermittedAttributes.address_attributes.push :personal_tax_code