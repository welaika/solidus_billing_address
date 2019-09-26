# frozen_string_literal: true

FactoryBot.modify do
  factory :address do
    lastname { 'Doe' }
  end

  factory :bill_address do
    address_type { 'billing' }
    private_customer

    trait :business_customer do
      customer_type { 'business' }
      vat_number { 'IT10300060018' }
      personal_tax_code { 'RSSMRA85H12D553D' }
      billing_email { 'foo@pec.example.com' }
      einvoicing_code { 'SZLUBAI' }
    end

    trait :private_customer do
      customer_type { 'private' }
      personal_tax_code { 'RSSMRA85H12D553D' }
    end
  end

  factory :ship_address do
    address_type { 'shipping' }
    customer_type { nil }
  end
end
