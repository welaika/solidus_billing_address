# frozen_string_literal: true

module SolidusBillingAddress
  module AddressDecorator
    Spree::Address.prepend self
  end
end
