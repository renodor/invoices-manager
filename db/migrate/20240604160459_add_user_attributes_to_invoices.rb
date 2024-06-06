class AddUserAttributesToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :seller_name, :string
    add_column :invoices, :seller_address1, :string
    add_column :invoices, :seller_zipcode, :string
    add_column :invoices, :seller_city, :string
    add_column :invoices, :seller_country, :string
    add_column :invoices, :seller_email, :string
    add_column :invoices, :seller_website, :string
    add_column :invoices, :seller_siren, :string
    add_column :invoices, :client_name, :string
    add_column :invoices, :client_address1, :string
    add_column :invoices, :client_address2, :string
    add_column :invoices, :client_zipcode, :string
    add_column :invoices, :client_city, :string
    add_column :invoices, :client_country, :string
  end
end
