# frozen_string_literal: true

task populate_invoices_seller_and_client_infos: :environment do
  Invoice.all.each do |invoice|
    invoice.seller_name = invoice.user.full_name(with_ei_mention: invoice.date >= Date.new(2023, 2, 23))
    invoice.seller_address1 = invoice.user.address1
    invoice.seller_zipcode = invoice.user.zipcode
    invoice.seller_city = invoice.user.city
    invoice.seller_country = invoice.user.country
    invoice.seller_email = invoice.user.email
    invoice.seller_website = invoice.user.website
    invoice.seller_siren = invoice.user.siren

    invoice.client_name = invoice.client.name
    invoice.client_address1 = invoice.client.address1
    invoice.client_address2 = invoice.client.address2
    invoice.client_zipcode = invoice.client.zipcode
    invoice.client_city = invoice.client.city

    invoice.save!
  end
end
