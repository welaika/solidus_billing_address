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
    element :billing_email_field, '#order_bill_address_attributes_billing_email'
    element :einvoicing_code_field, '#order_bill_address_attributes_einvoicing_code'

    def fill_in_as_private(attributes: {})
      private_customer_radio.choose
      fill_in_basic(attributes: attributes)
      personal_tax_code_field.set attributes.fetch(:personal_tax_code, 'RSSVSC52B07M183C')
    end

    def fill_in_as_business(attributes: {})
      business_customer_radio.choose
      fill_in_basic(attributes: attributes)
      company_field.set attributes.fetch(:company, FFaker::Company.name)
      vat_number_field.set attributes.fetch(:vat_number, 'IT10300060018')
      billing_email_field.set attributes.fetch(:billing_email, FFaker::Internet.email)
      einvoicing_code_field.set attributes.fetch(:einvoicing_code, '0000000')
      personal_tax_code_field.set attributes.fetch(:personal_tax_code, 'RSSVSC52B07M183C')
    end

    def fill_in_basic(attributes: {})
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
    end
  end
end
