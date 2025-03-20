class CreateDescriptionBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :description_blocks do |t|
      t.text :text, null: false
      t.integer :position, null: false
      t.integer :flavor, null: false
      t.references :quote, null: false, foreign_key: true
      t.timestamps
    end
  end
end
