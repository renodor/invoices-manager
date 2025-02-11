class AddAdvanceToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :advance, :boolean, default: false, null: false
  end
end
