# frozen_string_literal: true

class AddVatNumberToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :vat_number, :string
  end
end
