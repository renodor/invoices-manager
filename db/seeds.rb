# frozen_string_literal:true

Invoice.all.each { |invoice| invoice.destroy!(do_i_really_want_to_do_it: true) }
LineItem.destroy_all
Bank.destroy_all
Client.all.each { |client| client.destroy!(do_i_really_want_to_do_it: true) }
User.all.each { |user| user.destroy!(do_i_really_want_to_do_it: true) }

user = User.create!(
  email: "batman@gmail.com",
  password: "Azerty123",
  first_name: "Bruce",
  last_name: "Wayne",
  address1: "10 Rue de par ici",
  zipcode: "00000",
  city: "Cool City",
  country: "France",
  website: "www.website.co",
  siren: "000 000 000",
)

bank = Bank.create!(
  name: "Cool bank",
  bic: "AAAAAAAA",
  iban: "FR76 0000 0000 0000 0000 0000 000",
  is_default: true,
  user: user
)

5.times do |n|
  Client.create!(
    name: "Cool Client #{n + 1}",
    address1: "#{n + 1} Rue de là bas",
    zipcode: "00000",
    city: "Cool City",
    country: "France",
    user: user
  )
end

client = Client.first

5.times do |n|
  invoice = Invoice.new(
    date: DateTime.current,
    title: "Services de développement web",
    user: user,
    bank: bank,
    client: client,
    flavor: [0, 1, 2].sample,
    seller_name: user.full_name,
    seller_address1: user.address1,
    seller_zipcode: user.zipcode,
    seller_city: user.city,
    seller_country: user.country,
    seller_email: user.email,
    seller_website: user.website,
    seller_siren: user.siren,
    client_name: client.name,
    client_address1: client.address1,
    client_address2: client.address2,
    client_zipcode: client.zipcode,
    client_city: client.city
  )

  2.times do |i|
    LineItem.create!(
      description: "Cool Line Item #{i + 1}",
      quantity: i + 1,
      unit_price: rand(0..100.00),
      invoice: invoice
    )
  end
end

5.times do |n|
  quote = Quote.new(
    date: DateTime.current,
    title: "Services de développement web",
    user: user,
    client_name: "Cool client #{n + 1}",
    client_address1: "1 Rue cool",
    client_zipcode: "13004",
    client_city: "Marseille",
    client_country: "France",
    flavor: [0, 1, 2].sample,
    with_agreement: [true, false].sample
  )

  2.times do |i|
    LineItem.create!(
      description: "Cool Line Item #{i + 1}",
      quantity: i + 1,
      unit_price: rand(0..100.00),
      quote: quote
    )
  end
end
