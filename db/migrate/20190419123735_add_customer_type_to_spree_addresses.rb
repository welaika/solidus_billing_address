class AddCustomerTypeToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :customer_type, :string
  end
end
