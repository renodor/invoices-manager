class AddNumberToQuotes < ActiveRecord::Migration[7.0]
  def change
    add_column :quotes, :number, :string
  end
end
