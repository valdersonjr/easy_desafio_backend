FactoryBot.define do
  sequence :unique_load_code do |n|
    "load_code_#{n}"
  end

  factory :load do
    code { generate(:unique_load_code) }
    delivery_date { "09/04/99" }
  end
end
