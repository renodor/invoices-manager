class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :title
      t.string :client_name, null: false
      t.date :date, null: false
      t.text :description

      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
