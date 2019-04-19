# frozen_string_literal: true

module Checkout
  class BillingAddressSection < SitePrism::Section
    element :first_name_field, '#order_bill_address_attributes_firstname'
    element :last_name_field, '#order_bill_address_attributes_lastname'
    element :company_field, '#order_bill_address_attributes_company'
    element :street_address_field, '#order_bill_address_attributes_address1'
    element :city_field, '#order_bill_address_attributes_city'
    element :country_select, '#order_bill_address_attributes_country_id'
    element :state_select, '#order_bill_address_attributes_state_id'
    element :zip_field, '#order_bill_address_attributes_zipcode'
    element :phone_field, '#order_bill_address_attributes_phone'

    element :private_customer_radio, '#order_bill_address_attributes_customer_type_private'
    element :business_customer_radio, '#order_bill_address_attributes_customer_type_business'

    element :personal_tax_code_field, '#order_bill_address_attributes_personal_tax_code'
    element :vat_number_field, '#order_bill_address_attributes_vat_number'

    def fill_in(attributes: {})
      if Spree::Country.blank? || Spree::State.blank? # rubocop:disable Style/IfUnlessModifier
        raise ArgumentError, 'Cannot fill in an address without at least one country and one state'
      end

      private_customer_radio.choose if attributes.fetch(:customer_type, 'private').to_s == 'private'
      business_customer_radio.choose if attributes.fetch(:customer_type, 'business').to_s == 'business'

      first_name_field.set attributes.fetch(:first_name, FFaker::Name.first_name)
      last_name_field.set attributes.fetch(:last_name, FFaker::Name.last_name)
      company_field.set attributes.fetch(:company, FFaker::Company.name)
      street_address_field.set attributes.fetch(:street_address, FFaker::Address.street_address)
      city_field.set attributes.fetch(:city, FFaker::Address.city)
      country_select.select attributes.fetch(:country, Spree::Country.first.name)
      state_select.select attributes.fetch(:state, Spree::Country.first.states.first.name)
      zip_field.set attributes.fetch(:zip, FFaker::AddressUS.zip_code)
      phone_field.set attributes.fetch(:phone, FFaker::PhoneNumber.phone_number)

      personal_tax_code_field.set attributes.fetch(:personal_tax_code, 'RSSVSC52B07M183C')
      vat_number_field.set attributes.fetch(:vat_number, 'IT10300060018')
    end
  end
end
