# frozen_string_literal: true

module Checkout
  class BillingAddressSection < SitePrism::Section
    element :first_name_field, '#order_bill_address_attributes_firstname'
    element :last_name_field, '#order_bill_address_attributes_lastname'
    element :street_address_field, '#order_bill_address_attributes_address1'
    element :city_field, '#order_bill_address_attributes_city'
    element :country_select, '#order_bill_address_attributes_country_id'
    element :state_select, '#order_bill_address_attributes_state_id'
    element :zip_field, '#order_bill_address_attributes_zipcode'
    element :phone_field, '#order_bill_address_attributes_phone'

    element :personal_tax_code_field, '#order_bill_address_attributes_personal_tax_code'

    def fill_in(attributes: {})
      if Spree::Country.blank? || Spree::State.blank? # rubocop:disable Style/IfUnlessModifier
        raise ArgumentError, 'Cannot fill in an address without at least one country and one state'
      end

      first_name_field.set attributes.fetch(:first_name, FFaker::Name.first_name)
      last_name_field.set attributes.fetch(:last_name, FFaker::Name.last_name)
      street_address_field.set attributes.fetch(:street_address, FFaker::Address.street_address)
      city_field.set attributes.fetch(:city, FFaker::Address.city)
      country_select.select attributes.fetch(:country, Spree::Country.first.name)
      state_select.select attributes.fetch(:state, Spree::Country.first.states.first.name)
      zip_field.set attributes.fetch(:zip, FFaker::AddressUS.zip_code)
      phone_field.set attributes.fetch(:phone, FFaker::PhoneNumber.phone_number)

      personal_tax_code_field.set attributes.fetch(:personal_tax_code, 'RSSVSC52B07M183C')
    end
  end
end
