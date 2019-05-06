# frozen_string_literal: true

module SolidusBillingAddress
  module OrderDecorator
    def self.prepended(base); end

    # NOTE: unlike plain solidus, this method creates a new address if
    #       shipping and billing are not the same address.
    #       Solidus, instead, assigns the same billing address ID to
    #       the shipping address
    def assign_billing_to_shipping_address
      return true unless bill_address

      self.ship_address =
        Spree::Address.immutable_merge(
          ship_address,
          bill_address
          .value_attributes
          .except(*Spree::Address::BILLING_ONLY_ATTRS)
          .merge(Spree::Address.shipping_default_attributes)
        )
      true
    end

    Spree::Order.prepend self
  end
end
