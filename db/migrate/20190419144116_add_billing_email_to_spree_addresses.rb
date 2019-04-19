# frozen_string_literal: true

class AddBillingEmailToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :billing_email, :string
  end
end
