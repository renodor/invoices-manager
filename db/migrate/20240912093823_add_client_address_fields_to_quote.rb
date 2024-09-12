class AddClientAddressFieldsToQuote < ActiveRecord::Migration[7.0]
  def change
    add_column :quotes, :client_address1, :string
    add_column :quotes, :client_address2, :string
    add_column :quotes, :client_zipcode, :string
    add_column :quotes, :client_city, :string
    add_column :quotes, :client_country, :string
  end
end
