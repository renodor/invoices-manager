# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
task reset_demo_account: :environment do
  demo_user = User.find_by(email: Rails.application.credentials.demo_user_email)

  if demo_user.blank?
    puts 'No demo user found'
    next
  end

  puts '**WARNING** This task is not reversible and needs confirmation'
  puts "You are about to reset data for user with email: \"#{demo_user.email}\", type \"#{demo_user.email}\" to confirm:"

  input = $stdin.gets.chomp

  raise 'Task execution was aborted.' if input != demo_user.email

  if demo_user
    puts 'Destroy all demo user invoices'
    demo_user.invoices.each { |invoice| invoice.destroy!(do_i_really_want_to_do_it: true) }

    puts 'Destroy all demo user clients'
    demo_user.clients.each { |client| client.destroy!(do_i_really_want_to_do_it: true) }

    puts 'Destroy all demo user banks'
    demo_user.banks.destroy_all

    puts 'Destroy user demo'
    demo_user.reload.destroy!(do_i_really_want_to_do_it: true)

    puts '###################################'
  end

  puts 'Create demo user'

  demo_user = User.create!(
    email: Rails.application.credentials.demo_user_email,
    password: Rails.application.credentials.demo_user_password,
    first_name: 'Demo',
    last_name: 'User',
    address1: '1 Avenue de par ici',
    zipcode: '13000',
    city: 'Marseille',
    country: 'France',
    website: 'www.renodor.co',
    siren: '000 000 000',
    username: 'Demo User'
  )

  puts 'Create demo user bank'

  demo_user.banks.create!(
    name: 'Bank 1',
    bic: 'ABCDEFGH',
    iban: 'FR00 0000 0000 0000 0000 0000 000',
    is_default: true
  )

  puts 'Create demo user clients'

  client1 = demo_user.clients.create!(
    name: 'Client 1',
    address1: '5 Rue de là-bas',
    zipcode: '75000',
    city: 'Paris',
    country: 'France'
  )

  client2 = demo_user.clients.create!(
    name: 'Client 2',
    address1: '10 impasse plus loin',
    zipcode: '69000',
    city: 'Lyon',
    country: 'France'
  )

  puts 'Create demo user invoices'

  invoice1 = demo_user.invoices.builld(
    title: 'Titre général de la facture 1',
    client: client1,
    date: Date.current - 32.days,
    locked: true
  )
  populate_invoice_seller_and_client_infos(invoice1)
  invoice1.save!

  invoice1.line_items.create!(
    description: 'Item 1',
    quantity: '1',
    unit_price: 2350
  )

  invoice1.line_items.create!(
    description: 'Item 2',
    quantity: '1',
    unit_price: 175.26
  )

  invoice2 = demo_user.invoices.build(
    title: 'Titre général de la facture 2',
    date: Date.current - 11.days,
    client: client1
  )
  populate_invoice_seller_and_client_infos(invoice2)
  invoice2.save!

  invoice2.line_items.create!(
    description: 'Item 1',
    quantity: '1',
    unit_price: 550
  )

  invoice2.line_items.create!(
    description: 'Item 2',
    quantity: '2',
    unit_price: 100.33
  )

  invoice3 = demo_user.invoices.build(
    title: 'Titre général de la facture 3',
    date: Date.current,
    client: client2
  )
  populate_invoice_seller_and_client_infos(invoice3)
  invoice3.save!

  invoice3.line_items.create!(
    description: 'Item 1',
    quantity: '1',
    unit_price: 22.50
  )

  invoice3.line_items.create!(
    description: 'Item 2',
    quantity: '1',
    unit_price: 33.32
  )

  invoice3.line_items.create!(
    description: 'Item 3',
    quantity: '2',
    unit_price: 60.10
  )

  invoice3.line_items.create!(
    description: 'Item 4',
    quantity: '3',
    unit_price: 100.41
  )
end
# rubocop:enable Metrics/BlockLength

def populate_invoice_seller_and_client_infos(invoice)
  invoice.seller_name = invoice.user.full_name
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
end
