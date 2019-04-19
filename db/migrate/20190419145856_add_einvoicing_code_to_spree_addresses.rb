# frozen_string_literal: true

class AddEinvoicingCodeToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :einvoicing_code, :string
  end
end
