class MakeBankIdMandatoryForInvoices < ActiveRecord::Migration[7.0]
  def change
    change_column_null :invoices, :bank_id, false
  end
end
