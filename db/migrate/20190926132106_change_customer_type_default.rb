# frozen_string_literal: true

class ChangeCustomerTypeDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_default :spree_addresses, :customer_type, nil
  end

  def down
    change_column_default :spree_addresses, :customer_type, 'private'
  end
end
