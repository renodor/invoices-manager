class RemoveInvoiceWithTvaAttribute < ActiveRecord::Migration[7.0]
  def change
    remove_column :invoices, :with_tva, :boolean, default: true
  end
end
