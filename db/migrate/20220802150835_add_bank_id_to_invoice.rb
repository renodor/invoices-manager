class AddBankIdToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoices, :bank, foreign_key: true, null: false
  end
end
