FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "123123" } 
    password_confirmation { "123123" }
    profile { %i(admin client).sample }
  end
end
