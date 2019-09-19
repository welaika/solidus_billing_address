# frozen_string_literal: true

class AddAddressTypeToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :address_type, :string
  end
end
