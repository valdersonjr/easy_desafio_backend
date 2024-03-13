# require 'faker'

namespace :dev do
  desc 'Populate development database with sample data'

  task :prime => :environment do
    puts 'Populating development database...'

    start_time = Time.now

    50.times do |i|
      Load.create(
        code: "LD#{rand(1000..9999)}",
        delivery_date: Date.today + (i + 1).weeks
      )
    end

    50.times do |i|
      Product.create(
        name: "Produto #{i + 1}",
        ballast: rand(1..99)
      )
    end

    50.times do |i|
      Order.create(
        code: "OR#{rand(1000..9999)}",
        bay: "BAY#{rand(1..10)}",
        load_id: Load.all.sample.id
        )
    end

    50.times do |i|
      OrderProduct.create(
        order_id: Order.all.sample.id,
        product_id: Product.all.sample.id,
        quantity: rand(1..99),
        box: [true, false].sample
      )
    end

    50.times do |i|
      User.create(
        email: "email@#{i}.com",
        name: "name#{i}",
        password: "123123",
        password_confirmation: "123123",
        profile: 0
      )
    end


    end_time = Time.now
    processing_time = end_time - start_time

    User.create(
        email: 'valtin@easy.com',
        name: 'Valtin',
        password: "123123",
        password_confirmation: "123123",
        profile: 0
    )

    puts "Development database populated successfully."
    puts "Processing time: #{processing_time} seconds"
  end
end
