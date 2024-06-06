# frozen_string_literal: true

task populate_invoices_seller_and_client_infos: :environment do
  Invoice.each do |invoice|
    invoice.attributes = invoice_params
    invoice.seller_name = current_user.full_name(with_ei_mention: invoice.date >= Date.new(2023, 2, 23))
    invoice.seller_address1 = current_user.address1
    invoice.seller_zipcode = current_user.zipcode
    invoice.seller_city = current_user.city
    invoice.seller_country = current_user.country
    invoice.seller_email = current_user.email
    invoice.seller_website = current_user.website
    invoice.seller_siren = current_user.siren
    invoice.client_name = invoice.client.name

    invoice.client_address1 = invoice.client.address1
    invoice.client_address2 = invoice.client.address2
    invoice.client_zipcode = invoice.client.zipcode
    invoice.client_city = invoice.client.city

    invoice.save!
  end
end

