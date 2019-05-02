# frozen_string_literal: true

FactoryBot.modify do
  factory :address do
    # NOTE: I created this trait to have a fix set of attributes.
    #       It's useful when we want to create a billing address that
    #       is the same as the shipping address
    trait :susan do
      firstname { 'Susan' }
      lastname { 'Fakeness' }
      company { 'Company' }
      address1 { '10 Lovely Street' }
      address2 { 'Northwest' }
      city { 'Herndon' }
      zipcode { '10001' }
      country_iso_code { 'US' }
      state_code { 'AL' }
      phone { '555-555-0199' }
      alternative_phone { '555-555-0199' }
    end
  end

  factory :bill_address do
    address_type { 'billing' }
    private_customer

    trait :business_customer do
      customer_type { 'business' }
      vat_number { 'IT10300060018' }
      billing_email { 'foo@example.com' }
      einvoicing_code { 'SZLUBAI' }
    end

    trait :private_customer do
      customer_type { 'private' }
      personal_tax_code { 'VIVA VASCO' }
    end
  end

  factory :ship_address do
    address_type { 'shipping' }
    customer_type { nil }
  end
end
