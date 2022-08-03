class RemoveBicandIbanFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :bic, :string
    remove_column :users, :iban, :string
  end
end
