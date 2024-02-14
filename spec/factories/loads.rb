FactoryBot.define do
  sequence :unique_load_code do |n|
    "LD#{n}"
  end

  factory :load do
    code { generate(:unique_load_code) }
    delivery_date { Faker::Date.between(from: 2.years.ago, to: 2.years.from_now) }
  end
end
