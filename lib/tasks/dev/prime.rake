require 'faker'

namespace :dev do
  desc 'Populate development database with sample data'

  task :prime => :environment do
    puts 'Populating development database...'

    start_time = Time.now

    5.times do |i|
      Load.create(
        code: "LD#{rand(1000..9999)}",
        delivery_date: Date.today + (i + 1).weeks
      )
    end

    5.times do |i|
      Order.create(
        code: "OR#{rand(1000..9999)}",
        bay: "BAY#{rand(10..99)}",
        sorted: false,
        load_id: Load.all.sample.id
        )
    end

    50.times do |i|
      order_id = Order.first.id
      product_id = Product.all.sample.id

      next if OrderProduct.where(order_id: order_id).count >= 4

      OrderProduct.create(
        order_id: order_id,
        product_id: product_id,
        quantity: rand(10..99),
        box: [true, false].sample
      )
    end

    # 25.times do |i|
    #   star_wars_name = Faker::Movies::StarWars.unique.character
    #   email = star_wars_name.downcase.gsub(' ', '') + "@easypallet.star"
    #   User.create(
    #     email: email,
    #     name: star_wars_name,
    #     password: "123123",
    #     password_confirmation: "123123",
    #     profile: [0, 1].sample
    #   )
    # end

    # 25.times do |i|
    #   harry_potter_names = Faker::Movies::HarryPotter.unique.character
    #   email = harry_potter_names.downcase.gsub(' ', '') + "@easypallet.harry"
    #   User.create(
    #     email: email,
    #     name: harry_potter_names,
    #     password: "123123",
    #     password_confirmation: "123123",
    #     profile: [0, 1].sample
    #   )
    # end

    # 25.times do |i|
    #   big_bang_name = Faker::TvShows::BigBangTheory.unique.character
    #   email = big_bang_name.downcase.gsub(' ', '') + "@easypallet.big"
    #   User.create(
    #     email: email,
    #     name: big_bang_name,
    #     password: "123123",
    #     password_confirmation: "123123",
    #     profile: [0, 1].sample
    #   )
    # end

    # 25.times do |i|
    #   got_names = Faker::TvShows::GameOfThrones.unique.character
    #   email = got_names.downcase.gsub(' ', '') + "@easypallet.game"
    #   User.create(
    #     email: email,
    #     name: got_names,
    #     password: "123123",
    #     password_confirmation: "123123",
    #     profile: [0, 1].sample
    #   )
    # end

    # 25.times do |i|
    #   friends_name = Faker::TvShows::Friends.unique.character
    #   email = friends_name.downcase.gsub(' ', '') + "@easypallet.friends"
    #   User.create(
    #     email: email,
    #     name: friends_name,
    #     password: "123123",
    #     password_confirmation: "123123",
    #     profile: [0, 1].sample
    #   )
    # end


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
