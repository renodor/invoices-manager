class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.string :name, null: false
      t.string :bic, null: false
      t.string :iban, null: false
      t.boolean :is_default, default: false

      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
