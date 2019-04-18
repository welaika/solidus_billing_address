# frozen_string_literal: true

class AddPersonalTaxCodeToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :personal_tax_code, :string
  end
end
