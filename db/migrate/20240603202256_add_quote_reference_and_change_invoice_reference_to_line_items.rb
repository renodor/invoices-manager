class AddQuoteReferenceAndChangeInvoiceReferenceToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :line_items, :quote, foreign_key: true
    change_column_null :line_items, :invoice_id, true
  end
end
