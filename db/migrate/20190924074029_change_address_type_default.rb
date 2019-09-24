# frozen_string_literal: true

class ChangeAddressTypeDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_default :spree_addresses, :address_type, nil
  end

  def down
    change_column_default :spree_addresses, :address_type, 'billing'
  end
end
