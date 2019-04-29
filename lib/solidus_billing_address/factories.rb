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
    address_type 'billing'
  end

  factory :ship_address do
    address_type 'shipping'
  end
end
