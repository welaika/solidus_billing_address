# frozen_string_literal: true

FactoryBot.define do
  factory :country_it, class: Spree::Country do
    iso_name { 'ITALY' }
    iso { 'IT' }
    iso3 { 'ITA' }
    name { 'Italy' }
    numcode { 380 }
    states_required { true }
  end
end
