class AddWithTvaToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :with_tva, :boolean, default: true
  end
end
